export class AsyncQueue<T> implements AsyncIterable<T> {
  private readonly values: T[] = [];
  private readonly waiters: Array<{
    reject: (reason?: unknown) => void;
    resolve: (value: IteratorResult<T>) => void;
  }> = [];
  private closed = false;
  private failure: unknown = null;

  push(value: T): void {
    if (this.closed || this.failure !== null) {
      return;
    }

    const waiter = this.waiters.shift();

    if (waiter !== undefined) {
      waiter.resolve({
        done: false,
        value
      });
      return;
    }

    this.values.push(value);
  }

  close(): void {
    if (this.closed || this.failure !== null) {
      return;
    }

    this.closed = true;

    while (this.waiters.length > 0) {
      const waiter = this.waiters.shift();

      waiter?.resolve({
        done: true,
        value: undefined
      });
    }
  }

  fail(error: unknown): void {
    if (this.failure !== null || this.closed) {
      return;
    }

    this.failure = error;

    while (this.waiters.length > 0) {
      this.waiters.shift()?.reject(error);
    }
  }

  async next(): Promise<IteratorResult<T>> {
    if (this.values.length > 0) {
      const value = this.values.shift() as T;

      return {
        done: false,
        value
      };
    }

    if (this.failure !== null) {
      throw this.failure;
    }

    if (this.closed) {
      return {
        done: true,
        value: undefined
      };
    }

    return new Promise<IteratorResult<T>>((resolve, reject) => {
      this.waiters.push({
        reject,
        resolve
      });
    });
  }

  [Symbol.asyncIterator](): AsyncIterator<T> {
    return {
      next: () => this.next()
    };
  }
}

import json
import subprocess
from pathlib import Path


class StdioJsonRpcTransport:
    def __init__(self, command, cwd):
        self.command = [str(part) for part in command]
        self.cwd = Path(cwd)

    def start(self):
        return self

    def close(self):
        return None

    def __enter__(self):
        return self.start()

    def __exit__(self, exc_type, exc, tb):
        self.close()

    def request(self, payload):
        proc = subprocess.run(
            self.command,
            input=json.dumps(payload) + "\n",
            text=True,
            capture_output=True,
            cwd=self.cwd,
            check=False,
        )
        if proc.returncode != 0:
            raise RuntimeError(f"Mock server request failed: {proc.stderr}")

        output_lines = [json.loads(line) for line in proc.stdout.splitlines() if line.strip()]
        if not output_lines:
            raise RuntimeError("Mock server returned no JSON output")

        response = output_lines[0]
        emitted = output_lines[1:]
        return response, emitted

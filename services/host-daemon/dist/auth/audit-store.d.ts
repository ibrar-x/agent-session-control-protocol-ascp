import type { DaemonDatabase } from "../sqlite.js";
import type { AuditLogInput, AuditLogRecord } from "./types.js";
export interface AuditStore {
    append(entry: AuditLogInput): AuditLogRecord;
    listByCorrelationId(correlationId: string): AuditLogRecord[];
}
export declare function createAuditStore(database: DaemonDatabase): AuditStore;
//# sourceMappingURL=audit-store.d.ts.map
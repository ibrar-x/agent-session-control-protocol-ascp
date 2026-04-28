export function buildSnapshotMetadata(input) {
    const missingFields = [];
    const missingReasons = {};
    if (input.activeRun === undefined) {
        missingFields.push("active_run");
        missingReasons.active_run = "runtime_omitted";
    }
    return {
        snapshotOrigin: input.snapshotOrigin,
        completeness: missingFields.length === 0 ? "complete" : "partial",
        missingFields,
        missingReasons,
        attachmentStatus: input.attachmentStatus
    };
}
//# sourceMappingURL=metadata.js.map
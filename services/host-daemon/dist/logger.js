function writeLine(writer, level, message, details) {
    writer(`${JSON.stringify({
        level,
        message,
        ...(details ?? {})
    })}\n`);
}
export function createConsoleLogger() {
    return {
        info(message, details) {
            writeLine(process.stdout.write.bind(process.stdout), "info", message, details);
        },
        error(message, details) {
            writeLine(process.stderr.write.bind(process.stderr), "error", message, details);
        }
    };
}
//# sourceMappingURL=logger.js.map
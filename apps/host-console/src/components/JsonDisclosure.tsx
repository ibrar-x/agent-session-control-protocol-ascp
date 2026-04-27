import { useState } from "react";

interface JsonDisclosureProps {
  label: string;
  value: unknown;
  defaultOpen?: boolean;
}

function formatJson(value: unknown): string {
  return JSON.stringify(value, null, 2);
}

export function JsonDisclosure({ label, value, defaultOpen = false }: JsonDisclosureProps) {
  const [open, setOpen] = useState(defaultOpen);

  return (
    <div className="json-disclosure">
      <button
        type="button"
        className="ghost disclosure-trigger"
        onClick={() => setOpen((current) => !current)}
      >
        <span>{label}</span>
        <span>{open ? "Hide JSON" : "Show JSON"}</span>
      </button>
      {open ? <pre>{formatJson(value)}</pre> : null}
    </div>
  );
}

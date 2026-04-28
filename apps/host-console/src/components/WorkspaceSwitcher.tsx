interface WorkspaceSwitcherProps {
  activeWorkspace: "sessions" | "pairing";
  onSelectWorkspace: (workspace: "sessions" | "pairing") => void;
}

export function WorkspaceSwitcher({ activeWorkspace, onSelectWorkspace }: WorkspaceSwitcherProps) {
  return (
    <div className="workspace-switcher" role="tablist" aria-label="Console workspaces">
      <button
        type="button"
        className={`workspace-tab ${activeWorkspace === "sessions" ? "active" : ""}`}
        onClick={() => onSelectWorkspace("sessions")}
      >
        Sessions
      </button>
      <button
        type="button"
        className={`workspace-tab ${activeWorkspace === "pairing" ? "active" : ""}`}
        onClick={() => onSelectWorkspace("pairing")}
      >
        Pairing
      </button>
    </div>
  );
}

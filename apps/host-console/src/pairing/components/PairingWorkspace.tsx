import { deriveApprovalQueue } from "../model";
import type { PairingWorkspaceState } from "../types";
import { ClaimApprovalPanel } from "./ClaimApprovalPanel";
import { PairingSessionsPanel } from "./PairingSessionsPanel";
import { TrustedDevicesPanel } from "./TrustedDevicesPanel";

interface PairingWorkspaceProps {
  state: PairingWorkspaceState;
  onApprove: (sessionId: string) => void;
  onChangeScopes: (scopes: string[]) => void;
  onChangeTtlMinutes: (ttlMinutes: number) => void;
  onCopyCode: (sessionId: string) => void;
  onCreate: () => void;
  onRefreshDevices: () => void;
  onRefreshSessions: () => void;
  onReject: (sessionId: string) => void;
  onRevokeDevice: (deviceId: string) => void;
}

export function PairingWorkspace(props: PairingWorkspaceProps) {
  const approvalQueue = deriveApprovalQueue(props.state.sessions);
  const canSubmit =
    props.state.createForm.requestedScopes.length > 0 && Number.isFinite(props.state.createForm.ttlMinutes) && props.state.createForm.ttlMinutes > 0;

  return (
    <div className="pairing-workspace">
      <div className="pairing-workspace-header">
        <div>
          <p className="eyebrow">Pairing</p>
          <h1>Device Onboarding</h1>
        </div>
        <div className="session-row-meta">
          <span>{props.state.isLoaded ? "Daemon admin data loaded" : "Waiting for daemon admin data"}</span>
          <span>{props.state.lastLoadedAt ?? "No refresh yet"}</span>
        </div>
      </div>

      {props.state.error ? <p className="panel-error">{props.state.error}</p> : null}

      <div className="pairing-workspace-grid">
        <PairingSessionsPanel
          canSubmit={canSubmit}
          createForm={props.state.createForm}
          error={props.state.error}
          isSubmitting={props.state.isSubmitting}
          onChangeScopes={props.onChangeScopes}
          onChangeTtlMinutes={props.onChangeTtlMinutes}
          onCopyCode={props.onCopyCode}
          onCreate={props.onCreate}
          onRefresh={props.onRefreshSessions}
          sessions={props.state.sessions}
        />

        <ClaimApprovalPanel items={approvalQueue} onApprove={props.onApprove} onReject={props.onReject} />

        <TrustedDevicesPanel
          devices={props.state.devices}
          onRefresh={props.onRefreshDevices}
          onRevoke={props.onRevokeDevice}
        />
      </div>
    </div>
  );
}

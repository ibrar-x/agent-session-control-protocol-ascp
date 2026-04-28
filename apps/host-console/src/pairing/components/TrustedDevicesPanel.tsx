import type { TrustedDeviceRecord } from "../types";

interface TrustedDevicesPanelProps {
  devices: TrustedDeviceRecord[];
  onRefresh: () => void;
  onRevoke: (deviceId: string) => void;
}

function formatList(values: string[]): string {
  return values.length > 0 ? values.join(", ") : "No scopes granted";
}

export function TrustedDevicesPanel({ devices, onRefresh, onRevoke }: TrustedDevicesPanelProps) {
  return (
    <section className="pairing-panel trusted-devices-panel">
      <div className="rail-header">
        <div>
          <p className="eyebrow">Trusted Devices</p>
          <h2>Inventory</h2>
        </div>
        <button type="button" className="ghost" onClick={onRefresh}>
          Refresh
        </button>
      </div>

      {devices.length === 0 ? <p className="empty">No trusted devices loaded.</p> : null}

      <div className="trusted-device-list">
        {devices.map((device) => (
          <article key={device.deviceId} className="device-card">
            <div className="session-row-top">
              <div>
                <strong>{device.displayName}</strong>
                <p className="subcopy">{device.deviceId}</p>
              </div>
              <span className={`status-pill status-${device.status}`}>{device.status}</span>
            </div>

            <p>Scopes: {formatList(device.scopes)}</p>

            <dl className="pairing-session-details">
              <div>
                <dt>Paired</dt>
                <dd>{device.pairedAt}</dd>
              </div>
              <div>
                <dt>Last seen</dt>
                <dd>{device.lastSeenAt ?? "Not reported"}</dd>
              </div>
              <div>
                <dt>Revoked</dt>
                <dd>{device.revokedAt ?? "Active"}</dd>
              </div>
            </dl>

            {device.status === "active" ? (
              <div className="topbar-actions">
                <button type="button" className="ghost" onClick={() => onRevoke(device.deviceId)}>
                  Revoke
                </button>
              </div>
            ) : null}
          </article>
        ))}
      </div>
    </section>
  );
}

import { createConnectedClient, isDirectExecution, printJson } from "./_shared.ts";

export interface ArtifactDiffExampleSummary {
  sessionId: string;
  artifactIds: string[];
  artifactKind: string;
  diffFilesChanged: number;
  diffInsertions: number;
}

export async function runArtifactDiffExample(): Promise<ArtifactDiffExampleSummary> {
  const client = await createConnectedClient();

  try {
    const artifacts = await client.listArtifacts({
      session_id: "sess_abc123"
    });
    const artifact = artifacts.artifacts[0];

    if (artifact === undefined) {
      throw new Error("Mock server returned no artifacts for sess_abc123.");
    }

    const artifactResult = await client.getArtifact({
      artifact_id: artifact.id
    });
    const diff = await client.getDiff({
      session_id: "sess_abc123",
      run_id: artifact.run_id ?? "run_9"
    });

    return {
      sessionId: "sess_abc123",
      artifactIds: artifacts.artifacts.map((item) => item.id),
      artifactKind: artifactResult.artifact.kind,
      diffFilesChanged: diff.diff.files_changed,
      diffInsertions: diff.diff.insertions
    };
  } finally {
    await client.close();
  }
}

if (isDirectExecution(import.meta.url)) {
  runArtifactDiffExample()
    .then((summary) => {
      printJson(summary);
    })
    .catch((error: unknown) => {
      const message = error instanceof Error ? error.stack ?? error.message : String(error);
      process.stderr.write(`${message}\n`);
      process.exitCode = 1;
    });
}

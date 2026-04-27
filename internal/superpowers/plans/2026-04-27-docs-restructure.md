# Docs Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure all ASCP docs into Learn / Reference / Build sections in the website, move internal workflow files to `internal/`, delete old `docs/`, and update all cross-references.

**Architecture:** Progressive three-section website (Learn → Reference → Build) with repo-only `internal/` directory. Old `docs/` fully migrated and deleted. All file paths updated.

**Tech Stack:** MDX (Fumadocs), Next.js, markdown

---

## Files Map

| Action | File |
|--------|------|
| Create | `internal/README.md` |
| Move | `docs/status.md` → `internal/status.md` |
| Move | `docs/repo-operating-system.md` → `internal/repo-operating-system.md` |
| Move | `docs/prompts/*` → `internal/prompts/*` |
| Move | `docs/superpowers/*` → `internal/superpowers/*` |
| Move | `plans.md` → `internal/plans.md` |
| Move | Root `opencode_*.png` → `apps/web/public/images/` |
| Move | `apps/web/content/docs/getting-started/*` → `apps/web/content/docs/learn/` |
| Move | `apps/web/content/docs/core-concepts/*` → `apps/web/content/docs/learn/03-core-concepts/` |
| Move | `apps/web/content/docs/api-reference/*` → `apps/web/content/docs/reference/` |
| Move | `apps/web/content/docs/advanced/*` → `apps/web/content/docs/reference/` |
| Move | `apps/web/content/docs/contributing/*` → `apps/web/content/docs/build/05-contributing.mdx` |
| Move | `apps/web/content/docs/ecosystem/*` → `apps/web/content/docs/learn/05-ecosystem/` |
| Move | `apps/web/content/docs/sdks/*` → `apps/web/content/docs/build/` |
| Delete | `apps/web/content/docs/authentication/` (merged into reference/05-auth-approvals.mdx) |
| Rewrite | `apps/web/content/docs/index.mdx` (new landing page) |
| Rewrite | `apps/web/content/docs/learn/01-what-is-ascp.mdx` |
| Rewrite | `apps/web/content/docs/learn/02-quick-start.mdx` |
| Rewrite | `apps/web/content/docs/learn/03-core-concepts/` (simplified versions) |
| Rewrite | `apps/web/content/docs/learn/04-sdk-guides/` |
| Rewrite | `apps/web/content/docs/learn/05-ecosystem/` |
| Rewrite | `apps/web/content/docs/reference/*` (8 files) |
| Rewrite | `apps/web/content/docs/build/*` (6 files) |
| Create | `apps/web/content/docs/learn/meta.json` |
| Create | `apps/web/content/docs/reference/meta.json` |
| Create | `apps/web/content/docs/build/meta.json` |
| Modify | `apps/web/app/layout.config.tsx` (new sidebar sections) |
| Modify | `apps/web/lib/source.ts` (new content directories) |
| Delete | `docs/` directory |
| Delete | Root `opencode_*.png`, `opencode_*.txt`, `opencode_*.md` (moved) |
| Delete | `apps/web/content/docs/meta.json` (old root meta) |
| Update | `AGENTS.md` → change `docs/status.md` to `internal/status.md`, `plans.md` to `internal/plans.md` |
| Update | `README.md` → point to website, `internal/README.md` |
| Update | `internal/plans.md` → update paths |
| Update | `internal/status.md` → update paths |
| Update | All prompt files → update paths |
| Update | Package/adapter READMEs → website paths |

---

### Task 1: Create branch + move internal files

- [ ] **Step 1: Create feature branch from main**

```bash
git checkout main && git pull origin main && git checkout -b feature/docs-restructure
```

- [ ] **Step 2: Move internal workflow files**

```bash
cp docs/status.md internal/status.md
cp docs/repo-operating-system.md internal/repo-operating-system.md
cp -r docs/prompts/* internal/prompts/
cp -r docs/superpowers/* internal/superpowers/
cp plans.md internal/plans.md
```

- [ ] **Step 3: Move root design assets**

```bash
mkdir -p apps/web/public/images
cp opencode_design_*.png apps/web/public/images/
```

- [ ] **Step 4: Stage internal file moves**

```bash
git add internal/ apps/web/public/images/
```

### Task 2: Restructure website content directories

- [ ] **Step 1: Create new directory structure**

```bash
mkdir -p apps/web/content/docs/learn/03-core-concepts
mkdir -p apps/web/content/docs/learn/04-sdk-guides
mkdir -p apps/web/content/docs/learn/05-ecosystem
mkdir -p apps/web/content/docs/reference
mkdir -p apps/web/content/docs/build
```

- [ ] **Step 2: Move content to new sections**

```bash
# Learn section
cp apps/web/content/docs/getting-started/what-is-ascp.mdx apps/web/content/docs/learn/01-what-is-ascp.mdx
cp apps/web/content/docs/getting-started/quick-start.mdx apps/web/content/docs/learn/02-quick-start.mdx
cp apps/web/content/docs/getting-started/compatibility.mdx apps/web/content/docs/learn/02-compatibility.mdx
cp apps/web/content/docs/getting-started/installation.mdx apps/web/content/docs/learn/02-installation.mdx
cp apps/web/content/docs/core-concepts/* apps/web/content/docs/learn/03-core-concepts/
cp apps/web/content/docs/ecosystem/* apps/web/content/docs/learn/05-ecosystem/

# Reference section
cp apps/web/content/docs/api-reference/* apps/web/content/docs/reference/
cp apps/web/content/docs/advanced/* apps/web/content/docs/reference/

# Build section
cp apps/web/content/docs/sdks/* apps/web/content/docs/build/
cp apps/web/content/docs/contributing/* apps/web/content/docs/build/
```

- [ ] **Step 3: Merge authentication into reference**

Merge the 3 auth files (`actor-attribution.mdx`, `approval-flows.mdx`, `auth-hooks.mdx`) into one `reference/05-auth-approvals.mdx`.

- [ ] **Step 4: Stage website structure changes**

```bash
git add apps/web/content/docs/learn/ apps/web/content/docs/reference/ apps/web/content/docs/build/
```

### Task 3: Rewrite index.mdx landing page + meta.json files

- [ ] **Step 1: Rewrite index.mdx** with Learn / Reference / Build card layout

- [ ] **Step 2: Create meta.json for learn/**

```json
{
  "title": "Learn",
  "pages": ["01-what-is-ascp", "02-quick-start", "03-core-concepts", "04-sdk-guides", "05-ecosystem"]
}
```

- [ ] **Step 3: Create meta.json for reference/**

```json
{
  "title": "Reference",
  "pages": ["01-methods", "02-events", "03-errors", "04-schemas", "05-auth-approvals", "06-replay-streaming", "07-extensions", "08-conformance"]
}
```

- [ ] **Step 4: Create meta.json for build/**

```json
{
  "title": "Build",
  "pages": ["01-typescript-sdk", "02-dart-sdk", "03-adapters", "04-mock-server", "05-contributing", "06-architecture"]
}
```

- [ ] **Step 5: Stage**

```bash
git add apps/web/content/docs/index.mdx apps/web/content/docs/learn/meta.json apps/web/content/docs/reference/meta.json apps/web/content/docs/build/meta.json
```

### Task 4: Update website config (layout.config.tsx + source.ts)

- [ ] **Step 1: Update sidebar config** to reflect Learn / Reference / Build sections

- [ ] **Step 2: Update source.ts** if Fumadocs content source config needs new directory paths

- [ ] **Step 3: Stage**

```bash
git add apps/web/app/layout.config.tsx apps/web/lib/source.ts
```

### Task 5: Create internal/README.md

- [ ] **Step 1: Write internal/README.md** explaining what's in internal/ and why it's separate

- [ ] **Step 2: Stage**

```bash
git add internal/README.md
```

### Task 6: Update all cross-references

- [ ] **Step 1: Update AGENTS.md** — paths to `internal/plans.md`, `internal/status.md`

- [ ] **Step 2: Update README.md** — point to website, remove docs/ references

- [ ] **Step 3: Update internal/plans.md** — fix internal paths

- [ ] **Step 4: Update internal/status.md** — fix internal paths

- [ ] **Step 5: Update internal/prompts/README.md** — fix prompt paths

- [ ] **Step 6: Update internal/prompts/*.md** — fix all paths

- [ ] **Step 7: Update website MDX cross-page links** in all moved files

- [ ] **Step 8: Stage**

```bash
git add AGENTS.md README.md internal/ apps/web/content/docs/
```

### Task 7: Clean up old files

- [ ] **Step 1: Remove old docs/ directory**

```bash
git rm -r docs/
```

- [ ] **Step 2: Remove old root plans.md** (moved to internal/)

```bash
git rm plans.md
```

- [ ] **Step 3: Remove old website content dirs**

```bash
git rm -r apps/web/content/docs/getting-started/
git rm -r apps/web/content/docs/core-concepts/
git rm -r apps/web/content/docs/api-reference/
git rm -r apps/web/content/docs/authentication/
git rm -r apps/web/content/docs/advanced/
git rm -r apps/web/content/docs/contributing/
git rm -r apps/web/content/docs/ecosystem/
git rm -r apps/web/content/docs/sdks/
git rm apps/web/content/docs/meta.json
```

- [ ] **Step 4: Remove root design files** (moved to apps/web/public/images/)

```bash
git rm opencode_design_reference.md opencode_docs_config.png opencode_docs_design_spec.md opencode_docs_full.png opencode_docs_sdk.png opencode_fullpage.png opencode_search_modal.png opencode_snapshot.txt
```

- [ ] **Step 5: Stage**

```bash
# Already staged by git rm
```

### Task 8: Verify and commit

- [ ] **Step 1: Verify no broken paths** — grep for `docs/` references in remaining files

```bash
rg "docs/" --type md -l | grep -v node_modules | grep -v ".next" | grep -v ".source" | grep -v "internal" | grep -v "apps/web/content"
```

- [ ] **Step 2: Verify website structure**

```bash
find apps/web/content/docs -type f -name "*.mdx" | sort
```

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "docs: restructure into Learn/Reference/Build sections with internal/ separation"
```

### Task 9: Push and merge

- [ ] **Step 1: Push**

```bash
git push -u origin feature/docs-restructure
```

- [ ] **Step 2: Merge to main**

```bash
git checkout main && git pull origin main && git merge feature/docs-restructure && git push origin main
```

### Task 10: Checkpoint

- [ ] **Step 1: Update internal/status.md** with checkpoint entry

- [ ] **Step 2: Commit checkpoint**

```bash
git add internal/status.md && git commit -m "docs(status): add checkpoint for docs restructure" && git push
```

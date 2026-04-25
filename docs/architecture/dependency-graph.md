# ASCP Dependency Graph

```text
protocol
   |
packages
   |
sdks
   |
adapters
   |
apps
```

Additional module classes:

- `services/` may depend on `protocol/` directly when they are protocol test surfaces
- `tooling/` may orchestrate any module but must not become a runtime dependency

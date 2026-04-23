# Dart SDK Planning Prompt

Use this prompt when the TypeScript SDK is sufficiently established and the next step is to plan or begin the Dart SDK intentionally.

## Read First

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `../../../schema/`
5. `../../../spec/`
6. `../../../../ASCP_Dart_SDK_Implementation_Plan.md`
7. `../../../../ASCP_Next_Phase_Master_Roadmap.md`

## Feature Boundary

This feature is only for Dart SDK planning or a dedicated Dart implementation branch.

Included:

- Dart package scope review
- package layout planning
- model and JSON codec strategy
- stream-based subscription shape
- validation and replay plan

Out of scope:

- Flutter UI work
- transport decisions that belong to the app layer
- mixing Dart work into an active TypeScript branch

## Goal

Prepare the Dart SDK as a clean second downstream consumer after the TypeScript package establishes the first implementation reference.

## Documentation Requirements

Before closing the branch, document the Dart planning work in enough detail that the eventual implementation branch can start from repository files alone.

Make sure the branch documentation covers:

- how to read and use the planning outputs from the current branch
- the thought process behind the proposed package shape, async model, codec strategy, and validation approach
- why the chosen Dart direction was preferred over plausible alternatives
- which upstream protocol assets and TypeScript SDK learnings were used as inputs
- assumptions, risks, and unresolved questions that remain acceptable at planning time
- what validation or review steps were used to judge the plan quality
- what should be built first when the actual Dart implementation branch starts

---
name: ascp-dart-sdk-planning
description: Use when planning or beginning the Dart SDK after the TypeScript SDK establishes the first downstream reference package.
---

# ASCP Dart SDK Planning

## Overview

Use this skill when the work is about planning or starting the Dart SDK intentionally. The objective is to keep Dart as a second downstream package that learns from the TypeScript SDK without copying TypeScript-specific implementation choices blindly.

## Focus Areas

- package scope
- model and JSON codec strategy
- stream-based event subscriptions
- replay helper surface
- validation and auth hooks
- Flutter-friendly async ergonomics

## Working Rules

- Start from the upstream ASCP assets and the Dart SDK implementation plan.
- Keep Flutter UI concerns out of the SDK package.
- Preserve protocol fidelity over convenience abstractions.
- Reuse lessons from the TypeScript SDK where they improve clarity, not where they merely copy tooling choices.

## Done Criteria

The work is complete when the Dart package plan or scaffold is explicit enough that future implementation can proceed without guessing scope or mixing UI concerns into the SDK.

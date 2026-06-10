# Agent Context — ffreis-workflows-kotlin

Reusable GitHub Actions workflow library for **Kotlin / Android (Gradle)** projects. Consumed by
`petlook-mobile` (`android/`) and any future JVM/Android repo. Sibling of `ffreis-workflows-go`,
`-rust`, `-python`, `-general`; follows the same conventions.

## Rules (mandatory)

1. **Every `kotlin-*.yml` must be exercised in `ci.yml`** against `examples/hello/`. No untested
   reusable workflow.
2. **Reusable workflows are `on: workflow_call` only** — never add `push`/`pull_request`/`schedule`
   triggers to a `kotlin-*.yml`.
3. **No `concurrency:` block in reusable workflows** — concurrency is caller-controlled.
4. **Per-job `permissions`** (least privilege), **`timeout-minutes`** on every job, and the
   `harden-runner` (egress audit) step first.
5. **All `runs-on: ubuntu-latest`.** Kotlin/Android tooling is Linux-friendly and the GitHub
   `ubuntu-latest` image ships the Android SDK, so `assembleDebug` works without macOS. **Never add
   a macOS runner here** — that's the swift lib's (guarded) concern.
6. **Draft-skip + cost:** every workflow takes `run_on_draft` and gates with the standard
   `if: ${{ inputs.run_on_draft || vars.CI_RUN_ON_DRAFT == 'true' || github.event_name != 'pull_request' || github.event.pull_request.draft == false }}`.
7. **Third-party action SHAs are Renovate-managed** — pin to a full commit SHA with a `# vX.Y.Z`
   comment; never hand-bump.
8. **Route inputs through `env:`** in `run:` steps (no `${{ inputs.* }}` interpolation in shell) to
   prevent injection.

## Workflows

- `kotlin-lint.yml` — ktlint/detekt (Gradle tasks; configurable via `lint-tasks`).
- `kotlin-build.yml` — Gradle build (`build-task`, default `build`; Android passes `assembleDebug`).
- `kotlin-test.yml` — Gradle unit tests (`test-task`, default `test`; Android passes `testDebugUnitTest`).

Consumers pass Android-specific tasks; the `examples/hello/` self-test is a plain Kotlin/JVM module
(no Android SDK needed) using the generic defaults.

## Versioning

release-please (`release-type: simple`); consumers pin a tag's commit SHA with a `# vX.Y.Z` comment.
Security delegated to `ffreis-workflows-general` (`general-security-fs`, `general-codeql` with
`languages: java-kotlin`).

## Keeping this file current

If you add a workflow or change an input contract, update this file and `ci.yml` in the same PR.

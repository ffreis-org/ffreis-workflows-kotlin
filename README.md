# ffreis-workflows-kotlin

Reusable GitHub Actions workflows for Kotlin / Android (Gradle) projects. All run on
`ubuntu-latest` (the GitHub image ships the Android SDK, so `assembleDebug` needs no macOS).

## Workflows

| Workflow | Purpose | Key inputs |
|---|---|---|
| `kotlin-lint.yml` | ktlint / detekt | `lint-tasks` (default `ktlintCheck`), `working-directory`, `java-version` |
| `kotlin-build.yml` | Gradle build | `build-task` (default `build`), `upload-artifact`, `artifact-path` |
| `kotlin-test.yml` | Gradle unit tests | `test-task` (default `test`) |

## Usage (Android consumer, e.g. petlook-mobile)

```yaml
jobs:
  lint:
    uses: FelipeFuhr/ffreis-workflows-kotlin/.github/workflows/kotlin-lint.yml@<sha> # v0.1.0
    with:
      working-directory: android
      lint-tasks: "ktlintCheck detekt lintDebug"
  build:
    uses: FelipeFuhr/ffreis-workflows-kotlin/.github/workflows/kotlin-build.yml@<sha> # v0.1.0
    with:
      working-directory: android
      build-task: assembleDebug
      upload-artifact: true
      artifact-path: app/build/outputs/apk/debug/*.apk
  test:
    uses: FelipeFuhr/ffreis-workflows-kotlin/.github/workflows/kotlin-test.yml@<sha> # v0.1.0
    with:
      working-directory: android
      test-task: testDebugUnitTest
```

Pin to a release tag's commit SHA (Renovate keeps it current). See [AGENTS.md](AGENTS.md).

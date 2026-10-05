# TFLint template

Provisioned from [`Qode-Fleet-Control/fleet-template-v1`](https://github.com/Qode-Fleet-Control/fleet-template-v1) — the fleet
lifecycle contract (`bin/`, `fleet.conf`, `compose.yaml`, deploy workflows) with a Terraform module linted by [TFLint](https://github.com/terraform-linters/tflint)
laid on top.

**This repo is a job, not a service.** Its container runs `tflint --init` and
`tflint --recursive`, then exits — 0 when tflint reports no issues. Nothing listens on
`$PORT`.

## What is in it

| path | |
|---|---|
| `.tflint.hcl` | the `terraform` ruleset pinned (`0.15.0`, from GitHub) with `preset = "all"` — naming conventions, documented/typed variables and outputs, `required_version`/`required_providers`, unused declarations, standard module structure …; `call_module_type = "local"` so module calls are linted too; a commented `aws` ruleset to enable |
| `versions.tf` `variables.tf` `main.tf` `outputs.tf` | a credential-free module (`random_pet` × N + a `local_file` inventory) that passes every rule |
| `examples/basic/` | the module called the way a consumer would — linted by `--recursive` |
| `.terraform.lock.hcl` | provider pins for the module |
| `scripts/check.sh` | the job |

Try it: add `variable "Unused" { default = 1 }` to `main.tf` and the job fails with five
issues (no type, no description, unused, wrong file, not snake_case).

## Run it

**On the fleet:** `bin/run` builds the image (`docker compose build`) and stops there —
`DOCKER_START_CMD` is empty because there is no server. Run the job with
`docker compose run --rm app`.

**With docker:**

    docker compose build
    docker compose run --rm app        # exit 0 = no issues

**Without docker** (needs `tflint` >= 0.50 on `PATH`):

    tflint --init
    tflint --recursive

`FLEET_RUNTIME=process bin/run` runs `INSTALL_CMD` (`tflint --init`) and `BUILD_CMD`
(`tflint --recursive`) and then stops at the start step, by design.

## Origin

    hand-written — TFLint ships no project generator

`.tflint.hcl` follows TFLint's configuration docs (a `config` block plus one `plugin` block
per ruleset); the module follows HashiCorp's standard module structure, which the
`terraform_standard_module_structure` rule enforces.

## Deviations, and why

- `Dockerfile` is a job image on `ghcr.io/terraform-linters/tflint:v0.64.0`: its `ENTRYPOINT`
  (`tflint`) is cleared and the default command is `scripts/check.sh`. Runs as non-root `app`
  (uid 10001).
- The terraform ruleset is pinned by `source`/`version` instead of using the copy bundled in
  tflint, so a tflint upgrade cannot change the rules underneath you; `tflint --init` installs
  it at image build (pass `GITHUB_TOKEN` if GitHub's anonymous rate limit bites).

## Verified

**The docker job has NOT been verified yet.** On 2026-10-05 the build host's docker disk
stayed below the 6 GB floor (0-3 GB free) for over three hours, so `docker compose build`
was never run for this repo. Build and run it once before trusting it:

    docker compose build && docker compose run --rm app; docker compose down --rmi local -v

What WAS checked, with the real CLIs outside docker (same `scripts/check.sh` the image runs):

    tflint 0.64.0: sh scripts/check.sh      # --init installed terraform ruleset 0.15.0; --recursive: no issues -> exit 0
    (a bad variable added to the module makes it fail with 5 issues, exit 2)

## Serving over HTTP

There is no HTTP surface. If you add one, listen on `0.0.0.0:$PORT`, serve at `/`, set
`PORT`, `HEALTH_PATH`, `START_CMD` and `DOCKER_START_CMD` in `fleet.conf`, and publish
`"${PORT}:${PORT}"` in `compose.yaml`. See `docs/fleet-lifecycle.md`.

#!/bin/sh
# The job: install the plugins .tflint.hcl pins, then lint the root module and every
# directory under it. Exits non-zero when tflint reports an issue (or fails to run).
set -eu
cd "$(dirname "$0")/.."
echo "==> tflint --version";      tflint --version
echo "==> tflint --init";         tflint --init
echo "==> tflint --recursive";    tflint --recursive
echo "tflint: no issues"

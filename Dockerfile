# Built by .github/workflows/deploy.yml (context ., file Dockerfile) and pushed
# to Artifact Registry.
#
# A job image, not a server: the default command runs scripts/check.sh
# (`tflint --init`, then `tflint --recursive`) and exits 0 when tflint reports
# no issues. It never listens on $PORT.
#
# The rulesets .tflint.hcl pins are installed at BUILD time (`tflint --init`
# downloads them from GitHub releases; pass a GITHUB_TOKEN build secret if you
# hit the anonymous rate limit), so the job's own `--init` finds them present.

FROM ghcr.io/terraform-linters/tflint:v0.64.0 AS runtime
ARG BUILD_ID=""
ENV BUILD_ID=$BUILD_ID HOME=/home/app
RUN adduser -D -u 10001 -h /home/app app \
 && mkdir /app && chown app:app /app
WORKDIR /app
COPY --chown=app:app . .
USER app
RUN tflint --init
# the base image's ENTRYPOINT is `tflint`; the job is a script
ENTRYPOINT []
CMD ["sh", "scripts/check.sh"]

#!/usr/bin/env bash

set -euxo pipefail

export ADOC_BASEDIR="/home/asciidoc"
export ADOC_DIR="AsciiDoc_separate_files"
export ADOC_FILE_BASE_NAME="players-guide"
export ADOC_FILE="players-guide.adoc"
export ADOC_TARGET_DIR="${ADOC_DIR}/generated"

docker build --tag 'free5e-render-asciidoc' .github/render-action/
docker run \
  -e ADOC_BASEDIR="${ADOC_BASEDIR}" \
  -e ADOC_DIR="${ADOC_DIR}" \
  -e ADOC_FILE_BASE_NAME="${ADOC_FILE_BASE_NAME}" \
  -e ADOC_FILE="${ADOC_FILE}" \
  -e ADOC_TARGET_DIR="${ADOC_BASEDIR}/${ADOC_TARGET_DIR}" \
  -v "$(pwd):${ADOC_BASEDIR}" \
  'free5e-render-asciidoc'

#!/usr/bin/env bash

set -euxo pipefail

if [ -n "${ADOC_BASEDIR}" ]; then
  cd "${ADOC_BASEDIR}"
else
  export ADOC_BASEDIR="$(pwd)"
fi

# Prepare the directory...
rm "${ADOC_TARGET_DIR}/*" || echo 'Nothing to delete'
mkdir -p ${ADOC_TARGET_DIR}
ls -l

# For GitHub, combine the various files into one (since it doesn't support the include directive; see https://github.com/github/markup/issues/1095 for details)
asciidoctor-reducer --preserve-conditionals -o "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}_single-file.adoc" "${ADOC_DIR}/${ADOC_FILE}"

# Generate files using AsciiDoctor
asciidoctor-pdf "${ADOC_DIR}/${ADOC_FILE}" -o "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.pdf"

asciidoctor -b html "${ADOC_DIR}/${ADOC_FILE}" -o "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.html"

asciidoctor -b docbook "${ADOC_DIR}/${ADOC_FILE}" -o "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.xml"

asciidoctor-epub3 "${ADOC_DIR}/${ADOC_FILE}" -o "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.epub"

# Now we use Pandoc to generate even more files
downdoc "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}_single-file.adoc" --attribute=markdown=true -o "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.md"

pandoc --from docbook --to docx --output "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.docx" "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.xml"

pandoc --from docbook --to odt --output "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.odt" "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.xml"

pandoc --from docbook --to latex --output "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.tex" "${ADOC_TARGET_DIR}/${ADOC_FILE_BASE_NAME}.xml"

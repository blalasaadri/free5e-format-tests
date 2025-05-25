#!/usr/bin/env bash

set -euxo pipefail

# Prepare the directory...
rm '${TARGET_DIR}/*' || echo 'Nothing to delete'
mkdir -p ${TARGET_DIR}
ls -l

# For GitHub, combine the various files into one (since it doesn't support the include directive; see https://github.com/github/markup/issues/1095 for details)
asciidoctor-reducer --preserve-conditionals -o ${TARGET_DIR}/${ADOC_FILE_BASE_NAME}_single-file.adoc "${ADOC_BASEDIR}/${ADOC_FILE}"

# Generate files using AsciiDoctor
asciidoctor-pdf "${ADOC_BASEDIR}/${ADOC_FILE}" -o "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.pdf"

asciidoctor -b html "${ADOC_BASEDIR}/${ADOC_FILE}" -o "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.html"

asciidoctor -b docbook "${ADOC_BASEDIR}/${ADOC_FILE}" -o "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.xml"

asciidoctor-epub3 "${ADOC_BASEDIR}/${ADOC_FILE}" -o "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.epub"

downdoc "${ADOC_BASEDIR}/${ADOC_FILE}" --attribute=markdown=true -o "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.md"

# Now we use Pandoc to generate even more files
pandoc --from docbook --to docx --output "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.docx" "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.xml"

pandoc --from docbook --to odt --output "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.odt" "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.xml"

pandoc --from docbook --to latex --output "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.tex" "${TARGET_DIR}/${ADOC_FILE_BASE_NAME}.xml"

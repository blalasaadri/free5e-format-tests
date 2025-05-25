#!/usr/bin/env sh

set -euxo pipefail

FILE_BASE_NAME="players-guide"
ADOC_FILE="${FILE_BASE_NAME}.adoc"

rm "generated/${FILE_BASE_NAME}."* || echo "No files to delete"

asciidoctor-pdf "${ADOC_FILE}" -o "generated/${FILE_BASE_NAME}.pdf"

asciidoctor -b html "${ADOC_FILE}" -o "generated/${FILE_BASE_NAME}.html"

asciidoctor -b docbook "${ADOC_FILE}" -o "generated/${FILE_BASE_NAME}.xml"

asciidoctor-epub3 "${ADOC_FILE}" -o "generated/${FILE_BASE_NAME}.epub"

downdoc "${ADOC_FILE}" --attribute=markdown=true -o "generated/${FILE_BASE_NAME}.md"

pandoc --from docbook --to docx --output generated/${FILE_BASE_NAME}.docx generated/${FILE_BASE_NAME}.xml

pandoc --from docbook --to odt --output generated/${FILE_BASE_NAME}.odt generated/${FILE_BASE_NAME}.xml

pandoc --from docbook --to latex --output generated/${FILE_BASE_NAME}.tex generated/${FILE_BASE_NAME}.xml

#/bin/sh

FILE_BASE_NAME="players-guide"
ADOC_FILE="${FILE_BASE_NAME}.adoc"

# -r asciidoctor-mathematical
asciidoctor-pdf "${ADOC_FILE}" -o "generated/${FILE_BASE_NAME}.pdf"

asciidoctor -b html "${ADOC_FILE}" -o "generated/${FILE_BASE_NAME}.html"

# -r asciidoctor-mathematical
asciidoctor-epub3 "${ADOC_FILE}" -o "generated/${FILE_BASE_NAME}.epub"

downdoc "${ADOC_FILE}" --attribute=markdown=true -o "generated/${FILE_BASE_NAME}.md"

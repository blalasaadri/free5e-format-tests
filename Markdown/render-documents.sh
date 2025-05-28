#!/usr/bin/env bash

set -euxo pipefail

BASE_FILE_NAME=PlayersGuide

# Clean up after the previous run
rm generated/*
for bak in $(find . -name '*.adoc.bak'); do
  rm $bak
done
for adoc in $(find . -name '*.adoc'); do
  rm $adoc
done

# Convert all Markdown files to AsciiDoc
for md in $(find . -name '*.md'); do
  filename="${md##*/}"
  kramdoc \
    -a icons=font \
    -a lang=en-US \
    -a stem \
    -a revdate="$(git log -1 --pretty="format:%cs" $md)" \
    --auto-ids \
    --auto-id-prefix="${filename%.md}_" \
    $md
done

# In the newly generated AsciiDoc files, replace links with includes
for adoc in $(find . -name '*.adoc'); do
  sed -i'.bak' -e 's/^xref:\(.*\).adoc\[.*\]/include::\1.adoc[]/g' $adoc
done

# Now render all of the various formats we want to have
mkdir -p generated

asciidoctor \
  -b html \
  -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
  -a doctype=book \
  -a partnums \
  -a reproducible \
  -a revdate="$(git log -1 --pretty="format:%cs" .)" \
  -a sectnums \
  -a sectnumelevels=1 \
  -a stylesdir=css \
  -a stylesheet=adoc-golo.css \
  -a table-stripes=even \
  -a toc=left \
  -a toclevels=4 \
  "${BASE_FILE_NAME}.adoc" \
  -o generated/$BASE_FILE_NAME.html

asciidoctor-pdf \
  -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
  -a doctype=book \
  -a partnums \
  -a reproducible \
  -a revdate="$(git log -1 --pretty="format:%cs" .)" \
  -a sectnums \
  -a sectnumelevels=1 \
  -a stylesdir=css \
  -a stylesheet=adoc-golo.css \
  -a table-stripes=even \
  -a toc=left \
  -a toclevels=4 \
  "${BASE_FILE_NAME}.adoc" \
  -o "generated/${BASE_FILE_NAME}.pdf"

asciidoctor \
  -b docbook \
  -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
  -a doctype=book \
  -a partnums \
  -a reproducible \
  -a revdate="$(git log -1 --pretty="format:%cs" .)" \
  -a sectnums \
  -a sectnumelevels=1 \
  -a stylesdir=css \
  -a stylesheet=adoc-golo.css \
  -a table-stripes=even \
  -a toc=left \
  -a toclevels=4 \
  "${BASE_FILE_NAME}.adoc" \
  -o "generated/${BASE_FILE_NAME}.xml"

asciidoctor-epub3 \
  -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
  -a doctype=book \
  -a partnums \
  -a reproducible \
  -a revdate="$(git log -1 --pretty="format:%cs" .)" \
  -a sectnums \
  -a sectnumelevels=1 \
  -a stylesdir=css \
  -a stylesheet=adoc-golo.css \
  -a table-stripes=even \
  -a toc=left \
  -a toclevels=4 \
  "${BASE_FILE_NAME}.adoc" \
  -o "generated/${BASE_FILE_NAME}.epub"

pandoc \
  --from docbook \
  --to docx \
  --output generated/${BASE_FILE_NAME}.docx \
  generated/${BASE_FILE_NAME}.xml

pandoc \
  --from docbook \
  --to odt \
  --output generated/${BASE_FILE_NAME}.odt \
  generated/${BASE_FILE_NAME}.xml

pandoc \
  --from docbook \
  --to latex \
  --output generated/${BASE_FILE_NAME}.tex \
  generated/${BASE_FILE_NAME}.xml

cp ${BASE_FILE_NAME}.adoc generated/
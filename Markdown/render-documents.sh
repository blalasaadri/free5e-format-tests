#!/usr/bin/env bash

set -euxo pipefail

BASE_FILE_NAME=PlayersGuide

for adoc in $(find . -name '*.adoc'); do
  rm $adoc
done

for md in $(find . -name '*.md'); do
  kramdoc -a icons=font -a lang=en-US -a stem $md
done

for adoc in $(find . -name '*.adoc'); do
  sed -i'.bak' -e 's/^xref:\(.*\).adoc\[.*\]/include::\1.adoc[]/g' $adoc
done

mkdir -p generated
asciidoctor \
  -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
  -a doctype=book \
  -a partnums \
  -a reproducible \
  -a sectnums \
  -a sectnumelevels=1 \
  -a stylesdir=css \
  -a stylesheet=adoc-golo.css \
  -a table-stripes=even \
  -a toc=left \
  -a toclevels=4 \
  "$BASE_FILE_NAME.adoc" \
  -o generated/$BASE_FILE_NAME.html

for bak in $(find . -name '*.adoc.bak'); do
  rm $bak
done
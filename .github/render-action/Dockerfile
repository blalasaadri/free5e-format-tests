FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y asciidoctor bash nodejs npm pandoc
RUN gem install asciidoctor-pdf asciidoctor-epub3 asciidoctor-reducer asciimath
RUN npm i --global downdoc

COPY generate.sh /generate.sh

ENTRYPOINT [ "/generate.sh" ]

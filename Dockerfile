FROM python:3.9.7-alpine3.14
RUN apk add --update curl git

WORKDIR /workspace
VOLUME ["/workspace"]

COPY . /workspace/
COPY docs /workspace/docs/
RUN chmod +x /workspace/test.sh

ENTRYPOINT [ "/workspace/test.sh" ]

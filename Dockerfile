FROM python:3.10-alpine

EXPOSE 8000

ENV KASPAD_HOST_1=n.seeder1.kaspad.net:16110

RUN apk --no-cache add \
  git \
  gcc \
  libc-dev \
  build-base \
  linux-headers \
  dumb-init

RUN pip install \
  pipenv

RUN mkdir -p /app \
  && adduser -h /app -S -D -u 55747 api \
  && chown api /app

WORKDIR /app
USER api

RUN git clone https://github.com/lAmeR1/kaspa-rest-server.git /app 2>&1

RUN pipenv install --deploy 

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD pipenv run gunicorn -b 0.0.0.0:8000 -w 1 -k uvicorn.workers.UvicornWorker main:app


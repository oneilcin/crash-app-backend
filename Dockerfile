FROM quay.io/samsung_cnct/goglide:1.9.0

ENV PACKAGE_PATH "/go/src/github.com/samsung-cnct/crash-app-backend"
ENV     ELASTICSEARCH_TARGET_URL=http://elasticsearch:9200
ENV     RATE_LIMIT_PER_MINUTE=60

RUN apt-get -qq update && apt-get install -y -q build-essential

WORKDIR ${PACKAGE_PATH}
COPY . ${PACKAGE_PATH}

RUN make --no-builtin-rules --file make.golang build-app 
COPY    ./_containerize/crashbackend-linux /crashbackend
EXPOSE  8081
CMD     /crashbackend serve --target $ELASTICSEARCH_TARGET_URL --ratelimit $RATE_LIMIT_PER_MINUTE

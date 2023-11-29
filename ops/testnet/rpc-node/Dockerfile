# Support setting various labels on the final image
ARG COMMIT=""
ARG VERSION=""
ARG BUILDNUM=""

# Build Geth in a stock Go builder container
FROM golang:1.20-alpine as builder

RUN apk add --no-cache make cmake gcc musl-dev linux-headers git bash build-base libc-dev
# Get dependencies - will also be cached if we won't change go.mod/go.sum
COPY go.mod /go-ethereum/
COPY go.sum /go-ethereum/
RUN cd /go-ethereum && go mod download

ADD . /go-ethereum

# For blst
ENV CGO_CFLAGS="-O -D__BLST_PORTABLE__" 
ENV CGO_CFLAGS_ALLOW="-O -D__BLST_PORTABLE__"
RUN cd /go-ethereum && go run build/ci.go install -static ./cmd/geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:3.17

ARG RTF_USER=rtf
ARG RTF_USER_UID=1000
ARG RTF_USER_GID=1000

ENV RTF_HOME=/rtf
ENV HOME=${RTF_HOME}
ENV DATA_DIR=/data

ENV PACKAGES ca-certificates jq \
  bash bind-tools tini \
  grep curl sed gcc

RUN apk add --no-cache $PACKAGES \
  && rm -rf /var/cache/apk/* \
  && addgroup -g ${RTF_USER_GID} ${RTF_USER} \
  && adduser -u ${RTF_USER_UID} -G ${RTF_USER} --shell /sbin/nologin --no-create-home -D ${RTF_USER} \
  && addgroup ${RTF_USER} tty \
  && sed -i -e "s/bin\/sh/bin\/bash/" /etc/passwd  

RUN echo "[ ! -z \"\$TERM\" -a -r /etc/motd ] && cat /etc/motd" >> /etc/bash/bashrc

WORKDIR ${RTF_HOME}

COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

COPY ./ops/testnet/rpc-node/docker-entrypoint.sh ./

RUN chmod +x docker-entrypoint.sh \
    && mkdir -p ${DATA_DIR} \
    && chown -R ${RTF_USER_UID}:${RTF_USER_GID} ${RTF_HOME} ${DATA_DIR}

VOLUME ${DATA_DIR}

USER ${RTF_USER_UID}:${RTF_USER_GID}

# rpc ws graphql
EXPOSE 8545 8546 8547 30303 30303/udp

ENTRYPOINT ["/sbin/tini", "--", "./docker-entrypoint.sh"]
# Image for fetching and building tools
ARG        GO_VERSION=1.24
FROM       golang:${GO_VERSION}-alpine AS build-gno
ENV        GNOROOT="/gnoroot"
ENV        CGO_ENABLED=0 GOOS=linux
RUN        go env -w GOMODCACHE=/root/.cache/go-build

## Download gnoland/gno sources
ARG        GNO_COMMIT=refs/heads/master
## Replace aeddi's fork by main repo (gnolang/gno) when PR #4605 are merged
RUN        wget https://github.com/aeddi/gno/archive/${GNO_COMMIT}.zip -O gno.zip && \
           unzip gno.zip && \
           mv gno-* /gnoroot

## Build main gno tools: gno, gnoland, gnokey and gnoweb
WORKDIR    /gnoroot
RUN        --mount=type=cache,target=/go/pkg/mod/ --mount=type=cache,target=/root/.cache/go-build \
           go mod download -x && \
           go build -ldflags "-w -s" -o ./build/gnoland ./gno.land/cmd/gnoland && \
           go build -ldflags "-w -s" -o ./build/gnokey  ./gno.land/cmd/gnokey && \
           go build -ldflags "-w -s" -o ./build/gnoweb  ./gno.land/cmd/gnoweb && \
           go build -ldflags "-w -s" -o ./build/gno     ./gnovm/cmd/gno

## Build gnodev
WORKDIR    /gnoroot/contribs/gnodev
RUN        --mount=type=cache,target=/go/pkg/mod/ --mount=type=cache,target=/root/.cache/go-build \
           go mod download -x && \
           go build \
             -ldflags "-X github.com/gnolang/gno/gnovm/pkg/gnoenv._GNOROOT=/gnoroot" \
             -o /gnoroot/build/gnodev .

## Build gnogenesis
WORKDIR    /gnoroot/contribs/gnogenesis
RUN        --mount=type=cache,target=/go/pkg/mod/ --mount=type=cache,target=/root/.cache/go-build \
           go mod download -x && \
           go build -ldflags "-w -s" -o /gnoroot/build/gnogenesis .

## Download gnoverse/gnopls sources
ARG        GNOPLS_COMMIT=refs/heads/master
RUN        wget https://github.com/gnoverse/gnopls/archive/${GNOPLS_COMMIT}.zip -O gnopls.zip && \
           unzip gnopls.zip && \
           mv gnopls-* /gnopls

## Build gnopls
WORKDIR    /gnopls
RUN        --mount=type=cache,target=/go/pkg/mod/ --mount=type=cache,target=/root/.cache/go-build \
           go mod download -x && \
           go build -ldflags "-w -s" -o /gnopls/build/gnopls .

## Download prebuilt gnoverse/vscode-gno extension
ARG        VSCODE_EXT_VERSION=1.1.0
WORKDIR    /vscode-ext
## Replace aeddi's fork by main repo (gnoverse/vscode-gno) when PR #29 is merged
RUN        wget https://github.com/aeddi/vscode-gno/releases/download/v${VSCODE_EXT_VERSION}/gno-${VSCODE_EXT_VERSION}.vsix -O gno.vsix


# Image with only the required files and tools built above
FROM       golang:${GO_VERSION}-alpine AS gno-tools
ENV        GNOROOT="/gnoroot"
WORKDIR    /gnoroot
COPY       --from=build-gno /gnoroot/build/gno                             /usr/bin/gno
COPY       --from=build-gno /gnoroot/build/gnodev                          /usr/bin/gnodev
COPY       --from=build-gno /gnoroot/build/gnogenesis                      /usr/bin/gnogenesis
COPY       --from=build-gno /gnoroot/build/gnoland                         /usr/bin/gnoland
COPY       --from=build-gno /gnoroot/build/gnoweb                          /usr/bin/gnoweb
COPY       --from=build-gno /gnoroot/build/gnokey                          /usr/bin/gnokey
COPY       --from=build-gno /gnopls/build/gnopls                           /usr/bin/gnopls
COPY       --from=build-gno /gnoroot/examples                              /gnoroot/examples
COPY       --from=build-gno /gnoroot/gnovm/stdlibs                         /gnoroot/gnovm/stdlibs
COPY       --from=build-gno /gnoroot/gnovm/tests/stdlibs                   /gnoroot/gnovm/tests/stdlibs
COPY       --from=build-gno /gnoroot/gno.land/genesis/genesis_txs.jsonl    /gnoroot/gno.land/genesis/genesis_txs.jsonl
COPY       --from=build-gno /gnoroot/gno.land/genesis/genesis_balances.txt /gnoroot/gno.land/genesis/genesis_balances.txt
COPY       --from=build-gno /vscode-ext/gno.vsix                           /vscode-ext/gno.vsix
RUN        apk add --no-cache make git bash curl
EXPOSE     26656 26657 8888
ENTRYPOINT [ "/bin/bash", "-c" ]

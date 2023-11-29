#!/bin/bash
set -e

RTF_CONFIG=${RTF_HOME}/config/config.toml
RTF_GENESIS=${RTF_HOME}/config/genesis.json

# Init genesis state if geth not exist
DATA_DIR=$(cat ${RTF_CONFIG} | grep -A1 '\[Node\]' | grep -oP '\"\K.*?(?=\")')

GETH_DIR=${DATA_DIR}/geth
if [ ! -d "$GETH_DIR" ]; then
  geth --datadir ${DATA_DIR} init ${RTF_GENESIS}
fi

exec "geth" "--config" ${RTF_CONFIG} "$@"

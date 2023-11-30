#!/bin/bash
set -e

RTF_CONFIG=${RTF_HOME}/config/config.toml

KEYSTORE_DIR=${DATA_DIR}/keystore
if [ ! -d "$KEYSTORE_DIR" ]; then
  geth --rtftestnet --password <(echo) --datadir "${DATA_DIR}" account import <(echo ${VALIDATOR_KEY})
fi

# clear shell history
history -c && history -w

exec "geth" "--rtftestnet"\
 "--config" "${RTF_CONFIG}"\
 "--miner.etherbase" "${VALIDATOR_ADDRESS}"\
 "--datadir" "${DATA_DIR}"\
 "--unlock" "${VALIDATOR_ADDRESS}"\
 "--password" <(echo)\
 "--allow-insecure-unlock"\
 "--nodekey" <(echo "${NODE_KEY}")\
 "--port" "${P2P_PORT}"\
 "$@"

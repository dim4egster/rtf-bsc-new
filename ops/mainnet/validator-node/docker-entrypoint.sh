#!/bin/bash
set -e

RTF_CONFIG=${RTF_HOME}/config/config.toml

KEYSTORE_DIR=${DATA_DIR}/keystore
GETH_DIR=${DATA_DIR}/geth

# check if validator account exists, if not then import it.
if [ ! -d "$KEYSTORE_DIR" ]; then
  geth --rtfmainnet --password <(echo) --datadir "${DATA_DIR}" account import <(echo ${VALIDATOR_KEY})
fi

# clear shell history
history -c && history -w

# To start syncing from scratch should make first run with non full history mode,
# next run will auto switch node to full history archive mode.
# To switch on full history mode need restart container once.
if [ ! -d "$GETH_DIR" ]; then
  exec "geth" "--rtfmainnet"\
   "--config" "${RTF_CONFIG}"\
   "--miner.etherbase" "${VALIDATOR_ADDRESS}"\
   "--mine"\
   "--datadir" "${DATA_DIR}"\
   "--unlock" "${VALIDATOR_ADDRESS}"\
   "--password" <(echo)\
   "--allow-insecure-unlock"\
   "--nodekey" <(echo "${NODE_KEY}")\
   "--port" "${P2P_PORT}"\
   "$@"
 else
   exec "geth" "--rtfmainnet"\
    "--config" "${RTF_CONFIG}"\
    "--miner.etherbase" "${VALIDATOR_ADDRESS}"\
    "--mine"\
    "--datadir" "${DATA_DIR}"\
    "--unlock" "${VALIDATOR_ADDRESS}"\
    "--password" <(echo)\
    "--allow-insecure-unlock"\
    "--nodekey" <(echo "${NODE_KEY}")\
    "--port" "${P2P_PORT}"\
    "--gcmode" "archive"\
    "--syncmode" "full"\
    "--txlookuplimit" "0"\
    "$@"
 fi

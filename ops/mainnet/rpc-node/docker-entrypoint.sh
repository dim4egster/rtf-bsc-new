#!/bin/bash
set -e

RTF_CONFIG=${RTF_HOME}/config/config.toml

exec "geth" "--rtfmainnet"\
 "--config" "${RTF_CONFIG}"\
 "--datadir" "${DATA_DIR}"\
 "--port" "${P2P_PORT}"\
 "--http"\
 "--http.port" "${RPC_PORT}"\
 "--http.addr" "0.0.0.0"\
 "--http.vhosts" "*" \
 "--http.corsdomain" "*" \
 "--ws"\
 "--ws.port" "${WS_PORT}"\
 "--ws.addr" "0.0.0.0" \
 "--ws.origins" "*" \
 "$@"

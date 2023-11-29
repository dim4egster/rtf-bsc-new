#!/bin/bash
set -e

RTF_CONFIG=${RTF_HOME}/config/config.toml

exec "geth" "--rtftestnet"\
 "--config" "${RTF_CONFIG}"\
 "--datadir" "${DATA_DIR}"\
 "--port" "${P2P_PORT}"\
 "--http.port" "${RPC_PORT}"\
 "--ws.port" "${WS_PORT}"\
 "$@"

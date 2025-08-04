#!/bin/bash
set -e

# Remove um arquivo de pid do servidor pré-existente.
rm -f /brilhasorte/tmp/pids/server.pid

# Então executa o comando principal do container (o "CMD" no Dockerfile).
exec "$@"
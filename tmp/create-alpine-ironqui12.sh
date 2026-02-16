#!/bin/bash

set -e

### CONFIGURAÇÕES PADRÃO ###
CT_MIN=120
CT_MAX=129
HOST_PREFIX="ironqui-12"
TEMPLATE="local:vztmpl/alpine-virt-3.19.tar.gz"

MEMORY=256
SWAP=0
CORES=1
STORAGE="local-lvm"
DISK=4

BRIDGE="vmbr0"

MAC_PREFIX="00:01:02:03:01"

### FUNÇÕES ###
hex_id() {
  printf "%02x" "$1"
}

find_free_id() {
  for ((ID=$CT_MIN; ID<=$CT_MAX; ID++)); do
    if ! pct status "$ID" &>/dev/null; then
      echo "$ID"
      return
    fi
  done
  echo ""
}

### EXECUÇÃO ###
echo "=== Criador de LXC Alpine otimizado (ironqui-12) ==="

CT_ID=$(find_free_id)

if [[ -z "$CT_ID" ]]; then
  echo "❌ ERRO: todos os IDs entre $CT_MIN e $CT_MAX estão em uso."
  exit 1
fi

CT_NAME="${HOST_PREFIX}${CT_ID}"

MAC_SUFFIX=$(hex_id "$CT_ID")
MAC_ADDR="${MAC_PREFIX}:${MAC_SUFFIX}"

echo "✔ ID selecionado : $CT_ID"
echo "✔ Nome           : $CT_NAME"
echo "✔ MAC            : $MAC_ADDR"
echo

### CRIAÇÃO DO CONTAINER ###
pct create "$CT_ID" "$TEMPLATE" \
  --hostname "$CT_NAME" \
  --unprivileged 1 \
  --memory "$MEMORY" \
  --swap "$SWAP" \
  --cores "$CORES" \
  --rootfs "$STORAGE:$DISK" \
  --net0 "name=eth0,bridge=$BRIDGE,firewall=0,hwaddr=$MAC_ADDR,ip=dhcp" \
  --features keyctl=1,nesting=1 \
  --onboot 1 \
  --start 1

echo
echo "✅ Container $CT_NAME criado e iniciado com sucesso"

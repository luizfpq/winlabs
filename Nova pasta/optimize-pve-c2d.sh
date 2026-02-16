#!/bin/bash

set -e

echo "=== Otimizando Proxmox 8.4 para hardware antigo (C2D) ==="

### 1️⃣ Swappiness = 10
echo "[1/5] Ajustando swappiness..."
SYSCTL_FILE="/etc/sysctl.d/99-proxmox-tuning.conf"

cat <<EOF > "$SYSCTL_FILE"
vm.swappiness=10
vm.vfs_cache_pressure=50
EOF

sysctl --system >/dev/null
echo "✔ Swappiness configurado"

---

### 2️⃣ Desativar zram (se existir)
echo "[2/5] Desativando zram..."

if systemctl list-unit-files | grep -q zram; then
    systemctl disable --now zram-swap.service 2>/dev/null || true
    systemctl disable --now zramswap.service 2>/dev/null || true
    echo "✔ zram desativado"
else
    echo "✔ zram não encontrado (ok)"
fi

---

### 3️⃣ Desativar ballooning em TODOS os LXCs
echo "[3/5] Desativando ballooning nos LXCs..."

for CT in $(pct list | awk 'NR>1 {print $1}'); do
    pct set "$CT" --balloon 0
done

echo "✔ Ballooning desativado"

---

### 4️⃣ Forçar hard memory limit nos LXCs
echo "[4/5] Ajustando hard memory limits..."

for CT in $(pct list | awk 'NR>1 {print $1}'); do
    CONF="/etc/pve/lxc/${CT}.conf"

    if grep -q "^memory:" "$CONF"; then
        sed -i 's/^memory:.*/memory: 256/' "$CONF"
    else
        echo "memory: 256" >> "$CONF"
    fi

    if grep -q "^swap:" "$CONF"; then
        sed -i 's/^swap:.*/swap: 0/' "$CONF"
    else
        echo "swap: 0" >> "$CONF"
    fi
done

echo "✔ Hard memory limit aplicado (256 MB, swap 0)"

---

### 5️⃣ Garantir containers unprivileged
echo "[5/5] Convertendo LXCs para unprivileged (quando possível)..."

for CT in $(pct list | awk 'NR>1 {print $1}'); do
    CONF="/etc/pve/lxc/${CT}.conf"

    if ! grep -q "^unprivileged: 1" "$CONF"; then
        echo "⚠ CT $CT não é unprivileged"
        echo "   -> Conversão exige parada + mapeamento UID/GID manual"
    else
        echo "✔ CT $CT já é unprivileged"
    fi
done

echo
echo "=== Otimização concluída ==="
echo "⚠ Reinicie os containers para aplicar todas as mudanças"

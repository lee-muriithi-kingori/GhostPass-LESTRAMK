#!/system/bin/sh
# GhostPass — service.sh (mount hiding + re-enforce)
# Lee Muriithi Kingori | t.me/hbstunnelytics

LOG=/data/local/tmp/ghostpass.log
sleep 15

echo "[$(date)] ── GhostPass service ──" >> "$LOG"

# ════════════════════════════════════════════════
#  5. MOUNT — hide root overlays + writable system
# ════════════════════════════════════════════════

# Remount /system and /vendor as read-only
# to clear "writable-system behavior" signal
mount -o ro,remount /system  2>/dev/null && \
    echo "[$(date)] /system remounted RO." >> "$LOG"
mount -o ro,remount /vendor  2>/dev/null && \
    echo "[$(date)] /vendor remounted RO." >> "$LOG"
mount -o ro,remount /product 2>/dev/null

# Hide shell tmp mounts that leak root presence
# "selective shell-tmp concealment" signal
umount /dev/tmp    2>/dev/null
umount /debug_ramdisk 2>/dev/null

# ── Re-enforce all critical props after boot ──────────────────
resetprop ro.boot.verifiedbootstate green
resetprop ro.boot.flash.locked 1
resetprop ro.boot.vbmeta.device_state locked
resetprop ro.build.type user
resetprop ro.build.tags release-keys
resetprop ro.debuggable 0
resetprop ro.secure 1
resetprop ro.kernel.qemu 0
resetprop ro.build.version.security_patch 2025-12-05

echo "[$(date)] Props re-enforced after boot." >> "$LOG"

# ── Rotate vbmeta digest (makes attestation contradictions harder) ──
NEW_DIGEST=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 64)
resetprop ro.boot.vbmeta.digest "$NEW_DIGEST"

echo "[$(date)] ── GhostPass fully active ──" >> "$LOG"

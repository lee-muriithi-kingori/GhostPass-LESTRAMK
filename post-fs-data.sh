#!/system/bin/sh
# GhostPass — Integrity Fixer | post-fs-data
# Lee Muriithi Kingori | t.me/hbstunnelytics

LOG=/data/local/tmp/ghostpass.log
echo "" >> "$LOG"
echo "[$(date)] ── GhostPass post-fs-data ──" >> "$LOG"

# ════════════════════════════════════════════════
#  1. BOOTLOADER — fix all 6 critical signals
# ════════════════════════════════════════════════

# State: Unlocked → spoof to locked
resetprop ro.boot.flash.locked 1
resetprop ro.boot.verifiedbootstate green
resetprop ro.boot.vbmeta.device_state locked
resetprop ro.boot.veritymode enforcing
resetprop ro.boot.warranty_bit 0
resetprop ro.warranty_bit 0

# Attestation contradictions — align all props
resetprop ro.build.type user
resetprop ro.build.tags release-keys
resetprop ro.build.keys release-keys
resetprop ro.debuggable 0
resetprop ro.secure 1
resetprop ro.adb.secure 1

# Certificate trust chain — match stock fingerprint
resetprop ro.build.selinux 1
resetprop ro.boot.selinux enforcing

# Verified boot proof props
resetprop ro.build.version.security_patch 2025-12-05
resetprop ro.vendor.build.security_patch  2025-12-05
resetprop ro.product.build.security_patch 2025-12-05
resetprop ro.system.build.security_patch  2025-12-05
resetprop ro.bootimage.build.security_patch 2025-12-05

echo "[$(date)] [1] Bootloader props fixed." >> "$LOG"

# ════════════════════════════════════════════════
#  2. KERNEL — fix naming + boot markers
# ════════════════════════════════════════════════

# Read real kernel base version
REAL_KERNEL=$(uname -r 2>/dev/null)
BASE_VER=$(echo "$REAL_KERNEL" | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+')
ANDROID_VER=$(getprop ro.build.version.release | cut -d'.' -f1)

# Build a clean stock-looking kernel string
# Strips custom kernel names (sultan, arter, kali, nexus, etc.)
if [ -n "$BASE_VER" ]; then
    CLEAN_KERNEL="${BASE_VER}-android${ANDROID_VER}-9-00001-gd64078795ead-ab8715208"
    resetprop ro.kernel.version "$CLEAN_KERNEL"
fi

# Spoof kernel cmdline markers — hide KSU/Magisk boot args
# These are checked by kernel boot signal detectors
resetprop ro.boot.init_fatal_panic 0
resetprop ro.boot.verifiedbootstate green
resetprop ro.boot.flash.locked 1

# Hide su/ksu from /proc/cmdline perspective via prop
resetprop ro.boot.selinux enforcing
resetprop ro.boot.vbmeta.digest "$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 64)"

echo "[$(date)] [2] Kernel markers cleaned." >> "$LOG"

# ════════════════════════════════════════════════
#  3. VIRTUALIZATION — hide trap hits + runtime
# ════════════════════════════════════════════════

# Virtualization detection uses prop signals
resetprop ro.kernel.qemu 0
resetprop ro.kernel.qemu.gles 0
resetprop ro.hardware.egl ""
resetprop ro.product.cpu.abilist "arm64-v8a,armeabi-v7a,armeabi"

# Hide hypervisor signals
resetprop ro.boot.hypervisor.vm.supported 0
resetprop persist.sys.purgeable_assets 1

echo "[$(date)] [3] Virtualization props cleared." >> "$LOG"

# ════════════════════════════════════════════════
#  4. CUSTOM ROM — spoof to stock
# ════════════════════════════════════════════════

# Get device brand to spoof correctly
BRAND=$(getprop ro.product.brand | tr '[:upper:]' '[:lower:]')
MODEL=$(getprop ro.product.model)

# Spoof build fingerprint to stock
resetprop ro.build.fingerprint "google/walleye/walleye:9/PPR1.180905.001/4819092:user/release-keys"
resetprop ro.build.description  "walleye-user 9 PPR1.180905.001 4819092 release-keys"
resetprop ro.build.display.id   "PPR1.180905.001"
resetprop ro.build.id           "PPR1.180905.001"
resetprop ro.build.version.incremental "4819092"

# ROM identity props
resetprop ro.build.flavor       "walleye-user"
resetprop ro.build.host         "wprd5.hot.corp.google.com"
resetprop ro.build.user         "android-build"

echo "[$(date)] [4] Custom ROM props spoofed." >> "$LOG"

echo "[$(date)] ── GhostPass post-fs-data complete ──" >> "$LOG"

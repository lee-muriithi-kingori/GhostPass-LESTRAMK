#!/system/bin/sh

PROPFILE=true

permission() {
    set_perm_recursive "$MODPATH" 0 0 0755 0644
    chmod 0755 "$MODPATH/post-fs-data.sh"
    chmod 0755 "$MODPATH/service.sh"
}

Info() {
    ui_print ""
    sleep 0.2
    ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ui_print "  GhostPass — Integrity Fixer"
    ui_print "  by Lee Muriithi Kingori"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sleep 0.5
    ui_print ""
    ui_print "  Fixing:"
    sleep 0.2
    ui_print "  [*] Bootloader — 6 integrity signals"
    sleep 0.2
    ui_print "  [*] Kernel     — naming + boot markers"
    sleep 0.2
    ui_print "  [*] Mount      — overlay + RO signals"
    sleep 0.2
    ui_print "  [*] Virtualization — trap + runtime"
    sleep 0.2
    ui_print "  [*] Custom ROM — stock fingerprint"
    sleep 0.5
    ui_print ""
    ui_print "  Reboot and re-run your checker."
    ui_print "  Log: /data/local/tmp/ghostpass.log"
    ui_print ""
    ui_print "  Module flashed successfully!"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    sleep 1
}

install() {
    permission
    Info
}
install
am start -a android.intent.action.VIEW -d https://t.me/hbstunnelytics >/dev/null 2>&1

#!/bin/bash
# icons-visible — toggle, or set explicitly (true/false), nemo desktop icons.
# Uses the icons-visible key when available (live toggle, background
# right-click menu stays usable the whole time).
# Falls back to the deprecated show-desktop-icons key otherwise -- this
# works, but setting it to false kills the whole nemo-desktop process
# (it's tied to the session AutostartCondition), which takes the
# right-click context menu down with it. On the fallback path there is
# no mouse-driven way back -- you MUST run this script again from a
# terminal (e.g. `icons-visible true`) to bring icons back.

SCHEMA=org.nemo.desktop

if gsettings list-keys "$SCHEMA" 2>/dev/null | grep -qx icons-visible; then
    KEY=icons-visible
else
    KEY=show-desktop-icons
fi

case "$1" in
    true|false)
        gsettings set "$SCHEMA" "$KEY" "$1"
        ;;
    "")
        STATUS=$(gsettings get "$SCHEMA" "$KEY")
        if [ "$STATUS" = "true" ]; then
            gsettings set "$SCHEMA" "$KEY" false
        else
            gsettings set "$SCHEMA" "$KEY" true
        fi
        ;;
    *)
        echo "usage: icons-visible [true|false]" >&2
        exit 1
        ;;
esac

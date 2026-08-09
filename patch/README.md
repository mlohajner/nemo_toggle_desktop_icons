## The patch adds a new GSettings key:

```text
/org/nemo/desktop/icons-visible
```

This setting controls **only the visibility of the desktop icons**.

The important difference is:

```text
show-desktop-icons = false
    → disables nemo-desktop

icons-visible = false
    → hides desktop icons
    → keeps nemo-desktop running
```

With this patch applied, `nemo-desktop` continues to run normally even when the icons are hidden.

This means that the desktop remains interactive and the desktop context menu remains available.

## GSettings

After installing the patched version of Nemo, the new setting can be inspected with:

```bash
gsettings get org.nemo.desktop icons-visible
```

Show the icons:

```bash
gsettings set org.nemo.desktop icons-visible true
```

Hide the icons:

```bash
gsettings set org.nemo.desktop icons-visible false
```

Toggle the value manually:

```bash
gsettings set org.nemo.desktop icons-visible \
    "$(gsettings get org.nemo.desktop icons-visible | grep -q true && echo false || echo true)"
```

The `toggle-desktop-icons.sh` script in the parent project provides a more convenient interface for this and is intended to be used instead of manually manipulating GSettings.

## Patch

The patch is:

```text
nemo-desktop-icons-visible.patch
```

It is intended to be applied to the Nemo source tree before building Nemo.

## Tested version

The patch has been tested with:

* **Nemo 6.4.5**
* **Fedora**
* build system: **Ninja**

Other Nemo versions may require adjustments if the relevant `nemo-desktop` code changes.

This patch should therefore be considered **version-dependent** rather than a universal patch for every Nemo release.

## Installing

After successfully building Nemo, install it using the normal installation procedure for the Nemo build.

For example:

```bash
sudo ninja -C build install
```

**Be careful when installing a locally built Nemo over the distribution-provided package.**

It is recommended to keep a way to restore the original Fedora Nemo package in case the patched build needs to be removed or replaced.

## Using it with `toggle-desktop-icons.sh`

This patch is the underlying part of the `nemo_toggle_desktop_icons` project.

Once patched Nemo is installed, the script:

```text
../action/toggle-desktop-icons.sh
```

can use the new setting to provide a convenient toggle.

It supports:

```bash
toggle-desktop-icons.sh
```

Toggle the current state.

```bash
toggle-desktop-icons.sh true
```

Make the icons visible.

```bash
toggle-desktop-icons.sh false
```

Hide the icons.

The script can also be installed as a Nemo desktop action, allowing the icons to be toggled directly from the desktop context menu.

See the main project README for installation and usage instructions.

## Important

This patch changes Nemo itself.

Installing only the shell script or Nemo action **does not add `icons-visible`** to an unpatched Nemo installation.

The expected setup is:

```text
patched Nemo
    │
    └── org.nemo.desktop/icons-visible
                │
                ▼
    toggle-desktop-icons.sh
                │
        ┌───────┴────────┐
        ▼                ▼
 Nemo context menu     CLI
```

## Compatibility

The patch was tested on **Fedora 43, Kernel 7.1.7 with Nemo 6.4.5** and compiled using **Ninja**.

It may not apply cleanly to other Nemo versions.

If the patch fails to apply after a Nemo update, the relevant `nemo-desktop` source code has probably changed and the patch may need to be updated.

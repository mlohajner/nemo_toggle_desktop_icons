## Toggle Nemo desktop icons without disabling `nemo-desktop`.

This project adds a proper way to **show/hide desktop icons in `nemo-desktop` while keeping the desktop itself alive and usable**.

The main component is:

```text
action/toggle-desktop-icons.sh
```

It can be used either from the **Nemo desktop context menu** or directly from the **command line**.

## The issue

Nemo provides the following GSettings key:

```text
/org/nemo/desktop/show-desktop-icons
```

At first glance, this looks like the setting you would use to show or hide desktop icons.

Unfortunately, that is not what it actually does.

When `show-desktop-icons` is set to `false`, Nemo does not simply hide the icons. It effectively disables/stops the `nemo-desktop` desktop component.

As a result:

* desktop icons disappear;
* `nemo-desktop` is no longer functioning normally;
* the desktop context menu disappears with it;
* there is no longer a convenient mouse-driven way to enable the icons again.

This makes the setting unsuitable for a simple **"temporarily hide my desktop icons"** function.

## The solution

This project patches `nemo-desktop` to add a new GSettings key:

```text
/org/nemo/desktop/icons-visible
```

The new key does exactly what its name suggests:

> It controls **the visibility** of desktop icons without disabling `nemo-desktop`.

When `icons-visible` is set to `false`, the icons are hidden, but the Nemo desktop container remains active.

This means that:

* the desktop remains functional;
* right-click on the desktop continues to work;
* the Nemo desktop context menu remains available;
* the icons can be shown again immediately.

The relevant patch is located in:

```text
patch/
```

## The script

Once the patched Nemo is installed, the script:

```text
action/toggle-desktop-icons.sh
```

provides a simple interface for controlling the new setting.

### No argument — toggle

```bash
toggle-desktop-icons.sh
```

Toggles the current state:

```text
visible → hidden
hidden  → visible
```

### Explicitly show icons

```bash
toggle-desktop-icons.sh true
```

### Explicitly hide icons

```bash
toggle-desktop-icons.sh false
```

Invalid arguments are rejected:

```bash
toggle-desktop-icons.sh something
```

The usage is:

```text
toggle-desktop-icons.sh [true|false]
```

## Nemo desktop context menu

The script can be installed as a Nemo action so that it can be launched directly from the desktop context menu.

Install:

```text
action/toggle-desktop-icons.sh
```

together with the accompanying `nemo_action` file into:

```text
~/.local/share/nemo/actions/
```

For example:

```bash
mkdir -p ~/.local/share/nemo/actions

cp action/toggle-desktop-icons.sh ~/.local/share/nemo/actions/
cp action/nemo_action ~/.local/share/nemo/actions/
```

Make the script executable:

```bash
chmod +x ~/.local/share/nemo/actions/toggle-desktop-icons.sh
```

After installation, the action is available from the Nemo desktop context menu.

## Command-line usage

The same script can also be used as a normal command.

You can create a symlink to it somewhere in your `$PATH` and give it whatever name you prefer.

For example:

```bash
mkdir -p ~/.local/bin

ln -s \
  "$HOME/.local/share/nemo/actions/toggle-desktop-icons.sh" \
  "$HOME/.local/bin/icons-visible"
```

Make sure `~/.local/bin` is in your `$PATH`.

You can then simply use:

```bash
icons-visible
```

to toggle the icons.

Or explicitly set the desired state:

```bash
icons-visible true
icons-visible false
```

This makes it convenient to use from:

* terminal;
* keyboard shortcuts;
* scripts;
* launchers;
* desktop automation.

## How it works

The script uses the `org.nemo.desktop` GSettings schema.

When the patched Nemo provides the new key, the script uses:

```text
org.nemo.desktop/icons-visible
```

Otherwise, it falls back to the existing:

```text
org.nemo.desktop/show-desktop-icons
```

The fallback is useful on an unpatched system, but it has the original Nemo limitation: setting `show-desktop-icons=false` can disable the `nemo-desktop` component itself.

Therefore, **the patched `icons-visible` key is the intended and recommended solution**.

## Requirements

* Nemo
* `gsettings`
* a Nemo build containing the `icons-visible` patch

The shell script itself is intentionally simple and only depends on standard shell tools and GSettings.

## Repository layout

```text
.
├── action/
│   ├── README.md
│   ├── toggle-desktop-icons.nemo_action
│   └── toggle-desktop-icons.sh
├── patch/
│   ├── README.md
│   └── nemo-desktop-icons-visible.patch
├── binary/
│   ├── org.nemo.gschema.xml
│   └── nemo-desktop
├── LICENSE
└── README.md
```

The important pieces are:

| Component                        | Purpose                                           |
| -------------------------------- | ------------------------------------------------- |
| `patch/`                         | Adds `org.nemo.desktop/icons-visible` to Nemo     |
| `action/toggle-desktop-icons.sh` | CLI/context-menu interface for toggling the icons |
| `action/nemo_action`             | Nemo action definition                            |
| `binary/`                        | Binary/package-related files                      |

## Why not just use `show-desktop-icons`?

Because these are two different concepts:

```text
show-desktop-icons
        ↓
enable/disable nemo-desktop itself
```

versus:

```text
icons-visible
        ↓
show/hide the icons
        ↓
keep nemo-desktop running
```

### For a feature such as **"hide my desktop icons"**, the second behavior is what users actually expect.

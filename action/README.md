### Add **Toggle Desktop Icons** functionality to the Nemo desktop context menu!

The main component is:

```text
toggle-desktop-icons.sh
```

It can be used in two ways:

1. as a **Nemo desktop action**, available from the desktop context menu;
2. directly from the **command line**.

The script also works with an unpatched Nemo installation by falling back to the existing `show-desktop-icons` GSettings key, although that has the limitations described in the main project README.

## Installation as a Nemo action

Copy the files from this directory to:

```text
~/.local/share/nemo/actions/
```

For example:

```bash
mkdir -p ~/.local/share/nemo/actions

cp toggle-desktop-icons.sh nemo_action \
    ~/.local/share/nemo/actions/
```

Make sure the script is executable:

```bash
chmod +x ~/.local/share/nemo/actions/toggle-desktop-icons.sh
```


After installation, the action becomes available from the **Nemo desktop context menu**.

This is the intended way to use the script together with the patched Nemo: right-click the desktop and use the action to toggle the desktop icons without disabling `nemo-desktop`.

## Command-line usage

`toggle-desktop-icons.sh` is not limited to Nemo actions.

It can also be executed directly from the command line.

The accepted arguments are:

```text
no argument  → toggle
true         → show icons
false        → hide icons
```

## Making it available as a normal CLI command

For convenient command-line usage, create a symbolic link to the script somewhere in your `$PATH`.

For example, if `~/.local/bin` is in your `$PATH`:

```bash
mkdir -p ~/.local/bin

ln -s \
    ~/.local/share/nemo/actions/toggle-desktop-icons.sh \
    ~/.local/bin/icons-visible
```

You can then use:

```bash
icons-visible
```

or explicitly specify the desired state:

```bash
icons-visible true
icons-visible false
```
## GSettings fallback

The script is designed to work with both **patched and unpatched Nemo**.

When the new:

```text
org.nemo.desktop/icons-visible
```

setting is available, the script uses it.

If it is not available, the script falls back to the original:

```text
org.nemo.desktop/show-desktop-icons
```

This means the script can still be used from the CLI even if Nemo has not been patched.

However, the fallback has an important limitation.

### Unpatched Nemo

With the original `show-desktop-icons` setting, hiding the desktop icons also disables the Nemo desktop itself.

As a consequence, `nemo-desktop` no longer behaves normally and the desktop context menu may disappear.

This is a limitation of Nemo's original GSettings behavior, not of the script.

For the full explanation and the difference between the two settings, see the main project README.

### Patched Nemo

With the `icons-visible` patch installed:

```text
org.nemo.desktop/icons-visible
```

controls only the visibility of the icons.

`nemo-desktop` remains active, so the desktop and its context menu continue to work normally.

This is the recommended setup.
For details about building and applying the Nemo patch, see the README in the `patch/` directory.

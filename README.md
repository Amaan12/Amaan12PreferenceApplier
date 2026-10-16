# Amaan12 Preference Applier

Personal preferences, shortcuts, and layout configurations for rapid dev environment setups across different tools and software.

---

## Unity Preferences

One-command setup for personal Unity preferences, Blender-style shortcuts, and custom window layouts.

### Quick Install (PowerShell)

Open PowerShell on any Windows machine and run:

```powershell
irm https://raw.githubusercontent.com/Amaan12/Amaan12PreferenceApplier/main/Unity/setup.ps1 | iex
```

> Applies everything globally to Unity in seconds without touching your project files or Git history.

### What It Sets

<details>
<summary><b>Shortcuts (<code>Default copy</code>)</b></summary>

* `G`: Move Tool (Grab)
* `R`: Rotate Tool
* `S`: Scale Tool
* `MMB`: Orbit Scene View
* `Alt + MMB`: Pan Scene View *(Shift + MMB is not possible due to Unity internals as it causes conflicts with MMB)*
* `F12`: Toggle Fullscreen

</details>

<details>
<summary><b>Preferences</b></summary>

* Lime Playmode Tint (`#E0FF53`)
* Spawn at World Origin `(0, 0, 0)`
* Recompile After Finished Playing
* Disable Auto-Save in Prefab Mode
* 4x MSAA in Scene View
* Clean Hierarchy (no alternating row backgrounds, prompt to rename new objects)

</details>

<details>
<summary><b>Layout</b></summary>

* Deploys custom **`2 by 3 - 2026`** window layout to Unity's global Layouts menu.

</details>

---

## Krunker.io Preferences

Personal competitive configuration for Krunker.io. Includes tuned sensitivities, custom HUD scaling, crosshairs, audio levels, and per-class viewmodel offsets optimized for clean visuals and FPS performance.

Import [`Krunker.io/settings.txt`](Krunker.io/settings.txt) directly into the in-game settings menu via **Settings > Import**.

---

## VS Code Preferences

---

## Windows Preferences

---

## VS Code

Backup of personal Visual Studio Code preferences, keybindings, custom snippets, and extension list in [`VS Code/`](VS%20Code).

### Contents
* **`settings.json`**: Global editor configurations, themes, typography, formatting, and tool settings.
* **`keybindings.json`**: Custom shortcuts (e.g. `Ctrl + Tab` / `Ctrl + Shift + Tab` tab switching).
* **`extensions.txt`**: Complete list of installed user extensions.
* **`snippets/`**: Custom language snippets (`csharp.json`, `UnityUSS.json`, `UnityUXML.json`).

### Quick Restore on Windows
Copy the backup files into your VS Code User configuration folder:
```powershell
Copy-Item "VS Code\settings.json", "VS Code\keybindings.json" -Destination "$env:APPDATA\Code\User\" -Force
Copy-Item "VS Code\snippets\*" -Destination "$env:APPDATA\Code\User\snippets\" -Force
```
To install all extensions from `extensions.txt`:
```powershell
Get-Content "VS Code\extensions.txt" | ForEach-Object { code --install-extension $_ }
```

---

## License

[MIT](LICENSE.md)

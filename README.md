# Amaan12 Preference Applier (`com.amaan.preferenceapplier`)

A dedicated Unity Editor package to quickly apply and restore Amaan12's personalized Unity preferences, Blender-style shortcut mappings, custom window layouts, and clean project workflow defaults with a single click.

## Installation

### Install via Git URL
In Unity Package Manager (`Window > Package Manager`):
1. Click the `+` button in the top left.
2. Select **Add package from git URL...**
3. Enter your repository URL:
```
https://github.com/Amaan12/Amaan12PreferenceApplier.git
```

---

## Usage

Once installed, navigate to the Unity menu bar and select:
```
Tools > Amaan12 > PersonalPreferences
```

This single command automatically applies:

### 1. Shortcuts (`Default copy`)
* **Transform Tools (Blender-style)**:
  * `G`: Move Tool (Grab)
  * `R`: Rotate Tool
  * `S`: Scale Tool
* **Viewport Navigation**:
  * `Middle Mouse Button (MMB)`: Orbit Scene View
  * `Alt + MMB`: Pan Scene View *(Shift + MMB is not possible due to Unity internals)*
* **Window Management**:
  * `F12`: Toggle Focused Window Fullscreen (yFullScreen)

### 2. Editor & Project Preferences
* **Colors**: Custom lime-yellow Playmode tint (`#E0FF53`)
* **3D & 2D Objects**: New objects spawn at World Origin `(0, 0, 0)` instead of camera view
* **Scene View**: 4x MSAA enabled for clear viewport rendering
* **Script Changes While Playing**: Set to *Recompile After Finished Playing*
* **Prefab Mode**: Auto-Save disabled (manual save only)
* **Hierarchy Window**: Clean display with alternating row backgrounds off and prompt to rename new objects enabled

### 3. Window Layout (`2 by 3 - 2026`)
* Automatically deploys the custom **`2 by 3 - 2026`** window layout to Unity's global Layouts preferences.
* Dynamically reloads the Layouts dropdown menu so it is immediately accessible from **Window > Layouts**.

---

## License

This package is licensed under the [MIT License](LICENSE.md).

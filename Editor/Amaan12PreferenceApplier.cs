#if UNITY_EDITOR
using System;
using System.IO;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace Amaan12.Preferences
{
    public static class Amaan12PreferenceApplier
    {
        private const string ShortcutProfileName = "Default copy";
        private const string ShortcutFileName = "Default copy.shortcut";
        private const string LayoutFileName = "2 by 3 - 2026.wlt";

        [MenuItem("Tools/Amaan12/PersonalPreferences")]
        public static void ApplyPersonalPreferences()
        {
            try
            {
                ApplyShortcuts();
                ApplyEditorPreferences();
                ApplyLayoutPreferences();

                Debug.Log($"<color=#55FF55><b>[Amaan12]</b></color> Successfully applied personal preferences, shortcuts ('{ShortcutProfileName}'), and layout ('{Path.GetFileNameWithoutExtension(LayoutFileName)}')!");
                EditorUtility.DisplayDialog(
                    "Amaan12 Preferences",
                    "Personal Preferences applied successfully!\n\n" +
                    "• Shortcuts: 'Default copy' (G: Move, R: Rotate, S: Scale, MMB: Orbit, Shift+MMB: Pan, F12: Fullscreen)\n" +
                    "• Colors: Lime Playmode Tint (#E0FF53)\n" +
                    "• Scene & Objects: Spawn at World Origin (0,0,0) & 4x MSAA\n" +
                    "• General: Recompile after finished playing & Manual Prefab Save\n" +
                    "• Hierarchy: Clean hierarchy (no alternating rows, prompt to rename)\n" +
                    "• Layout: '2 by 3 - 2026' added to Layouts menu!",
                    "Awesome!"
                );
            }
            catch (Exception ex)
            {
                Debug.LogError($"[Amaan12] Failed to apply preferences: {ex.Message}");
                EditorUtility.DisplayDialog("Error", $"Failed to apply preferences:\n{ex.Message}", "OK");
            }
        }

        private static void ApplyShortcuts()
        {
            string sourceFile = FindPackageFile(ShortcutFileName);
            if (string.IsNullOrEmpty(sourceFile) || !File.Exists(sourceFile))
            {
                Debug.LogWarning($"[Amaan12] Could not locate '{ShortcutFileName}' in project or packages.");
                return;
            }

            string appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            string destinationDir = Path.Combine(appData, "Unity", "Editor-5.x", "Preferences", "shortcuts", "default");
            if (!Directory.Exists(destinationDir))
            {
                Directory.CreateDirectory(destinationDir);
            }

            string destinationFile = Path.Combine(destinationDir, ShortcutFileName);
            File.Copy(sourceFile, destinationFile, overwrite: true);

            EditorPrefs.SetString("ShortcutManagement_LastUsedShortcutProfileId_default", ShortcutProfileName);
            ReloadShortcutManager(ShortcutProfileName);
        }

        private static void ApplyEditorPreferences()
        {
            // Colors: Lime Playmode Tint (#E0FF53)
            EditorPrefs.SetString("Playmode tint", "Playmode tint;0.8784314;1;0.3254902;1");

            // Scene View & Object Creation: Spawn at World Origin (0,0,0)
            EditorPrefs.SetInt("Create3DObject.PlaceAtWorldOrigin", 1);
            EditorPrefs.SetInt("Create3DObject.PlacementMode", 1);

            // Scene View: 4x MSAA
            EditorPrefs.SetInt("SceneViewMSAALevel", 4);

            // General: Recompile After Finished Playing
            EditorPrefs.SetInt("ScriptCompilationDuringPlay", 0);

            // Prefab Mode: Disable Auto-Save (manual save only)
            EditorPrefs.SetInt("PrefabEditing.AutoSave", 0);

            // Hierarchy: Clean Hierarchy (no alternating rows, prompt to rename new objects)
            EditorPrefs.SetInt("HierarchyWindow.AlternatingRowBackground", 0);
            EditorPrefs.SetInt("SceneHierarchyWindow.RenameNewObjects", 1);
        }

        private static void ApplyLayoutPreferences()
        {
            string sourceFile = FindPackageFile(LayoutFileName);
            if (string.IsNullOrEmpty(sourceFile) || !File.Exists(sourceFile))
            {
                Debug.LogWarning($"[Amaan12] Could not locate '{LayoutFileName}' in project or packages.");
                return;
            }

            string appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            string layoutsRootDir = Path.Combine(appData, "Unity", "Editor-5.x", "Preferences", "Layouts");
            string layoutsDefaultDir = Path.Combine(layoutsRootDir, "default");

            if (!Directory.Exists(layoutsRootDir))
            {
                Directory.CreateDirectory(layoutsRootDir);
            }
            if (!Directory.Exists(layoutsDefaultDir))
            {
                Directory.CreateDirectory(layoutsDefaultDir);
            }

            string destDefault = Path.Combine(layoutsDefaultDir, LayoutFileName);
            string destRoot = Path.Combine(layoutsRootDir, LayoutFileName);

            File.Copy(sourceFile, destDefault, overwrite: true);
            File.Copy(sourceFile, destRoot, overwrite: true);

            ReloadWindowLayoutMenu();
        }

        private static string FindPackageFile(string fileName)
        {
            // 1. Direct check in Packages folder
            string packageEditorPath = Path.GetFullPath(Path.Combine("Packages", "com.amaan.preferenceapplier", "Editor", fileName));
            if (File.Exists(packageEditorPath)) return packageEditorPath;

            // 2. Search inside project Assets
            string[] found = Directory.GetFiles(Application.dataPath, fileName, SearchOption.AllDirectories);
            if (found.Length > 0) return found[0];

            // 3. Search inside Packages directory
            string packagesDir = Path.GetFullPath(Path.Combine(Application.dataPath, "..", "Packages"));
            if (Directory.Exists(packagesDir))
            {
                found = Directory.GetFiles(packagesDir, fileName, SearchOption.AllDirectories);
                if (found.Length > 0) return found[0];
            }

            // 4. Search inside Library/PackageCache
            string packageCacheDir = Path.GetFullPath(Path.Combine(Application.dataPath, "..", "Library", "PackageCache"));
            if (Directory.Exists(packageCacheDir))
            {
                found = Directory.GetFiles(packageCacheDir, fileName, SearchOption.AllDirectories);
                if (found.Length > 0) return found[0];
            }

            return null;
        }

        private static void ReloadShortcutManager(string profileId)
        {
            try
            {
                var shortcutIntegrationType = typeof(Editor).Assembly.GetType("UnityEditor.ShortcutManagement.ShortcutIntegration");
                if (shortcutIntegrationType == null) return;

                var instanceProp = shortcutIntegrationType.GetProperty("instance", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
                var instance = instanceProp?.GetValue(null, null);
                if (instance == null) return;

                var profileManagerProp = shortcutIntegrationType.GetProperty("profileManager", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                var profileManager = profileManagerProp?.GetValue(instance, null);
                if (profileManager == null) return;

                var reloadMethod = profileManager.GetType().GetMethod("ReloadProfiles", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                reloadMethod?.Invoke(profileManager, null);

                var getProfileByIdMethod = profileManager.GetType().GetMethod("GetProfileById", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                var profile = getProfileByIdMethod?.Invoke(profileManager, new object[] { profileId });

                if (profile != null)
                {
                    var activeProfileProp = profileManager.GetType().GetProperty("activeProfile", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                    activeProfileProp?.SetValue(profileManager, profile, null);
                }
            }
            catch (Exception ex)
            {
                Debug.LogWarning($"[Amaan12] Note: Restart Unity if shortcut changes are not immediately visible: {ex.Message}");
            }
        }

        private static void ReloadWindowLayoutMenu()
        {
            try
            {
                var windowLayoutType = typeof(Editor).Assembly.GetType("UnityEditor.WindowLayout");
                if (windowLayoutType == null) return;

                var reloadMenuMethod = windowLayoutType.GetMethod("ReloadWindowLayoutMenu", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
                reloadMenuMethod?.Invoke(null, null);
            }
            catch (Exception ex)
            {
                Debug.LogWarning($"[Amaan12] Note: Restart Unity if layout changes are not immediately visible in menu: {ex.Message}");
            }
        }
    }
}
#endif

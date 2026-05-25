## 2.1.0

* 14th release of `interactive_3d` — **Runtime PBR overrides** 🎨
- New controller API: `setEntityMaterial`, `setEntityMaterials`, `resetEntityMaterial`, `resetAllMaterialOverrides`. Apply per-entity color, metallic, roughness, and emissive at runtime, independent of the selection system.
- New widget param `initialMaterialOverrides` applies overrides once on model load (alongside `preselectedEntities`).
- New `MaterialOverride` model with partial-update semantics: unspecified fields keep their prior value, successive calls merge.
- Visual precedence on the clean path: `selection > override > GLB original`. Selection still wins while active; deselect restores the override, not the GLB original.
- GLB textures are preserved by default; `color` tints them via factor multiplication (Filament `baseColorFactor` on Android, SCNMaterial `multiply` on iOS).
- Backward compatible. Existing cache, `patchColors`, and `preselectedEntities` continue to work. When both cache and override target the same entity, override wins visually and cache stays in storage; calling `resetEntityMaterial` makes the cache color show again on that entity.
- Texture upload from bytes is tracked for v2.2.0.

## 2.0.4

* 13th release of `interactive_3d`
- Added `selectionSequence` enforcement on Android, matching the existing iOS behavior. Taps that violate the configured order are rejected and emit a `selectionRejected` event.


## 2.0.3

* 12th release of `interactive_3d`
- Adaptive render resolution using capped devicePixelRatio for sharper output without Hybrid Composition performance cost.
- Fixed touch coordinate scaling to match render buffer dimensions.
- Removed redundant native-side supersampling.

## 2.0.2

* 11th release of `interactive_3d` 
- Small fixes and optimizations for Android and iOS platforms.

## 2.0.1

* 10th release of `interactive_3d` — **Bug Fix & Code Quality Release** 🛠️
- Fixed selection clear, cache clear, refresh cache, and visibility toggle not working correctly on Android.
- Fixed cache clear not preserving active selection color on iOS.
- Codebase reorganized into focused files across all platforms — no API changes.

## 2.0.0

* 9th release of `interactive_3d` — **Major Release** 🚀
- **BREAKING CHANGE:**
  - Android rendering migrated from Hybrid Composition (AndroidView) to **Texture API (SurfaceProducer)** — dramatically improved performance and instant tap response.
  - iOS memory management optimized to prevent leaks and crashes.

- **New Feature (Both Platforms):**
  - `solidBackgroundColor` — use a solid color background instead of IBL skybox while keeping IBL lighting for PBR quality.

## 1.2.4

* 8th release of `interactive_3d`.
- Feature:
    - Android Memory Performance Optimized

## 1.2.3

* 7th release of `interactive_3d`.
- Feature:
    - Android & iOS memory leaks lead to crash fixes
    - Performance Optimized on Android
    - Example UI updates

## 1.2.2

* 6th release of `interactive_3d`.
- Feature:
  - Control Visibility of different parts of model using Interactive3dController.

## 1.2.1

* 5th release of `interactive_3d`.
- Fix:
  - iOS Plugin name conflict issue fix.
- Feature:
  - Load background environment for iOS.

## 1.2.0

* 4th release of `interactive_3d`.
- Features:
  - Patch Colors (update selected & preselected colors).
  - Interactive3dController introduced.
  - iOS Support with all features on Android 🚀

## 1.0.1

* 3rd release of `interactive_3d`.
- Features:
  - Preselection based on entity names.
  - Dynamic selected color.
  - Set Default Zoom.
  - Load model and background environments from network URLs.

## 0.0.2

* 2nd release of `interactive_3d`.
- Features:
    - App lifecycle crash fixed.
    - Load models background environments ibl and skybox `.ktx` files fix.
    - Code refactored.

## 0.0.1

* Initial release of `interactive_3d`.
- Features:
    - Render `.glb` and `.gltf` models.
    - Interactive touch gestures to extract information.
    - Currently supports only Android using the Filament Engine.
    - Open-source and customizable.

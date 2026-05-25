import 'package:flutter/material.dart';
import 'package:interactive_3d/interactive_3d.dart';

/// Demonstrates runtime PBR material overrides.
///
/// Tap a tooth, then press a condition button to apply the override.
/// The override survives selection: tap the tooth again to re-select it,
/// then tap a button or use reset to see the override returns on deselect.
class PbrOverrideExample extends StatefulWidget {
  const PbrOverrideExample({super.key});

  @override
  State<PbrOverrideExample> createState() => _PbrOverrideExampleState();
}

class _PbrOverrideExampleState extends State<PbrOverrideExample> {
  final _controller = Interactive3dController();
  String? _selectedName;
  final Map<String, _Condition> _conditions = {};

  void _onSelectionChanged(List<EntityData> entities) {
    setState(() {
      _selectedName = entities.isEmpty ? null : entities.first.name;
    });
  }

  Future<void> _apply(_Condition cond) async {
    final name = _selectedName;
    if (name == null) return;
    setState(() => _conditions[name] = cond);
    await _controller.setEntityMaterial(
      name: name,
      color: cond.color,
      metallic: cond.metallic,
      roughness: cond.roughness,
    );
    await _controller.clearSelections();
  }

  Future<void> _resetSelected() async {
    final name = _selectedName;
    if (name == null) return;
    setState(() => _conditions.remove(name));
    await _controller.resetEntityMaterial(name);
    await _controller.clearSelections();
  }

  Future<void> _resetAll() async {
    setState(() => _conditions.clear());
    await _controller.resetAllMaterialOverrides();
    await _controller.clearSelections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PBR Material Overrides'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Interactive3d(
              controller: _controller,
              modelPath: 'assets/models/Tooth-3.glb',
              iblPath: 'assets/models/giuseppe_bridge_4k_ibl.ktx',
              skyboxPath: 'assets/models/giuseppe_bridge_4k_skybox.ktx',
              iOSBackgroundEnvPath: 'assets/models/san_giuseppe_bridge_4k.hdr',
              selectionColor: const [0.0, 0.6, 1.0, 1.0],
              onSelectionChanged: _onSelectionChanged,
            ),
          ),
          _ControlPanel(
            selectedName: _selectedName,
            conditions: _conditions,
            onApply: _apply,
            onResetSelected: _resetSelected,
            onResetAll: _resetAll,
          ),
        ],
      ),
    );
  }
}

/// One mark a tooth can carry. Color tints the GLB texture; metallic and
/// roughness change the surface response. GLB texture detail is preserved.
class _Condition {
  final String label;
  final List<double> color;
  final double metallic;
  final double roughness;
  final Color swatch;

  const _Condition({
    required this.label,
    required this.color,
    required this.metallic,
    required this.roughness,
    required this.swatch,
  });

  static const cavity = _Condition(
    label: 'Cavity',
    color: [0.85, 0.15, 0.15, 1.0],
    metallic: 0.0,
    roughness: 0.9,
    swatch: Color(0xFFD92626),
  );
  static const filling = _Condition(
    label: 'Filling',
    color: [0.85, 0.7, 0.2, 1.0],
    metallic: 0.9,
    roughness: 0.2,
    swatch: Color(0xFFD9B233),
  );
  static const crown = _Condition(
    label: 'Crown',
    color: [1.0, 1.0, 1.0, 1.0],
    metallic: 0.1,
    roughness: 0.4,
    swatch: Color(0xFFE0E0E0),
  );
  static const inflammation = _Condition(
    label: 'Inflamed',
    color: [1.0, 0.5, 0.6, 1.0],
    metallic: 0.0,
    roughness: 0.7,
    swatch: Color(0xFFFF8099),
  );
}

class _ControlPanel extends StatelessWidget {
  final String? selectedName;
  final Map<String, _Condition> conditions;
  final Future<void> Function(_Condition) onApply;
  final Future<void> Function() onResetSelected;
  final Future<void> Function() onResetAll;

  const _ControlPanel({
    required this.selectedName,
    required this.conditions,
    required this.onApply,
    required this.onResetSelected,
    required this.onResetAll,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedName != null;
    final selectedCondition =
        hasSelection ? conditions[selectedName] : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            hasSelection
                ? 'Selected: $selectedName'
                : 'Tap a tooth to select it',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (selectedCondition != null) ...[
            const SizedBox(height: 4),
            Text(
              'Current: ${selectedCondition.label}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _ConditionButton(_Condition.cavity, hasSelection ? onApply : null)),
              const SizedBox(width: 8),
              Expanded(child: _ConditionButton(_Condition.filling, hasSelection ? onApply : null)),
              const SizedBox(width: 8),
              Expanded(child: _ConditionButton(_Condition.crown, hasSelection ? onApply : null)),
              const SizedBox(width: 8),
              Expanded(child: _ConditionButton(_Condition.inflammation, hasSelection ? onApply : null)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reset selected'),
                  onPressed: hasSelection ? () => onResetSelected() : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text('Reset all (${conditions.length})'),
                  onPressed: conditions.isEmpty ? null : () => onResetAll(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConditionButton extends StatelessWidget {
  final _Condition condition;
  final Future<void> Function(_Condition)? onTap;

  const _ConditionButton(this.condition, this.onTap);

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: enabled ? () => onTap!(condition) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: enabled ? condition.swatch : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              Icons.circle,
              color: Colors.black.withValues(alpha: 0.15),
              size: 16,
            ),
            const SizedBox(height: 2),
            Text(
              condition.label,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

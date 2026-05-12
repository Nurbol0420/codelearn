import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import '../../../../core/theme/app_color.dart';

class CourseFilterDialog extends StatefulWidget {
  final Function(String) onLevelSelected;
  final String? initialLevel;
  const CourseFilterDialog({super.key, required this.onLevelSelected, this.initialLevel});

  @override
  State<CourseFilterDialog> createState() => _CourseFilterDialogState();
}

class _CourseFilterDialogState extends State<CourseFilterDialog> {
  late String _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel ?? '';
  }

  void _handleApplyFilter() { widget.onLevelSelected(_selectedLevel); Navigator.pop(context); }
  void _handleResetFilter() {
    final l10n = AppLocalizations.of(context)!;
    setState(() { _selectedLevel = l10n.allLevels; });
    widget.onLevelSelected(l10n.allLevels);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedLevel.isEmpty) _selectedLevel = l10n.allLevels;
    final levels = [l10n.allLevels, l10n.beginner, l10n.intermediate, l10n.advanced];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.filterCourses, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...levels.map((level) => ListTile(
            title: Text(level),
            trailing: _selectedLevel == level ? Icon(Icons.check_circle, color: AppColors.primary) : const Icon(Icons.circle_outlined),
            onTap: () => setState(() => _selectedLevel = level),
          )),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: TextButton(onPressed: _handleResetFilter, child: Text(l10n.reset))),
            const SizedBox(width: 16),
            Expanded(child: ElevatedButton(onPressed: _handleApplyFilter, child: Text(l10n.apply))),
          ]),
        ],
      ),
    );
  }
}

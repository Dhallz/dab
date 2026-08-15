import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/styles/provider_icon_resolver.dart';
import '../../../features/app/app_notifier.dart';
import '../../../core/widgets/selection_tile.dart';
import '../settings_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Settings controls to clear scoped Explorer ObjectBox provider cache.
class SettingsExplorerCacheSection extends ConsumerStatefulWidget {
  const SettingsExplorerCacheSection({super.key});

  @override
  ConsumerState<SettingsExplorerCacheSection> createState() =>
      _SettingsExplorerCacheSectionState();
}

class _SettingsExplorerCacheSectionState
    extends ConsumerState<SettingsExplorerCacheSection> {
  late DateTime _startDate;
  late DateTime _endDate;
  late Set<String> _selectedProviders;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
    final today = _orgToday();
    _startDate = today;
    _endDate = today;
    _selectedProviders = _availableProviderIds().toSet();
  }

  DateTime _orgToday() {
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    final now = DateTime.now().toUtc();
    final dayKey = orgDayKeyFromUtc(orgTimezoneId, now);
    final parts = dayKey.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  List<String> _availableProviderIds() {
    final configs = ref.read(appNotifierProvider).configs;
    return configs
        .where((config) => config.isActive)
        .map((config) => config.id)
        .toList();
  }

  String _formatDay(DateTime day) {
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    return orgCalendarDayString(orgTimezoneId, day);
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _startDate = picked.start;
      _endDate = picked.end;
    });
  }

  void _toggleProvider(String providerId) {
    setState(() {
      final next = Set<String>.from(_selectedProviders);
      if (next.contains(providerId)) {
        next.remove(providerId);
      } else {
        next.add(providerId);
      }
      _selectedProviders = next;
    });
  }

  void _selectAllProviders(List<String> providerIds) {
    setState(() {
      _selectedProviders = providerIds.toSet();
    });
  }

  Future<void> _confirmAndClear() async {
    final l10n = context.l10n;
    if (_selectedProviders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsExplorerCacheSelectProvider)),
      );
      return;
    }

    final providerList = _selectedProviders.toList()..sort();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.settingsExplorerCacheConfirmTitle),
          content: Text(
            l10n.settingsExplorerCacheConfirmMessage(
              _formatDay(_startDate),
              _formatDay(_endDate),
              providerList.join(', '),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.settingsExplorerCacheClearButton),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isClearing = true);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final result = await notifier.clearExplorerCache(
      startDate: _startDate,
      endDate: _endDate,
      providerIds: _selectedProviders,
    );
    if (!mounted) return;
    setState(() => _isClearing = false);

    final messenger = ScaffoldMessenger.of(context);
    result.fold(
      (failure) => messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsExplorerCacheFailure)),
      ),
      (clearResult) => messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.settingsExplorerCacheSuccess(clearResult.totalRemoved),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final configs = ref.watch(appNotifierProvider.select((s) => s.configs));
    final providerIds = configs
        .where((config) => config.isActive)
        .map((config) => config.id)
        .toList();

    if (providerIds.isEmpty) {
      return Text(
        l10n.settingsExplorerCacheNoProviders,
        style: AppTextStyles.bodySmall.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    final allSelected = _selectedProviders.length == providerIds.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsExplorerCacheDescription,
          style: AppTextStyles.bodySmall.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.settingsExplorerCacheDateRange,
                  style: AppTextStyles.labelMedium,
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _isClearing ? null : _pickDateRange,
                  icon: Icon(AppIcons.calendar, size: 18),
                  label: Text(
                    '${_formatDay(_startDate)} — ${_formatDay(_endDate)}',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.settingsExplorerCacheProviders,
                style: AppTextStyles.labelMedium,
              ),
            ),
            TextButton(
              onPressed: _isClearing
                  ? null
                  : () => _selectAllProviders(
                      allSelected ? const [] : providerIds,
                    ),
              child: Text(
                allSelected
                    ? l10n.settingsExplorerCacheClearSelection
                    : l10n.settingsExplorerCacheSelectAll,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...providerIds.map((providerId) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SelectionTile(
              label: _providerLabel(providerId, configs),
              isSelected: _selectedProviders.contains(providerId),
              iconData: ProviderIconResolver.resolveFallbackIcon(
                context,
                providerId,
              ),
              onTap: _isClearing ? () {} : () => _toggleProvider(providerId),
            ),
          );
        }),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _isClearing || _selectedProviders.isEmpty
              ? null
              : _confirmAndClear,
          icon: _isClearing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(AppIcons.delete, size: 18),
          label: Text(l10n.settingsExplorerCacheClearButton),
        ),
      ],
    );
  }

  String _providerLabel(String providerId, List<ProviderConfig> configs) {
    final config = configs
        .where((entry) => entry.id.toLowerCase() == providerId.toLowerCase())
        .firstOrNull;
    final name = config?.name.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    if (providerId.isEmpty) return providerId;
    return providerId[0].toUpperCase() + providerId.substring(1);
  }
}

import 'package:flutter/material.dart';

import '../../../../domain/entities/activity.dart';
import '../../../core/app_bloc_consumer.dart';
import '../../../core/widgets/dab_mesh_background.dart';
import '../../admin/admin_console_view.dart';
import '../../history/history_explorer_view.dart';
import '../../statistics/statistics_view.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dab_activity_card.dart';
import '../widgets/dab_top_menu.dart';

class DashboardViewMobile extends StatefulWidget {
  final DabViewTab activeTab;
  final ValueChanged<DabViewTab> onTabChanged;

  const DashboardViewMobile({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  State<DashboardViewMobile> createState() => _DashboardViewMobileState();
}

class _DashboardViewMobileState extends State<DashboardViewMobile> {
  String _selectedProvider = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: AppBlocConsumer<DashboardBloc, DashboardState>(
          onInit: (context, bloc) => bloc.add(const DashboardStarted()),
          listener: (context, state, bloc) {},
          builder: (context, state, bloc) {
            final filteredActivities = _selectedProvider == 'All'
                ? state.activities
                : state.activities
                      .where(
                        (a) =>
                            a.provider.toLowerCase() ==
                            _selectedProvider.toLowerCase(),
                      )
                      .toList();

            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DabTopMenu(
                      activeTab: widget.activeTab,
                      onTabChanged: widget.onTabChanged,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildTabContent(state, filteredActivities)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF1E293B),
                  child: Text(
                    'AD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  _getFormattedTime(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF8FAFC).withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF10B981),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Feed',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFF8FAFC),
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'Monitoring active stack',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(DashboardState state, List<Activity> activities) {
    switch (widget.activeTab) {
      case DabViewTab.feed:
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildMetrics(state),
            _buildFilters(),
            _buildActivityList(state, activities),
          ],
        );
      case DabViewTab.history:
        return const HistoryExplorerView();
      case DabViewTab.stats:
        return const StatisticsView();
      case DabViewTab.admin:
        return const AdminConsoleView();
    }
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMetrics(DashboardState state) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 120,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            _MetricCard(
              label: 'Slack',
              value:
                  '${state.activities.where((a) => a.provider.toLowerCase() == 'slack').length}',
              icon: Icons.message_rounded,
              color: const Color(0xFF4A154B),
            ),
            _MetricCard(
              label: 'Jira',
              value:
                  '${state.activities.where((a) => a.provider.toLowerCase() == 'jira').length}',
              icon: Icons.analytics_rounded,
              color: const Color(0xFF0052CC),
            ),
            _MetricCard(
              label: 'Phorge',
              value:
                  '${state.activities.where((a) => a.provider.toLowerCase() == 'phorge').length}',
              icon: Icons.settings_suggest_rounded,
              color: const Color(0xFF6B7280),
            ),
            _MetricCard(
              label: 'PRs',
              value:
                  '${state.activities.where((a) => a.type.toLowerCase().contains('pr')).length}',
              icon: Icons.call_merge_rounded,
              color: const Color(0xFF24292F),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final providers = ['All', 'GitHub', 'Slack', 'Jira', 'Linear', 'Phorge'];
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: providers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = _selectedProvider == providers[index];
              return ChoiceChip(
                label: Text(providers[index]),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedProvider = providers[index]);
                  }
                },
                backgroundColor: Colors.white.withOpacity(0.05),
                selectedColor: const Color(0xFF6366F1),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList(DashboardState state, List<Activity> activities) {
    if (state.status == DashboardStatus.loading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
      );
    }

    if (activities.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 48,
                color: const Color(0xFF94A3B8).withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No activities matching your filter.',
                style: TextStyle(
                  color: const Color(0xFF94A3B8).withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => DabActivityCard(activity: activities[index]),
          childCount: activities.length,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8).withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

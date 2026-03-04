import 'package:dab_app/presentation/views/admin/admin_console_view.dart';
import 'package:dab_app/presentation/views/history/history_explorer_view.dart';
import 'package:dab_app/presentation/views/statistics/statistics_view.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/activity.dart';
import '../../../core/app_bloc_consumer.dart';
import '../../../core/widgets/dab_mesh_background.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dab_activity_card.dart';
import '../widgets/dab_top_menu.dart';

class DashboardViewDesktop extends StatefulWidget {
  final DabViewTab activeTab;
  final ValueChanged<DabViewTab> onTabChanged;

  const DashboardViewDesktop({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  State<DashboardViewDesktop> createState() => _DashboardViewDesktopState();
}

class _DashboardViewDesktopState extends State<DashboardViewDesktop> {
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

            return Row(
              children: [
                _buildSidebar(),
                Expanded(
                  child: Column(
                    children: [
                      _buildTopBar(),
                      Expanded(
                        child: _buildTabContent(state, filteredActivities),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final providers = ['All', 'GitHub', 'Slack', 'Jira', 'Linear'];

    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAB',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 48),
          _SidebarItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isSelected: widget.activeTab == DabViewTab.feed,
            onTap: () => widget.onTabChanged(DabViewTab.feed),
          ),
          _SidebarItem(
            icon: Icons.history_rounded,
            label: 'Historical Explorer',
            isSelected: widget.activeTab == DabViewTab.history,
            onTap: () => widget.onTabChanged(DabViewTab.history),
          ),
          _SidebarItem(
            icon: Icons.insights_rounded,
            label: 'Statistics',
            isSelected: widget.activeTab == DabViewTab.stats,
            onTap: () => widget.onTabChanged(DabViewTab.stats),
          ),
          _SidebarItem(
            icon: Icons.notifications_rounded,
            label: 'Alerts',
            onTap: () {},
          ),
          _SidebarItem(
            icon: Icons.link_rounded,
            label: 'Connections',
            onTap: () {},
          ),
          _SidebarItem(
            icon: Icons.admin_panel_settings_rounded,
            label: 'Admin Console',
            isSelected: widget.activeTab == DabViewTab.admin,
            onTap: () => widget.onTabChanged(DabViewTab.admin),
          ),
          _SidebarItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          Text(
            'STACK PROVIDERS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8).withOpacity(0.5),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          ...providers.map(
            (p) => _SidebarItem(
              icon: _getIconForProvider(p),
              label: p,
              isSelected: _selectedProvider == p,
              onTap: () => setState(() => _selectedProvider = p),
              isCompact: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(DashboardState state, List<Activity> activities) {
    switch (widget.activeTab) {
      case DabViewTab.feed:
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildMetricsGrid(),
            _buildActivitySection(state, activities),
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

  Widget _buildTopBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Text(
            'Live Activity Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: DabTopMenu(
              activeTab: widget.activeTab,
              onTabChanged: widget.onTabChanged,
            ),
          ),
          const SizedBox(width: 48),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 8),
                const SizedBox(width: 8),
                Text(
                  'Connected to Relay',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF94A3B8).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF6366F1),
            child: Text(
              'AD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(32),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 2.2,
        ),
        delegate: SliverChildListDelegate([
          _DesktopMetricCard(
            label: 'Ingested Events',
            value: '42,892',
            trend: '+12%',
            icon: Icons.auto_graph_rounded,
            color: const Color(0xFF6366F1),
          ),
          _DesktopMetricCard(
            label: 'System Load',
            value: '22%',
            trend: 'Nominal',
            icon: Icons.terminal_rounded,
            color: const Color(0xFF10B981),
          ),
          _DesktopMetricCard(
            label: 'Active WebHooks',
            value: '14',
            trend: '4 Active',
            icon: Icons.webhook_rounded,
            color: const Color(0xFFA855F7),
          ),
        ]),
      ),
    );
  }

  Widget _buildActivitySection(
    DashboardState state,
    List<Activity> activities,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (state.status == DashboardStatus.loading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(100.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (activities.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Text(
                    'No events detected in this stream.',
                    style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  ),
                ),
              );
            }
            return DabActivityCard(activity: activities[index]);
          },
          childCount: state.status == DashboardStatus.loading
              ? 1
              : (activities.isEmpty ? 1 : activities.length),
        ),
      ),
    );
  }

  IconData _getIconForProvider(String provider) {
    switch (provider.toLowerCase()) {
      case 'github':
        return Icons.code_rounded;
      case 'slack':
        return Icons.chat_bubble_outline_rounded;
      case 'jira':
        return Icons.task_alt_rounded;
      case 'linear':
        return Icons.layers_outlined;
      default:
        return Icons.radar_rounded;
    }
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCompact;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isCompact ? 10 : 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: isCompact ? 18 : 22,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: isCompact ? 13 : 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;

  const _DesktopMetricCard({
    required this.label,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8).withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

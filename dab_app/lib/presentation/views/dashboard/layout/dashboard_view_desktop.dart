import 'package:flutter/material.dart';

import '../../../../domain/entities/activity.dart';
import '../../../core/app_bloc_consumer.dart';
import '../../../core/widgets/dab_mesh_background.dart';
import '../dashboard_bloc.dart';
import '../dashboard_event.dart';
import '../dashboard_state.dart';
import '../widgets/dab_activity_card.dart';

class DashboardViewDesktop extends StatefulWidget {
  const DashboardViewDesktop({super.key});

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
                            a.provider.name.toLowerCase() ==
                            _selectedProvider.toLowerCase(),
                      )
                      .toList();

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSidebar(),
                Expanded(
                  child: Column(
                    children: [
                      _buildTopBar(),
                      Expanded(
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            _buildMetricsGrid(),
                            _buildActivitySection(state, filteredActivities),
                          ],
                        ),
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
    final providers = ['All', 'GitHub', 'Slack', 'Jira', 'Linear', 'Phorge'];

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
          Text(
            'FEED FILTERS',
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
              isCompact: false,
            ),
          ),
        ],
      ),
    );
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
          const Spacer(),
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
      case 'phorge':
        return Icons.settings_suggest_rounded;
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

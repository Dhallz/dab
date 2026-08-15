import 'package:dab_app/presentation/views/dashboard/widgets/dashboard_grouped_feed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('masonry column count grows then caps so tiles widen', () {
    expect(dashboardMasonryColumnCount(0, itemCount: 5), 1);
    expect(dashboardMasonryColumnCount(319, itemCount: 5), 1);
    expect(dashboardMasonryColumnCount(320, itemCount: 5), 1);
    expect(dashboardMasonryColumnCount(640, itemCount: 5), 2);
    expect(dashboardMasonryColumnCount(959, itemCount: 5), 2);
    expect(dashboardMasonryColumnCount(960, itemCount: 5), 3);
    expect(
      dashboardMasonryColumnCount(1600, itemCount: 5),
      3,
      reason: 'extra width must widen tiles, not add a 4th/5th column',
    );
    expect(dashboardMasonryColumnCount(double.infinity, itemCount: 5), 1);
  });

  test('masonry column count never exceeds the number of tiles', () {
    expect(dashboardMasonryColumnCount(1600, itemCount: 1), 1);
    expect(dashboardMasonryColumnCount(1600, itemCount: 2), 2);
    expect(dashboardMasonryColumnCount(400, itemCount: 8), 1);
  });
}

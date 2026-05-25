import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/home/application/home_controller.dart';
import 'package:mobile/features/home/domain/priority_work_item.dart';

void main() {
  test('home priority work is sorted by rank', () {
    final ordered = orderPriorityWork([
      const PriorityWorkItem(
        kind: PriorityWorkKind.session,
        title: 'Active session',
        detail: 'Running',
        rank: 20,
      ),
      const PriorityWorkItem(
        kind: PriorityWorkKind.approval,
        title: 'Approval required',
        detail: 'Command pending',
        rank: 10,
      ),
    ]);

    expect(ordered.map((item) => item.title), [
      'Approval required',
      'Active session',
    ]);
  });
}

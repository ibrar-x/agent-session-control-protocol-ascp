import '../domain/priority_work_item.dart';

List<PriorityWorkItem> orderPriorityWork(List<PriorityWorkItem> items) {
  final ordered = [...items]..sort((a, b) => a.rank.compareTo(b.rank));
  return ordered;
}

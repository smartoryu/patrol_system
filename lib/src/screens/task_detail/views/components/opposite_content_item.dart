import 'package:nusalima_patrol_system/src/views.dart';

class TaskDetailOppositeContentItem extends StatelessWidget {
  const TaskDetailOppositeContentItem({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: this.child,
      ),
    );
  }
}

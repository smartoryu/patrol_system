import 'package:nusalima_patrol_system/src/views.dart';

class HomeUserTaskItem extends StatelessWidget {
  const HomeUserTaskItem({
    Key? key,
    this.isDone = false,
    required this.location,
    this.onTap,
    required this.time,
  }) : super(key: key);

  final bool isDone;
  final String location;
  final void Function()? onTap;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite,
      child: InkWell(
        onTap: this.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: fromRGB("#C5C5C5")),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: this.isDone
                    ? Icon(Icons.assignment_turned_in, size: 32)
                    : Icon(Icons.assignment_turned_in_outlined, size: 32),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.time,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      this.location,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 32, child: Icon(Icons.navigate_next)),
            ],
          ),
        ),
      ),
    );
  }
}

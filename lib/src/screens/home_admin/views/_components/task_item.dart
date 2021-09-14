import 'package:nusalima_patrol_system/src/views.dart';

class HomeAdminTaskItem extends StatelessWidget {
  const HomeAdminTaskItem({
    Key? key,
    this.isDone = false,
    required this.officer,
    required this.location,
    this.onTap,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  final bool isDone;
  final String officer;
  final String location;
  final void Function()? onTap;
  final String startTime;
  final String endTime;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite,
      child: InkWell(
        onTap: onTap,
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
                child: isDone
                    ? const Icon(Icons.assignment_turned_in, size: 32)
                    : const Icon(Icons.assignment_turned_in_outlined, size: 32),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      officer,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${Format.date(startTime, "dd/MM/yyyy")} | ${Format.date(startTime, "HH.mm")} - ${Format.date(endTime, "HH.mm")}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32, child: Icon(Icons.navigate_next)),
            ],
          ),
        ),
      ),
    );
  }
}

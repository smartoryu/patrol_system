import 'package:nusalima_patrol_system/src/screens/home_user/views/components/task_item.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/date_selector.dart';

class HomeReportScreen extends StatefulWidget {
  HomeReportScreen({Key? key}) : super(key: key);

  @override
  _HomeReportScreenState createState() => _HomeReportScreenState();
}

class _HomeReportScreenState extends State<HomeReportScreen> {
  @override
  Widget build(BuildContext context) {
    var _dummy = [
      TaskModel("23.00 - 07.00", "Posko 2"),
    ];

    var _today = new DateTime.now();
    var _yesterday = new DateTime(_today.year, _today.month, _today.day - 1);

    return Expanded(
      child: Column(
        children: [
          HomeReportDateSelector(
            today: _yesterday,
            selectableDayPredicate: (date) => date != DateTime.now(),
            onChangeDate: (date) {
              print(date.toUtc().toIso8601String());
            },
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: _dummy.length,
                separatorBuilder: (ctx, i) => SizedBox(height: 16),
                itemBuilder: (ctx, i) {
                  var item = _dummy[i];
                  return HomeUserTaskItem(
                    location: item.location,
                    time: item.time,
                    isDone: item.isDone == true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return TaskDetailScreen(
                            location: item.location,
                            time: item.time,
                            isDone: true,
                          );
                        }),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:nusalima_patrol_system/src/views.dart';

import 'components/date_selector.dart';
import 'components/header.dart';
import 'components/task_item.dart';

class HomeUserScreen extends StatefulWidget {
  static const route = "/home-user-screen";
  HomeUserScreen({Key? key}) : super(key: key);

  @override
  _HomeUserScreenState createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  // ignore: unused_field
  final _photo =
      "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80";

  @override
  Widget build(BuildContext context) {
    var _dummy = [
      // TaskModel("07.00 - 15.00", "Posko PAM Gedung 1"),
      // TaskModel("15.00 - 23.00", "Posko 2"),
      // TaskModel("23.00 - 07.00", "Posko PAM Gedung 4", true),
      // TaskModel("07.00 - 15.00", "Posko PAM Gedung 1", true),
      // TaskModel("15.00 - 23.00", "Posko 2", true),
      // TaskModel("23.00 - 07.00", "Posko PAM Gedung 4", true),
      // TaskModel("07.00 - 15.00", "Posko PAM Gedung 1", true),
      // TaskModel("15.00 - 23.00", "Posko 2", true),
      TaskModel("23.00 - 07.00", "Posko 2"),
    ];

    return Scaffold(
      appBar: myAppBarMinimal(brightness: Brightness.light),
      backgroundColor: kPrimary,
      body: Column(
        children: [
          HomeUserHeader(
            username: "Olive Yew",
            phoneNumber: "+62821334334123",
            // photo: this._photo,
            onTapEditProfile: () {
              Navigator.pushNamed(context, ProfileScreen.route);
            },
            onTapAlert: () {},
          ),
          HomeUserDateSelector(
            // today: DateTime(2021, 8, 15),
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
                separatorBuilder: (ctx, i) {
                  return SizedBox(height: 16);
                },
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
                          );
                        }),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TaskModel {
  TaskModel(
    this.time,
    this.location, [
    this.isDone,
  ]);

  final String time;
  final String location;
  final bool? isDone;
}

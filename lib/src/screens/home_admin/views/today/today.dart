import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/screens/home_admin/views/_components/task_item.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/date_selector.dart';

class HomeTodayScreen extends StatefulWidget {
  const HomeTodayScreen({Key? key}) : super(key: key);

  @override
  _HomeTodayScreenState createState() => _HomeTodayScreenState();
}

class _HomeTodayScreenState extends State<HomeTodayScreen> {
  List<Shift> shifts = [];
  List<Shift> filtered = [];

  DateTime date = DateTime.now();
  setDate(DateTime e) => setState(() => date = e);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var result = await FirebaseFirestore.instance.collection("shifts").get();
    for (var e in result.docs) {
      var json = e.data();
      var item = Shift.fromJson(jsonDecode(jsonEncode(json)));
      shifts.add(item);
    }
    filterByDate(DateTime.now(), shifts);
  }

  void filterByDate(DateTime now, List<Shift> data) {
    final yesterday = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    List<Shift> today = data.where((e) {
      final start = DateTime.parse(e.startTime);
      return start.isAfter(yesterday) && start.isBefore(tomorrow);
    }).toList();

    setState(() => filtered = today);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          HomeActiveDateSelector(
            today: date,
            onChangeDate: (date) {
              if (date != null) {
                filterByDate(date, shifts);
                setDate(date);
              }
            },
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: filtered.length,
                separatorBuilder: (ctx, i) => const SizedBox(height: 16),
                itemBuilder: (ctx, i) {
                  var item = filtered[i];
                  return HomeAdminTaskItem(
                    officer: item.officer.fullName,
                    location: item.location.name,
                    startTime: item.startTime,
                    endTime: item.endTime,
                    isDone: item.isDone,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return TaskDetailScreen(
                            uid: item.uid,
                            isDone: item.isDone,
                            isAdmin: true,
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

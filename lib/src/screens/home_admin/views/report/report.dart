import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/screens/home_admin/views/_components/task_item.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/date_selector.dart';

class HomeReportScreen extends StatefulWidget {
  const HomeReportScreen({Key? key}) : super(key: key);

  @override
  _HomeReportScreenState createState() => _HomeReportScreenState();
}

class _HomeReportScreenState extends State<HomeReportScreen> {
  List<Shift> shifts = [];
  List<Shift> filtered = [];

  DateTime date = DateTime.now();
  setDate(DateTime e) => setState(() => date = e);

  @override
  void initState() {
    super.initState();
    var dt = DateTime.now();
    var _yesterday = DateTime(dt.year, dt.month, dt.day - 1, 0, 0, 0);
    setDate(_yesterday);
    fetchData();
  }

  Future<void> fetchData() async {
    var result = await FirebaseFirestore.instance.collection("shifts").get();
    setState(() => shifts = []);
    for (var e in result.docs) {
      var json = e.data();
      var item = Shift.fromJson(jsonDecode(jsonEncode(json)));
      shifts.add(item);
    }
    var dt = DateTime.now();
    var _yesterday = DateTime(dt.year, dt.month, dt.day - 1, 0, 0, 0);
    filterByDate(_yesterday, shifts);
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
          HomeReportDateSelector(
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
              child: RefreshIndicator(
                onRefresh: fetchData,
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
                              item: item,
                              isDone: true,
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
          ),
        ],
      ),
    );
  }
}

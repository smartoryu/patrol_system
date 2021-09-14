import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/date_selector.dart';
import 'components/header.dart';
import 'components/task_item.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({
    Key? key,
    required this.officer,
  }) : super(key: key);

  final Officer officer;

  @override
  _HomeUserScreenState createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  Officer? user;
  List<Shift> shifts = [];
  List<Shift> filtered = [];
  bool loading = false;

  DateTime date = DateTime.now();
  setDate(DateTime e) => setState(() => date = e);

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchData(DateTime.now());
  }

  Future<void> fetchUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid ?? "";
    var data = await DatabaseService().users.getSingle(uid);
    setState(() => user = data);
  }

  Future<void> fetchData(DateTime _date) async {
    setState(() => loading = true);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    var result = await FirebaseFirestore.instance
        .collection("shifts")
        .where('officer.uid', isEqualTo: uid)
        .get();

    shifts = [];

    for (var e in result.docs) {
      var json = e.data();
      var item = Shift.fromJson(jsonDecode(jsonEncode(json)));
      shifts.add(item);
    }

    final yesterday = DateTime(_date.year, _date.month, _date.day, 0, 0, 0);
    final tomorrow = DateTime(_date.year, _date.month, _date.day + 1, 0, 0, 0);

    List<Shift> today = shifts.where((e) {
      final start = DateTime.parse(e.startTime);
      return start.isAfter(yesterday) && start.isBefore(tomorrow);
    }).toList();

    setDate(_date);
    setState(() => filtered = today);
    setState(() => loading = false);
    // filterByDate(DateTime.now(), shifts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBarMinimal(brightness: Brightness.light),
      backgroundColor: kPrimary,
      body: Column(
        children: [
          HomeUserHeader(
            username: user?.fullName ?? "",
            phoneNumber: user?.phoneNumber ?? "",
            photo: user?.photo ?? "",
            onTapEditProfile: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen(uid: user?.uid ?? "");
                  },
                ),
              );
            },
            onTapAlert: () {},
          ),
          HomeUserDateSelector(
            today: date,
            onChangeDate: (date) {
              if (date != null) {
                fetchData(date);
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
                onRefresh: () => fetchData(date),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filtered.length,
                  separatorBuilder: (ctx, i) {
                    return const SizedBox(height: 16);
                  },
                  itemBuilder: (ctx, i) {
                    var item = filtered[i];
                    return HomeUserTaskItem(
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
                              isDone: item.isDone,
                              isAdmin: false,
                            );
                          }),
                        );
                      },
                    );
                  },
                ),
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

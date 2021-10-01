import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/button_cek_rute.dart';
import 'components/button_selesaikan_shift.dart';
import 'components/content_item.dart';
import 'components/opposite_content_item.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    Key? key,
    required this.item,
    required this.isDone,
    required this.isAdmin,
  }) : super(key: key);

  final Shift item;
  final bool isDone;
  final bool isAdmin;

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  List<ShiftReport> reports = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => loading = true);
    try {
      var result = await FirebaseFirestore.instance
          .collection("shift_report")
          .where('shiftId', isEqualTo: widget.item.uid)
          .get();

      reports = [];

      for (var e in result.docs) {
        var json = e.data();
        var item = ShiftReport.fromJson(jsonDecode(jsonEncode(json)));
        reports.add(item);
      }
      reports.sort((a,b) {
        var adate = a.createdAt;
        var bdate = b.createdAt;
        return bdate.compareTo(adate);
      });
      setState(() {});
      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ITEM ${reports.map((e) => Format.date(e.createdAt, 'HH:mm'))}");

    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: DatabaseService(uid: widget.item.uid).shifts.getCurrent,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const Text("Network Error");
          }
          if (snapshot.hasData) {
            var json = jsonDecode(jsonEncode(snapshot.data!.data()));
            Shift? item;
            item = Shift.fromJson(json);

            // ignore: unused_local_variable
            var date = Format.date(item.startTime, "dd/MM");
            var start = Format.date(item.startTime, "HH.mm");
            var end = Format.date(item.endTime, "HH.mm");
            var time = '$start - $end';

            return Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimary,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: kPrimary,
                  statusBarIconBrightness: Brightness.light,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.officer.fullName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "${item.location.name}   $time",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              floatingActionButton: !widget.isAdmin
                  ? widget.item.isDone
                      ? null
                      : FloatingActionButton.extended(
                          label: const Text('Selesaikan Shift'),
                          icon: const Icon(Icons.task_alt),
                          backgroundColor: kDanger,
                          onPressed: () {
                            _showPopup() => showDialog(
                                  context: context,
                                  builder: (context) {
                                    var _size = MediaQuery.of(context).size;
                                    var _width = _size.width - 64;
                                    return MyPopupDialog(
                                      title: "Yakin selesaikan shift?",
                                      height: 120,
                                      width: _width,
                                      buttonWidth: _width / 3,
                                      cancelText: "Tidak",
                                      cancelType: MyButtonType.primaryOutline,
                                      cancelTap: Navigator.of(context).pop,
                                      confirmText: "Ya",
                                      isLoading: loading,
                                      confirmTap: () async {
                                        try {
                                          setState(() => loading = true);
                                          DatabaseService(
                                            uid: widget.item.uid,
                                          ).shifts.update(
                                            json: {"isDone": true},
                                          );

                                          setState(() => loading = false);
                                          Navigator.of(context)
                                            ..pop()
                                            ..pop();
                                        } catch (e) {
                                          debugPrint(e.toString());
                                          setState(() => loading = false);
                                        }
                                      },
                                    );
                                  },
                                );

                            _showPopup();
                          },
                        )
                  : reports.isEmpty
                      ? null
                      : FloatingActionButton.extended(
                          label: const Text('Lihat Rute Jaga'),
                          icon: const Icon(Icons.navigation),
                          backgroundColor: kDanger,
                          onPressed: () {
                            Future<void> _handleLaunchMap() async {
                              setState(() => loading = true);
                              _launchURL(String url) async {
                                if (await canLaunch(url)) {
                                  await launch(url);
                                  Navigator.of(context).pop();
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }

                              var pos = await getCurrentPosition();
                              var baseUrl = "https://www.google.com/maps/dir";
                              var position = "${pos.latitude},${pos.longitude}";

                              var gps = reports.map((e) {
                                return "${e.lat},${e.long}";
                              }).toList();

                              var base = [baseUrl];
                              for (var e in gps) {
                                base.add(e);
                              }
                              base.add(position);

                              var _url = base.join("/");

                              debugPrint("$_url&mode=walking");

                              _launchURL("$_url&mode=walking");
                              setState(() => loading = false);
                            }

                            _showPopup() => showDialog(
                                  context: context,
                                  builder: (context) {
                                    var _size = MediaQuery.of(context).size;
                                    var _width = _size.width - 64;
                                    return MyPopupDialog(
                                      title: "Ingin melihat rute jaga petugas?",
                                      height: 120,
                                      width: _width,
                                      buttonWidth: _width / 3,
                                      cancelText: "Tidak",
                                      cancelType: MyButtonType.primaryOutline,
                                      cancelTap: Navigator.of(context).pop,
                                      confirmText: "Ya",
                                      confirmTap: _handleLaunchMap,
                                    );
                                  },
                                );

                            _showPopup();
                            // _addNewShift();
                          },
                        ),
              body: RefreshIndicator(
                onRefresh: fetchData,
                child: SingleChildScrollView(
                  child: FixedTimeline.tileBuilder(
                    builder: TimelineTileBuilder.connectedFromStyle(
                      contentsAlign: ContentsAlign.basic,
                      oppositeContentsBuilder: (context, index) {
                        if (index == 0 && !widget.isDone) {
                          return null;
                        } else {
                          var _item = widget.isDone || widget.isAdmin
                              ? reports[index]
                              : reports[index - 1];
                          return TaskDetailOppositeContentItem(
                            child: Text(
                              Format.date(_item.createdAt, "HH:mm"),
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }
                      },
                      contentsBuilder: (context, index) {
                        if (index == 0 && !widget.isDone && !widget.isAdmin) {
                          // var nowIso = DateTime.now().toUtc().toIso8601String();
                          // var createdAt = widget.item.createdAt;
                          // var now = Format.date(nowIso, "dd-MM-yyyy");
                          // var current = Format.date(createdAt, "dd-MM-yyyy");

                          return Card(
                            color: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: MyButton(
                                "Buat Laporan Baru",
                                // disabled: now != current,
                                type: MyButtonType.primary2,
                                onTap: () {
                                  if (item == null) return;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return UserReportFormScreen(
                                        shiftId: item!.uid,
                                        location: item.location,
                                        officer: item.officer,
                                      );
                                    }),
                                    // UserReportFormScreen.route,
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          var _item = widget.isDone || widget.isAdmin
                              ? reports[index]
                              : reports[index - 1];

                          return TaskDetailContentItem(
                            notes: _item.notes,
                            photos: _item.photos,
                          );
                        }
                      },
                      nodePositionBuilder: (context, _) => 0.2,
                      indicatorPositionBuilder: (context, _) => 0.5,
                      connectorStyleBuilder: (context, index) {
                        return ConnectorStyle.solidLine;
                      },
                      firstConnectorStyle: ConnectorStyle.transparent,
                      lastConnectorStyle: ConnectorStyle.transparent,
                      indicatorStyleBuilder: (context, index) =>
                          IndicatorStyle.dot,
                      itemCount: widget.isDone || widget.isAdmin
                          ? reports.length
                          : reports.length + 1,
                      itemExtent: 125,
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class TaskDetailModel {
  TaskDetailModel({
    required this.createdAt,
    required this.notes,
    this.photos = const [],
  });

  final String createdAt;
  final String notes;
  final List<String> photos;
}

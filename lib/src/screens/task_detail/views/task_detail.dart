import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/button_cek_rute.dart';
import 'components/button_selesaikan_shift.dart';
import 'components/content_item.dart';
import 'components/opposite_content_item.dart';

class TaskDetailScreen extends StatefulWidget {
  static const route = "/task-detail-screen";
  const TaskDetailScreen({
    Key? key,
    this.uid = "",
    this.time = "",
    this.location = "",
    this.isDone = false,
    this.isAdmin = false,
  }) : super(key: key);

  final String uid;
  final String time;
  final String location;
  final bool isDone;
  final bool isAdmin;

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var _note =
        "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";

    final List<TaskDetailModel> dummy = [
      TaskDetailModel(
        createdAt: "23.15",
        notes: _note,
        photos: [
          "https://images.unsplash.com/photo-1621866568420-9bf4a508c062?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8a2VidW58ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
          "https://images.unsplash.com/photo-1576403575366-786274ee7a50?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8a2VidW58ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
          "https://images.unsplash.com/photo-1615796000240-c0b7cd3d385f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGtlYnVufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
        ],
      ),
      TaskDetailModel(
        createdAt: "23.01",
        notes: _note,
        photos: [
          "https://images.unsplash.com/photo-1615648178124-01f7162ceac4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fGtlYnVufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
          "https://images.unsplash.com/photo-1615648178124-01f7162ceac4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        ],
      ),
    ];

    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: DatabaseService(uid: widget.uid).shifts.getCurrent,
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
                actions: [
                  if (!widget.isAdmin && widget.isDone)
                    const TaskDetailButtonSelesaikanShift()
                  else
                    const SizedBox(width: 8),
                  const SizedBox(width: 8),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                label: const Text('Lihat Rute Jaga'),
                icon: const Icon(Icons.navigation),
                backgroundColor: kDanger,
                onPressed: () {
                  Future<void> _handleLaunchMap() async {
                    _launchURL(String url) async {
                      if (await canLaunch(url)) {
                        await launch(url);
                        Navigator.of(context).pop();
                      } else {
                        throw 'Could not launch $url';
                      }
                    }

                    var position = await getCurrentPosition();
                    var _lat = position.latitude;
                    var _lon = position.longitude;

                    var base = [
                      "https://www.google.com/maps/dir",
                      "-6.3095561,106.6775224",
                      "-6.3098492,106.6770244",
                      "-6.3107685,106.6770161",
                      "-6.311245,106.678152",
                      "-6.3108108,106.678875",
                      "-6.310334,106.678834",
                      "-6.309774,106.678507",
                      "-6.3092222,106.6781635",
                      "-6.3095561,106.6775224",
                      //
                      "$_lat,$_lon",
                    ];

                    var _url = base.join("/");

                    _launchURL("$_url&mode=walking");
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
              body: SingleChildScrollView(
                child: FixedTimeline.tileBuilder(
                  builder: TimelineTileBuilder.connectedFromStyle(
                    contentsAlign: ContentsAlign.basic,
                    oppositeContentsBuilder: (context, index) {
                      if (index == 0 && !widget.isDone) {
                        return null;
                      } else {
                        var _item = widget.isDone || widget.isAdmin
                            ? dummy[index]
                            : dummy[index - 1];
                        return TaskDetailOppositeContentItem(
                          child: Text(
                            _item.createdAt,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }
                    },
                    contentsBuilder: (context, index) {
                      if (index == 0 && !widget.isDone && !widget.isAdmin) {
                        return Card(
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: MyButton(
                              "Buat Laporan Baru",
                              type: MyButtonType.primary2,
                              onTap: () => Navigator.pushNamed(
                                context,
                                UserReportFormScreen.route,
                              ),
                            ),
                          ),
                        );
                      } else {
                        var _item = widget.isDone || widget.isAdmin
                            ? dummy[index]
                            : dummy[index - 1];
                        return TaskDetailContentItem(
                          notes: _item.notes,
                          photos: _item.photos,
                        );
                      }
                    },
                    nodePositionBuilder: (context, _) => 0.2,
                    indicatorPositionBuilder: (context, _) => 0.5,
                    connectorStyleBuilder: (context, index) =>
                        ConnectorStyle.solidLine,
                    firstConnectorStyle: ConnectorStyle.transparent,
                    lastConnectorStyle: ConnectorStyle.transparent,
                    indicatorStyleBuilder: (context, index) =>
                        IndicatorStyle.dot,
                    itemCount: widget.isDone || widget.isAdmin
                        ? dummy.length
                        : dummy.length + 1,
                    itemExtent: 125,
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

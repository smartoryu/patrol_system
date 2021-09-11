import 'package:nusalima_patrol_system/src/views.dart';

import 'components/button_cek_rute.dart';
import 'components/button_selesaikan_shift.dart';
import 'components/content_item.dart';
import 'components/opposite_content_item.dart';

class TaskDetailScreen extends StatefulWidget {
  static const route = "/task-detail-screen";
  TaskDetailScreen({
    Key? key,
    required this.time,
    required this.location,
    this.isDone = false,
  }) : super(key: key);

  final String time;
  final String location;
  final bool isDone;

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var _note =
        "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";

    final List<TaskDetailModel> dummy = [
      new TaskDetailModel(
        createdAt: "23.15",
        notes: _note,
        photos: [
          "https://images.unsplash.com/photo-1621866568420-9bf4a508c062?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8a2VidW58ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
          "https://images.unsplash.com/photo-1576403575366-786274ee7a50?ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8a2VidW58ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
          "https://images.unsplash.com/photo-1615796000240-c0b7cd3d385f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGtlYnVufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
        ],
      ),
      new TaskDetailModel(
        createdAt: "23.01",
        notes: _note,
        photos: [
          "https://images.unsplash.com/photo-1615648178124-01f7162ceac4?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fGtlYnVufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
          "https://images.unsplash.com/photo-1615648178124-01f7162ceac4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kPrimary,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.time, style: TextStyle(fontSize: 20)),
            Text(widget.location, style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          if (widget.isDone)
            TaskDetailButtonCekRute()
          else
            TaskDetailButtonSelesaikanShift(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: FixedTimeline.tileBuilder(
          builder: TimelineTileBuilder.connectedFromStyle(
            contentsAlign: ContentsAlign.basic,
            oppositeContentsBuilder: (context, index) {
              if (index == 0 && !widget.isDone) {
                return null;
              } else {
                var _item = widget.isDone ? dummy[index] : dummy[index - 1];
                return TaskDetailOppositeContentItem(
                  child: Text(
                    _item.createdAt,
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
            },
            contentsBuilder: (context, index) {
              if (index == 0 && !widget.isDone) {
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
                var _item = widget.isDone ? dummy[index] : dummy[index - 1];
                return TaskDetailContentItem(
                  notes: _item.notes,
                  photos: _item.photos,
                );
              }
            },
            nodePositionBuilder: (context, _) => 0.2,
            indicatorPositionBuilder: (context, _) => 0.5,
            connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
            firstConnectorStyle: ConnectorStyle.transparent,
            lastConnectorStyle: ConnectorStyle.transparent,
            indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
            itemCount: widget.isDone ? dummy.length : dummy.length + 1,
            itemExtent: 125,
          ),
        ),
      ),
    );
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

import 'package:nusalima_patrol_system/src/views.dart';

class TaskDetailButtonCekRute extends StatelessWidget {
  const TaskDetailButtonCekRute({
    Key? key,
    this.onConfirm,
  }) : super(key: key);

  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
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

    return Center(
      child: MyButton(
        "Lihat Rute Jaga",
        type: MyButtonType.danger,
        onTap: _showPopup,
      ),
    );
  }
}

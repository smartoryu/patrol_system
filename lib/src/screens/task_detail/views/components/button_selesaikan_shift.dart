import 'package:nusalima_patrol_system/src/views.dart';

class TaskDetailButtonSelesaikanShift extends StatelessWidget {
  const TaskDetailButtonSelesaikanShift({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              confirmTap: () => Navigator.of(context)..pop()..pop(),
            );
          },
        );

    return Center(
      child: MyButton(
        "Selesaikan Shift",
        type: MyButtonType.danger,
        onTap: _showPopup,
      ),
    );
  }
}

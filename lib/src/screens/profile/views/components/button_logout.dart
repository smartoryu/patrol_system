import 'package:nusalima_patrol_system/src/views.dart';

class ProfileButtonLogout extends StatelessWidget {
  const ProfileButtonLogout({
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
              title: "Anda yakin ingin logout?",
              height: 130,
              width: _width,
              buttonWidth: _width / 3,
              cancelText: "Tidak",
              cancelType: MyButtonType.primaryOutline,
              cancelTap: () => Navigator.of(context).pop(),
              confirmText: "Ya",
              confirmType: MyButtonType.danger,
              confirmTap: () {
                AuthService().signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.route,
                  (_) => false,
                );
              },
            );
          },
        );

    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
      onPressed: _showPopup,
    );
  }
}

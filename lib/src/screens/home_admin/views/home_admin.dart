import 'package:nusalima_patrol_system/src/screens/home_user/views/components/header.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({
    Key? key,
    required this.officer,
  }) : super(key: key);

  final Officer officer;

  @override
  _HomeAdminScreenState createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int selectedIndex = 0;

  final List<Widget> _screenOptions = <Widget>[
    HomeTodayScreen(),
    HomeReportScreen(),
    HomeSettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBarMinimal(brightness: Brightness.light),
      backgroundColor: kPrimary,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        iconSize: 20,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: kPrimary,
        unselectedItemColor: fromRGB("#C5C5C5"),
        backgroundColor: kWhite,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Jadwal Aktif",
            icon: NavigationIcon(Icons.account_circle),
          ),
          BottomNavigationBarItem(
            label: "Laporan",
            icon: NavigationIcon(Icons.account_circle),
          ),
          BottomNavigationBarItem(
            label: "Pengaturan",
            icon: NavigationIcon(Icons.account_circle),
          ),
        ],
      ),
      body: Column(
        children: [
          HomeUserHeader(
            username: widget.officer.fullName,
            phoneNumber: widget.officer.phoneNumber,
            onTapEditProfile: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen(uid: widget.officer.uid);
                  },
                ),
              );
            },
          ),
          _screenOptions.elementAt(selectedIndex),
        ],
      ),
    );
  }
}

class NavigationIcon extends StatelessWidget {
  final IconData iconName;
  final double height;

  const NavigationIcon(
    this.iconName, {
    Key? key,
    this.height = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Icon(iconName, size: 25),
    );
  }
}

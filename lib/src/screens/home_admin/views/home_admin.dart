import 'package:nusalima_patrol_system/src/screens/home_user/views/components/header.dart';
import 'package:nusalima_patrol_system/src/views.dart';

class HomeAdminScreen extends StatefulWidget {
  static const route = "/home-admin-screen";
  HomeAdminScreen({Key? key}) : super(key: key);

  @override
  _HomeAdminScreenState createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int selectedIndex = 0;

  List<Widget> _screenOptions = <Widget>[
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
        currentIndex: this.selectedIndex,
        onTap: (index) => setState(() => this.selectedIndex = index),
        iconSize: 20,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: kPrimary,
        unselectedItemColor: fromRGB("#C5C5C5"),
        backgroundColor: kWhite,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
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
            username: "Olivia Yew",
            phoneNumber: "+62821334334123",
            onTapEditProfile: () {
              // Navigator.pushNamed(context, ProfileScreen.route);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen(name: "");
                  },
                ),
              );
            },
          ),
          _screenOptions.elementAt(this.selectedIndex),
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

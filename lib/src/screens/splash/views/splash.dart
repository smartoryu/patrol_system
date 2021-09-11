import 'dart:async';

import 'package:nusalima_patrol_system/src/views.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const route = "/splash-screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  void _loadWidget() async {
    // final user = Provider.of<UserModel>(context);
    // print(user);
    
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        LoginScreen.route,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset("assets/img/LOGO-PTPN5.png"),
          )
        ],
      ),
    );
  }
}

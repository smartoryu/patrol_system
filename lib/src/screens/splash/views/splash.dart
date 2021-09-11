import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

class SplashScreen extends StatefulWidget {
  static const route = "/splash-screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late StreamSubscription<User?> _sub;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      _sub = auth.authStateChanges().listen((user) async {
        var officer = await DatabaseService().users.getSingle(user?.uid ?? "");

        debugPrint("USER $user");
        debugPrint("OFFICER $officer");

        if (officer?.role == "officer") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeUserScreen(officer: officer!),
            ),
          );
        } else if (officer?.role == "admin") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeAdminScreen(officer: officer!),
            ),
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            LoginScreen.route,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
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

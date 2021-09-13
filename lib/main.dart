import 'package:firebase_core/firebase_core.dart';
import 'package:nusalima_patrol_system/src/views.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends AppMVC {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    return MaterialApp(
      theme: ThemeData(fontFamily: 'OpenSans'),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.route,
      routes: {
        // splash
        SplashScreen.route: (context) => const SplashScreen(),

        // login
        LoginScreen.route: (context) => const LoginScreen(),

        // profile
        // ProfileScreen.route: (context) => ProfileScreen(),

        // home user
        // HomeUserScreen.route: (context) => const HomeUserScreen(),

        // task detail
        // TaskDetailScreen.route: (context) => TaskDetailScreen(),

        // user report form
        UserReportFormScreen.route: (context) => UserReportFormScreen(),

        // home admin
        // HomeAdminScreen.route: (context) => HomeAdminScreen(),

        // daftar petugas
        // DaftarPetugasScreen.route: (context) => DaftarPetugasScreen(),

        // daftar lokasi
        DaftarLokasiScreen.route: (context) => const DaftarLokasiScreen(),

        // daftar waktu
        DaftarWaktuScreen.route: (context) => DaftarWaktuScreen(),

        // buat jadwal
        BuatJadwalScreen.route: (context) => BuatJadwalScreen(),
      },
    );
  }
}

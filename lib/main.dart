import 'package:nusalima_patrol_system/src/views.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialRoute: LoginScreen.route,
      routes: {
        // login
        LoginScreen.route: (context) => LoginScreen(),

        // profile
        ProfileScreen.route: (context) => ProfileScreen(),

        // home user
        HomeUserScreen.route: (context) => HomeUserScreen(),

        // task detail
        // TaskDetailScreen.route: (context) => TaskDetailScreen(),

        // user report form
        UserReportFormScreen.route: (context) => UserReportFormScreen(),

        // home admin
        HomeAdminScreen.route: (context) => HomeAdminScreen(),

        // daftar petugas
        DaftarPetugasScreen.route: (context) => DaftarPetugasScreen(),

        // daftar lokasi
        DaftarLokasiScreen.route: (context) => DaftarLokasiScreen(),

        // daftar waktu
        DaftarWaktuScreen.route: (context) => DaftarWaktuScreen(),

        // buat jadwal
        BuatJadwalScreen.route: (context) => BuatJadwalScreen(),
      },
    );
  }
}

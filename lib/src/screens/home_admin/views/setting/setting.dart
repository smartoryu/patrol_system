import 'package:nusalima_patrol_system/src/views.dart';

import 'components/item.dart';

class HomeSettingScreen extends StatefulWidget {
  HomeSettingScreen({Key? key}) : super(key: key);

  @override
  _HomeSettingScreenState createState() => _HomeSettingScreenState();
}

class _HomeSettingScreenState extends State<HomeSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pengaturan",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            HomeSettingItem(
              "Daftar Petugas",
              onTap: () {
                Navigator.pushNamed(context, DaftarPetugasScreen.route);
              },
            ),
            SizedBox(height: 16),
            HomeSettingItem(
              "Daftar Lokasi Jaga",
              onTap: () {
                Navigator.pushNamed(context, DaftarLokasiScreen.route);
              },
            ),
            SizedBox(height: 16),
            HomeSettingItem(
              "Daftar Waktu Shift",
              onTap: () {
                Navigator.pushNamed(context, DaftarWaktuScreen.route);
              },
            ),
            SizedBox(height: 16),
            SizedBox(height: 16),
            HomeSettingItem(
              "Buat Jadwal Shift Baru Petugas",
              filled: true,
              onTap: () {
                Navigator.pushNamed(context, BuatJadwalScreen.route);
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

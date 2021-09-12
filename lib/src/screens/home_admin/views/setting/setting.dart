import 'package:nusalima_patrol_system/src/views.dart';

import 'components/item.dart';

class HomeSettingScreen extends StatefulWidget {
  const HomeSettingScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  _HomeSettingScreenState createState() => _HomeSettingScreenState();
}

class _HomeSettingScreenState extends State<HomeSettingScreen> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserModel>(context);

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pengaturan", style: TextStyle(fontSize: 24)),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: HomeSettingItem(
                "Daftar Admin",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DaftarPetugasScreen(
                        role: "admin",
                        uid: widget.uid,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: HomeSettingItem(
                "Daftar Petugas",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DaftarPetugasScreen(
                        role: "officer",
                        uid: widget.uid,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: HomeSettingItem(
                "Daftar Lokasi Jaga",
                onTap: () {
                  Navigator.pushNamed(context, DaftarLokasiScreen.route);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: HomeSettingItem(
                "Daftar Waktu Shift",
                onTap: () {
                  Navigator.pushNamed(context, DaftarWaktuScreen.route);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: HomeSettingItem(
                "Buat Jadwal Shift Baru Petugas",
                filled: true,
                onTap: () {
                  Navigator.pushNamed(context, BuatJadwalScreen.route);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

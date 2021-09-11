import 'package:nusalima_patrol_system/src/views.dart';

class BuatJadwalScreen extends StatefulWidget {
  static const route = "/buat-jadwal-screen";
  BuatJadwalScreen({Key? key}) : super(key: key);

  @override
  _BuatJadwalScreenState createState() => _BuatJadwalScreenState();
}

class _BuatJadwalScreenState extends State<BuatJadwalScreen> {
  String? user;
  String? location;
  String? time;

  void setUser(String e) => setState(() => this.user = e);
  void setLocation(String e) => setState(() => this.location = e);
  void setTime(String e) => setState(() => this.time = e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kPrimary,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text("Buat Jadwal Shift Baru"),
      ),
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Petugas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                isExpanded: true,
                hint: Text('Pilih User'),
                items: [
                  "Roy Maximilian",
                  "Olivia Yew",
                  "Tina Wayne",
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                value: this.user,
                onChanged: (e) => setUser(e ?? ""),
              ),
              SizedBox(height: 8),
              Text(
                "Lokasi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                isExpanded: true,
                hint: Text('Pilih Lokasi'),
                items: [
                  "Pos 1",
                  "Pos 2",
                  "Pos 3",
                  "Pos 4",
                  "Pos 5",
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                value: this.location,
                onChanged: (e) => setLocation(e ?? ""),
              ),
              SizedBox(height: 8),
              Text(
                "Jadwal Shift",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                isExpanded: true,
                hint: Text('Pilih Jadwal Shift'),
                items: [
                  "07.00 - 15.00",
                  "15.00 - 23.00",
                  "23.00 - 07.00",
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                value: this.time,
                onChanged: (e) => setTime(e ?? ""),
              ),
              SizedBox(height: 64),
              Center(
                child: MyButton(
                  "Konfirmasi",
                  width: 200,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

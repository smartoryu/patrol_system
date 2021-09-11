import 'package:nusalima_patrol_system/src/views.dart';

import 'components/form.dart';

class DaftarLokasiScreen extends StatefulWidget {
  static const route = "/daftar-lokasi-screen";
  DaftarLokasiScreen({Key? key}) : super(key: key);

  @override
  _DaftarLokasiScreenState createState() => _DaftarLokasiScreenState();
}

class _DaftarLokasiScreenState extends State<DaftarLokasiScreen> {
  List<String> location = [];

  @override
  void initState() {
    super.initState();
    this.location = [
      "Pos 1",
      "Pos 2",
      "Pos 3",
      "Pos 4",
      "Pos 5",
      "Pos 6",
      "Pos 7",
      "Pos 8",
      "Pos 9",
      "Pos 10",
      "Pos 11",
      "Pos 12",
    ];
    setState(() {});
  }

  _showPopup([String? value]) => showDialog(
        context: context,
        builder: (context) {
          var _size = MediaQuery.of(context).size;
          var _width = _size.width - 64;
          return DaftarLokasiForm(
            width: _width,
            buttonWidth: _width / 3,
            onConfirm: (value) {
              if (value != "") {
                print(value);
                setState(() => location.add(value));
              }

              Navigator.of(context).pop();
            },
            value: value,
          );
        },
      );

  _deletePopup([String? value]) => showDialog(
        context: context,
        builder: (context) {
          var _size = MediaQuery.of(context).size;
          var _width = _size.width - 64;
          return MyPopupDialog(
            title: "Hapus $value?",
            height: 130,
            width: _width,
            buttonWidth: _width / 3,
            cancelText: "Batal",
            cancelType: MyButtonType.primaryOutline,
            cancelTap: Navigator.of(context).pop,
            confirmText: "Ya",
            confirmType: MyButtonType.danger,
            confirmTap: () {
              print(value);
              setState(
                () => this.location =
                    location.where((item) => item != value).toList(),
              );
              Navigator.of(context).pop();
            },
          );
        },
      );

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
        title: Text("Daftar Lokasi Jaga"),
        actions: [
          Center(
            child: MyButton(
              "Tambah Baru",
              type: MyButtonType.danger,
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
              onTap: _showPopup,
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      backgroundColor: kWhite,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          var item = this.location[index];
          return Container(
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: kPrimary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item, style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showPopup(item),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.edit, size: 16),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _deletePopup(item),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.delete, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemCount: this.location.length,
      ),
    );
  }
}

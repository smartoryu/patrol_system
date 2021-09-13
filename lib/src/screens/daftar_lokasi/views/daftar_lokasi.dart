import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/networks.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/form.dart';

class DaftarLokasiScreen extends StatefulWidget {
  static const route = "/daftar-lokasi-screen";
  const DaftarLokasiScreen({Key? key}) : super(key: key);

  @override
  _DaftarLokasiScreenState createState() => _DaftarLokasiScreenState();
}

class _DaftarLokasiScreenState extends State<DaftarLokasiScreen> {
  String error = "";
  bool loading = false;
  void requestStart() => setState(() {
        error = "";
        loading = true;
      });
  void requestDone([String e = '']) => setState(() {
        error = e;
        loading = true;
      });

  _showPopup([Location? _value]) => showDialog(
        context: context,
        builder: (context) {
          return DaftarLokasiForm(isEditing: _value);
        },
      );

  _showPopupEditing(Location _value) => showDialog(
        context: context,
        builder: (context) {
          return DaftarLokasiForm(isEditing: _value);
        },
      );

  _deletePopup(Location _value) => showDialog(
        context: context,
        builder: (context) {
          var _size = MediaQuery.of(context).size;
          var _width = _size.width - 64;
          return MyPopupDialog(
            title: "Hapus ${_value.name}?",
            height: 130,
            width: _width,
            buttonWidth: _width / 3,
            cancelText: "Batal",
            cancelType: MyButtonType.primaryOutline,
            cancelTap: Navigator.of(context).pop,
            confirmText: "Ya",
            confirmType: MyButtonType.danger,
            confirmTap: () async {
              try {
                requestStart();
                await DatabaseService(uid: _value.uid).locations.delete();
                Navigator.of(context).pop();
              } catch (e) {
                requestDone();
              }
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kPrimary,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text("Daftar Lokasi Jaga"),
        actions: [
          Center(
            child: MyButton(
              "Tambah Baru",
              type: MyButtonType.danger,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
              onTap: _showPopup,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: kWhite,
      body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: DatabaseService().locations.getAll,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Text("Network Error");
            }
            if (snapshot.hasData) {
              List<Location> locations = [];
              for (var e in snapshot.data!.docs) {
                var json = e.data();
                var item = Location.fromJson(jsonDecode(jsonEncode(json)));
                locations.add(item);
              }
              locations.sort((a, b) => a.name.compareTo(b.name));

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  var item = locations[index];
                  return Container(
                    padding: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: kPrimary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name, style: const TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showPopupEditing(item),
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(Icons.edit, size: 16),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _deletePopup(item),
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(Icons.delete, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: locations.length,
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

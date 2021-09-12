import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'daftar_petugas_form.dart';

class DaftarPetugasScreen extends StatefulWidget {
  const DaftarPetugasScreen({
    Key? key,
    required this.role,
    this.uid = "",
  }) : super(key: key);

  final String role;
  final String uid;

  @override
  _DaftarPetugasScreenState createState() => _DaftarPetugasScreenState();
}

class _DaftarPetugasScreenState extends State<DaftarPetugasScreen> {
  bool isDeleting = false;

  _deletePopup(Officer item) => showDialog(
        context: context,
        builder: (context) {
          var _size = MediaQuery.of(context).size;
          var _width = _size.width - 64;

          return MyPopupDialog(
            title: "Hapus ${item.fullName}?",
            height: 130,
            width: _width,
            buttonWidth: _width / 3,
            isLoading: isDeleting,
            cancelText: "Batal",
            cancelType: MyButtonType.primaryOutline,
            cancelTap: Navigator.of(context).pop,
            confirmText: "Ya",
            confirmType: MyButtonType.danger,
            confirmTap: () async {
              try {
                setState(() => isDeleting = true);
                await DatabaseService().users.delete(item.uid);
                Navigator.of(context).pop();
                setState(() => isDeleting = false);
              } catch (e) {
                debugPrint(e.toString());
                setState(() => isDeleting = false);
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
        title: widget.role == "admin"
            ? const Text("Daftar Admin")
            : const Text("Daftar Petugas"),
        actions: [
          Center(
            child: MyButton(
              "Tambah Baru",
              type: MyButtonType.danger,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DaftarPetugasForm(
                    role: widget.role,
                    uid: widget.uid,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: kWhite,
      body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: DatabaseService().users.getAll,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Text("Network Error");
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Officer> officers = [];
            for (var e in snapshot.data!.docs) {
              var json = e.data();
              var item = Officer.fromJson(jsonDecode(jsonEncode(json)));
              if (item.role == widget.role && item.uid != widget.uid) {
                officers.add(item);
              }
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                var item = officers[index];
                return Container(
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: kPrimary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.fullName, style: const TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, ProfileScreen.route);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProfileScreen(
                                      uid: item.uid,
                                      type: "admin",
                                    );
                                  },
                                ),
                              );
                            },
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
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: officers.length,
            );
          }),
    );
  }
}

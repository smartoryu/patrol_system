import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/button_logout.dart';
import 'components/panel_info.dart';
import 'components/panel_info_item.dart';
import 'edit_form.dart';

class ProfileScreen extends StatefulWidget {
  static const route = "/profile-screen";
  const ProfileScreen({
    Key? key,
    required this.uid,
    this.isEditing = false,
    this.type = "",
  }) : super(key: key);

  final String uid;
  final bool isEditing;
  final String type;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _showEditPopup(ProfileEditFormType type, [String value = ""]) {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProfileEditForm(
          uid: widget.uid,
          defaultValue: value,
          type: type,
          onConfirm: (value) {
            debugPrint(value);
            // Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: kPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kPrimary,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          if (!widget.isEditing) const ProfileButtonLogout(),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: DatabaseService(uid: widget.uid).users.getCurrent,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Text("Network Error");
            }
            if (snapshot.hasData) {
              var json = jsonDecode(jsonEncode(snapshot.data!.data()));
              Officer? item;
              item = Officer.fromJson(json);

              // debugPrint("DECODED: $json");
              // debugPrint("OFFICER: $item");

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfilePicture(item: item, type: widget.type),
                      const SizedBox(height: 24),
                      ProfilePanelInfo(
                        children: [
                          ProfilePanelInfoItem(
                            "Nama",
                            value: item.fullName,
                            isFirstChild: true,
                            onTap: () {
                              if (item != null) {
                                _showEditPopup(
                                  ProfileEditFormType.fullName,
                                  item.fullName,
                                );
                              }
                            },
                          ),
                          ProfilePanelInfoItem(
                            "Nomor Telepon",
                            value: item.phoneNumber,
                            onTap: () {
                              if (item != null) {
                                _showEditPopup(
                                  ProfileEditFormType.phoneNumber,
                                  item.phoneNumber,
                                );
                              }
                            },
                          ),
                          ProfilePanelInfoItem(
                            "Posisi",
                            value: item.position,
                            onTap: () {
                              if (item != null) {
                                _showEditPopup(
                                  ProfileEditFormType.position,
                                  item.position,
                                );
                              }
                            },
                          ),
                          ProfilePanelInfoItem(
                            "Nomor Induk Karyawan",
                            value: item.officerId,
                            onTap: () {
                              if (item != null) {
                                _showEditPopup(
                                  ProfileEditFormType.officerId,
                                  item.officerId,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      if (widget.type == "")
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: ProfilePanelInfo(
                            children: [
                              ProfilePanelInfoItem(
                                "Email",
                                value: item.email,
                                isFirstChild: true,
                                onTap: () {
                                  if (item != null) {
                                    _showEditPopup(
                                      ProfileEditFormType.email,
                                      item.email,
                                    );
                                  }
                                },
                              ),
                              ProfilePanelInfoItem(
                                "Password",
                                value: "********",
                                onTap: () {
                                  if (item != null) {
                                    _showEditPopup(
                                      ProfileEditFormType.password,
                                      "",
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    required this.item,
    this.type = "",
  }) : super(key: key);

  final Officer? item;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(125),
            child: Container(
              width: 100,
              height: 100,
              color: kPrimary2,
              child: item == null
                  ? null
                  : item?.photo == ""
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              Format.nameToInitial(item?.fullName ?? ""),
                              style: TextStyle(
                                color: kSecondary2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Image.network(item!.photo, fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: type != ""
              ? null
              : MyButton(
                  "GANTI FOTO PROFIL",
                  width: 180,
                  size: MyButtonSize.sm,
                  type: MyButtonType.primaryOutline,
                  onTap: () {
                    if (item != null) {
                      DatabaseService()
                          .users
                          .uploadPhoto(item!.uid, item!.photo);
                    }
                  },
                ),
        ),
      ],
    );
  }
}

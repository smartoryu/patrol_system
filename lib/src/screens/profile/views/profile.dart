import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

import 'components/button_logout.dart';
import 'components/panel_info.dart';
import 'components/panel_info_item.dart';

class ProfileScreen extends StatefulWidget {
  static const route = "/profile-screen";
  const ProfileScreen({
    Key? key,
    required this.uid,
    this.isEditing = false,
  }) : super(key: key);

  final String uid;
  final bool isEditing;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          if (widget.isEditing) const ProfileButtonLogout(),
        ],
      ),
      body: FutureBuilder<Officer?>(
          future: DatabaseService().users.getSingle(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Text("Network Error");
            }
            if (snapshot.hasData) {
              debugPrint("${snapshot.data}");
              var item = snapshot.data;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(125),
                          child: Container(
                            width: 125,
                            height: 125,
                            color: kPrimary2,
                            // child: this.photo == ""
                            //     ? Padding(
                            //         padding: const EdgeInsets.all(16.0),
                            //         child: FittedBox(
                            //           fit: BoxFit.contain,
                            //           child: Text(
                            //             Format.nameToInitial(this.user?.name),
                            //             style: TextStyle(
                            //               color: kSecondary2,
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //     : Image.network(this.photo),
                          ),
                        ),
                      ),
                      MyButton(
                        "GANTI FOTO PROFIL",
                        onTap: () {},
                        width: 180,
                        type: MyButtonType.primaryOutline,
                      ),
                      const SizedBox(height: 24),
                      ProfilePanelInfo(
                        children: [
                          ProfilePanelInfoItem(
                            "Nama",
                            value: item?.fullName ?? "",
                            isFirstChild: true,
                            onTap: () {},
                          ),
                          ProfilePanelInfoItem(
                            "Posisi",
                            value: item?.position ?? "",
                            onTap: () {},
                          ),
                          ProfilePanelInfoItem(
                            "Nomor Telepon",
                            value: item?.phoneNumber ?? "",
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ProfilePanelInfo(
                        children: [
                          ProfilePanelInfoItem(
                            "Email",
                            value: item?.email ?? "",
                            isFirstChild: true,
                            onTap: () {},
                          ),
                          ProfilePanelInfoItem(
                            "Password",
                            value: "********",
                            onTap: () {},
                          ),
                        ],
                      ),
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

// class UserModel {
//   UserModel(
//     this.username,
//     this.name,
//     this.position,
//     this.phone,
//     this.email,
//     this.password,
//   );

//   final String username;
//   final String name;
//   final String position;
//   final String phone;
//   final String email;
//   final String password;
// }

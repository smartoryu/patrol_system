import 'package:nusalima_patrol_system/src/views.dart';

import 'components/button_logout.dart';
import 'components/panel_info.dart';
import 'components/panel_info_item.dart';

class ProfileScreen extends StatefulWidget {
  static const route = "/profile-screen";
  ProfileScreen({Key? key, this.name = ""}) : super(key: key);

  final String name;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String photo = "";
  UserModel? user;

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.name == "") {
        this.user = new UserModel(
          "olive_yew",
          "Olive Yew",
          "Petugas Keamanan",
          "+62821334334123",
          "oliveyew@mail.com",
          "password",
        );
      } else {
        var username = widget.name.replaceAll(" ", "").toLowerCase();
        var email = widget.name.replaceAll(" ", "_").toLowerCase();

        this.user = new UserModel(
          username,
          widget.name,
          "Petugas Keamanan",
          "+62821334334123",
          "$email@mail.com",
          "password",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: kPrimary,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kPrimary,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          if (widget.name == "") ProfileButtonLogout(),
        ],
      ),
      body: SingleChildScrollView(
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
                    child: this.photo == ""
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                Format.nameToInitial(this.user?.name),
                                style: TextStyle(
                                  color: kSecondary2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Image.network(this.photo),
                  ),
                ),
              ),
              MyButton(
                "GANTI FOTO PROFIL",
                onTap: () {},
                width: 180,
                type: MyButtonType.primaryOutline,
              ),
              SizedBox(height: 24),
              ProfilePanelInfo(
                children: [
                  ProfilePanelInfoItem(
                    "Nama",
                    value: this.user?.name ?? "",
                    isFirstChild: true,
                    onTap: widget.name == "" ? null : () {},
                  ),
                  ProfilePanelInfoItem(
                    "Posisi",
                    value: this.user?.position ?? "",
                    onTap: widget.name == "" ? null : () {},
                  ),
                  ProfilePanelInfoItem(
                    "Nomor Telepon",
                    value: this.user?.phone ?? "",
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 24),
              ProfilePanelInfo(
                children: [
                  ProfilePanelInfoItem(
                    "Email",
                    value: this.user?.email ?? "",
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
      ),
    );
  }
}

class UserModel {
  UserModel(
    this.username,
    this.name,
    this.position,
    this.phone,
    this.email,
    this.password,
  );

  final String username;
  final String name;
  final String position;
  final String phone;
  final String email;
  final String password;
}

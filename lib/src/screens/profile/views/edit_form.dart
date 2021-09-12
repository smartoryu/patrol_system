import 'package:nusalima_patrol_system/src/utils/services/firestore/user_collection.dart';
import 'package:nusalima_patrol_system/src/views.dart';

enum ProfileEditFormType {
  fullName,
  password,
  position,
  phoneNumber,
  email,
  officerId,
}

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({
    Key? key,
    this.defaultValue = "",
    required this.onConfirm,
    required this.type,
    required this.uid,
  }) : super(key: key);

  final String defaultValue;
  final void Function(String) onConfirm;
  final ProfileEditFormType type;
  final String uid;

  @override
  _ProfileEditFormState createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  TextEditingController conText = TextEditingController();
  String text = "";
  void setText(String e) => setState(() => text = e);

  TextEditingController conPassword = TextEditingController();
  String password = "";
  void setPassword(String e) => setState(() => password = e);

  TextEditingController conPassword2 = TextEditingController();
  String password2 = "";
  void setPassword2(String e) => setState(() => password2 = e);

  String error = "";
  bool loading = false;
  void requestStart() => setState(() {
        loading = true;
        error = "";
      });
  void requestFailed(String e) => setState(() {
        loading = false;
        error = e;
      });

  @override
  void initState() {
    super.initState();
    conText.text = widget.defaultValue;
    text = widget.defaultValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var _isPassword = widget.type == ProfileEditFormType.password;
    var _isEmail = widget.type == ProfileEditFormType.email;
    var _size = MediaQuery.of(context).size;
    var _width = _size.width - 64;
    var _height = _isPassword
        ? 350.0
        : _isEmail
            ? 275.0
            : 200.0;

    return WillPopScope(
      onWillPop: () async {
        if (!loading) Navigator.of(context).pop();
        return false;
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 150),
              height: _height,
              width: _width,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  EditFormTitle(type: widget.type),
                  Column(
                    children: [
                      EditFormInput(
                        controller: conText,
                        type: widget.type,
                        onChanged: setText,
                      ),
                      if (widget.type == ProfileEditFormType.email)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: EditFormInput(
                            controller: conPassword,
                            hintText: "Masukkan password untuk ganti email",
                            type: widget.type,
                            onChanged: setPassword,
                          ),
                        ),
                      if (widget.type == ProfileEditFormType.password)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: EditFormInput(
                            controller: conPassword,
                            hintText: "Masukkan Password Baru",
                            type: widget.type,
                            onChanged: setPassword,
                          ),
                        ),
                      if (widget.type == ProfileEditFormType.password)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: EditFormInput(
                            controller: conPassword2,
                            hintText: "Konfirmasi Password Baru",
                            type: widget.type,
                            onChanged: setPassword2,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kDanger, fontSize: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton(
                        "Batal",
                        width: _width / 3,
                        disabled: loading,
                        type: MyButtonType.primaryOutline,
                        size: MyButtonSize.sm,
                        onTap: Navigator.of(context).pop,
                      ),
                      const SizedBox(width: 16),
                      MyButton(
                        "Simpan",
                        width: _width / 3,
                        disabled: loading ||
                            text == "" ||
                            (_isEmail && password == ""),
                        loading: loading,
                        type: MyButtonType.primary,
                        size: MyButtonSize.sm,
                        onTap: () async {
                          try {
                            requestStart();

                            Map<String, dynamic> obj = {};

                            switch (widget.type) {
                              case ProfileEditFormType.email:
                                obj["email"] = text;
                                break;
                              case ProfileEditFormType.fullName:
                                obj["fullName"] = text;
                                break;
                              case ProfileEditFormType.officerId:
                                obj["officerId"] = text;
                                break;
                              case ProfileEditFormType.phoneNumber:
                                obj["phoneNumber"] = text;
                                break;
                              case ProfileEditFormType.position:
                                obj["position"] = text;
                                break;
                              default:
                            }

                            if (_isPassword) {
                              if (text == "") throw "Masukkan password lama";
                              if (password == "") {
                                throw "Password baru tidak boleh kosong.";
                              }
                              if (password != password2) {
                                throw "Konfirmasi password salah.";
                              }
                              await AuthService()
                                  .changePassword(text, password);
                            } else {
                              if (_isEmail) {
                                if (password == "") {
                                  throw "Masukkan password untuk mengganti email.";
                                }
                                await AuthService().changeEmail(text, password);
                              }

                              await UserCollection().update(
                                uid: widget.uid,
                                json: obj,
                              );
                            }

                            Navigator.of(context).pop();
                          } catch (e) {
                            var errMsg = e.toString();
                            if (errMsg.contains("wrong-password")) {
                              if (_isPassword) {
                                requestFailed("Password lama salah.");
                              }
                              if (_isEmail) {
                                requestFailed("Password salah.");
                              }
                            } else {
                              requestFailed(e.toString());
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditFormTitle extends StatelessWidget {
  const EditFormTitle({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ProfileEditFormType type;

  String getTitle() {
    switch (type) {
      case ProfileEditFormType.email:
        return "Edit Email";
      case ProfileEditFormType.fullName:
        return "Edit Nama";
      case ProfileEditFormType.officerId:
        return "Edit Nomor Induk Karyawan";
      case ProfileEditFormType.password:
        return "Edit Password";
      case ProfileEditFormType.phoneNumber:
        return "Edit Nomor HP";
      case ProfileEditFormType.position:
        return "Edit Posisi";
      default:
        return "Edit";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        getTitle(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

class EditFormInput extends StatelessWidget {
  const EditFormInput({
    Key? key,
    required this.controller,
    this.hintText,
    required this.onChanged,
    required this.type,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final void Function(String) onChanged;
  final ProfileEditFormType type;

  String getHintText() {
    if (hintText != null) return hintText!;
    switch (type) {
      case ProfileEditFormType.email:
        return "Masukkan Email";
      case ProfileEditFormType.fullName:
        return "Masukkan Nama";
      case ProfileEditFormType.officerId:
        return "Masukkan Nomor Induk Karyawan";
      case ProfileEditFormType.password:
        return "Masukkan Password Lama";
      case ProfileEditFormType.phoneNumber:
        return "Masukkan Nomor HP";
      case ProfileEditFormType.position:
        return "Masukkan Posisi";
      default:
        return "Edit";
    }
  }

  TextInputType getKeyboardType() {
    switch (type) {
      case ProfileEditFormType.email:
        return TextInputType.emailAddress;
      case ProfileEditFormType.phoneNumber:
        return TextInputType.phone;
      case ProfileEditFormType.fullName:
      case ProfileEditFormType.officerId:
      case ProfileEditFormType.position:
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _isPhoneNumber = type == ProfileEditFormType.phoneNumber;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kPrimary2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            isDense: true,
            border: InputBorder.none,
            hintText: getHintText(),
          ),
          keyboardType: getKeyboardType(),
          style: const TextStyle(fontSize: 14),
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            if (_isPhoneNumber && value == "0") {
              controller.value = controller.value.copyWith(
                text: "+62",
                composing: TextRange.empty,
                selection: const TextSelection(
                  baseOffset: 3,
                  extentOffset: 3,
                ),
              );
              onChanged("+62");
            } else {
              onChanged(value);
            }
          },
          controller: controller,
        ),
      ),
    );
  }
}

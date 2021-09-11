import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

class DaftarPetugasForm extends StatefulWidget {
  const DaftarPetugasForm({Key? key, this.editing}) : super(key: key);

  final Officer? editing;

  @override
  _DaftarPetugasFormState createState() => _DaftarPetugasFormState();
}

class _DaftarPetugasFormState extends State<DaftarPetugasForm> {
  TextEditingController conFullName = TextEditingController();
  TextEditingController conEmail = TextEditingController();
  TextEditingController conPass = TextEditingController();
  TextEditingController conPhoneNumber = TextEditingController();
  TextEditingController conPosition = TextEditingController();

  String fullName = "";
  String email = "";
  String password = "";
  String phoneNumber = "";
  String position = "";
  bool isLoading = false;
  String error = "";

  @override
  void initState() {
    super.initState();

    if (widget.editing != null) {
      var editing = widget.editing!;

      conFullName.text = editing.fullName;
      conEmail.text = editing.email;
      conPhoneNumber.text = editing.phoneNumber;
      conPosition.text = editing.position;

      fullName = editing.fullName;
      email = editing.email;
      phoneNumber = editing.phoneNumber;
      position = editing.position;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _width = _size.width - 64;
    var isFormValid = fullName != "" &&
        email != "" &&
        password != "" &&
        phoneNumber != "" &&
        position != "";

    void requestStart() => setState(() {
          isLoading = true;
          error = "";
        });
    void requestFailed(String e) => setState(() {
          isLoading = false;
          error = e;
        });

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: kPrimary,
            statusBarIconBrightness: Brightness.light,
          ),
          automaticallyImplyLeading: false,
          title: Text(
            widget.editing != null ? "Edit Petugas" : "Daftar Petugas Baru",
          ),
        ),
        backgroundColor: kWhite,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OfficerFormInput(
                  controller: conFullName,
                  label: "Nama Petugas",
                  onChanged: (e) => setState(() => fullName = e),
                ),
                OfficerFormInput(
                  controller: conEmail,
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (e) => setState(() => email = e),
                ),
                if (widget.editing == null)
                  OfficerFormInput(
                    controller: conPass,
                    label: "Password",
                    hintText: "Masukkan Password (min. 6 karakter)",
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (e) => setState(() => password = e),
                  ),
                OfficerFormInput(
                  controller: conPhoneNumber,
                  label: "Nomor HP (format: +62xxxxxxxxx)",
                  hintText: "Masukkan Nomor HP",
                  keyboardType: TextInputType.phone,
                  onChanged: (e) {
                    if (e == "0") {
                      conPhoneNumber.value = conPhoneNumber.value.copyWith(
                        text: "+62",
                        composing: TextRange.empty,
                        selection: const TextSelection(
                          baseOffset: 3,
                          extentOffset: 3,
                        ),
                      );
                      setState(() => phoneNumber = "+62");
                    } else {
                      setState(() => phoneNumber = e);
                    }
                  },
                ),
                OfficerFormInput(
                  controller: conPosition,
                  label: "Posisi",
                  onChanged: (e) => setState(() => position = e),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      "Batal",
                      width: _width / 3.5,
                      disabled: isLoading,
                      type: MyButtonType.primaryOutline,
                      size: MyButtonSize.sm,
                      onTap: Navigator.of(context).pop,
                    ),
                    const SizedBox(width: 16),
                    MyButton(
                      "Simpan",
                      width: _width / 3.5,
                      loading: isLoading,
                      disabled: isLoading || !isFormValid,
                      type: MyButtonType.primary,
                      size: MyButtonSize.sm,
                      onTap: () async {
                        try {
                          requestStart();
                          if (fullName == "" ||
                              email == "" ||
                              password == "" ||
                              phoneNumber == "" ||
                              position == "") {
                            throw "Tidak boleh ada data yang kosong.";
                          }
                          if (!phoneNumber.contains("+62")) {
                            throw "Nomor tidak valid.";
                          }

                          await AuthService().registerWithEmailAndPassword(
                            email: email,
                            password: password,
                            fullName: fullName,
                            phoneNumber: phoneNumber,
                            role: "officer",
                            position: position,
                          );

                          setState(() => isLoading = false);
                          Navigator.of(context).pop();
                        } catch (error) {
                          var e = error.toString();
                          if (e.contains("invalid-email")) {
                            requestFailed("Format email salah");
                          } else if (e.contains("weak-password")) {
                            requestFailed("Password minimal 6 karakter");
                          } else {
                            requestFailed(e);
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kDanger, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OfficerFormInput extends StatelessWidget {
  const OfficerFormInput({
    Key? key,
    required this.controller,
    this.keyboardType,
    required this.label,
    this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String label;
  final String? hintText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
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
                hintText: hintText ?? "Masukkan $label",
              ),
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 14),
              textInputAction: TextInputAction.next,
              onChanged: onChanged,
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:nusalima_patrol_system/src/views.dart';

class DaftarPetugasForm extends StatefulWidget {
  DaftarPetugasForm({
    Key? key,
    required this.width,
    this.buttonWidth,
    this.onConfirm,
    this.value,
  }) : super(key: key);

  final double width;
  final double? buttonWidth;
  final void Function(String)? onConfirm;
  final String? value;

  @override
  _DaftarPetugasFormState createState() => _DaftarPetugasFormState();
}

class _DaftarPetugasFormState extends State<DaftarPetugasForm> {
  TextEditingController conText = TextEditingController();
  TextEditingController conEmail = TextEditingController();
  TextEditingController conPass = TextEditingController();
  TextEditingController conPhone = TextEditingController();
  TextEditingController conRole = TextEditingController();

  String text = "";
  String email = "";
  String password = "";
  String phone = "";
  String role = "";

  @override
  void initState() {
    super.initState();

    if (this.widget.value != null) {
      conText.text = this.widget.value!;
      setState(() => this.text = this.widget.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 500,
              width: this.widget.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      this.widget.value == null ? "Tambah Baru" : "Edit",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 4),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Masukkan nama Petugas",
                    ),
                    onChanged: (value) {
                      setState(() => this.text = value);
                    },
                    controller: this.conText,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Masukkan email",
                    ),
                    onChanged: (value) {
                      setState(() => this.email = value);
                    },
                    controller: this.conEmail,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Masukkan password",
                    ),
                    onChanged: (value) {
                      setState(() => this.password = value);
                    },
                    controller: this.conPass,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Masukkan nomor hp",
                    ),
                    onChanged: (value) {
                      setState(() => this.phone = value);
                    },
                    controller: this.conPhone,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Masukkan posisi",
                    ),
                    onChanged: (value) {
                      setState(() => this.role = value);
                    },
                    controller: this.conRole,
                  ),
                  SizedBox(height: 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton(
                        "Batal",
                        width: this.widget.width / 3.5,
                        type: MyButtonType.primaryOutline,
                        size: MyButtonSize.sm,
                        onTap: Navigator.of(context).pop,
                      ),
                      SizedBox(width: 16),
                      MyButton(
                        "Simpan",
                        width: this.widget.width / 3.5,
                        type: MyButtonType.primary,
                        size: MyButtonSize.sm,
                        onTap: this.widget.onConfirm == null
                            ? null
                            : () => this.widget.onConfirm!(text),
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

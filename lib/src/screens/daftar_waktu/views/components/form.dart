import 'package:nusalima_patrol_system/src/views.dart';

class DaftarWaktuForm extends StatefulWidget {
  DaftarWaktuForm({
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
  _DaftarWaktuFormState createState() => _DaftarWaktuFormState();
}

class _DaftarWaktuFormState extends State<DaftarWaktuForm> {
  TextEditingController conText = TextEditingController();
  String text = "";

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
          child: Container(
            height: 200,
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Masukkan waktu shift baru",
                  ),
                  onChanged: (value) {
                    setState(() => this.text = value);
                  },
                  controller: this.conText,
                ),
                SizedBox(height: 16),
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
    );
  }
}

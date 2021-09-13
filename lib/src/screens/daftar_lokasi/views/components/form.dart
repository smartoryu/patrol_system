import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

class DaftarLokasiForm extends StatefulWidget {
  const DaftarLokasiForm({
    Key? key,
    this.isEditing,
  }) : super(key: key);

  final Location? isEditing;

  @override
  _DaftarLokasiFormState createState() => _DaftarLokasiFormState();
}

class _DaftarLokasiFormState extends State<DaftarLokasiForm> {
  TextEditingController conText = TextEditingController();
  String text = "";
  void setText(String e) => setState(() => text = e);

  String error = "";
  bool loading = false;
  void requestStart() => setState(() {
        error = "";
        loading = true;
      });
  void requestDone([String e = ""]) => setState(() {
        error = e;
        loading = false;
      });

  @override
  void initState() {
    super.initState();

    if (widget.isEditing != null) {
      conText.text = widget.isEditing!.name;
      text = widget.isEditing!.name;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _width = _size.width - 64;
    var _height = 200.0;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            height: _height,
            width: _width,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 200),
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
                    widget.isEditing == null
                        ? "Tambah Baru"
                        : "Edit Nama Lokasi",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Masukkan nama lokasi",
                  ),
                  textAlign: TextAlign.center,
                  controller: conText,
                  onChanged: setText,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      "Batal",
                      width: _width / 3.5,
                      disabled: loading,
                      type: MyButtonType.primaryOutline,
                      size: MyButtonSize.sm,
                      onTap: Navigator.of(context).pop,
                    ),
                    const SizedBox(width: 16),
                    MyButton(
                      "Simpan",
                      width: _width / 3.5,
                      disabled: text == "" || loading,
                      loading: loading,
                      type: MyButtonType.primary,
                      size: MyButtonSize.sm,
                      onTap: () async {
                        if (text == "") return;
                        try {
                          requestStart();

                          if (widget.isEditing == null) {
                            await DatabaseService()
                                .locations
                                .create(name: text);
                          } else {
                            await DatabaseService(uid: widget.isEditing!.uid)
                                .locations
                                .update(json: {"name": text});
                          }
                          requestDone();

                          Navigator.of(context).pop();
                        } catch (e) {
                          var errMsg = e.toString();
                          requestDone(errMsg);
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
    );
  }
}

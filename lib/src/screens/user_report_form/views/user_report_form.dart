import 'dart:io';

import 'package:nusalima_patrol_system/src/views.dart';

class UserReportFormScreen extends StatefulWidget {
  static const route = "/task-detail-screen";
  UserReportFormScreen({Key? key}) : super(key: key);

  @override
  _UserReportFormScreenState createState() => _UserReportFormScreenState();
}

class _UserReportFormScreenState extends State<UserReportFormScreen> {
  ImagePicker imagePicker = ImagePicker();
  TextEditingController conNotes = TextEditingController();

  List<XFile> photos = [];
  String notes = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    final double IMG_WIDTH = (width - 32 - (16 * 3)) * 0.25;

    Widget _image({Widget? child}) {
      return GestureDetector(
        onTap: () async {
          final pickedFile = await imagePicker.pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.rear,
          );
          if (pickedFile != null) setState(() => this.photos.add(pickedFile));
        },
        child: Container(
          height: IMG_WIDTH,
          width: IMG_WIDTH,
          decoration: BoxDecoration(
            border: Border.all(
              color: kPrimary,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      );
    }

    Future<void> handleKirimLaporan() async {
      setState(() => this.loading = true);
      var position = await getCurrentPosition();
      var imgPaths = photos.map((e) => e.path).toList();

      var body = {
        "notes": notes,
        "photos": imgPaths,
        "latitude": position.latitude,
        "longitude": position.longitude,
      };

      print(body);
      setState(() => this.loading = false);
      Navigator.pop(context);
    }

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: kPrimary,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text("Laporan Baru"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: kPrimary)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload Foto",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: IMG_WIDTH,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _image(
                              child: Center(child: Icon(Icons.add)),
                            );
                          } else {
                            var item = photos[index - 1];
                            return Stack(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: index == 0 ? 0 : 8),
                                  child: SizedBox(
                                    height: IMG_WIDTH,
                                    width: IMG_WIDTH,
                                    child: Image.file(
                                      File(item.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      var newPhotos = photos.where((e) {
                                        return e.name != item.name;
                                      }).toList();
                                      setState(() => this.photos = newPhotos);
                                    },
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                        itemCount: photos.length + 1,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Catatan (opsional)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 4,
                    onChanged: (value) {
                      setState(() => this.notes = value);
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: "Masukkan catatan",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 72),
              Center(
                child: MyButton(
                  "Kirim Laporan",
                  width: 150,
                  onTap: handleKirimLaporan,
                  loading: this.loading,
                  disabled: this.loading,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

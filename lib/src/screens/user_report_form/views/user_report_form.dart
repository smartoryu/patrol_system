import 'dart:io';

import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

class UserReportFormScreen extends StatefulWidget {
  const UserReportFormScreen({
    Key? key,
    required this.shiftId,
    required this.officer,
    required this.location,
  }) : super(key: key);

  final String shiftId;
  final Officer officer;
  final Location location;

  @override
  _UserReportFormScreenState createState() => _UserReportFormScreenState();
}

class _UserReportFormScreenState extends State<UserReportFormScreen> {
  ImagePicker imagePicker = ImagePicker();
  TextEditingController conNotes = TextEditingController();

  List<String> photos = [];
  String notes = "";
  bool loading = false;
  bool cancelling = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    final double IMG_WIDTH = (width - 32 - (16 * 3)) * 0.25;

    Widget _image({Widget? child}) {
      return GestureDetector(
        onTap: () async {
          if (photos.length == 5) return;
          final image = await imagePicker.pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.rear,
          );
          if (image != null) {
            String fileName = "profile";
            File file = File(image.path);

            var downloadURL = await StorageService().upload(
              fileName: fileName,
              file: file,
              category: "report",
            );

            setState(() => photos.add(downloadURL));
          }
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
      setState(() => loading = true);
      var position = await getCurrentPosition();
      var imgPaths = photos.map((e) => e).toList();

      await DatabaseService().shiftReport.create(
            shiftId: widget.shiftId,
            officer: widget.officer,
            location: widget.location,
            notes: notes,
            photos: imgPaths,
            lat: position.latitude.toString(),
            long: position.longitude.toString(),
          );

      setState(() => loading = false);
      Navigator.pop(context);
      Navigator.pop(context);
    }

    Future<void> handleBack() async {
      if (loading || cancelling) return;

      if (photos.isNotEmpty) {
        setState(() => cancelling = true);
        await StorageService().deleteBulkByUrl(urls: photos);
        setState(() => cancelling = false);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        await handleBack();
        return false;
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimary,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: kPrimary,
              statusBarIconBrightness: Brightness.light,
            ),
            title: const Text("Laporan Baru"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async => await handleBack(),
            ),
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
                      const Text(
                        "Upload Foto",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: IMG_WIDTH,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (index == 0 && photos.length < 5) {
                              return _image(
                                child: Center(
                                    child: photos.length == 5
                                        ? const Text(
                                            "Maksimal 5 foto",
                                            textAlign: TextAlign.center,
                                          )
                                        : const Icon(Icons.add)),
                              );
                            } else {
                              var item = photos.length == 5
                                  ? photos[index]
                                  : photos[index - 1];
                              return Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: index == 0 ? 0 : 8),
                                    child: SizedBox(
                                      height: IMG_WIDTH,
                                      width: IMG_WIDTH,
                                      child: Image.network(
                                        item,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        var newPhotos = photos.where((e) {
                                          return e != item;
                                        }).toList();
                                        setState(() => photos = newPhotos);
                                        await StorageService()
                                            .deleteByUrl(url: item);
                                      },
                                      child: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                          itemCount: photos.length == 5 ? 5 : photos.length + 1,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.all(8.0),
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
                        setState(() => notes = value);
                      },
                      decoration: const InputDecoration.collapsed(
                        hintText: "Masukkan catatan",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 72),
                Center(
                  child: MyButton(
                    cancelling ? "membatalkan" : "Kirim Laporan",
                    width: 150,
                    onTap: handleKirimLaporan,
                    loading: loading || cancelling,
                    disabled: loading || cancelling || photos.isEmpty,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

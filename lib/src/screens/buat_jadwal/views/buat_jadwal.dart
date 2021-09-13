import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';
import 'package:uuid/uuid.dart';

import 'select_location.dart';
import 'select_officer.dart';

class BuatJadwalScreen extends StatefulWidget {
  static const route = "/buat-jadwal-screen";
  const BuatJadwalScreen({Key? key}) : super(key: key);

  @override
  _BuatJadwalScreenState createState() => _BuatJadwalScreenState();
}

class _BuatJadwalScreenState extends State<BuatJadwalScreen> {
  String error = "";
  bool loading = false;
  void requestStart() => setState(() {
        error = "";
        loading = true;
      });
  void requestDone([String e = '']) => setState(() {
        error = e;
        loading = true;
      });

  List<NewShift> shifts = [];

  _addNewShift() => showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AddNewShift(
          onConfirm: (value) {
            shifts.add(value);
            setState(() {});
          },
        );
      });

  _deleteShift(NewShift _value) => showDialog(
        context: context,
        builder: (context) {
          var _size = MediaQuery.of(context).size;
          var _width = _size.width - 64;
          return MyPopupDialog(
            title: "Hapus Jadwal ${_value.officer.fullName}?",
            height: 130,
            width: _width,
            buttonWidth: _width / 3,
            cancelText: "Batal",
            cancelType: MyButtonType.primaryOutline,
            cancelTap: Navigator.of(context).pop,
            confirmText: "Ya",
            confirmType: MyButtonType.danger,
            confirmTap: () {
              shifts.removeWhere((item) => item.uid == _value.uid);
              setState(() {});
              Navigator.of(context).pop();
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: kPrimary,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text("Buat Jadwal Shift Baru"),
      ),
      backgroundColor: kWhite,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Tambah Shift'),
        icon: const Icon(Icons.add),
        backgroundColor: kPrimary,
        onPressed: () {
          _addNewShift();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: shifts.map((item) {
                  var name = item.officer.fullName;
                  var loc = item.location.name;
                  var start = item.startTime.toUtc().toIso8601String();
                  var end = item.endTime.toUtc().toIso8601String();
                  String formatDate(String e) {
                    return Format.date(e, "dd/MM/yyyy HH:mm");
                  }

                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: kPrimary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$name - $loc"),
                            const SizedBox(height: 8),
                            Text("Mulai: ${formatDate(start)}"),
                            const SizedBox(height: 8),
                            Text("Selesai: ${formatDate(end)}"),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _deleteShift(item),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.delete,
                              size: 36,
                              color: kDanger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 64),
              if (shifts.isNotEmpty)
                Center(
                  child: MyButton(
                    "Konfirmasi",
                    width: 200,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          var _size = MediaQuery.of(context).size;
                          var _width = _size.width - 64;
                          return MyPopupDialog(
                            title: "Konfirmasi Pembuatan Jadwal Baru?",
                            height: 130,
                            width: _width,
                            buttonWidth: _width / 3,
                            cancelText: "Batal",
                            cancelType: MyButtonType.primaryOutline,
                            cancelTap: Navigator.of(context).pop,
                            confirmText: "Ya",
                            confirmType: MyButtonType.danger,
                            confirmTap: () async {
                              try {
                                requestStart();
                                await DatabaseService()
                                    .shifts
                                    .createBulk(shifts);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } catch (e) {
                                requestDone();
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class AddNewShift extends StatefulWidget {
  const AddNewShift({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  final void Function(NewShift) onConfirm;

  @override
  State<AddNewShift> createState() => _AddNewShiftState();
}

class _AddNewShiftState extends State<AddNewShift> {
  List<String> officerOptions = ["-"];
  List<Officer> officerData = [];
  List<String> locationOptions = ["-"];
  List<Location> locationData = [];

  String officer = "-";
  String location = "-";
  DateTime? startTime;
  DateTime? endTime;

  void setOfficer(String? e) => setState(() => officer = e ?? "-");
  void setLocation(String? e) => setState(() => location = e ?? "-");
  void setStartTime(DateTime? e) => setState(() => startTime = e);
  void setEndTime(DateTime? e) => setState(() => endTime = e);

  @override
  void initState() {
    super.initState();
    fetchOfficer();
    fetchLocation();
  }

  Future<void> fetchOfficer() async {
    var result = await FirebaseFirestore.instance.collection('users').get();
    for (var e in result.docs) {
      var json = e.data();
      var item = Officer.fromJson(jsonDecode(jsonEncode(json)));
      if (item.role == "officer") {
        officerOptions.add(item.uid);
        officerData.add(item);
      }
      setState(() {});
    }
  }

  Future<void> fetchLocation() async {
    var result = await FirebaseFirestore.instance.collection('locations').get();
    for (var e in result.docs) {
      var json = e.data();
      var item = Location.fromJson(jsonDecode(jsonEncode(json)));
      locationOptions.add(item.uid);
      locationData.add(item);
    }
    setState(() {});
  }

  void createShift() {
    if (officer == "-" ||
        location == "-" ||
        startTime == null ||
        endTime == null) return;

    var newShift = NewShift(
      uid: const Uuid().v4(),
      officer: officerData.firstWhere((val) => val.uid == officer),
      location: locationData.firstWhere((val) => val.uid == location),
      startTime: startTime!,
      endTime: endTime!,
    );

    widget.onConfirm(newShift);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width - 64;
    var height = 400.0;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(16),
            // margin: const EdgeInsets.only(bottom: 200),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SelectOfficer(
                    value: officer,
                    options: officerOptions,
                    data: officerData,
                    onChanged: setOfficer,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SelectLocation(
                    value: location,
                    options: locationOptions,
                    data: locationData,
                    onChanged: setLocation,
                  ),
                ),
                //
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: BasicDateTimeField(
                    title: "Mulai Shift",
                    onChanged: setStartTime,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: BasicDateTimeField(
                    title: "Selesai Shift",
                    onChanged: setEndTime,
                  ),
                ),
                //
                const SizedBox(height: 24),
                //
                MyButton(
                  "Pilih",
                  onTap: createShift,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BasicDateTimeField extends StatelessWidget {
  BasicDateTimeField({
    Key? key,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final format = DateFormat("dd/MM/yyyy HH:mm");
  final String title;
  final void Function(DateTime?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        DateTimeField(
          format: format,
          onChanged: onChanged,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                  currentValue ?? DateTime.now(),
                ),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
        ),
      ]),
    );
  }
}

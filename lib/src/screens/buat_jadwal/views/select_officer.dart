import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

class SelectOfficer extends StatelessWidget {
  const SelectOfficer({
    Key? key,
    required this.data,
    required this.options,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final List<Officer> data;
  final List<String> options;
  final String value;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Petugas",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          isExpanded: true,
          hint: const Text('Pilih Petugas'),
          items: options.isEmpty
              ? const [
                  DropdownMenuItem<String>(
                    value: "-",
                    child: Text("Pilih Petugas"),
                  )
                ]
              : options.map((String value) {
                  Officer findName(String uid) =>
                      data.firstWhere((val) => val.uid == value);

                  return DropdownMenuItem<String>(
                    value: value,
                    child: value == "-"
                        ? const Text("Pilih Petugas")
                        : Text(findName(value).fullName),
                  );
                }).toList(),
          value: value,
          onChanged: onChanged,
          // onChanged: widget.onChanged,
        ),
      ],
    );
  }
}

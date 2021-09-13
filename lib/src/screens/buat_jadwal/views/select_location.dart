import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';

class SelectLocation extends StatelessWidget {
  const SelectLocation({
    Key? key,
    required this.data,
    required this.options,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final List<Location> data;
  final List<String> options;
  final String value;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lokasi",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          isExpanded: true,
          hint: const Text('Pilih Lokasi'),
          items: options.isEmpty
              ? const [
                  DropdownMenuItem<String>(
                    value: "-",
                    child: Text("Pilih Lokasi"),
                  )
                ]
              : options.map((String value) {
                  Location findName(String uid) =>
                      data.firstWhere((val) => val.uid == value);

                  return DropdownMenuItem<String>(
                    value: value,
                    child: value == "-"
                        ? const Text("Pilih Lokasi")
                        : Text(findName(value).name),
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

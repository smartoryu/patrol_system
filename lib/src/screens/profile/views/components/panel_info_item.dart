import 'package:nusalima_patrol_system/src/views.dart';

class ProfilePanelInfoItem extends StatelessWidget {
  const ProfilePanelInfoItem(
    this.title, {
    Key? key,
    this.isFirstChild,
    required this.value,
    this.onTap,
  }) : super(key: key);

  final bool? isFirstChild;
  final String title;
  final String value;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: fromRGB("#C5C5C5"),
            width: isFirstChild == true ? 0 : 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(this.title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(this.value),
            ],
          ),
          if (this.onTap != null)
            ClipOval(
              child: Material(
                child: InkWell(
                  onTap: this.onTap,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(Icons.edit, size: 16),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

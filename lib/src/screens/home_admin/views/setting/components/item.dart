import 'package:nusalima_patrol_system/src/views.dart';

class HomeSettingItem extends StatelessWidget {
  const HomeSettingItem(
    this.title, {
    Key? key,
    this.onTap,
    this.filled = false,
  }) : super(key: key);

  final String title;
  final void Function()? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? kPrimary : kWhite,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: this.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: fromRGB("#C5C5C5")),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: filled ? kWhite : kPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: 32,
                  child: Icon(
                    Icons.navigate_next,
                    color: filled ? kWhite : kPrimary,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

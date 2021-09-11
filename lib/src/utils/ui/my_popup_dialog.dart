import 'package:nusalima_patrol_system/src/views.dart';

class MyPopupDialog extends StatelessWidget {
  const MyPopupDialog({
    Key? key,
    required this.height,
    required this.title,
    required this.width,
    this.buttonWidth,
    this.cancelText,
    this.cancelTap,
    this.cancelType,
    this.confirmText,
    this.confirmTap,
    this.confirmType,
  }) : super(key: key);

  final double height;
  final String title;
  final double width;
  final double? buttonWidth;
  final String? cancelText;
  final void Function()? cancelTap;
  final MyButtonType? cancelType;
  final String? confirmText;
  final void Function()? confirmTap;
  final MyButtonType? confirmType;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: this.height,
          width: this.width,
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
                  this.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    this.cancelText ?? "Tidak",
                    width: this.buttonWidth ?? this.width / 3.5,
                    type: this.cancelType ?? MyButtonType.danger,
                    size: MyButtonSize.sm,
                    onTap: this.cancelTap,
                  ),
                  SizedBox(width: 16),
                  MyButton(
                    this.confirmText ?? "Ya",
                    width: this.buttonWidth ?? this.width / 3.5,
                    type: this.confirmType ?? MyButtonType.primary,
                    size: MyButtonSize.sm,
                    onTap: this.confirmTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

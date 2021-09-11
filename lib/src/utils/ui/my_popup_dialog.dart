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
    this.isLoading = false,
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
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: height,
          width: width,
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
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    cancelText ?? "Tidak",
                    width: buttonWidth ?? width / 3.5,
                    type: cancelType ?? MyButtonType.danger,
                    size: MyButtonSize.sm,
                    disabled: isLoading,
                    onTap: cancelTap,
                  ),
                  const SizedBox(width: 16),
                  MyButton(
                    confirmText ?? "Ya",
                    width: buttonWidth ?? width / 3.5,
                    type: confirmType ?? MyButtonType.primary,
                    size: MyButtonSize.sm,
                    disabled: isLoading,
                    loading: isLoading,
                    onTap: confirmTap,
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

import 'package:nusalima_patrol_system/src/views.dart';

class MyButton extends StatelessWidget {
  const MyButton(
    this.title, {
    Key? key,
    this.backgroundColor,
    this.bold = true,
    this.borderRadius = 8,
    this.childAlign = MainAxisAlignment.center,
    this.disabled = false,
    this.height,
    this.iconPrefix,
    this.iconSuffix,
    this.loading = false,
    this.margin = const EdgeInsets.all(0),
    this.onTap,
    this.padding,
    this.size = MyButtonSize.md,
    this.textColor,
    this.type = MyButtonType.primary,
    this.width,
  }) : super(key: key);

  final Color? backgroundColor;
  final bool? bold;
  final double borderRadius;
  final MainAxisAlignment childAlign;
  final bool? disabled;
  final double? height;
  final Widget? iconPrefix;
  final Widget? iconSuffix;
  final bool? loading;
  final EdgeInsetsGeometry margin;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final MyButtonSize? size;
  final Color? textColor;
  final String title;
  final MyButtonType? type;
  final double? width;

  @override
  Widget build(BuildContext context) {
    bool _isBordered = this.type == MyButtonType.textOnly ||
        this.type == MyButtonType.primaryOutline ||
        this.type == MyButtonType.primary2Outline ||
        this.type == MyButtonType.secondaryOutline ||
        this.type == MyButtonType.dangerOutline;

    BorderRadius _getBorderRadius() {
      return BorderRadius.circular(this.borderRadius);
    }

    BoxBorder _getBorder() {
      return Border.all(
        color: this.disabled == true
            ? _CreateColor.from(MyButtonType.disabled).border
            : _isBordered
                ? _CreateColor.from(this.type).border
                : Colors.transparent,
        width: 1.5,
      );
    }

    EdgeInsetsGeometry _getPadding() {
      switch (this.size) {
        case MyButtonSize.xl:
          return EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          );
        case MyButtonSize.md:
          return EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          );
        default:
          return EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          );
      }
    }

    Color? _getBackgroundColor() {
      return this.disabled == true
          ? _CreateColor.from(MyButtonType.disabled).background
          : backgroundColor != null
              ? backgroundColor
              : _CreateColor.from(this.type).background;
    }

    Color? _getTextColor() {
      return this.disabled == true
          ? _CreateColor.from(MyButtonType.disabled).text
          : textColor != null
              ? textColor
              : _CreateColor.from(this.type).text;
    }

    return Padding(
      padding: this.margin,
      child: Material(
        color: _getBackgroundColor(),
        borderRadius: _getBorderRadius(),
        child: InkWell(
          onTap: this.disabled == true ? null : onTap,
          borderRadius: _getBorderRadius(),
          splashColor: this.type == MyButtonType.textOnly
              ? Colors.transparent
              : Color.fromRGBO(255, 255, 255, 0.25),
          highlightColor: this.type == MyButtonType.textOnly
              ? Colors.transparent
              : Color.fromRGBO(0, 0, 0, 0.05),
          child: Container(
            height: height,
            padding: this.padding != null ? padding : _getPadding(),
            width: width,
            decoration: BoxDecoration(
              border: _getBorder(),
              borderRadius: _getBorderRadius(),
            ),
            child: Row(
              mainAxisAlignment: this.childAlign,
              children: [
                if (iconPrefix != null) iconPrefix!,
                this.loading == true
                    ? SizedBox(
                        height: 19,
                        width: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : AutoSizeText(
                        title,
                        maxLines: 1,
                        style: TextStyle(
                          color: _getTextColor(),
                          fontWeight:
                              bold == true ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                if (iconSuffix != null) iconSuffix!
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum MyButtonType {
  primary,
  primary2,
  primaryOutline,
  primary2Outline,
  secondary,
  secondaryOutline,
  danger,
  dangerOutline,
  textOnly,
  disabled,
}

enum MyButtonSize { sm, md, xl }

class _CreateColor {
  _CreateColor({
    required this.background,
    required this.border,
    required this.text,
  });

  final Color background;
  final Color border;
  final Color text;

  factory _CreateColor.from(MyButtonType? type) {
    /// This function return `List<Color>`
    /// consist of [backgroundColor, borderColor, textColor]
    /// based on the [type]
    List<Color> _getColor() {
      switch (type) {
        case MyButtonType.primary:
          return [kPrimary, kPrimary, kWhite];
        case MyButtonType.primary2:
          return [kPrimary2, kPrimary2, kWhite];

        case MyButtonType.primaryOutline:
          return [Colors.transparent, kPrimary, kPrimary];
        case MyButtonType.primary2Outline:
          return [Colors.transparent, kPrimary2, kPrimary2];

        case MyButtonType.secondary:
          return [kSecondary, kSecondary, kPrimary];
        case MyButtonType.secondaryOutline:
          return [Colors.transparent, kSecondary, kPrimary];

        case MyButtonType.textOnly:
          return [Colors.transparent, Colors.transparent, kPrimary];

        case MyButtonType.danger:
          return [kDanger, kDanger, kWhite];
        case MyButtonType.dangerOutline:
          return [Colors.transparent, kDanger, kPrimary];

        default:
          return [fromRGB("#EDEDED"), fromRGB("#EDEDED"), fromRGB("#979797")];
      }
    }

    return _CreateColor(
      background: _getColor()[0],
      border: _getColor()[1],
      text: _getColor()[2],
    );
  }
}

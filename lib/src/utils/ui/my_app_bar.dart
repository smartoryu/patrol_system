import 'package:nusalima_patrol_system/src/views.dart';

myAppBarMinimal({
  Brightness brightness = Brightness.dark,
  Color? color,
}) {
  var isDark = brightness == Brightness.dark;

  return AppBar(
    backgroundColor: isDark ? kWhite : kPrimary,
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: color != null
          ? color
          : isDark
              ? kWhite
              : kPrimary,
      statusBarIconBrightness: isDark ? Brightness.dark : Brightness.light,
    ),
    elevation: 0,
    toolbarHeight: 0,
  );
}

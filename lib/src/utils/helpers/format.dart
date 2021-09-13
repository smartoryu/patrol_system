import 'package:intl/intl.dart';

class Format {
  /// Format number without currency symbol
  ///
  /// example: 150.000
  static String quantity(dynamic number) {
    NumberFormat formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: "",
      decimalDigits: 0,
    );
    return formatCurrency.format(number);
  }

  /// Parse quantity to string
  ///
  /// example: 150000
  static int parse(String str) {
    return int.parse(str.replaceAll(".", ""));
  }

  static String nameToInitial(String? text) {
    if (text == null || text == "") {
      return "";
    } else {
      var replaced = text.replaceAllMapped(
        RegExp(r"/[^0-9a-z]/gi"),
        (match) => " ",
      );
      var splitted = replaced
          .replaceAllMapped(RegExp(r"/  +/g, " ""), (match) => " ")
          .split(" ");
      var result = splitted;
      var arr = result.map((e) => e[0]).join("");

      return arr.length > 1 ? arr.substring(0, 2) : arr + arr;
    }
  }

  /// format date to locale
  ///
  /// `string` timestampUTC  |  `string` format (default: "`dd MMMM yyyy, HH:mm`")
  static String date(
    String text, [
    String format = "dd MMMM yyyy, HH:mm",
  ]) {
    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(text, true);
    var dateLocal = dateTime.toLocal();
    return DateFormat(format, "id-ID").format(dateLocal);
  }
}

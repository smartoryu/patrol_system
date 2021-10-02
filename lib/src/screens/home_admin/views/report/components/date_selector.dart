import 'package:nusalima_patrol_system/src/views.dart';

class HomeReportDateSelector extends StatelessWidget {
  const HomeReportDateSelector({
    Key? key,
    required this.onChangeDate,
    required this.today,
    this.selectableDayPredicate,
  }) : super(key: key);

  final void Function(DateTime?) onChangeDate;
  final DateTime today;
  final bool Function(DateTime)? selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    var _today = DateTime.now().subtract(const Duration(days: 1));
    // var _yesterday = DateTime(_today.year, _today.month, _today.day - 1);
    var _firstDate = DateTime(today.year - 1, today.month, today.day);

    debugPrint("REPORT TODAY: $today");
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CalendarTimeline(
        initialDate: today,
        firstDate: _firstDate,
        lastDate: _today,
        onDateSelected: (date) {
          onChangeDate(date);
        },
        // leftMargin: MediaQuery.of(context).size.width * 0.75,
        leftMargin: 48,
        monthColor: kWhite,
        dayColor: fromRGB("#BDC9D7"),
        activeDayColor: kPrimary,
        dayNameColor: kWhite,
        selectableDayPredicate: selectableDayPredicate,
        activeBackgroundDayColor: kWhite,
        dotsColor: kWhite,
        locale: 'id',
      ),
    );
  }
}

import 'package:nusalima_patrol_system/src/views.dart';

class HomeUserDateSelector extends StatelessWidget {
  const HomeUserDateSelector({
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
    var _today = DateTime.now();
    var _firstDate = DateTime(_today.year - 1, _today.month, _today.day);
    var _lastDate = DateTime(_today.year + 1, _today.month, _today.day);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CalendarTimeline(
        initialDate: today,
        firstDate: _firstDate,
        lastDate: _lastDate,
        onDateSelected: onChangeDate,
        leftMargin: 50,
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

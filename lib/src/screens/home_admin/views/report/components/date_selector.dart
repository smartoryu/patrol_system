import 'package:nusalima_patrol_system/src/views.dart';

class HomeReportDateSelector extends StatelessWidget {
  const HomeReportDateSelector({
    Key? key,
    required this.onChangeDate,
    this.today,
    this.selectableDayPredicate,
  }) : super(key: key);

  final void Function(DateTime) onChangeDate;
  final DateTime? today;
  final bool Function(DateTime)? selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    var _today = new DateTime.now();
    var _yesterday = new DateTime(_today.year, _today.month, _today.day - 1);
    var _firstDate = new DateTime(_today.year - 1, _today.month, _today.day);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CalendarTimeline(
        initialDate: _yesterday,
        firstDate: _firstDate,
        lastDate: _yesterday,
        onDateSelected: (date) {
          if (date != null) this.onChangeDate(date);
        },
        leftMargin: MediaQuery.of(context).size.width * 0.75,
        monthColor: kWhite,
        dayColor: fromRGB("#BDC9D7"),
        activeDayColor: kPrimary,
        dayNameColor: kWhite,
        selectableDayPredicate: this.selectableDayPredicate,
        activeBackgroundDayColor: kWhite,
        dotsColor: kWhite,
        locale: 'id',
      ),
    );
  }
}

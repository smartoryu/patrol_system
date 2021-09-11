import 'package:nusalima_patrol_system/src/views.dart';

class ProfilePanelInfo extends StatelessWidget {
  const ProfilePanelInfo({
    Key? key,
    this.children = const <Widget>[],
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fromRGB("#C5C5C5")),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.children,
      ),
    );
  }
}

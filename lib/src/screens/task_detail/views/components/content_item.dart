import 'package:nusalima_patrol_system/src/views.dart';

class TaskDetailContentItem extends StatelessWidget {
  const TaskDetailContentItem({
    Key? key,
    this.date = "",
    this.notes = "",
    this.photos = const [""],
  }) : super(key: key);

  final String date;
  final String notes;
  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: photos.isEmpty
                  ? <Widget>[]
                  : photos
                      .asMap()
                      .map((index, item) {
                        return MapEntry(
                          index,
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ShowImageScreen(src: item);
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 0 : 8,
                              ),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Material(
                                  color: kPrimary2,
                                  child: Image.network(
                                    item,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                      .values
                      .toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Catatan: $notes',
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowImageScreen extends StatelessWidget {
  const ShowImageScreen({
    Key? key,
    required this.src,
  }) : super(key: key);

  final String src;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: Scaffold(
        backgroundColor: kPrimary,
        body: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(this.src),
          ),
        ),
      ),
    );
  }
}

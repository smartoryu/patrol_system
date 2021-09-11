import 'package:nusalima_patrol_system/src/views.dart';

class HomeUserHeader extends StatelessWidget {
  const HomeUserHeader({
    Key? key,
    this.onTapAlert,
    this.onTapEditProfile,
    this.photo = "",
    required this.phoneNumber,
    required this.username,
  }) : super(key: key);

  final void Function()? onTapAlert;
  final void Function()? onTapEditProfile;
  final String photo;
  final String phoneNumber;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: Container(
              width: 75,
              height: 75,
              color: kPrimary2,
              child: this.photo == ""
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          Format.nameToInitial(this.username),
                          style: TextStyle(
                            color: kSecondary2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Image.network(this.photo),
            ),
          ),

          //
          SizedBox(width: 16),
          //

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.username,
                  style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  this.phoneNumber,
                  style: TextStyle(color: kWhite),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: this.onTapEditProfile,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: kWhite),
                    ),
                    child: Text(
                      "Edit Profil",
                      style: TextStyle(
                        fontSize: 10,
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //

          if (this.onTapAlert != null)
            Material(
              color: fromRGB("#F4F2F2"),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: this.onTapAlert,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: fromRGB("#F4F2F2"),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        color: kDanger,
                        size: 28,
                      ),
                      Text("ALERT", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

import 'package:nusalima_patrol_system/src/models.dart';
import 'package:nusalima_patrol_system/src/views.dart';
import 'package:provider/provider.dart';

class HomeUserHeader extends StatelessWidget {
  const HomeUserHeader({
    Key? key,
    this.onTapAlert,
    this.onTapEditProfile,
    this.photo = "",
    this.phoneNumber = "",
    this.username = "",
    this.isLoading = false,
  }) : super(key: key);

  final void Function()? onTapAlert;
  final void Function()? onTapEditProfile;
  final String photo;
  final String phoneNumber;
  final String username;
  final bool isLoading;

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
              child: photo == ""
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          isLoading
                              ? "loading..."
                              : Format.nameToInitial(username),
                          style: TextStyle(
                            color: kSecondary2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Image.network(photo),
            ),
          ),

          //
          const SizedBox(width: 16),
          //

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoading ? "loading..." : username,
                  style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  isLoading ? "loading..." : phoneNumber,
                  style: TextStyle(color: kWhite),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onTapEditProfile,
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

          if (onTapAlert != null)
            Material(
              color: fromRGB("#F4F2F2"),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: onTapAlert,
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
                      const Text("ALERT", style: TextStyle(fontSize: 12)),
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

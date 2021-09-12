import 'user_collection.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ''});

  UserCollection get users {
    return UserCollection(uid: uid);
  }
}

import 'location_collection.dart';
import 'shift_collection.dart';
import 'user_collection.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ''});

  UserCollection get users {
    return UserCollection(uid: uid);
  }

  LocationCollection get locations {
    return LocationCollection(uid: uid);
  }

  ShiftCollection get shifts {
    return ShiftCollection(uid: uid);
  }
}

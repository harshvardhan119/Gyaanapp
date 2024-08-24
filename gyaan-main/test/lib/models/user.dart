import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String phoneNumber;
  final String uid;
  final String phoneuid;

  const User(
      {required this.email,
      required this.phoneNumber,
      required this.uid,
      required this.phoneuid});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot["email"],
      phoneNumber: snapshot["phoneNumber"],
      uid: snapshot["uid"],
      phoneuid: snapshot["phoneuid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "phoneNumber": phoneNumber,
        "uid": uid,
        "phoneuid": phoneuid
      };
}

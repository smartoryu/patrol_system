class Officer {
  final String email;
  final String fullName;
  final String officerId;
  final String phoneNumber;
  final String position;
  final String photo;
  final String role;
  final String uid;

  Officer({
    required this.email,
    required this.fullName,
    this.officerId = "",
    required this.phoneNumber,
    required this.position,
    this.photo = "",
    required this.role,
    required this.uid,
  });

  factory Officer.fromJson(Map<String, dynamic> json) {
    return Officer(
      email: json["email"],
      fullName: json['fullName'],
      officerId: json["officerId"] ?? "",
      phoneNumber: json["phoneNumber"],
      position: json["position"],
      photo: json["photo"] ?? "",
      role: json["role"],
      uid: json["uid"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "fullName": fullName,
      "officerId": officerId,
      "phoneNumber": phoneNumber,
      "position": position,
      "photo": photo,
      "role": role,
      "uid": uid,
    };
  }
}

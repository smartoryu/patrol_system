class Officer {
  final String email;
  final String fullName;
  final String phoneNumber;
  final String position;
  final String role;
  final String uid;

  Officer({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.position,
    required this.role,
    required this.uid,
  });

  factory Officer.fromJson(Map<String, dynamic> json) {
    return Officer(
      email: json["email"],
      fullName: json['fullName'],
      phoneNumber: json["phoneNumber"],
      position: json["position"],
      role: json["role"],
      uid: json["uid"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "position": position,
      "role": role,
      "uid": uid,
    };
  }
}

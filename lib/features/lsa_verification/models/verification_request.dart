class VerificationRequest {
  const VerificationRequest({
    required this.profileId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.predecessorId,
    required this.verificationType,
  });

  final String profileId;
  final String fullName;
  final String email;
  final String phone;
  final String? predecessorId;
  final String verificationType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'profile_id': profileId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'predecessor_id': predecessorId,
      'verification_type': verificationType,
    };
  }
}

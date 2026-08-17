class VerificationResponse {
  const VerificationResponse({
    required this.status,
    required this.verificationId,
    required this.predecessorId,
    required this.traceId,
    required this.logicHash,
    required this.message,
  });

  final String status;
  final String verificationId;
  final String predecessorId;
  final String traceId;
  final String logicHash;
  final String message;

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      status: json['status'] as String,
      verificationId: json['verification_id'] as String,
      predecessorId: json['predecessor_id'] as String,
      traceId: json['trace_id'] as String,
      logicHash: json['logic_hash'] as String,
      message: json['message'] as String,
    );
  }
}

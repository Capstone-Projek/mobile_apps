class UploadResponse {
  final String prediction;
  final double confidence;

  UploadResponse({required this.prediction, required this.confidence});

  factory UploadResponse.fromJson(Map<String, dynamic> map) {
    return UploadResponse(
      prediction: map['prediction'],
      confidence: map['confidence'],
    );
  }
}

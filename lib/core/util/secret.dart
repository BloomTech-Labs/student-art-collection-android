class CloudinarySecret {
  final String cloudName;
  final String apiKey;
  final String apiSecret;

  CloudinarySecret({
    this.cloudName = "",
    this.apiKey = "",
    this.apiSecret = "",
  });

  factory CloudinarySecret.fromJson(Map<String, dynamic> jsonMap) {
    return CloudinarySecret(
        cloudName: jsonMap["cloud_name"],
        apiKey: jsonMap["api_key"],
        apiSecret: jsonMap["api_secret"]);
  }
}

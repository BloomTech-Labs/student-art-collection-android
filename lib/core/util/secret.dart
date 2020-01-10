class Secret {
  final String cloudName;
  final String apiKey;
  final String apiSecret;

  Secret({
    this.cloudName = "",
    this.apiKey = "",
    this.apiSecret = "",
  });

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return Secret(
        cloudName: jsonMap["cloud_name"],
        apiKey: jsonMap["api_key"],
        apiSecret: jsonMap["api_secret"]);
  }
}

class IapConfig {
  final String name;
  final String id;
  final String version;
  final int disable;
  final String code;
  final String status;
  final String? url;
  final String? msg;

  const IapConfig({
    required this.name,
    required this.id,
    required this.version,
    required this.disable,
    required this.code,
    required this.status,
    this.url,
    this.msg,
  });

  /// disable=1 → tắt Google Billing, disable=0 → bật mua qua cửa hàng Google
  bool get isBillingDisabled => disable == 1;
  bool get isBillingEnabled => !isBillingDisabled;

  factory IapConfig.fromJson(Map<String, dynamic> json) {
    return IapConfig(
      name: json['name'] as String? ?? '',
      id: json['id'] as String? ?? '',
      version: json['version'] as String? ?? '',
      disable: _parseDisable(json['disable']),
      code: json['code'] as String? ?? '',
      status: json['status'] as String? ?? '',
      url: json['url'] as String?,
      msg: json['msg'] as String?,
    );
  }

  static int _parseDisable(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 1;
    return 1;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'version': version,
        'disable': disable,
        'code': code,
        'status': status,
        'url': url,
        'msg': msg,
      };

  static IapConfig offlineFallback() => const IapConfig(
        name: 'BMI Calculator',
        id: 'com.bmicalculator.bmicalculator',
        version: '1.0.0',
        disable: 1,
        code: 'OFFLINE',
        status: 'OFFLINE',
        msg: 'No network connection',
      );
}

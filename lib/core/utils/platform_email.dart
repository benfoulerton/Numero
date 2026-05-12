/// Helpers for launching platform intents (email, URLs).
library;

import 'package:url_launcher/url_launcher.dart';

class PlatformEmail {
  const PlatformEmail._();

  /// Opens the device's email client with [to] as the recipient. Returns true
  /// on success, false if no mail handler is available.
  static Future<bool> compose({
    required String to,
    String subject = '',
    String body = '',
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      query: _encodeQuery({
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      }),
    );
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }

  static String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}

class PlatformUrl {
  const PlatformUrl._();

  static Future<bool> open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}

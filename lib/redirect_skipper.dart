import 'dart:convert';

import 'package:html_unescape/html_unescape_small.dart';

final HtmlEscape _escape = new HtmlEscape(HtmlEscapeMode.ATTRIBUTE);
final RegExp _googleRedirectUrl =
    new RegExp(r'"(https?://www.google.com/url.+?)"');
final HtmlUnescape _unescape = new HtmlUnescape();

String skipGoogleRedirects(String input) {
  String sanitized = input.replaceAllMapped(_googleRedirectUrl, (match) {
    var url = match.group(1);
    var urlUnescaped = _unescape.convert(url);
    var uri = Uri.parse(urlUnescaped);
    var nakedUrl = uri.queryParameters['q'];
    if (nakedUrl.isEmpty) {
      throw new UnsupportedError('URL $url is not a google redirect url');
    }
    var nakedUrlEscaped = _escape.convert(nakedUrl);
    // Put back into double quotes.
    return '"$nakedUrlEscaped"';
  });
  return sanitized;
}

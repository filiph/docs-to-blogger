import 'package:test/test.dart';

import 'package:docs_to_blogger/redirect_skipper.dart';

void main() {
  test('simple url', () {
    var input =
        r'The <a href="https://www.google.com/url?q=https://en.wikipedia.org/wiki/Fail-fast&amp;sa=D&amp;ust=1486584709019000&amp;usg=AFQjCNHASwSBhmi9FmmLXBBmtaM5UkisRA">fail-fast</a>&nbsp;principle';
    var expectedOutput =
        r'The <a href="https://en.wikipedia.org/wiki/Fail-fast">fail-fast</a>&nbsp;principle';
    expect(skipGoogleRedirects(input), expectedOutput);
  });

  test('url with hash', () {
    var input =
        r'Learn more about this feature in the <a href="https://www.google.com/url?q=https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md%231220&amp;sa=D&amp;ust=1486584709042000&amp;usg=AFQjCNEl4yAFzVsdFx_EQokRj1SsNVJItQ">changelog</a>&nbsp;or in';
    var expectedOutput =
        r'Learn more about this feature in the <a href="https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#1220">changelog</a>&nbsp;or in';
    expect(skipGoogleRedirects(input), expectedOutput);
  });
}

library docs_to_blogger;

import 'html_entities.dart';
import 'package:docs_to_blogger/redirect_skipper.dart';

class DocsToBloggerConverter {
  static final RegExp _header = new RegExp(r"<html.*</head><body.*?>");
  static final RegExp _footer = new RegExp(r"</body></html>");
  static final RegExp _spanBegin = new RegExp(r"<span.*?>");
  static final RegExp _spanEnd = new RegExp(r"</span>");
  static final RegExp _spanClassC =
      new RegExp(r'<span class="(c.+?)">(.+?)</span>', multiLine: true);
  static final RegExp _aname = new RegExp("<a name=\".*?\"></a>");
  static final RegExp _cssClass = new RegExp(' class=".*?"');
  static final RegExp _pBegin = new RegExp(r"<p.*?>");
  static final RegExp _lineEnd = new RegExp(r"(</p>)|(<br/?>)");

  DocsToBloggerConverter() {}

  // TODO: resolve google.com/url?=... links
  String convert(String input,
      {String strongId: "c3", String emId: "c2", bool removePTags: true}) {
//    Stopwatch stopwatch = new Stopwatch()..start();
//    print("${stopwatch.elapsedInMs()}ms - Starting conversion");

    StringBuffer strBuf = new StringBuffer();
    int index = 0;

    // find <span class="c2">...</span> and convert to <strong>...</strong>
    Match m = _spanClassC.firstMatch(input);
    while (m != null) {
      print("index is $index, match found from "
          "${index+m.start} to ${index+m.end}");
      strBuf.write(input.substring(index, index + m.start));

      int groupCount = m.groupCount;
      print("Group Count = $groupCount");
      String classesStr = m.group(1);
      Set<String> classes = new Set<String>.from(classesStr.split(" "));

      if (classes.contains(strongId.trim())) {
        strBuf.write("<strong>");
      }
      if (classes.contains(emId.trim())) {
        strBuf.write("<em>");
      }

      strBuf.write(m.group(groupCount));

      if (classes.contains(emId.trim())) {
        strBuf.write("</em>");
      }
      if (classes.contains(strongId.trim())) {
        strBuf.write("</strong>");
      }

      index = index + m.end;
      m = _spanClassC.firstMatch(input.substring(index));
    }

    // add the rest
    strBuf.write(input.substring(index));

//    print("${stopwatch.elapsedInMs()}ms - Found and replaced c{n} spans");

    String intermediary = strBuf.toString();

//    print("${stopwatch.elapsedInMs()}ms - Converted to intermediary string");

    String outputWithEntities = intermediary
        .replaceAll(_header, "")
        .replaceAll(_footer, "")
        .replaceAll(_spanBegin, "")
        .replaceAll(_spanEnd, "")
        .replaceAll(_aname, "")
        .replaceAll(_cssClass, "")
        .replaceAll("<p></p>", "\n");

//    print("${stopwatch.elapsedInMs()}ms - Replaced header, footer, etc.");

    if (removePTags) {
      outputWithEntities =
          outputWithEntities.replaceAll(_pBegin, "").replaceAll(_lineEnd, "\n");
    } else {
      outputWithEntities = outputWithEntities.replaceAll("</p>", "</p>\n\n");
    }

//    print("${stopwatch.elapsedInMs()}ms - Removed <p> tags.");

    String output =
        HtmlEntities.collapseSafeEntities(outputWithEntities, useAll: false);

    String outputWithoutRedirects = skipGoogleRedirects(output);

//    print("${stopwatch.elapsedInMs()}ms - Collapsed entities.");

    return outputWithoutRedirects;
  }
}

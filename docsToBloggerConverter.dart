#library('docsToBlogger');

#import('html_entities.dart');

class DocsToBloggerConverter {
  static final RegExp _header = const RegExp(@"<html.*</head><body.*?>");
  static final RegExp _footer = const RegExp(@"</body></html>");
  static final RegExp _spanBegin = const RegExp(@"<span.*?>");
  static final RegExp _spanEnd = const RegExp(@"</span>");
  static final RegExp _spanClassC = const RegExp(@'<span class="(c.+?)">(.+?)</span>', multiLine:true);
  static final RegExp _aname = const RegExp("<a name=\".*?\"></a>");
  static final RegExp _cssClass = const RegExp(' class=".*?"');
  static final RegExp _pBegin = const RegExp(@"<p.*?>");
  static final RegExp _lineEnd = const RegExp(@"(</p>)|(<br/?>)");

  DocsToBloggerConverter() {
  }

  String convert(String input, [String strongId="c3", String emId="c2", bool removePTags=true]) {
    StringBuffer strBuf = new StringBuffer();
    int index = 0;

    // find <span class="c2">...</span> and convert to <strong>...</strong>
    Match m = _spanClassC.firstMatch(input);
    while (m != null) {
      print("index is $index, match found from ${index+m.start()} to ${index+m.end()}");
      strBuf.add(input.substring(index,index + m.start()));

      int groupCount = m.groupCount();
      print("Group Count = $groupCount");
      String classesStr = m.group(1);
      Set<String> classes = new Set<String>.from(classesStr.split(" "));

      if (classes.contains(strongId.trim())) {
        strBuf.add("<strong>");
      }
      if (classes.contains(emId.trim())) {
        strBuf.add("<em>");
      }
      
      strBuf.add(m.group(groupCount));
      
      if (classes.contains(emId.trim())) {
        strBuf.add("</em>");
      }
      if (classes.contains(strongId.trim())) {
        strBuf.add("</strong>");
      }

      index = index + m.end();
      m = _spanClassC.firstMatch(input.substring(index));
    }

    // add the rest
    strBuf.add(input.substring(index));

    String intermediary = strBuf.toString();

    String outputWithEntities = intermediary
        .replaceAll(_header, "")
        .replaceAll(_footer, "")
        .replaceAll(_spanBegin, "")
        .replaceAll(_spanEnd, "")
        .replaceAll(_aname, "")
        .replaceAll(_cssClass, "");
        
    if (removePTags) {
      outputWithEntities = outputWithEntities
          .replaceAll(_pBegin, "")
          .replaceAll(_lineEnd, "\n");
    } else {
      outputWithEntities = outputWithEntities.replaceAll("</p>", "</p>\n\n");
    }
    
    String output = HtmlEntities.collapseSafeEntities(outputWithEntities, useAll:false);

    return output;
  }
}

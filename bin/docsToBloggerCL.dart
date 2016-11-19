import 'dart:io';
import 'package:docs_to_blogger/docsToBloggerConverter.dart';

import 'package:args/args.dart';

void main(List<String> args) {
  var parser = new ArgParser();

  parser.addOption("strong", abbr: "s", defaultsTo: "c1");
  parser.addOption("em", abbr: "e", defaultsTo: "c2");
  parser.addFlag("ptags", abbr: "p", defaultsTo: false);

  var results = parser.parse(args);
  if (results.rest.length < 1) {
    print(parser.getUsage());
    return;
  }
  var filename = results.rest[0];

  new File(filename).open().then((RandomAccessFile f) {
    List<int> buffer = new List<int>(f.lengthSync());
    f.readIntoSync(buffer, 0, f.lengthSync());

    String input = new String.fromCharCodes(buffer);

    String convertedText = new DocsToBloggerConverter().convert(input,
        strongId: results["strong"],
        emId: results["em"],
        removePTags: results["ptags"]);

    print(convertedText);
  });
}

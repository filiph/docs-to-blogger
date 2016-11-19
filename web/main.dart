import 'dart:html';

import 'package:docs_to_blogger/docsToBloggerConverter.dart';

void main() {
  DocsToBloggerConverter converter = new DocsToBloggerConverter();

  ButtonElement convertBtn = document.query("#convertBtn");
  TextAreaElement inputTextEl = document.query("#inputText");
  TextAreaElement strongIdEl = document.query("#strongId");
  TextAreaElement emIdEl = document.query("#emId");
  InputElement removePTagsEl = document.query("#removePTags");
  TextAreaElement outputTextEl = document.query("#outputText");
  DivElement outputTextDivEl = document.query("#outputTextDiv");
  
  convertBtn.onClick.listen((e) {
    String convertedText = converter.convert(
            inputTextEl.value,
            strongId:strongIdEl.value,
            emId:emIdEl.value,
            removePTags:(removePTagsEl.checked)
    );
    
    outputTextEl.value = convertedText;
    
    if (removePTagsEl.checked) {
      outputTextDivEl.innerHtml = convertedText.replaceAll("\n", "<br/>");
    } else {
      outputTextDivEl.innerHtml = convertedText;
    }
  });

  inputTextEl.onDrop.listen((MouseEvent e) {
    File inFile = e.dataTransfer.files[0];
    FileReader reader = new FileReader();
    reader.readAsText(inFile.slice());
    reader.onLoadEnd.listen((_) {
      inputTextEl.value = reader.result;
    });
    e.preventDefault();
  });

}

import 'dart:html';

import 'package:docs_to_blogger/docsToBloggerConverter.dart';

class LooseNodeValidator implements NodeValidator {
  LooseNodeValidator();

  @override
  bool allowsAttribute(Element element, String attributeName, String value) =>
      true;

  @override
  bool allowsElement(Element element) => true;
}

void main() {
  DocsToBloggerConverter converter = new DocsToBloggerConverter();

  ButtonElement convertBtn = document.querySelector("#convertBtn");
  TextAreaElement inputTextEl = document.querySelector("#inputText");
  TextAreaElement strongIdEl = document.querySelector("#strongId");
  TextAreaElement emIdEl = document.querySelector("#emId");
  InputElement removePTagsEl = document.querySelector("#removePTags");
  TextAreaElement outputTextEl = document.querySelector("#outputText");
  DivElement outputTextDivEl = document.querySelector("#outputTextDiv");

  convertBtn.onClick.listen((e) {
    String convertedText = converter.convert(inputTextEl.value,
        strongId: strongIdEl.value,
        emId: emIdEl.value,
        removePTags: (removePTagsEl.checked));

    outputTextEl.value = convertedText;

    if (removePTagsEl.checked) {
      outputTextDivEl.setInnerHtml(convertedText.replaceAll("\n", "<br/>"),
          validator: new LooseNodeValidator());
    } else {
      outputTextDivEl.setInnerHtml(convertedText,
          validator: new LooseNodeValidator());
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

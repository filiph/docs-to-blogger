#import('dart:html');

#import('docsToBloggerConverter.dart');

void main() {
  DocsToBloggerConverter converter = new DocsToBloggerConverter();

  ButtonElement convertBtn = document.query("#convertBtn");
  TextAreaElement inputTextEl = document.query("#inputText");
  TextAreaElement strongIdEl = document.query("#strongId");
  TextAreaElement emIdEl = document.query("#emId");
  InputElement removePTagsEl = document.query("#removePTags");
  TextAreaElement outputTextEl = document.query("#outputText");
  DivElement outputTextDivEl = document.query("#outputTextDiv");
  
  convertBtn.on.click.add((e) {
    outputTextEl.value = outputTextDivEl.innerHTML
        = converter.convert(
            inputTextEl.value,
            strongId:strongIdEl.value,
            emId:emIdEl.value,
            removePTags:(removePTagsEl.checked)
    );
  });

}

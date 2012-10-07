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
    String convertedText = converter.convert(
            inputTextEl.value,
            strongId:strongIdEl.value,
            emId:emIdEl.value,
            removePTags:(removePTagsEl.checked)
    );
    
    outputTextEl.value = convertedText;
    
    if (removePTagsEl.checked) {
      outputTextDivEl.innerHTML = convertedText.replaceAll("\n", "<br/>");
    } else {
      outputTextDivEl.innerHTML = convertedText;
    }
  });
  
  inputTextEl.on.drop.add((MouseEvent e) {
    File inFile = e.dataTransfer.files[0];
    FileReader reader = new FileReader();
    reader.readAsText(inFile.slice());
    reader.on.loadEnd.add((_) {
      inputTextEl.value = reader.result;
    });
    e.preventDefault();
  });

}

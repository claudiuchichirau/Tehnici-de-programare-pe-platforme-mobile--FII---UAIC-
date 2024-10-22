void main() {
  var phrase = "I have 2    cars. bb";
  var s = phrase.split(" ,;");
  for (int i = 0; i < s.length; i++) {
    print(s[i]);
  }
}
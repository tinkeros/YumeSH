U8 *border(I64 length){
  U8 *heap=StrNew(""),*tmp;
  I64 i;
  for (i = 0; i < length + 2; i++){
    tmp=MStrPrint("%s%c",heap,'-');
    Free(heap);
    heap=tmp;
  }
  return heap;
}
U0 CowSay(U8 *string = "This is CowSay running on TempleOS!"){
  I64 inputLength = StrLen(string);
  " %s \n", border(inputLength);
  "< %s >\n", string;
  " %s \n", border(inputLength);
  "        \\   ^__^\n";
  "         \\  (oo)\\_______\n";
  "            (__)\\       )\\/\\\n";
  "                ||----w |\n";
  "                ||     ||\n";

}

U0 GodSay(U8 *string = NULL){
    if (!string){
        I64 number = 6;
        I64 i;
        for (i=0; i<number; i++) {
            string = MStrPrint("%s%s ", string, god.words[GodBits(17)%god.num_words]);
        }
    }
    I64 inputLength = StrLen(string);

  "    __      %s\n", border(inputLength);
  " __----__  < %s >\n", string;
  "{   p p  }  %s\n", border(inputLength);
  "{____||__}__\n";
  "  /  || \\/ / \n";
  " / /  - |_/ \n";
  " \\_\\    | \n";
  "  |= = =| \n";
  "  '-----' \n";
  "  |_) |_)\n";
}
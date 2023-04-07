/*
Credits to:
 -> TheTinkerer: For literally loads.
 -> Sree Kotay: for his suggestion on Reddit to improve wordCount.
 -> Nrootconauto: for teaching me how arrays work prior to this.

This is basically a library for this shell that I feel like could be applied to other projects.
Attributions will be made for certain function.
*/


I64 wordCount(U8 *string){
    // Returning word count of a string.
    U8 *stringEnd = string + StrLen(string);
    I64 numOfWords= 0;
    while (string < stringEnd && *string == ' ') string++;
    while (string < stringEnd) {
        while (string < stringEnd && *string != ' ') string++;
        while (string < stringEnd && *string == ' ') string++;
        numOfWords++;
    }
    return numOfWords;
}

/* 
TheTinker StrSplit
License: Public Domain

This method only MAllocs one chuck of memory
which holds both the array of pointers to the
individual words that got split and also all
the words themselves at the same time.

Since there is only 1 MAlloc, you only have
to do one Free (just free what StrSplit returns).
*/
U8 **StrSplit(U8* String, I64 *_word_cnt){
  
  I64 len,arr_end,word_index;
  U8 *str,**str_arr,*stringEnd;

  arr_end=*_word_cnt=wordCount(String);
  len=StrLen(String);

  // Points to end of the array of pointers
  arr_end*=sizeof(U8*);

  str_arr = MAlloc(arr_end + len + 1);

  // The strings are stored here, just after the array
  str = str_arr(U8*)+arr_end;
  stringEnd=str+len;  

  // Copy in the original string
  MemCpy(str,String,len+1);
  
  word_index=0;

  while (str < stringEnd && *str == ' ') str++;
  while (str < stringEnd) {
    str_arr[word_index++]=str; // Store word start pointer
    while (str < stringEnd && *str != ' ') str++;
    *str++=0;  // Split the string when we find the end
    while (str < stringEnd && *str == ' ') str++;
  }

  return str_arr;

}

Bool StartsWith(U8 *str, U8 *check){
  return !StrNCmp(str,check,StrLen(check));
}

U8 **SpliceAfter(U8 **str_arr, I64 cnt, I64 index){
  // Splices an array into a new array after certain index.
  I64 i;
  I64 newCnt = cnt - index;
  U8 **new_arr = MAlloc(newCnt * sizeof(U8*));
  for (i = 0; i < newCnt; i++) {
    new_arr[i] = str_arr[i + index];
  }
  return new_arr;
}

U8 *DirSub(U8 *string){
    U8 *ret = StrNew("");
    U8 *SplitStr = CAlloc(StrLen(string)+1); 

     // &string[2] is a string that ignores the drive letter: part
     if(StartsWith(&string[2], "/Home")) {
        StrScan(&string[2],"/Home%s",&SplitStr);
        ret = MStrPrint("~%s", SplitStr);
     }
     else if(StartsWith(&string[2], "/")){
        StrScan(string,"T:/%s",&SplitStr);
        ret = MStrPrint("/%s", SplitStr);
     } else{ret = string;}
    Free(SplitStr);
    return ret;
}

U8 *RevDirSub(U8 *string){
    U8 *ret = StrNew("");
    U8 *SplitStr = CAlloc(StrLen(string)+1); 
    if(StartsWith(string, "~")) {
        StrScan(string,"~%s",&SplitStr);
        ret = MStrPrint("/Home%s", SplitStr);
    } 
    else{ret = StrNew(string);}

    Free(SplitStr);
    return ret;
}

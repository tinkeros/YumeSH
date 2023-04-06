#include "./libs/BokettoLib.HH"
#define MY_HASH_TABLE_SIZE 256

// -- HashTables
class CMyClass:CHash {
  U0 (*f)(U8 **, I64);
};

CHashTable *my_hash_table=HashTableNew(MY_HASH_TABLE_SIZE);

U0 Register(CMyClass *h,U8 *str, I64 type,U0 (*f)()){
    h->str=StrNew(str);
    h->type=type;
    h->f=f;
    HashAdd(h,my_hash_table);

}

// Just a wrapper for CD to change outputs.
U0 CMDCd(U8 **params, I64 cnt){
  if (cnt>1){
    U8 *path = RevDirSub(params[0]);
    // FileFind doesn't work if the directory is just *:/ 
    // so it must be a full path, so we just skip it and go through.
    if (!StrCmp(path, "/") || !StrCmp(path, "/Home")){
       Cd(path);
    } else{
      if (FileFind(path)){ // Directories are still counted as files
        if (IsDir(path)){ // Makes sure they are actually directories though.
          Cd(path);
        } else{
          "$FG,8$ '%s' is a file, not a directory.\n$FD$", path;
        }
      } else{
        "$FG,8$'%s' is not a directory or file\n$FD$", path;
      }
    }
  Free(path); 
  } 
}

U0 Pwd(){
  "%s\n", DirCur;
}

// PutDirLink renamed to PutLsLink so it does "Ls" instead of "Dir"
U0 PutLsLink(U8 *dirname,U8 *full_name=NULL){
  U8 *st;
  if (!dirname) return;
  if (__IsCmdLine)
    "%s",dirname;
  else {
    if (!full_name)
      full_name=st=DirNameAbs(dirname);
    else
      st=NULL;
    "$$MA,T=\"%s\",LM=\"cd %s\nls\n\"$$",dirname,full_name;
    Free(st);
  }
}

// Copied from Dir. Refactored & Improved.  
U0 Ls(U8 **params, I64 cnt){
  CDirEntry *tmpde1=NULL,*tmpde2;
  U8 *st, *directory="";
  Bool changed = FALSE;
  I64 csize=0xFFFF,c=0xFFFF;
  if (cnt>1){
    directory = params[0];
    changed = TRUE;
  } 

  tmpde1=FilesFind(directory);


  if (!(st=DirCur)) PrintErr("Invalid Drive\n");

  else {
    
    if (tmpde1) {
      Free(st);
      st=MAllocIdent(tmpde1->full_name);
      StrLastRem(st,"/");
      if (!st[2]) StrCpy(st+2,"/");

      tmpde2=tmpde1;
      while (tmpde2) {
	      if (tmpde2->size>csize) csize=tmpde2->size;
	      if (tmpde2->clus>c) c=tmpde2->clus;
	      
        tmpde2=tmpde2->next;
      }
      csize=Bsr(csize)/4+1;
      c=Bsr(c)/4+1;

      while (tmpde1) {
	      tmpde2=tmpde1->next;
	      if (tmpde1->attr & RS_ATTR_DIR){
          if (!StartsWith(tmpde1->name, ".")){
            PutLsLink(tmpde1->name,tmpde1->full_name);
            '\n';
          }
        } 
	      else{
          PutFileLink(tmpde1->name,tmpde1->full_name);
          '\n';
        } 
        
	      
	      
        DirEntryDel(tmpde1);
	      tmpde1=tmpde2;
      }
    } else
      "No matching entries\n";
    Free(st);
  }
  if (changed) Free(directory);
}

CMyClass cd, pwd, ls;
Register(&cd, "cd",HTT_FUN,&CMDCd);
Register(&pwd, "pwd",HTT_FUN,&Pwd);
Register(&ls, "ls",HTT_FUN,&Ls);

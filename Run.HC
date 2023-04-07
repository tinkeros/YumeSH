#include "./libs/BokettoLib.HH";
#include "./Commands.HC"
#define TILDE_BM 0x70F99F0E0000
#define TILDE_CHARCODE 0x7E
#define SIGMA "\xE4"

// Replacing the current tilde icon (~). 
U0 PatchFont() {
  text.font[TILDE_CHARCODE] = TILDE_BM;
}

// This function is executed on the first start of the shell.
U0 YOnce(){
    U8 *file = "/Home/.YumeSHRC.HC";
    // Check if a user already has YumeSHRC & Run it.
    if (FileFind(file)){
        ExeFile2(file);
    }
    else {
        U8 *localfile = "Apps/.YumeSHRC.HC";
        // Otherwise move the example over.
        if (FileFind(localfile)){
            Move(localfile, file);
            ExeFile2(file);
        } else{
            // If example doesn't exist, just create a blank file.
            CDirEntry de;
            FileWrite(file,NULL,0,de.datetime,0);
            ExeFile2(file);
        }

    }
}

U8 *Prompt(){
    static U8 buf[200];
    U8 *prompt = DirSub(DirCur);
    StrPrint(buf, "$FG,8$%s $FG,2$"SIGMA" $FD$", prompt);
    Free(prompt);
    return buf; 
} 

U0 YumeSH(){
    I64 count = 0, word_cnt, i;
    U8 *input, **str_arr;
    
    PatchFont;

    while (1){
        if (count == 0) YOnce;
        
        "%s", Prompt;
        input = GetStr();
        count++;
        str_arr=StrSplit(input,&word_cnt);
        
        while (i < CMDS_LEN) {
            str_arr=StrSplit(input,&word_cnt);
            command* cmd = &cmds[i];

            if (!StrCmp(str_arr[0], cmd->name)) {
                I64 ret = cmd->func(str_arr, word_cnt);

                switch (ret) {
                case -1:
                    Free(input);
                    Free(str_arr);
                    return;
                default:
                    break;
                }
            } else{
                
            }

            i++;
        }
    }

}

YumeSH;
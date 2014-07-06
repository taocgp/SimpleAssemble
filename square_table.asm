.386
        DATA  SEGMENT   USE16
        MENT  DB        '请输入0-19的数字：$'
        ERRO  DB        0AH,0DH,'输入错误！'
        CRLF  DB        0AH,0DH,'其平方值为：$'
      RESULT  DW        0,1,4,9,16,25,36,49,64,81,100,121,144,169,196,225,256,289,324,361
           X  DB        ?
           Y  DB        ?
          XX  DW        ?
        DATA  ENDS

        CODE  SEGMENT   USE16
              ASSUME    CS:CODE,DS:DATA
      START:  MOV       AX,DATA
              MOV       DS,AX
     NOTICE:  MOV       DX,OFFSET  MENT   ;提示信息
              MOV       AH,9
              INT       21H
              
      INPUT:  MOV       AH,1              ;输入数字
              INT       21H
              CMP       AL,20H
              JE        EXIST
              CMP       AL,0DH
              JE        ERR
              CMP       AL,'0'
              JB        ERR
              CMP       AL,'9'
              JA        ERR
              SUB       AL,30H
              MOV       X,AL
              MOV       AH,1              ;输入数字
              INT       21H
              CMP       AL,20H
              JE        EXIST
              CMP       AL,0DH
              JE        CAL
              CMP       AL,'0'
              JB        ERR
              CMP       AL,'9'
              JA        ERR
              SUB       AL,30H
              CMP       X,1
              JNE       ERR
              MOV       X,AL
              MOV       AL,10
              ADD       X,AL
              
        CAL:  XOR       EBX,EBX          ;查表获得平方
              MOV       BL,X
              MOV       AX,RESULT[2*EBX]
              MOV       XX,AX
             
      PRINT:  LEA       DX,CRLF         ;显示结果
              MOV       AH,9
              INT       21H
              
              MOV       AX,XX
              MOV       DL,100
              DIV       DL
              ADD       AL,30H
              MOV       DL,AL
              MOV       AH,2
              INT       21H
              
              MOV       AX,XX
              MOV       DL,100
              DIV       DL
              MOV       CL,AH
              MOV       AL,CL
              MOV       AH,0
              MOV       DL,10
              DIV       DL
              MOV       CL,AH
              
              ADD       AL,30H
              MOV       DL,AL
              MOV       AH,2
              INT       21H
              
              ADD       CL,30H
              MOV       DL,CL
              MOV       AH,2
              INT       21H
              
              MOV       DL,0AH
              MOV       AH,2
              INT       21H
              MOV       DL,0DH
              MOV       AH,2
              INT       21H
              JMP       NOTICE
              
        ERR:  MOV       DX,OFFSET  ERRO   ;提示错误
              MOV       AH,9
              INT       21H
              JMP       NOTICE
              
              
      
      EXIST:  MOV       AX,4C00H         ;退出程序
              INT       21H
        CODE  ENDS
              END       START
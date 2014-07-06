.386
DATA   SEGMENT   USE16
ARR1   DB        11,5,20,13,32
ARR2   DB        7,0,64,23,35
CRLF   DB        'H',0AH,0DH,'$'
DATA   ENDS
CODE   SEGMENT   USE16
       ASSUME    DS:DATA,SS:STACK,CS:CODE
START: MOV       AX,DATA
       MOV       DS,AX
       
       MOV       CX,4
       MOV       DI,OFFSET  ARR1
       CALL      MAX
       CALL      PRINT
       
       MOV       CX,4
       MOV       DI,OFFSET  ARR2
       CALL      MAX
       CALL      PRINT
       
EXIST: MOV       AH,4CH
       INT       21H
       
MAX    PROC                                    ;子程序 获得最大值
       MOV       AL,[DI]
COM:   INC       DI
       CMP       AL,[DI]
       JA        CON
       MOV       AL,[DI]
CON:   DEC       CX
       JNZ       COM
       RET
MAX    ENDP
       
PRINT  PROC                                   ;子程序 十六进制输出
       MOV       AH,0
       MOV       BH,16
       IDIV      BH
       MOV       BL,AH
       MOV       CL,AL
       CALL      CHANGE
       MOV       CL,BL
       CALL      CHANGE
       LEA       DX,CRLF                     ;输出H并换行
       MOV       AH,9
       INT       21H
PRINT  ENDP
CHANGE PROC                                  ;将每一位变为十六进制字符
       CMP       CL,10
       JB        NUM
       ADD       CL,7H
NUM:   ADD       CL,30H
       MOV       DL,CL
       MOV       AH,2
       INT       21H
CHANGE ENDP
 
CODE   ENDS
       END       START
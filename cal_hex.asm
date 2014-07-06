.386
        DATA  SEGMENT   USE16
       PRINT  DB        ?
        MENT  DB        '(116*96-18)/2 = ：$'
        CRLF  DB        0AH,0DH,'$'
        SYMB  DB        '(H)$'
        DATA  ENDS

        CODE  SEGMENT   USE16
              ASSUME    CS:CODE,DS:DATA
      
      START:  MOV       AX,DATA
              MOV       DS,AX
      
              MOV       AX,116      ;计算
              MOV       BX,96
              MUL       BX
              SUB       AX,18
              MOV       BX,2
              DIV       BX
              MOV       BX,AX
      
              LEA       DX,MENT     ;提示信息
              MOV       AH,9
              INT       21H
              LEA       DX,CRLF
              MOV       AH,9
              INT       21H
              
              MOV       CH,BH       ;显示第一位
              SHR       CH,4
              ADD       CH,30H
              MOV       DL,CH
              MOV       AH,2
              INT       21H
              
              AND       BH,0FH      ;显示第二位
              ADD       BH,30H
              MOV       DL,BH
              MOV       AH,2
              INT       21H
      
              MOV       CL,BL       ;显示第三位
              SHR       CL,4
              ADD       CL,37H
              MOV       DL,CL
              MOV       AH,2
              INT       21H
      
              AND       BL,0FH      ;显示第四位
              ADD       BL,30H
              MOV       DL,BL
              MOV       AH,2
              INT       21H

              LEA       DX,SYMB     ;十六进制提示符
              MOV       AH,9
              INT       21H
              LEA       DX,CRLF
              MOV       AH,9
              INT       21H

              MOV       AX,4C00H    ;退出程序
              INT       21H
        CODE  ENDS
              END       START
.386
        DATA  SEGMENT   USE16
       PRINT  DB        ?
        MENT  DB        '(116*96-18)/2 = ��$'
        CRLF  DB        0AH,0DH,'$'
        SYMB  DB        '(H)$'
        DATA  ENDS

        CODE  SEGMENT   USE16
              ASSUME    CS:CODE,DS:DATA
      
      START:  MOV       AX,DATA
              MOV       DS,AX
      
              MOV       AX,116      ;����
              MOV       BX,96
              MUL       BX
              SUB       AX,18
              MOV       BX,2
              DIV       BX
              MOV       BX,AX
      
              LEA       DX,MENT     ;��ʾ��Ϣ
              MOV       AH,9
              INT       21H
              LEA       DX,CRLF
              MOV       AH,9
              INT       21H
              
              MOV       CH,BH       ;��ʾ��һλ
              SHR       CH,4
              ADD       CH,30H
              MOV       DL,CH
              MOV       AH,2
              INT       21H
              
              AND       BH,0FH      ;��ʾ�ڶ�λ
              ADD       BH,30H
              MOV       DL,BH
              MOV       AH,2
              INT       21H
      
              MOV       CL,BL       ;��ʾ����λ
              SHR       CL,4
              ADD       CL,37H
              MOV       DL,CL
              MOV       AH,2
              INT       21H
      
              AND       BL,0FH      ;��ʾ����λ
              ADD       BL,30H
              MOV       DL,BL
              MOV       AH,2
              INT       21H

              LEA       DX,SYMB     ;ʮ��������ʾ��
              MOV       AH,9
              INT       21H
              LEA       DX,CRLF
              MOV       AH,9
              INT       21H

              MOV       AX,4C00H    ;�˳�����
              INT       21H
        CODE  ENDS
              END       START
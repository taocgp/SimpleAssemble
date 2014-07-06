.386                                                               ;(116*96-18)/2
DATA  SEGMENT     USE16
SHOW  DB         '(116*96-18)/2 = £º$'
RES   DW          0
PRINT DB          0,'$'
CRLF  DB          0AH,0DH,'$'
JINZHI  DB         '(H)$'
DATA  ENDS

STACK SEGMENT     USE16 STACK
      DB          200  DUP(0)
STACK ENDS
CODE  SEGMENT     USE16
      ASSUME      CS:CODE,DS:DATA,SS:STACK
      
START:MOV         AX,DATA
      MOV         DS,AX
      
      MOV         AX,116
      MOV         BX,96
      MUL         BX
      SUB         AX,18
      MOV         BX,2
      DIV         BX
      MOV         BX,AX
      
      LEA         DX,SHOW
      MOV         AH,9
      INT         21H
      LEA         DX,CRLF
      MOV         AH,9
      INT         21H
      MOV         CH,BH
      SHR         CH,4
      MOV         PRINT,CH
      ADD         PRINT,30H
      LEA         DX,PRINT
      MOV         AH,9
      INT         21H
      MOV         PRINT,BH
      AND         PRINT,0FH
      ADD         PRINT,30H
      LEA         DX,PRINT
      MOV         AH,9
      INT         21H
      
      MOV         CL,BL
      SHR         CL,4
      MOV         PRINT,CL
      ADD         PRINT,37H
      LEA         DX,PRINT
      MOV         AH,9
      INT         21H
      
      MOV         PRINT,BL
      AND         PRINT,0FH
      ADD         PRINT,30H
      LEA         DX,PRINT
      MOV         AH,9
      INT         21H

      LEA         DX,JINZHI
      MOV         AH,9
      INT         21H
      LEA         DX,CRLF
      MOV         AH,9
      INT         21H
      
      MOV         AH,4CH
      INT         21H
CODE  ENDS
      END         START
.386
DATA SEGMENT USE16
INPUT DB '请输入字符,使第4-7个是数字：$'
SHOWR DB '字符中的数字之和为:$'
SHIWEI DB 0
GEWEI DB 0
SUM   DB 0
BUF   DB 50
      DB 0
      DB 50 DUP(0)
CRFL  DB 0AH,0DH,'$'
DATA ENDS
STACK SEGMENT USE16 STACK
      DB 200 DUP(0)
STACK ENDS
CODE  SEGMENT USE16
      ASSUME DS:DATA,SS:STACK,CS:CODE
START:  MOV AX,DATA
        MOV DS,AX
        LEA DX,INPUT
        MOV AH,9
        INT 21H
        LEA DX,CRFL
        MOV AH,9
        INT 21H
        LEA DX,BUF
        MOV AH,10
        INT 21H
        LEA DX,CRFL
        MOV AH,9
        INT 21H
        MOV CX,3
        MOV AH,BYTE PTR BUF+4
CAL:    INC AH
        ADD SUM,AH
        SUB SUM,30H
        DEC CX
        JNE CAL
        SUB SUM,30H
        MOV AL,SUM
        MOV AH,0
        MOV CL,10
        DIV CL
        MOV SHIWEI,AL
        MOV GEWEI,AH
        ADD SHIWEI,30H
        ADD GEWEI,30H
        MOV BYTE PTR SHIWEI+1,'$'
        MOV BYTE PTR GEWEI+1,'$'

        LEA DX,SHOWR
        MOV AH,9
        INT 21H
        LEA DX,SHIWEI
        MOV AH,9
        INT 21H
        LEA DX,GEWEI
        MOV AH,9
        INT 21H

        MOV AH,4CH
        INT 21H
CODE ENDS
      END START
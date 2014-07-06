;������ʵ��4*4���ھ���˷�
;ÿ���������ŵ�����һ����һ�����������ܲ��ܼ��㣬���Ƶ�����2 
;�ӵڶ�������ʼ��ÿ�������������һ�˾����������������s, ������ �� ����2����ʾ����
;�����û�ÿ��������һ������ǰ�ܿ���ǰ��Ľ����������ע��Ҫ����ľ���ĸ�ʽ 

      STACKS  SEGMENT   STACK
              DW        128 DUP(?)
      STACKS  ENDS

      
        DATA  SEGMENT
        HEAD  DB        '        Matrix Multiplying (within 4 Matrixes)',0AH,0DH,'SpaceKey:between numbers  EnterKey:between lines(onemore for another matrix) ',0AH,0DH,'[keyboard shortcuts]r:restart o:over =:result$'
    REMINDI1  DB        'Please input Matrix $'
    REMINDI2  DB        ' (within 4*4,and each number < 20):$'
     REMINDS  DB        'the result is:$'
        ERRO  DB        'Input Erro! Restarting...$'
    TOOLARGE  DB        'The number is too large.Restarting...$'
    NOTEQUAL  DB        'erro:The input row != current column,multiplying can not be done.Restarting...$'
        
     
     NMATRIX  DB        0           ;�������
     
     MATRIX1  DB        16 DUP(0)   ;����1����������
    NCOLUMN1  DB        0
       NROW1  DB        0
       
     MATRIX2  DB        16 DUP(0)   ;����2����������
    NCOLUMN2  DB        0
       NROW2  DB        0
       
     MATRIXS  DB        16 DUP(0)   ;����s����������
    NCOLUMNS  DB        0
       NROWS  DB        0
        DATA  ENDS

      
        CODE  SEGMENT
              ASSUME    CS:CODE,DS:DATA,SS:STACKS
              
      START:  MOV       AX,DATA     ;��ʼ����
              MOV       DS,AX
              
              CALL      CRLFP
              MOV       AH,9
              LEA       DX,HEAD
              INT       21H
              CALL      CRLFP
              MOV       NMATRIX,0   ;���������0
              
    REINPUT:  CALL      REMPRINT
              
              MOV       NCOLUMN1,0
              MOV       NROW1,0
              MOV       CL,0        ;��ջ�����ָ���
              MOV       BL,0        ;��ǰ��������
      
      INPUT:  MOV       AH,1        ;�����ж�
              INT       21H
              CMP       AL,'r'
              JE        START
              CMP       AL,'o'
              JE        ENDUP
              CMP       AL,'='
              JNE       INPUT1
              CALL      MATMUL
              CALL      RESPRINT
              JMP       START
     INPUT1:  CMP       AL,' '      ;�ո��
              JNE       INPUT2
              CMP       CL,0
              JE        ERRO1       ;��ջ�����ִ���
              CALL      SETNUM      ;��ջ�����ִ���
              JMP       INPUT
     INPUT2:  CMP       AL,0DH      ;�س���
              JNE       INPUT3
              CALL      CRLFP
              CMP       CL,0
              JE        ARRANGE
              CALL      SETNUM      ;����ջ��������
    ARRANGE:  CMP       BL,0
              JNE       ARRANGE1
              CMP       NMATRIX,0   ;��������ֵ����
              JE        NONEMATRIX  ;�������Ϊ0
              CALL      MATMUL      ;���㲢��ӡ
              CALL      RESPRINT
              INC       NMATRIX     ;������� ��1
              JMP       REINPUT     ;������һ������
 NONEMATRIX:  CMP       NCOLUMN1,0
              JE        ERRO1       ;δ������󱨴�
              CALL      MATRIX1TO2  ; ����1���͵�����2
              INC       NMATRIX     ; ������1
              JMP       REINPUT     ;������һ������
                                     
   ARRANGE1:  CMP       NROW1,0     ; ��������ֵ����
              JNE       ROWEXIST
              MOV       NCOLUMN1,BL ;����Ϊ0,ȷ������
              JMP       ARRANGE2
   ROWEXIST:  CMP       BL,NCOLUMN1 ;��ǰ�������Ƿ������������
              JNE       ERRO1       ;���ȱ���
   ARRANGE2:  INC       NROW1       ;������1
              MOV       BL,0
              JMP       INPUT
     INPUT3:  CMP       AL,'0'
              JB        ERRO1
              CMP       AL,'9'
              JA        ERRO1
              SUB       AL,30H      ;�������ִ���
              MOV       AH,0
              PUSH      AX
              INC       CL
              JMP       INPUT
                
      ENDUP:  MOV       AX,4C00H    ;�˳�����
              INT       21H
                      
      ERRO1:  LEA       DX,ERRO     ;�����������
              CALL      ERRONOTICE
      TLERR:  LEA       DX,TOOLARGE ;���ֹ�������
              CALL      ERRONOTICE
     NOTFIT:  LEA       DX,NOTEQUAL ;�С����������޷�����
              CALL      ERRONOTICE
              
              ;�ӳ��� 
              

      SETNUM  PROC                  ;����ջ��������������
              POP       SI
              POP       AX
              CMP       CL,1
              JE        COUNT
              CMP       CL,2        ;������λ������
              JNE       TLERR
              POP       DX
              CMP       DL,0
              JE        COUNT
              CMP       DL,1
              JA        TLERR
              ADD       AL,10
              
      COUNT:
              MOV       DL,AL
              MOV       AL,NCOLUMN1
              MOV       AH,NROW1
              MUL       AH
              MOV       DI,AX
              MOV       BH,0
              ADD       DI,BX
              MOV       MATRIX1[DI],DL          ;����ջ���������� ����1
              INC       BL          ;��ǰ�����ָ�����1
              MOV       CL,0
              PUSH      SI
              RET
      SETNUM  ENDP
      
    REMPRINT  PROC                  ;����ǰ������
              MOV       AH,9
              LEA       DX,REMINDI1
              INT       21H
              MOV       DL,NMATRIX  ;��������
              INC       DL
              ADD       DL,30H
              MOV       AH,2
              INT       21H
              LEA       DX,REMINDI2
              MOV       AH,9
              INT       21H
              CALL      CRLFP
              RET
    REMPRINT  ENDP
       
      MATMUL  PROC                  ;������� MS = M1*M2
              PUSH      BX
              MOV       AL,NCOLUMN2
              CMP       AL,NROW1
              JNE       NOTFIT
              MOV       AL,NCOLUMN1
              MOV       NCOLUMNS,AL
              MOV       AL,NROW2
              MOV       NROWS,AL

              MOV       SI,0        ;M2ĳ���׸������±�
         C3:  MOV       BX,0        ;M1����
         C2:  MOV       BP,0        ;M2����
              MOV       DI,0        ;M1ĳ���׸������±�
         C1:  MOV       AL,MATRIX1[BX][DI]
              MOV       AH,MATRIX2[BP][SI]
              MUL       AH
              ADD       MATRIXS[BX][SI], AL
             
              MOV       AL,NCOLUMN1
              MOV       AH,0
              ADD       DI,AX       ;ÿ�μ��� M1����
              MOV       AL,NCOLUMN2
              MOV       AH,0
              INC       BP
              CMP       BP,AX       ;��M1�����Ƚ�
              JB        C1

              INC       BX
              CMP       BL,NCOLUMNS
              JB        C2

              MOV       AL,NCOLUMN2
              MOV       AH,0
              ADD       SI,AX       ;ÿ�μ��� M1����
              MOV       AH,NROW2
              MUL       AH
              CMP       SI,AX       ;��M1�ܸ����Ƚ�
              JB        C3
              CALL      MATRIXSTO2  ;����s->����2
              POP       BX
              RET
      MATMUL  ENDP

    RESPRINT  PROC                  ;��ӡ����MS
              PUSH      BX
              PUSH      CX
              
              CALL      CRLFP
              CALL      CRLFP
              LEA       DX,REMINDS
              MOV       AH,9
              INT       21H
              CALL      CRLFP
              CALL      CRLFP
                        
              MOV       SI,0
       OUTC:  MOV       BX,0        ;�ⲿѭ��  �������
        CAL:  MOV       AL,MATRIXS[BX][SI]      ;�ڲ�ѭ�� ������ֵ���
              PUSH      BX
              MOV       CX,0
              CMP       AL,0
              JNZ       CHANGE
              MOV       AH,2        ;�����ֵΪ0��ֱ�����
              MOV       DL,'0'
              INT       21H
              JMP       SHOW1
     CHANGE:  MOV       AH,0
              MOV       DL,0
              MOV       BL,10
              DIV       BL          ;���� 10
              MOV       DL,AH
              ADD       DL,30H
              MOV       DH,0
              CMP       AX,0        ;��Ϊ0��ʼ���
              JE        SHOW
              PUSH      DX          ;��Ϊ0��������ջ��������
              INC       CX          ;��¼λ��
              JMP       CHANGE
       SHOW:  POP       DX
              MOV       AH,2
              INT       21H
              DEC       CX
              JNZ       SHOW
              
      SHOW1:  MOV       DL,20H
              MOV       AH,2
              INT       21H

              POP       BX
              INC       BX
              CMP       BL,NCOLUMNS
              JB        CAL
              CALL      CRLFP
              
              MOV       AL,NCOLUMNS
              MOV       AH,0
              ADD       SI,AX
              MOV       AH,NROWS
              MUL       AH
              CMP       SI,AX
              JB        OUTC
              CALL      CRLFP
              POP       CX
              POP       BX
              RET
    RESPRINT  ENDP
  ERRONOTICE  PROC
              CALL      CRLFP
              MOV       AH,9
              INT       21H
              CALL      CRLFP
              JMP       START
              RET
  ERRONOTICE  ENDP

       CRLFP  PROC                  ;����س�
              PUSH      DX
              MOV       AH,2
              MOV       DL,0AH
              INT       21H
              MOV       DL,0DH
              INT       21H
              POP       DX
              RET
       CRLFP  ENDP

      SHUCHU  PROC                  ;����
              ADD       DL,30H
              MOV       AH,2
              INT       21H
              RET
      SHUCHU  ENDP

  MATRIX1TO2  PROC                  ;����1���Ƶ�����2
              MOV       AL,NROW1
              MOV       NROW2,AL
              MOV       AH,NCOLUMN1
              MOV       NCOLUMN2,AH
              MUL       AH
              MOV       AH,0
              MOV       SI,0
       MULT:  MOV       BH,MATRIX1[SI]
              MOV       MATRIX2[SI],BH
              INC       SI
              CMP       SI,AX
              JNA       MULT
              RET
  MATRIX1TO2  ENDP

  MATRIXSTO2  PROC                  ;����1���Ƶ�����2
              MOV       AL,NROWS
              MOV       NROW2,AL
              MOV       AH,NCOLUMNS
              MOV       NCOLUMN2,AH
              MUL       AH
              MOV       AH,0
              MOV       SI,0
      MULT1:  MOV       BH,MATRIXS[SI]
              MOV       MATRIX2[SI],BH
              INC       SI
              CMP       SI,AX
              JNA       MULT1
              RET
  MATRIXSTO2  ENDP
                     
      
        CODE  ENDS
              END       START

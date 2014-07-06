;本程序实现4*4以内矩阵乘法
;每次输入矩阵放到矩阵一，第一个矩阵输完能不能计算，复制到矩阵2 
;从第二个矩阵开始，每次输入结束矩阵一乘矩阵二，结果放入矩阵s, 并复制 到 矩阵2且显示出来
;这样用户每次输入下一个矩阵前能看到前面的结果，方便其注意要输入的矩阵的格式 

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
        
     
     NMATRIX  DB        0           ;矩阵个数
     
     MATRIX1  DB        16 DUP(0)   ;矩阵1及其行列数
    NCOLUMN1  DB        0
       NROW1  DB        0
       
     MATRIX2  DB        16 DUP(0)   ;矩阵2及其行列数
    NCOLUMN2  DB        0
       NROW2  DB        0
       
     MATRIXS  DB        16 DUP(0)   ;矩阵s及其行列数
    NCOLUMNS  DB        0
       NROWS  DB        0
        DATA  ENDS

      
        CODE  SEGMENT
              ASSUME    CS:CODE,DS:DATA,SS:STACKS
              
      START:  MOV       AX,DATA     ;开始运行
              MOV       DS,AX
              
              CALL      CRLFP
              MOV       AH,9
              LEA       DX,HEAD
              INT       21H
              CALL      CRLFP
              MOV       NMATRIX,0   ;矩阵个数置0
              
    REINPUT:  CALL      REMPRINT
              
              MOV       NCOLUMN1,0
              MOV       NROW1,0
              MOV       CL,0        ;堆栈中数字个数
              MOV       BL,0        ;当前行数字数
      
      INPUT:  MOV       AH,1        ;输入判断
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
     INPUT1:  CMP       AL,' '      ;空格键
              JNE       INPUT2
              CMP       CL,0
              JE        ERRO1       ;堆栈无数字处理
              CALL      SETNUM      ;堆栈有数字处理
              JMP       INPUT
     INPUT2:  CMP       AL,0DH      ;回车键
              JNE       INPUT3
              CALL      CRLFP
              CMP       CL,0
              JE        ARRANGE
              CALL      SETNUM      ;检查堆栈并送数字
    ARRANGE:  CMP       BL,0
              JNE       ARRANGE1
              CMP       NMATRIX,0   ;本行无数值处理
              JE        NONEMATRIX  ;矩阵个数为0
              CALL      MATMUL      ;计算并打印
              CALL      RESPRINT
              INC       NMATRIX     ;矩阵个数 加1
              JMP       REINPUT     ;输入下一个矩阵
 NONEMATRIX:  CMP       NCOLUMN1,0
              JE        ERRO1       ;未输入矩阵报错
              CALL      MATRIX1TO2  ; 矩阵1传送到矩阵2
              INC       NMATRIX     ; 个数加1
              JMP       REINPUT     ;输入下一个矩阵
                                     
   ARRANGE1:  CMP       NROW1,0     ; 本行有数值处理
              JNE       ROWEXIST
              MOV       NCOLUMN1,BL ;行数为0,确定列数
              JMP       ARRANGE2
   ROWEXIST:  CMP       BL,NCOLUMN1 ;当前行列数是否等于已有列数
              JNE       ERRO1       ;不等报错
   ARRANGE2:  INC       NROW1       ;行数加1
              MOV       BL,0
              JMP       INPUT
     INPUT3:  CMP       AL,'0'
              JB        ERRO1
              CMP       AL,'9'
              JA        ERRO1
              SUB       AL,30H      ;输入数字处理
              MOV       AH,0
              PUSH      AX
              INC       CL
              JMP       INPUT
                
      ENDUP:  MOV       AX,4C00H    ;退出程序
              INT       21H
                      
      ERRO1:  LEA       DX,ERRO     ;输入错误提醒
              CALL      ERRONOTICE
      TLERR:  LEA       DX,TOOLARGE ;数字过大提醒
              CALL      ERRONOTICE
     NOTFIT:  LEA       DX,NOTEQUAL ;行、列数不等无法计算
              CALL      ERRONOTICE
              
              ;子程序 
              

      SETNUM  PROC                  ;将堆栈中数字送入数组
              POP       SI
              POP       AX
              CMP       CL,1
              JE        COUNT
              CMP       CL,2        ;大于两位数报错
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
              MOV       MATRIX1[DI],DL          ;将堆栈中数字送入 矩阵1
              INC       BL          ;当前行数字个数加1
              MOV       CL,0
              PUSH      SI
              RET
      SETNUM  ENDP
      
    REMPRINT  PROC                  ;输入前的提醒
              MOV       AH,9
              LEA       DX,REMINDI1
              INT       21H
              MOV       DL,NMATRIX  ;矩阵序数
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
       
      MATMUL  PROC                  ;矩阵相乘 MS = M1*M2
              PUSH      BX
              MOV       AL,NCOLUMN2
              CMP       AL,NROW1
              JNE       NOTFIT
              MOV       AL,NCOLUMN1
              MOV       NCOLUMNS,AL
              MOV       AL,NROW2
              MOV       NROWS,AL

              MOV       SI,0        ;M2某行首个数的下标
         C3:  MOV       BX,0        ;M1列数
         C2:  MOV       BP,0        ;M2列数
              MOV       DI,0        ;M1某行首个数的下标
         C1:  MOV       AL,MATRIX1[BX][DI]
              MOV       AH,MATRIX2[BP][SI]
              MUL       AH
              ADD       MATRIXS[BX][SI], AL
             
              MOV       AL,NCOLUMN1
              MOV       AH,0
              ADD       DI,AX       ;每次加上 M1列数
              MOV       AL,NCOLUMN2
              MOV       AH,0
              INC       BP
              CMP       BP,AX       ;和M1列数比较
              JB        C1

              INC       BX
              CMP       BL,NCOLUMNS
              JB        C2

              MOV       AL,NCOLUMN2
              MOV       AH,0
              ADD       SI,AX       ;每次加上 M1列数
              MOV       AH,NROW2
              MUL       AH
              CMP       SI,AX       ;和M1总个数比较
              JB        C3
              CALL      MATRIXSTO2  ;矩阵s->矩阵2
              POP       BX
              RET
      MATMUL  ENDP

    RESPRINT  PROC                  ;打印矩阵MS
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
       OUTC:  MOV       BX,0        ;外部循环  整行输出
        CAL:  MOV       AL,MATRIXS[BX][SI]      ;内部循环 单个数值输出
              PUSH      BX
              MOV       CX,0
              CMP       AL,0
              JNZ       CHANGE
              MOV       AH,2        ;如果数值为0，直接输出
              MOV       DL,'0'
              INT       21H
              JMP       SHOW1
     CHANGE:  MOV       AH,0
              MOV       DL,0
              MOV       BL,10
              DIV       BL          ;被除 10
              MOV       DL,AH
              ADD       DL,30H
              MOV       DH,0
              CMP       AX,0        ;商为0开始输出
              JE        SHOW
              PUSH      DX          ;不为0余数进堆栈，继续除
              INC       CX          ;记录位数
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

       CRLFP  PROC                  ;输出回车
              PUSH      DX
              MOV       AH,2
              MOV       DL,0AH
              INT       21H
              MOV       DL,0DH
              INT       21H
              POP       DX
              RET
       CRLFP  ENDP

      SHUCHU  PROC                  ;测试
              ADD       DL,30H
              MOV       AH,2
              INT       21H
              RET
      SHUCHU  ENDP

  MATRIX1TO2  PROC                  ;矩阵1复制到矩阵2
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

  MATRIXSTO2  PROC                  ;矩阵1复制到矩阵2
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

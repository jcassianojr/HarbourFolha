*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foif1.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 15-Out-2026 as 12:37 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// //#INCLUDE "COMANDO.CH"

CABEX("Escolha o Grupo a listar")
VAL    := Array(12)
aRETU  := RFILORD("FO_FFE",.F.)
INX    := aRETU[1]
FILTRO := aRETU[2]


CABEX("Escolha o Grupo de Contas listar")
MDS("Ande com as setas e Tecle enter na desejada")
@  7,1 PROM " 1 - Todas as Contas"+spac(20)
@  8,1 PROM " 2 - S¢ as Contas de Cr‚dito"+spac(12)
@  9,1 PROM " 3 - S¢ as Contas de Bases de Calculo   "
@ 10,1 PROM " 4 - S¢ as Contas de D‚bitos"+spac(12)
@ 11,1 PROM " 5 - S¢ as Contas de Cr‚dito + D‚bitos  "
@ 12,1 PROM " 6 - S¢ as Contas de Bases   + D‚bitos  "
@ 13,1 PROM " 7 - S¢ as Contas de Cr‚dito + Bases    "
@ 14,1 PROM " 8 - Sequencia de Contas"+spac(16)
@ 15,1 PROM " 9 - Pr‚ Selecionada"+spac(20)
MENU TO KEY
IF KEY = 0
   RETU .F.
ENDIF

IF KEY = 8
   SEPARADO := PEGRELCTA("")
ENDIF

IF KEY = 9
   mSELFEE := " "
   MDS("Qual Sele‡„o")
   @ 24,40 GET mSELFEE         
   IF !READCUR()
      RETU .F.
   ENDIF
ENDIF

HORIMP := MDG("Deseja Imprimir tamb‚m o acumulado de Horas")

CABEX("Carregando defini‡”es das Contas")
aCTA01 := {}  // NUMERO
aCTA02 := {}  // DESCRICAO
aCTA03 := {}  // TIPO
IF !NETUSE("CONTAS")
   RETU .F.
ENDIF
GRAPP := 1
GRAPT := LastRec()
GRAPT("Carregando Dados do Plano de Contas")
dbGoTop()
WHILE !Eof()
   INC := .F.
   DO CASE
   CASE KEY = 1
      INC := .T.
   CASE KEY = 2
      IF CODIGO < 400 .AND. (CODIGO > 40 .AND. CODIGO < 50)
         INC := .T.
      ENDIF
   CASE KEY = 3
      IF CODIGO > 400 .AND. CODIGO < 502
         INC := .T.
      ENDIF
   CASE KEY = 4
      IF CODIGO > 501 .OR. (CODIGO > 40 .AND. CODIGO < 50)
         INC := .T.
      ENDIF
   CASE KEY = 5
      IF CODIGO < 400 .OR. CODIGO > 501 .AND. (CODIGO > 40 .AND. CODIGO < 50)
         INC := .T.
      ENDIF
   CASE KEY = 6
      IF CODIGO > 399 .OR. (CODIGO > 40 .AND. CODIGO < 50)
         INC := .T.
      ENDIF
   CASE KEY = 7
      IF CODIGO < 502 .AND. (CODIGO > 40 .AND. CODIGO < 50)
         INC := .T.
      ENDIF
   CASE KEY = 8
      IF AScan(SEPARADO,CODIGO) # 0
         INC := .T.
      ENDIF
   CASE KEY = 9
      IF mSELFEE = SELFFE
         INC := .T.
      ENDIF
   ENDCASE
   IF INC
      AAdd(aCTA01,CODIGO)
      AAdd(aCTA02,Left(DESCR,30))
      AAdd(aCTA03,TIPO)
   ENDIF
   GRAPS()
   dbSkip()
ENDDO
dbCloseAll()

IF !CHECKIMP(0)
   RETU .F.
ENDIF

FL  := 0
LIN := 80
IF !netuse("FO_FFE")  // AREDE( "FO_FFE", "FO_FFE", 0 )
   RETU .F.
ENDIF
SET FILTER TO &FILTRO
IMPRESSORA()
dbGoTop()
WHILE !Eof()
   FL ++
   IF LIN > 60
      @  1,1   SAY IMPCHR(18)                                              
      @  2,20  SAY IMPCHR(14)+MSG2                                         
      @  3,20  SAY IMPCHR(14)+'FICHA FINANCEIRA EMPRESA ( ANUAL )'         
      @  4,100 SAY Time()                                                  
      @  4,110 SAY DXDIA                                                   
      @  4,120 SAY 'FL. '+StrZero(FL,4)                                    
      @  5,0   SAY repl("-",132)                                           
      @  6,0   SAY IMPCHR(15)+'CTA'                                        
      @  6,5   SAY 'Nome Conta '                                           
      FOR X := 1 TO 12
         COL := 23+(X * 14)
         @  6,COL SAY PadL(MMES(X),14)         
      NEXT X
      @  6,208 SAY 'Total   Ano'                               
      @  7,0   SAY IMPCHR(18)+repl("-",132)+IMPCHR(15)         
      LIN := 8
   ENDIF
   mCONTA := CONTA
   MPOS   := AScan(aCTA01,mCONTA)
   IF MPOS # 0
      @ LIN,0 SAY mCONTA       PICT "###"        
      @ LIN,4 SAY aCTA02[mPOS]                   
      HOR  := if(aCTA03[mPOS] = 1 .OR. aCTA03[mPOS] = 3,.T.,.F.)
      TVAL := 0.00
      AFill(VAL,0)
      WHILE CONTA = mCONTA .AND. !Eof()
         COL := MES * 14+22
         IF HOR .AND. HORIMP
            @ LIN,COL SAY HORAS PICT '###,###,###.##'        
            TVAL += HORAS
         ENDIF
         VAL[MES] = VALOR
         dbSkip()
      ENDDO
      IF HOR .AND. HORIMP
         @ LIN,208 SAY TVAL PICT '#########.##'        
         LIN ++
         TVAL := 0.00
      ENDIF
      FOR X := 1 TO 12
         IF VAL[X] # 0
            COL := X * 14+22
            @ LIN,COL SAY VAL[X] PICT '###########.##'        
            TVAL += VAL[X]
         ENDIF
      NEXT X
      @ LIN,208 SAY TVAL PICT '#########.##'        
      LIN ++
   ELSE
      WHILE mCONTA = CONTA .AND. !Eof()
         dbSkip()
      ENDDO
   ENDIF
ENDDO
dbCloseAll()
VIDEO()
IMPEND()
RETU



*+ EOF: foif1.prg
*+

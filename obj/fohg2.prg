*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fohg2.prg
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

CABEX('Gerar Arquivo para RE FGTS')
IF ARQ # 1
   ALERTX("Somente para Folha de Pagamento")
   RETU .F.
ENDIF
IF Empty(ZPESSOA)
   ALERTX("Cadastre Tipo de Pessoa Cadastro Empresa")
   RETU .F.
ENDIF
IF Empty(CGC1)
   ALERTX("Cadastre CPF ou CGC Cadastro Empresa")
   RETU .F.
ENDIF
INSREP := Space(14)
TIPREP := " "
DO CASE
CASE ZPESSOA = 'J'
   INSREP := SubStr(CGC1,1,2)+SubStr(CGC1,4,3)+SubStr(CGC1,8,3)+SubStr(CGC1,12,4)+SubStr(CGC1,17,2)
   TIPREP := "1"
CASE ZPESSOA = 'C'
   INSREP := "00"+ZCEI
   TIPREP := "2"
CASE ZPESSOA = 'F'
   INSREP := "000"+SubStr(CGC1,1,3)+SubStr(CGC1,5,3)+SubStr(CGC1,9,3)+SubStr(CGC1,13,2)
   TIPREP := "3"
ENDCASE
mPAGGPS := "2100"
GRACTA  := "N"
mRAZAO  := TIRACX(MSG2,30)
CONTATO := TIRACX(OBTER("FIRMA",,NREMP,"RESPONSAV"),20)
mEMAIL  := OBTER("FIRMA",,NREMP,"EMAIL")
SIMPLES := OBTER("FIRMA",,NREMP,"SIMPLES")
SIMPLES := if(SIMPLES = "N","1",SIMPLES)
SIMPLES := if(SIMPLES = "S","2",SIMPLES)
IF SIMPLES = "2"
   mPAGGPS := "2003"
ENDIF
INCDIR    := if(hb_FileExists(ZDIRE+"FO_DIR.DBF"),"S","N")
INCFUN    := if(PES = "FO_PES","S","N")
ALTEND    := "N"
mCODREC   := "115"
mINDFGS   := "1"
mSITUI    := "1"
mREMESSA  := "1"
mMODAL    := " "
mTIPFOR   := "1"
mCGCFOR   := INSREP
FILAN     := 0
mVCOOPER  := 0
mGPSANT   := 0
mCOMERFIS := 0
mCOMERJUR := 0

mCLASSE  := OBTER("BCOFGTS",,NREMP,"TIPOEMP")
mCODCAI  := OBTER("BCOFGTS",,NREMP,"CODEMP+CODEMPDV+SEQUENCIA+SEQUENDV")
mUNIDADE := OBTER("BCOFGTS",,NREMP,"UNIDADE")
mBCO     := OBTER("BCOFGTS",,NREMP,"NUMERO")
mAGENCIA := OBTER("BCOFGTS",,NREMP,"AGENCIA")
mCONTA   := OBTER("BCOFGTS",,NREMP,"AGENCTA")

mINDINSS  := 0
mCEP      := StrTran(CEP1,"-","")
mFPAS     := OBTER("FIRMA",,NREMP,"FPAS")
mENDERECO := TIRACX(ENDER1,50)
mBAIRRO   := TIRACX(BAI1,20)
mCIDADE   := TIRACX(CID1,20)
mESTADO   := EST1
mTEL      := StrZero(Val(OBTER("FIRMA",,NREMP,"DDD")),3)
mTEL      += StrZero(Val(StrTran(zTELEFONE,"-","")),9)
mALTC     := "N"
mCNAE     := OBTER("FIRMA",,NREMP,"ATIVIDADE")
mDELIM    := "S"
mCHR26    := "N"
INSS12    := GPS12 := 0
IND12     := "0"

mCOMP  := StrZero(ANO,4)+StrZero(MESTRAB,2)
MESXXX := MESTRAB+1
ANOXXX := ANO
IF MESXXX = 13
   MESXXX := 1
   ANOXXX += 1
ENDIF
mDATFGT := "07"+StrZero(MESXXX,2)+StrZero(ANOXXX,4)
mDATINS := "01"+StrZero(MESXXX,2)+StrZero(ANOXXX,4)

mSAT    := 0
mCODTER := Space(4)
VERSEHA("CONFINSS",,Val(mFPAS),,'COdigo FPAS INEXISTENTE',.T.,;
 {{"ACIDENTE","mSAT"},;
 {"STRZERO(TERCEIRO,4)","mCODTER"}})

IF SIMPLES = "2"
   mCODTER := Space(4)
ENDIF

aCTA01 := PEGRELCTA("FGTS01")
aCTA02 := PEGRELCTA("FGTS02")
aCTA03 := PEGRELCTA("FGTS03")
aCTA04 := PEGRELCTA("FGTS04")
aCTA05 := PEGRELCTA("FGTS05")
aCTA10 := PEGRELCTA("FGTS10")
aCTA11 := PEGRELCTA("FGTS11")
aCTA12 := PEGRELCTA("FGTS12")

mSALFAM := 0
mVALMAT := 0
MDS("Somando Salario Familia/AuxMat.")
IF !NETUSE(FOL,,,,,.F.,)  // BREDE( FOL, 1 )
   dbCloseAll()
   RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordCreate(,"temp","conta")
ordSetFocus("temp")

FOR X := 1 TO 15
   IF !Empty(aCTA05[X])
      dbGoTop()
      dbSeek(aCTA05[X])
      WHILE CONTA = aCTA05[X] .AND. !Eof()
         mSALFAM += VALOR
         dbSkip()
      ENDDO
   ENDIF
   IF !Empty(aCTA12[X])
      dbGoTop()
      dbSeek(aCTA12[X])
      WHILE CONTA = aCTA12[X] .AND. !Eof()
         mVALMAT += VALOR
         dbSkip()
      ENDDO
   ENDIF
NEXT X
dbCloseArea()
@ 24,00

ALERTX("Confirme os Dados com Aten‡„o")
TELASAY("FOHG21")
EDITSAY("FOHG21")



mMESYYY := SubStr(mCOMP,5)
// ALERTX(mMESYYY)
IF mMESYYY = "13"
   aCTA04 := PEGRELCTA("FGTS1301")
ENDIF

mCODTER := if(SIMPLES # "2",StrZero(Val(mCODTER),4),Space(4))

cTOM1 := " "
cTOMA := Space(14)
IF mCODREC = "130" .OR. mCODREC = "150" .OR. mCODREC = "155" .OR. mCODREC = "608"
   cTOMA := repl("0",14)
   cTOM1 := "1"
ENDIF

cVALFAM := GRVVAL(mSALFAM,15,2)
IF mSAT > 0
   cSAT := GRVVAL(mSAT,2,1)
ELSE
   cSAT := Space(2)
ENDIF

IF FILAN > 0
   cFILAN := GRVVAL(FILAN,5,2)
ELSE
   cFILAN := Space(5)
ENDIF

cVALMAT := GRVVAL(mVALMAT,15,2)

cINSS12 := GRVVAL(INSS12,15,2)

cGPS12 := GRVVAL(GPS12,14,2)

IF INCFUN = "S"
   IF !NETUSE(PES,,,,,.F.,)
      RETU .F.
   ENDIF
   FILTRO := FILTRO("")
   IF !Empty(FILTRO)
      SET FILTER TO &FILTRO
   ENDIF
   nLASTREC := LastRec()
   zei_fort(nLASTREC,,,0)
   ordDestroy("temp")
   ordCreate(,"temp","pis")
   ordSetFocus("temp")


   IF !NETUSE('FP'+EMP+ARQMES)
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE2 := Alias()
ENDIF

IF !NETUSE("FO_OCO")
   dbCloseAll()
   RETU .F.
ENDIF
IF INCDIR = "S"
   IF !NETUSE("FO_DIR",,,,,.F.,)
      dbCloseAll()
      RETU .F.
   ENDIF
   FILTR2 := FILTRO("")
   IF !Empty(FILTR2)
      SET FILTER TO &FILTR2
   ENDIF
   nLASTREC := LastRec()
   zei_fort(nLASTREC,,,0)
   ordDestroy("temp")
   ordCreate(,"temp","ci")
   ordSetFocus("temp")


   cSELE4 := Alias()

   IF !NETUSE('SO'+EMP+ARQMES)  // AREDE( 'SO' + EMP + ARQMES, 'SO' + EMP + ARQMES, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE5 := Alias()

ENDIF

ARQUIVO := ZDIRE+"SEFIP.RE"
USO     := FCreate(ARQUIVO)
IF FError() # 0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF
FWRITX("00",2)  // 1 00-Header
FWRITX(Space(51),51)  // 2
FWRITX(mREMESSA,1,,1)   // 3
FWRITX(TIPREP,1,,1)   // 4
FWRITX(INSREP,14,,1)  // 5
FWRITX(mRAZAO,30)   // 6
FWRITX(CONTATO,20)  // 7
FWRITX(mENDERECO,50)  // 8
FWRITX(mBAIRRO,20)  // 9
FWRITX(mCEP,8,,1)   // 10
FWRITX(mCIDADE,20)  // 11
FWRITX(mESTADO,2)   // 12
FWRITX(mTEL,12,,1)  // 13
FWrite(USO,PadR(mEMAIL,60))   // 14
FWRITX(mCOMP,6)   // 15
FWRITX(mCODREC,3,,1)  // 16
FWRITX(mINDFGS,1)   // 17
FWRITX(mMODAL,1)  // 18
IF mINDFGS = "2"
   FWRITX(mDATFGT,8)  // 19
ELSE
   FWRITX(Space(8),8)   // 19
ENDIF
FWRITX(mSITUI,1,,1)   // 20
IF mSITUI = "2"
   FWRITX(mDATINS,8)  // 21
ELSE
   FWRITX(Space(8),8)   // 21
ENDIF
IF mINDINSS > 0
   FWRITX(mINDINSS,7,,1)  // 22
ELSE
   FWRITX(Space(7),7)   // 22
ENDIF
FWRITX(mTIPFOR,1,,1)  // 23
FWRITX(mCGCFOR,14,,1)   // 24
FWRITX(Space(18),18)  // 25
FWRITX("*",1)   // 26
IF mDELIM = "S"
   FWrite(USO,Chr(13)+Chr(10))
ENDIF

FWrite(USO,"10")  // 10-Dados da Empresa //1
FWRITX(TIPREP,1,,1)   // 2
FWRITX(INSREP,14,,1)  // 3
FWRITX(repl("0",36),36,,1)  // 4
FWRITX(mRAZAO,40)   // 5
FWRITX(mENDERECO,50)  // 6
FWRITX(mBAIRRO,20)  // 7
FWRITX(mCEP,8,,1)   // 8
FWRITX(mCIDADE,20)  // 9
FWRITX(mESTADO,2)   // 10
FWRITX(mTEL,12,,1)  // 11
FWRITX(ALTEND,1)  // 12
FWRITX(mCNAE,7,,1)  // 13
FWRITX(mALTC,1)   // 14
FWRITX(cSAT,2,,1)   // 15
FWRITX(mCLASSE,1,,1)  // 16
FWRITX(SIMPLES,1,,1)  // 17
FWRITX(mFPAS,3,,1)  // 18
FWRITX(mCODTER,4)   // 19
FWRITX(mPAGGPS,4)   // 20
FWRITX(cFILAN,5)  // 21
FWRITX(cVALFAM,15)  // 22
FWRITX(cVALMAT,15)  // 23
FWRITX(cINSS12,15)  // 24
FWRITX(IND12,1)   // 25
FWRITX(cGPS12,14)   // 26
IF GRACTA = "N"
   FWRITX(Space(3),3)   // 27
   FWRITX(Space(4),4)   // 28
   FWRITX(Space(9),9)   // 29
ELSE
   FWRITX(mBCO,3,,1)  // 27
   FWRITX(mAGENCIA,4,,1)  // 28
   FWRITX(mCONTA,9)   // 29
ENDIF
FWRITX(repl("0",15),15)   // 30
FWRITX(repl("0",15),15)   // 30
FWRITX(repl("0",15),15)   // 30
FWRITX(Space(4),4)  // 31
FWRITX("*",1)   // 32
IF mDELIM = "S"
   FWrite(USO,Chr(13)+Chr(10))
ENDIF

IF mvCOOPER > 0 .OR. mGPSANT > 0 .OR. mCOMERFIS > 0 .OR. mCOMERFIS > 0
   FWrite(USO,"12")   // 12-Dados da Empresa Complemento //1
   FWRITX(TIPREP,1,,1)  // 2 tIPO Inscri‡ao
   FWRITX(INSREP,14,,1)   // 3 cgc
   FWRITX(repl("0",36),36)  // 4  zeros
   FWRITX(repl("0",15),15)  // 5 Ded 13 Mat
   FWRITX(repl("0",15),15)  // 6 Evento Desportivo
   FWRITX(" ",1)  // 7 Origem Desportivo
   FWRITX(GRVVAL(mCOMERFIS,15,2),15)  // 8 Comercializacao Rural Fisica
   FWRITX(GRVVAL(mCOMERJUR,15,2),15)  // 9 Comercializacao Rural Juridica
   FWRITX(Space(11),11)   // 10 Outras Inf Processo
   FWRITX(Space(4),4)   // 11 Ano Processo
   FWRITX(Space(5),5)   // 12 Vara
   FWRITX(Space(6),6)   // 13 Periodo Ini
   FWRITX(Space(6),6)   // 14 Perido Fim
   FWRITX(repl("0",15),15)  // 15 Compensacao
   FWRITX(Space(6),6)   // 16 Inicio Compensacao
   FWRITX(Space(6),6)   // 17 Fim Compensacao
   FWRITX(GRVVAL(mGPSANT,15,2),15)  // 18 GPS<R$ 29 Meses Anteriores
   FWRITX(repl("0",15),15)  // 19 GPS<R$ 29 oUTRAS Entidades
   FWRITX(repl("0",15),15)  // 20 GPS<R$ 29 Comer.Rural
   FWRITX(repl("0",15),15)  // 21 GPS<R$ 29 Corer.OUTRAS
   FWRITX(repl("0",15),15)  // 22 GPS<R$ 29 Evento Desp
   FWRITX(repl("0",15),15)  // 23 pARCELAMENTO
   FWRITX(repl("0",15),15)  // 24 Parcelamento
   FWRITX(repl("0",15),15)  // 25 Parcelamento
   FWRITX(GRVVAL(mVCOOPER,15,2),15)   // 26 Valor Cooperados
   FWRITX(repl("0",15),15)  // 27 Futura
   FWRITX(repl("0",15),15)  // 27 Futura
   FWRITX(repl("0",15),15)  // 27 Futura
   FWRITX(Space(6),6)   // 28 Preencher Brancos
   FWRITX("*",1)  // 29 Final de Linha
   IF mDELIM = "S"
      FWrite(USO,Chr(13)+Chr(10))
   ENDIF

ENDIF

FOR K := 1 TO 3
   IF INCFUN = "S"
      dbSelectAr(PES)
      dbGoTop()
      WHILE !Eof()
         PETELA(8)
         mNUMERO := NUMERO
         mNOME   := NOME
         mPIS    := PIS
         mCI     := CI
         mCAT    := CATEGORIA
         mOCO    := OCOFGTS
         IF Empty(mPIS)
            mPIS := "1"+Space(10)
         ENDIF
         IF Empty(mCAT)
            mCAT := "01"
         ENDIF
         IF Empty(mOCO)
            mOCO := "0"
         ENDIF
         nGRUP01 := 2
         IF mCAT = "01" .OR. mCAT = "02" .OR. mCAT = "03" .OR. mCAT = "04" .OR. mCAT = "05" .OR. mCAT = "12"
            nGRUP01 := 1
         ENDIF
         nGRUP02 := 2
         IF mCAT = "01" .OR. mCAT = "03" .OR. mCAT = "04" .OR. mCAT = "05" ;
                    .OR. mCAT = "06" .OR. mCAT = "07" .OR. mCAT = "11" ;
                    .OR. mCAT = "12" .OR. mCAT = "19" .OR. mCAT = "20" ;
                    .OR. mCAT = "21"
            nGRUP02 := 1
         ENDIF
         mADM := StrZero(Day(ADMITIDO),2)+StrZero(Month(ADMITIDO),2)+StrZero(Year(ADMITIDO),4)
         mDFG := StrZero(Day(FGTS),2)+StrZero(Month(FGTS),2)+StrZero(Year(FGTS),4)
         mDEM := StrZero(Day(DEMITIDO),2)+StrZero(Month(DEMITIDO),2)+StrZero(Year(DEMITIDO),4)
         mNAS := StrZero(Day(NASC),2)+StrZero(Month(NASC),2)+StrZero(Year(NASC),4)
         mCEP := SubStr(CEP,1,5)+SubStr(CEP,7,3)
         DO CASE
         CASE K = 1
            G2R13()
         CASE K = 2
            G2R14()
         CASE K = 3
            G2R30(2)
            G2R32(2)
         ENDCASE
         dbSelectAr(PES)
         dbSkip()
      ENDDO
   ENDIF
   IF INCDIR = "S" .AND. K = 3  // Diretores
      aCTA01 := PEGRELCTA("FGTSD01")
      aCTA02 := PEGRELCTA("FGTSD02")
      aCTA03 := PEGRELCTA("FGTSD03")
      aCTA04 := PEGRELCTA("FGTSD04")
      dbSelectAr(cSELE4)
      dbGoTop()
      WHILE !Eof()
         PETELA(8)
         mNUMERO := NUMERO
         mPIS    := PIS
         mCAT    := CATEGORIA
         mOCO    := OCOFGTS
         mCI     := CI
         IF Empty(mPIS)
            mPIS := "1"+Space(10)
         ENDIF
         IF Empty(mCAT)
            mCAT := "11"
         ENDIF
         IF Empty(mOCO)
            mOCO := "1"
         ENDIF
         nGRUP01 := 2
         IF mCAT = "01" .OR. mCAT = "02" .OR. mCAT = "03" .OR. mCAT = "04" .OR. mCAT = "05" .OR. mCAT = "12"
            nGRUP01 := 1
         ENDIF
         nGRUP02 := 2
         IF mCAT = "01" .OR. mCAT = "03" .OR. mCAT = "04" .OR. mCAT = "05" ;
                    .OR. mCAT = "06" .OR. mCAT = "07" .OR. mCAT = "11" ;
                    .OR. mCAT = "12" .OR. mCAT = "19" .OR. mCAT = "20" ;
                    .OR. mCAT = "21"
            nGRUP02 := 1
         ENDIF
         mADM := StrZero(Day(ADMITIDO),2)+StrZero(Month(ADMITIDO),2)+StrZero(Year(ADMITIDO),4)
         mDFG := StrZero(Day(FGTS),2)+StrZero(Month(FGTS),2)+StrZero(Year(FGTS),4)
         mDEM := StrZero(Day(DEMITIDO),2)+StrZero(Month(DEMITIDO),2)+StrZero(Year(DEMITIDO),4)
         mNAS := StrZero(Day(NASC),2)+StrZero(Month(NASC),2)+StrZero(Year(NASC),4)
         mCEP := SubStr(CEP,1,5)+SubStr(CEP,7,3)
         G2R30(5)
         G2R32(5)
         dbSelectAr(cSELE4)
         dbSkip()
      ENDDO
   ENDIF
NEXT K
dbCloseAll()

FWrite(USO,"90")  // 1          //90 Totalizador
FWrite(USO,repl("9",51))  // 2
FWrite(USO,Space(306))  // 3
FWrite(USO,"*")   // 4
IF mDELIM = "S"
   FWrite(USO,Chr(13)+Chr(10))
ENDIF
IF mCHR26 = "S"
   FWrite(USO,Chr(26))
ENDIF
FClose(USO)

IF MDG("Deseja Ver o Arquivo")
   VERTXT(ARQUIVO)
ENDIF
IF MDG("Deseja imprimir o Arquivo")
   imparq(ARQUIVO,,,,,,,360,)
ENDIF

ALERTX("N„o Esque‡a de Utilizar o Validador")

RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TIRACX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC TIRACX(cVAR,nLEN,nDEC,cREP)


IF ValType(cVAR) # "C"
   IF ValType(nLEN) = "N" .AND. ValType(nDEC) = "N"
      cVAR := STRVAL(cVAR,nLEN,nDEC)
   ELSE
      cVAR := STRVAL(cVAR,nLEN,nDEC)
   ENDIF
ENDIF
IF ValType(cREP) # "C"
   cREP := " "
ENDIF
cVAR := TIRACE(cVAR)
cVAR := StrTran(cVAR,"/",cREP)
cVAR := StrTran(cVAR,"-",cREP)
cVAR := StrTran(cVAR,".",cREP)
cVAR := StrTran(cVAR,",",cREP)
cVAR := StrTran(cVAR,":",cREP)
cVAR := StrTran(cVAR,"&",cREP)
cVAR := StrTran(cVAR,"  ",cREP)   // Duplos Espacos
cVAR := AllTrim(cVAR)
IF ValType(nLEN) = "N"
   cVAR := PadR(AllTrim(cVAR),nLEN)
ENDIF
RETU cVAR


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FWRITX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FWRITX(cVAR,nLEN,nDEC,nTIP)


IF ValType(nTIP) # "N"
   nTIP := 0
ENDIF
DO CASE
CASE ValType(cVAR) = "N"
   cVAR := StrZero(cVAR,nLEN)
CASE ValType(cVAR) = "C" .AND. nTIP = 1
   cVAR := StrZero(Val(cVAR),nLEN)
CASE ValType(cVAR) = "C"
   cVAR := TIRACX(cVAR,nLEN)
ENDCASE
FWrite(USO,cVAR)
RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function G2R13()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC G2R13


IF Val(mCAT) > 10   // cAT 11,12,13,14,15,16,17
   IF ALTFGTS = "404" .OR. ALTFGTS = "405"
   ELSE
      RETU .T.
   ENDIF
ENDIF
IF mMESYYY = "13"
   RETU
ENDIF
IF !Empty(ALTFGTS) .AND. ALTFGTS # "END"  // 13  Alteracao cadastral do trabalhador.
   cCAMPO := ""
   DO CASE
   CASE ALTFGTS = "403"
      cCAMPO := SubStr(PROFIS,1,7)+SubStr(SERIE,1,5)
   CASE ALTFGTS = "404"
      cCAMPO := NOME
   CASE ALTFGTS = "405"
      cCAMPO := PIS
   CASE ALTFGTS = "406"
      cCAMPO := NUMERO
   CASE ALTFGTS = "408"
      cCAMPO := mADM
   CASE ALTFGTS = "426"
      cCAMPO := mUNIDADE
   CASE ALTFGTS = "427"
      cCAMPO := OBTER("FUNCAO",,FUNCAO,"CBONEW")  // CBONEW CBONEW
   CASE ALTFGTS = "428"
      cCAMPO := mNAS
   ENDCASE
   FWRITX("13",2)   // 1
   FWRITX(TIPREP,1,,1)  // 2
   FWRITX(INSREP,14,,1)   // 3
   FWRITX(repl("0",36),36,,1)   // 4
   IF nGRUP01 = 1
      FWRITX(mPIS,11,,1)  // 5
   ELSE
      FWRITX(mCI,11,,1)   // 5
   ENDIF
   IF nGRUP02 = 1
      FWRITX(mADM,8)  // 6
   ELSE
      FWrite(USO,Space(8))  // 6
   ENDIF
   FWRITX(mCAT,2,,1)  // 11
   IF Val(mCAT) > 12
      FWrite(USO,Space(11))   // 7
   ELSE
      FWRITX(mNUMERO,11,,1)   // 7
   ENDIF
   IF mCAT = "01" .OR. mCAT = "02" .OR. mCAT = "03" .OR. mCAT = "04"
      FWRITX(SubStr(PROFIS,1,7),7,,1)   // 8
      FWRITX(SubStr(SERIE,1,5),5,,1)  // 9
   ELSE
      FWrite(USO,Space(7))
      FWrite(USO,Space(5))
   ENDIF
   FWRITX(NOME,70)  // 10
   IF Val(mCAT) < 6
      FWRITX(mCODCAI,14,,1)   // 12
      FWRITX(CONTAFGTS,11,,1)   // 13
   ELSE
      FWrite(USO,Space(14))
      FWrite(USO,Space(11))
   ENDIF
   FWRITX(ALTFGTS,3,,1)   // 14
   FWRITX(cCAMPO,70)  // 15
   FWrite(USO,Space(94))  // 16
   FWRITX("*",1)  // 17
   IF mDELIM = "S"
      FWrite(USO,Chr(13)+Chr(10))
   ENDIF
ENDIF
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function G2R14()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC G2R14


// FWRITE(USO,"14") 14  Alteracao do endere‡o do trabalhador.
IF nGRUP01 = 1 .OR. mCAT = "11"
ELSE
   RETU .T.
ENDIF
IF mMESYYY = "13"
   RETU
ENDIF

IF (Month(ADMITIDO) = MES .AND. Year(ADMITIDO) = ANO) .OR. (ALTFGTS = "END")
   FWRITX("14",2)   // 1
   FWRITX(TIPREP,1,,1)  // 2
   FWRITX(INSREP,14,,1)   // 3
   FWRITX(repl("0",36),36,,1)   // 4
   FWRITX(mPIS,11,,1)   // 5
   IF mCAT = "11"
      FWrite(USO,Space(8))  // 16
   ELSE
      FWRITX(mADM,8)  // 6
   ENDIF
   FWRITX(mCAT,2,,1)  // 8
   FWRITX(NOME,70)  // 7
   IF mCAT = "11" .OR. mCAT = "12" .OR. mCAT = "05"
      FWrite(USO,Space(7))  // 16
      FWrite(USO,Space(5))  // 16
   ELSE
      FWRITX(SubStr(PROFIS,1,7),7,,1)   // 9
      FWRITX(SubStr(SERIE,1,5),5,,1)  // 10
   ENDIF
   FWRITX(ENDER+","+AllTrim(ENDNUM)+" "+AllTrim(ENDCOMPL),50)   // 11
   FWRITX(BAIRRO,20)  // 12
   FWRITX(mCEP,8,,1)  // 13
   FWRITX(CIDADE,20)  // 14
   FWRITX(ESTADO,2)   // 15
   FWrite(USO,Space(103))   // 16
   FWRITX("*",1)  // 17
   IF mDELIM = "S"
      FWrite(USO,Chr(13)+Chr(10))   // INDICA FINAL DE REGISTRO
   ENDIF
ENDIF
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function G2R30()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC G2R30(nSELE)


nVAL01 := nVAL02 := nVAL03 := nVAL04 := nVAL10 := nVAL11 := 0

// nVAL1 Remuneracao sem 13o (Destinado ainformacao da remuneracao paga, devida ou creditada ao trabalhador no mes, conforme base de incidencia registrada na p gina 04 do Manual. Excluir do valor da remuneracao o 13§ sal rio pago no mes. 146 160 15 V Opci
// nVAL2 Remuneracao sobre 13o  (Destinado ainformacao da parcela de  13§ sal rio pago no mes ao trabalhador). 161 175 15 V Este campo nÆo deve ser informado para a competencia AAAA13 . Somente acatar a informacao de 13o sal rio das categorias de trabalha
// nVAL3 Mult¡plos V¡nculos - Valor Retido Segurado (Destinado ainformacao do valor da contribuicao do trabalhador que possuir mais de um v¡nculo empregat¡cio. O valor informado ser  considerado como contribuicao do segurado) 182 196 15 V Campo opcional p
// nVAL4 Base de C lculo 13o  Sal rio Previdencia Social (Indicar o valor total do 13§ sal rio pago no ano ao trabalhador. Sobre o valor informado incide contribuicao previdenci ria) 197 211 15 V Campo obrigat¢rio para a competencia AAAA13 e opcional para
// Nval10 Segurado/Exercito
// nval11 Complemento/13

IF nSELE = 2
   dbSelectAr(cSELE2)
ELSE
   dbSelectAr(cSELE5)
ENDIF
dbGoTop()
dbSeek(mNUMERO * 10000)
WHILE mNUMERO = NUMERO .AND. !Eof()
   FOR X := 1 TO 15
      IF aCTA01[X] = CONTA
         nVAL01 += VALOR
      ENDIF
      IF aCTA02[X] = CONTA
         nVAL02 += VALOR
      ENDIF
      IF aCTA03[X] = CONTA
         nVAL03 += VALOR
      ENDIF
      IF aCTA04[X] = CONTA
         nVAL04 += VALOR
      ENDIF
      IF aCTA10[X] = CONTA
         nVAL10 += VALOR
      ENDIF
      IF aCTA11[X] = CONTA
         nVAL11 += VALOR
      ENDIF
   NEXT X
   dbSkip()
ENDDO
IF nSELE = 2
   dbSelectAr(PES)
ELSE
   dbSelectAr(cSELE4)
ENDIF
IF mMESYYY = "13"
   nVAL01 := 0
   nVAL02 := 0
   nVAL03 := 0
   nVAL10 := 0
   nVAL11 := 0
ENDIF
cVAL01 := GRVVAL(nVAL01,15,2)
cVAL02 := GRVVAL(nVAL02,15,2)
cVAL03 := GRVVAL(nVAL03,15,2)
cVAL04 := GRVVAL(nVAL04,15,2)
cVAL10 := GRVVAL(nVAL10,15,2)
cVAL11 := GRVVAL(nVAL11,15,2)

IF (nVAL01+nVAL02+nVAL03+nVAL04+nVAL10+nVAL11 > 0) .OR. (Month(DEMITIDO) = MES .AND. Year(DEMITIDO) = ANO)
   FWRITX("30",2)   // 1   //30  Registro de empregado.
   FWRITX(TIPREP,1,,1)  // 2
   FWRITX(INSREP,14,,1)   // 3
   FWRITX(cTOM1,1)  // 4 Tomador em Branco
   FWRITX(cTOMA,14)   // 5 Tomador insc em branco
   IF nGRUP01 = 1
      FWRITX(mPIS,11,,1)  // 5
   ELSE
      FWRITX(mCI,11,,1)   // 5
   ENDIF
   IF nGRUP02 = 1
      FWRITX(mADM,8)  // 6
   ELSE
      FWrite(USO,Space(8))  // 6
   ENDIF
   FWRITX(mCAT,2,,1)  // 18
   FWRITX(NOME,70)  // 9
   IF Val(mCAT) > 12
      FWrite(USO,Space(11))
   ELSE
      FWRITX(mNUMERO,11,,1)
   ENDIF
   IF Val(mCAT) < 7 .AND. mCAT # "02" .AND. mCAT # "05"
      FWRITX(SubStr(PROFIS,1,7),7,,1)   // 8
      FWRITX(SubStr(SERIE,1,5),5,,1)  // 9
   ELSE
      FWrite(USO,Space(7))
      FWrite(USO,Space(5))
   ENDIF
   IF Val(mCAT) < 7 .AND. mCAT # "02"
      FWRITX(mDFG,8)  // 13
   ELSE
      FWrite(USO,Space(8))
   ENDIF
   IF nGRUP01 = 1
      FWRITX(mNAS,8)  // 14
   ELSE
      FWrite(USO,Space(8))
   ENDIF

   // IF EMPTY(CBONEW)
   // FWRITX( CBO, 5 )                     //15
   // ELSE
   FWRITX("0"+Left(OBTER("FUNCAO",,FO_PES->FUNCAO,"CBONEW"),4),5)
   // ENDIF

   FWRITX(cVAL01,15)  // 16
   FWRITX(cVAL02,15)  // 17
   IF !Empty(CLASSE) .AND. CLASSE < 11 .AND. mMESYYY <> "13"
      FWRITX(CLASSE,2,,1)   // 18
   ELSE
      FWRITX("  ",2)  // 18
   ENDIF
   IF mCAT = "01" .OR. mCAT = "02" .OR. mCAT = "04" .OR. mCAT = "12"
      FWRITX(mOCO,2,,1)   // 19
   ELSE
      FWRITX("  ",2)
   ENDIF
   FWRITX(cVAL03,15)  // 20
   FWRITX(cVAL10,15)  // 21
   FWRITX(cVAL04,15)  // 22
   FWRITX(cVAL11,15)  // 23
   FWrite(USO,Space(98))  // 24
   FWRITX("*",1)  // 25
   IF mDELIM = "S"
      FWrite(USO,Chr(13)+Chr(10))
   ENDIF
ENDIF
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function G2R32()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC G2R32(nTIP)


IF nGRUP01 = 1 .OR. mCAT = "11"
ELSE
   RETU .T.
ENDIF
IF mMESYYY = "13"
   RETU
ENDIF

IF Month(DEMITIDO) = MES .AND. Year(DEMITIDO) = ANO
   FWRITX("32",2)   // 1   //32 Movimento Empregado demiss„o
   FWRITX(TIPREP,1,,1)  // 2
   FWRITX(INSREP,14,,1)   // 3
   FWRITX(cTOM1,1)  // 4 Tomador em Branco
   FWRITX(cTOMA,14)   // 5 Tomador insc em branco
   IF nGRUP01 = 1
      FWRITX(mPIS,11,,1)  // 6
   ELSE
      FWRITX(mCI,11,,1)   // 6
   ENDIF
   IF nGRUP02 = 1
      FWRITX(mADM,8)  // 7
   ELSE
      FWrite(USO,Space(8))  // 7
   ENDIF
   FWRITX(mCAT,2,,1)  // 8
   FWRITX(NOME,70)  // 9
   FWRITX(FGTSMOT,2)  // 10
   FWRITX(mDEM,8)   // 11
   IF Left(FGTSMOT,1) = "I" .OR. Left(FGTSMOT,1) = "L"
      FWRITX(PGFGTS,1)  // 12
   ELSE
      FWRITX(" ",1)   // 12
   ENDIF
   FWrite(USO,Space(225))   // 13
   FWRITX("*",1)  // 14
   IF mDELIM = "S"
      FWrite(USO,Chr(13)+Chr(10))
   ENDIF
ENDIF
IF nTIP = 5
   RETU .T.
ENDIF
dbSelectAr("FO_OCO")
dbGoTop()
dbSeek(Str(mNUMERO,8))
WHILE mNUMERO = NUMERO .AND. !Eof()
   IF !Empty(CODFGS)
      IF (Month(DATASAIDA) = MES .AND. Year(DATASAIDA) = ANO) .OR. ;
                         (Month(DATARETORN) = MES .AND. Year(DATARETORN) = ANO)
         mDATASAIDA := StrZero(Day(DATASAIDA),2)+StrZero(Month(DATASAIDA),2)+StrZero(Year(DATASAIDA),4)
         FWRITX("32",2)   // 1   //32 Movimento Empregado demiss„o
         FWRITX(TIPREP,1,,1)  // 2
         FWRITX(INSREP,14,,1)   // 3
         FWRITX(cTOM1,1)  // 4 Tomador em Branco
         FWRITX(cTOMA,14)   // 5 Tomador insc em branco
         IF nGRUP01 = 1
            FWRITX(mPIS,11,,1)  // 6
         ELSE
            FWRITX(mCI,11,,1)   // 6
         ENDIF
         IF nGRUP02 = 1
            FWRITX(mADM,8)  // 7
         ELSE
            FWrite(USO,Space(8))  // 7
         ENDIF
         FWRITX(mCAT,2,,1)  // 8
         FWRITX(mNOME,70)   // 9
         FWRITX(CODFGS,2)   // 10
         FWRITX(mDATASAIDA,8)   // 11
         FWRITX(PGFGS,1)  // 12
         FWrite(USO,Space(225))   // 13
         FWRITX("*",1)  // 14
         IF mDELIM = "S"
            FWrite(USO,Chr(13)+Chr(10))
         ENDIF
      ENDIF
      IF Month(DATARETORN) = MES .AND. Year(DATARETORN) = ANO
         mDATARETOR := StrZero(Day(DATARETORN),2)+StrZero(Month(DATARETORN),2)+StrZero(Year(DATARETORN),4)
         FWRITX("32",2)   // 1   //32 Movimento Empregado demiss„o
         FWRITX(TIPREP,1,,1)  // 2
         FWRITX(INSREP,14,,1)   // 3
         FWRITX(cTOM1,1)  // 4 Tomador em Branco
         FWRITX(cTOMA,14)   // 5 Tomador insc em branco
         FWRITX(mPIS,11,,1)   // 6
         FWRITX(mADM,8)   // 7
         FWRITX(mCAT,2,,1)  // 8
         FWRITX(mNOME,70)   // 9
         FWRITX(CODFGR,2)   // 10
         FWRITX(mDATARETOR,8)   // 11
         FWRITX(PGFGR,1)  // 12
         FWrite(USO,Space(225))   // 13
         FWRITX("*",1)  // 14
         IF mDELIM = "S"
            FWrite(USO,Chr(13)+Chr(10))
         ENDIF
      ENDIF
   ENDIF
   dbSkip()
ENDDO
RETU .T.



*+ EOF: fohg2.prg
*+

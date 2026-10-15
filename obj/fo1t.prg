*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo1t.prg
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
*+    Documentado em 15-Out-2026 as 12:36 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :       FO1T.PRG: Tela para Edicao de Dados do Cadastro da Firma
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1997,  jcassiano  S/C Ltda.
// :  Atualizado em: 02/10/97
// :
// :*****************************************************************************
@  3,0 CLEAR
@  3,0  SAY "É C¢digo » Cognome "+Replicate('Í',7)+"» Raz„o "+Replicate('Í',35)+"» Pessoa Í»"                  
@  4,0  SAY "º"+spac(8)+"º"+spac(16)+"º"+spac(42)+"º (F/J/C) º"                                                
@  5,0  SAY "Ç"+Replicate('Ä',8)+"Ð"+Replicate('Ä',16)+"Ð"+Replicate('Ä',42)+"Ð"+Replicate('Ä',9)+"¶"          
@  6,0  SAY "º Endere‡o:"+spac(34)+"Bairro:"+spac(27)+"º"                                                      
@  7,0  SAY "º CEP:"+spac(12)+"Cidade:"+spac(17)+"UF:"+spac(34)+"º"                                            
@  8,0  SAY "º DDD:"+spac(7)+"FONE:"+spac(12)+"Ramal:"+spac(8)+"FAX:"+spac(11)+"Simples:   (S/N)    º"         
@  9,0  SAY "º Responsavel:"+spac(42)+"CPF:"+spac(19)+"º"                                                      
@ 10,0  SAY "Ç"+Replicate('Ä',38)+"Â"+Replicate('Ä',39)+"¶"                                                    
@ 10,50 SAY "Data Nscto Resp:"                                                                                 
@ 11,0  SAY "º C.G.C.   :"+spac(27)+"³ Tabela de Pre‡o Refei‡”es"+spac(13)+"º"                                 
@ 12,0  SAY "º Ins.Est. :"+spac(27)+"³ Jan ="+spac(14)+"Jul ="+spac(14)+"º"                                    
@ 13,0  SAY "º C.E.I.   :"+spac(27)+"³ Fev ="+spac(14)+"Ago ="+spac(14)+"º"                                    
@ 14,0  SAY "º Convenio CAGED :"+spac(21)+"³ Mar ="+spac(14)+"Set ="+spac(14)+"º"                              
@ 15,0  SAY "º Natureza Estabelecimento :"+spac(11)+"³ Abr ="+spac(14)+"Out ="+spac(14)+"º"                    
@ 16,0  SAY "º Horas Trabalhadas mˆs:"+spac(15)+"³ Mai ="+spac(14)+"Nov ="+spac(14)+"º"                        
@ 17,0  SAY "º Arredondamento Pagto :"+spac(15)+"³ Jul ="+spac(14)+"Dez ="+spac(14)+"º"                        
@ 18,0  SAY "º Valor Normativo"+spac(12)+"p/hora    Ã"+Replicate('Ä',39)+"¶"                                   
@ 19,0  SAY "º S¢cios :    Familiares:    PROD:     ³ IRRF Competˆncia dentro do mˆs:   S/N º"                 
@ 20,0  SAY "º CNAE:               -"+spac(16)+"³ Codigo Acidente Trabalho GRPS:"+spac(8)+"º"                  
@ 21,0  SAY "º           "+spac(7)+"Inicia Ano:"+spac(9)+"³ Categoria FGTS:    FPAS GRPS:"+spac(9)+"º"         
@ 22,0  SAY "º Cod.Cidade IBGE:"+spac(21)+"³ Email:"+spac(32)+"º"                                              
@ 23,0  SAY "È"+Replicate('Í',38)+"Ï"+Replicate('Í',39)+"¼"                                                    
RETU

// : FIM: FO1T.PRG


*+ EOF: fo1t.prg
*+

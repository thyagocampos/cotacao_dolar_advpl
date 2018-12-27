#include 'protheus.ch'
#include 'parmtype.ch'

//Obtém a cotação do dólar do dia anterior, via webservice e faz a atualização da tabela M2
//Autor: Thyago Silva Campos

user function DolDiaAnt()		
	Local oWs 		:= WSFachadaWSSGSService():NEW()	//Webservice		
	Local cError 	:= ""								//Controle de erro webservice
	Local cWarning	:= ""								//Controle de aviso webservice
	Local aValores	:= {}								//Vetor a ser utilizado execauto	
	
	Local oXmlDolar	:= NIL								//Guarda o resultado da consulta $
	Local oXmlEuro	:= NIL								//Guarda o resultado da consulta €
	Local oXmlLibra	:= NIL								//Guarda o resultado da consulta £
	Local oXmlIene	:= NIL								//Guarda o resultado da consulta ¥	
	
	oWs:getUltimoValorXML(1)							//Obtendo cotação Dólar
	oXmlDolar := XmlParser(oWs:cgetUltimoValorXMLReturn, "_", @cError, @cWarning)
	
	oWs:getUltimoValorXML(21619)						//Obtendo cotação Euro
	oXmlEuro := XmlParser(oWs:cgetUltimoValorXMLReturn, "_", @cError, @cWarning)
	
	oWs:getUltimoValorXML(21621)						//Obtendo cotação Libra
	oXmlLibra := XmlParser(oWs:cgetUltimoValorXMLReturn, "_", @cError, @cWarning)
	
	oWs:getUltimoValorXML(21623)			 			//Obtendo cotação Iene
	oXmlIene := XmlParser(oWs:cgetUltimoValorXMLReturn, "_", @cError, @cWarning)	

	//Inserindo as cotações na tabela de moedas
    DbSelectArea("SM2")
	DbSetOrder(1)
	IF MsSeek(Date())		
		Reclock("SM2",.F.) 
		SM2->M2_MOEDA2 := Val(StrTran(oXmlDolar:_RESPOSTA:_SERIE:_VALOR:TEXT,",","."))
		SM2->M2_MOEDA4 := Val(StrTran(oXmlEuro:_RESPOSTA:_SERIE:_VALOR:TEXT,",","."))
		SM2->M2_MOEDA5 := Val(StrTran(oXmlLibra:_RESPOSTA:_SERIE:_VALOR:TEXT,",","."))
		SM2->M2_MOEDA6 := Val(StrTran(oXmlIene:_RESPOSTA:_SERIE:_VALOR:TEXT,",","."))
		MsUnlock("SM2") 		
	End If
		
Return
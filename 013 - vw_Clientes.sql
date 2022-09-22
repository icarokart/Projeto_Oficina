/*-------------------------------------------------------------------------------
Nome: vw_Clientes
Data de Criação: 22/09/2022
Autor: Ícaro Rodrigues
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.[vw_Clientes]'))
	Drop View dbo.vw_Clientes
Go

Create View dbo.vw_Clientes As

SELECT    C.ID_CLIENTE
		, C.SIT_CLIENTE
		, C.DT_CADASTRO
		, P.ID_PESSOA
		, P.NOME_PESSOA
		, P.TELEFONE1
		, P.TELEFONE2
		, P.WHATSAPP
		, P.CEP
		, P.LOGRADOURO
		, P.COMPLEMENTO
		, P.NUMERO_CASA
		, P.ID_PESSOA
		, CD.NOME_CIDADE
		, E.NOME_ESTADO
		, E.SIGLA_ESTADO
		, E.NOME_PAIS
		, P.CPF
		, P.RG
		, P.EMAIL
		, P.GENERO
		, P.OBSERVACOES

FROM CLIENTES C
	JOIN PESSOAS P
		ON (C.ID_PESSOA = P.ID_PESSOA)
	LEFT JOIN CIDADES CD
		ON (P.ID_CIDADE = CD.ID_CIDADE)
	LEFT JOIN ESTADOS E
		ON (CD.ID_ESTADO = E.ID_ESTADO)

Go


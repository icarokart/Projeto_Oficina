/*-------------------------------------------------------------------------------
Nome: vw_Produtos
Data de Cria��o: 22/09/2022
Autor: �caro Rodrigues
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.[vw_Produtos]'))
	Drop View dbo.vw_Produtos
Go

Create View dbo.vw_Produtos As

SELECT  P.ID_PRODUTO
	   , P.NOME_PRODUTO
	   , P.MARCA
	   , P.LINHA
	   , TPE.QTD_ESTOQUE
	   , TPE.PRECO_UND AS PRE�O_UN_ATUAL
	   , TPE.LOTE_ATUAL

FROM PRODUTOS P
	JOIN TOTAL_PRODUTOS_ESTOQUE TPE
		ON (P.ID_PRODUTO = TPE.ID_PRODUTO)

Go
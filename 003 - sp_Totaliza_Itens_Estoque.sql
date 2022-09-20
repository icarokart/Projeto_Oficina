/*-------------------------------------------------------------------------------
Nome: sp_Totaliza_Itens_Estoque
Data de Criação: 19/09/2022
Autor: Ícaro Rodrigues

Descrição: Totaliza a quantidade atual de itens da entrada do estoque e, em seguida, atualiza a tabela "TOTAL_PRODUTOS_ESTOQUE" com esse novo valor
-------------------------------------------------------------------------------*/
If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.sp_Totaliza_Itens_Estoque'))
     Drop Procedure dbo.sp_Totaliza_Itens_Estoque
Go

Create Procedure [dbo].sp_Totaliza_Itens_Estoque
(
       @ID_PRODUTO INT
) As
Begin
     Set NoCount On;

		DECLARE
			@TOTAL_ITENS INT

			--SOMATÓRIA DA QUANTIDADE TOTAL DE ITENS CADASTRADOS NO ESTOQUE
			SET @TOTAL_ITENS = (SELECT SUM(NUM_ITENS_ATUAL)
								FROM ENTRADAS_ESTOQUE
								WHERE ID_PRODUTO = @ID_PRODUTO)


			BEGIN
				UPDATE TOTAL_PRODUTOS_ESTOQUE
				SET QTD_ESTOQUE = @TOTAL_ITENS
				WHERE ID_PRODUTO = @ID_PRODUTO
			END
		

     Set NoCount Off;
End

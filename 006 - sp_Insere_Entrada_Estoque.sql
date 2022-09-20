/*-------------------------------------------------------------------------------
Nome: sp_Insere_Entrada_Estoque
Data de Criação: 13/09/2022
Autor: Ícaro Rodrigues
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.sp_Insere_Entrada_Estoque'))
     Drop Procedure dbo.sp_Insere_Entrada_Estoque
Go

Create Procedure dbo.sp_Insere_Entrada_Estoque
(
       @ID_PRODUTO INT,
	   @QTD_ENTRADA INT,
	   @PRECO_UN NUMERIC(7,2),
	   @N_NOTA_FISCAL INT,
	   @LOTE VARCHAR(20)
) As
Begin
     Set NoCount On;
     
		DECLARE
			@NOME_PRODUTO VARCHAR(50),
			@DT_ENTRADA DATETIME,
			@LOTE_ABERTO BIT = 0 --Por padrão, cada novo pacote entrará "fechado" || 0 - Fechado / 1 - Aberto

		SELECT @NOME_PRODUTO = P.NOME_PRODUTO
		FROM PRODUTOS P
		WHERE P.ID_PRODUTO = @ID_PRODUTO


		SET @DT_ENTRADA = (SELECT GETDATE())

		--CASO NAO HAJA UM LOTE DO PRODUTO EM ABERTO, INICIA O NOVO LOTE EM ABERTO
		IF NOT EXISTS(SELECT 1 FROM ENTRADAS_ESTOQUE WHERE ID_PRODUTO = @ID_PRODUTO AND NUM_ITENS_ATUAL > 0 AND ABERTO = 1)
		BEGIN
			SET @LOTE_ABERTO = 1

			--FECHA O LOTE ANTERIOR 
			UPDATE ENTRADAS_ESTOQUE
			SET ABERTO = 0
			WHERE ID_PRODUTO = @ID_PRODUTO
				AND NUM_ITENS_ATUAL = 0
					AND ABERTO = 1
		END
		
		--teste de saída
		--select @ID_PRODUTO
		--	 , @NOME_PRODUTO
		--	 , @QTD_ENTRADA
		--	 , @DT_ENTRADA
		--	 , @PRECO_UN
		--	 , @N_NOTA_FISCAL
		--	 , @LOTE

		BEGIN
			INSERT ENTRADAS_ESTOQUE  ([ID_PRODUTO]
									, [NOME_PRODUTO]
									, [QTD_ENTRADA]
									, [DT_ENTRADA]
									, [NUM_ITENS_ATUAL]
									, [PRECO_UN]
									, [NUM_NOTA_FISCAL]
									, [LOTE]
									, [ABERTO])
		
			VALUES					 (@ID_PRODUTO
									, @NOME_PRODUTO
									, @QTD_ENTRADA
									, @DT_ENTRADA
									, @QTD_ENTRADA
									, @PRECO_UN
									, @N_NOTA_FISCAL
									, @LOTE
									, @LOTE_ABERTO)
		END
          
     Set NoCount Off;
End
Go
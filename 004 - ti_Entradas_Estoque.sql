/*-------------------------------------------------------------------------------
Nome: ti_Entradas_Estoque
Data de Criação: 12/09/2022
Autor: Ícaro Rodrigues
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.ti_Entradas_Estoque'))
     Drop Trigger dbo.ti_Entradas_Estoque
Go

Create Trigger dbo.ti_Entradas_Estoque On Entradas_Estoque After INSERT As
Begin
     Set NoCount On;

     If TRIGGER_NESTLEVEL(OBJECT_ID('ti_Entradas_Estoque')) > 1
          Return;
          
     DECLARE
			@ID_PRODUTO INT,
			@ID_ENTRADA INT,
			@NOME_PRODUTO VARCHAR(50),
			@QTD_ENTRADA INT,
			@PRECO_UND NUMERIC(7,2),
			@LOTE_ATUAL VARCHAR(20),
			@PRECO_UN_ATUAL NUMERIC(7,2),
			@QTD_PRODUTOS_TPE INT,
			@DT_ENTRADA DATETIME


	--valores de entrada
	SELECT @ID_PRODUTO =   I.ID_PRODUTO,
		   @ID_ENTRADA =   I.ID_ENTRADA,
		   @QTD_ENTRADA =  I.QTD_ENTRADA,
		   @PRECO_UND =    I.PRECO_UN,
		   @LOTE_ATUAL =   I.LOTE,
		   @NOME_PRODUTO = P.NOME_PRODUTO
	
	FROM inserted I
		join Produtos P
			On (I.ID_PRODUTO = P.ID_PRODUTO)

	
	IF EXISTS(SELECT 1 FROM TOTAL_PRODUTOS_ESTOQUE WHERE ID_PRODUTO = @ID_PRODUTO)
	BEGIN
		SET @QTD_ENTRADA = @QTD_ENTRADA + (SELECT QTD_ESTOQUE FROM TOTAL_PRODUTOS_ESTOQUE WHERE ID_PRODUTO = @ID_PRODUTO)
	END

	--SE HOUVER UM LOTE DO MESMO PRODUTO EM ABERTO:...
	IF EXISTS(SELECT 1 FROM ENTRADAS_ESTOQUE WHERE ID_PRODUTO = @ID_PRODUTO AND NUM_ITENS_ATUAL > 0 AND ID_ENTRADA <> @ID_ENTRADA)
		BEGIN
			--mantem a informação do lote igual ao lote em aberto
			SET @LOTE_ATUAL = (	SELECT LOTE
								FROM ENTRADAS_ESTOQUE
								WHERE ID_PRODUTO = @ID_PRODUTO
										AND NUM_ITENS_ATUAL > 0
										AND DT_ENTRADA = (SELECT MIN(DT_ENTRADA)
														  FROM ENTRADAS_ESTOQUE
														  WHERE ID_PRODUTO = @ID_PRODUTO
																AND ID_ENTRADA <> @ID_ENTRADA))

			-- mantem o preço do lote em aberto
			SET @PRECO_UN_ATUAL = (	SELECT PRECO_UN
									FROM ENTRADAS_ESTOQUE
									WHERE ID_PRODUTO = @ID_PRODUTO
										AND ID_ENTRADA <> @ID_ENTRADA
										AND NUM_ITENS_ATUAL > 0
										AND DT_ENTRADA = (SELECT MIN(DT_ENTRADA)
														  FROM ENTRADAS_ESTOQUE
														  WHERE ID_PRODUTO = @ID_PRODUTO
																AND ID_ENTRADA <> @ID_ENTRADA))
		END

		--SE NAO HOUVER LOTE DO PRODUTO EM ABERTO:...
		IF NOT EXISTS(SELECT 1 FROM ENTRADAS_ESTOQUE WHERE ID_PRODUTO = @ID_PRODUTO AND NUM_ITENS_ATUAL > 0 AND ID_ENTRADA <> @ID_ENTRADA)
		BEGIN
			--ATUALIZA A TABELA DE ESTOQUE COM O PREÇO UNITÁRIO INFORMADO NO LOTE QUE ESTÁ ENTRANDO
			SET @PRECO_UN_ATUAL = @PRECO_UND
		END

	--ATRIBUINDO A TABELA DE ESTOQUE:

	--se ainda nao houver registro, cria um novo na totalização do estoque
	IF NOT EXISTS  (SELECT 1 FROM TOTAL_PRODUTOS_ESTOQUE TPE WHERE ID_PRODUTO = @ID_PRODUTO)

		BEGIN
			INSERT TOTAL_PRODUTOS_ESTOQUE([ID_PRODUTO], [NOME_PRODUTO], [QTD_ESTOQUE], [PRECO_UND], [LOTE_ATUAL])
			VALUES						 (@ID_PRODUTO, @NOME_PRODUTO, @QTD_ENTRADA, @PRECO_UND, @LOTE_ATUAL)
		END
	
	----se ja houver registros, atualiza a quantidade de produtos, o preço e o lote
	IF EXISTS  (SELECT 1 FROM TOTAL_PRODUTOS_ESTOQUE TPE WHERE TPE.ID_PRODUTO = @ID_PRODUTO)

		BEGIN
			UPDATE TOTAL_PRODUTOS_ESTOQUE
			SET QTD_ESTOQUE = @QTD_ENTRADA,
				PRECO_UND = @PRECO_UN_ATUAL,
				LOTE_ATUAL = @LOTE_ATUAL
			--SELECT *
			FROM TOTAL_PRODUTOS_ESTOQUE TPE
			WHERE ID_PRODUTO = @ID_PRODUTO
		END
			  
     Set NoCount Off;
End
Go

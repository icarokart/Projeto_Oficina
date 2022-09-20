/*-------------------------------------------------------------------------------
Nome: tu_Entradas_Estoque
Data de Criação: 12/09/2022
Autor: Ícaro Rodrigues 

Alterações:
	[19/09/2022 - Ícaro] => Refatoração e alteração da lógica de funcionamento.
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.[tu_Entradas_Estoque]'))
     Drop Trigger dbo.tu_Entradas_Estoque
Go

Create Trigger dbo.tu_Entradas_Estoque On Entradas_Estoque After UPDATE As
Begin
      Set NoCount On;

     If TRIGGER_NESTLEVEL(OBJECT_ID('tu_Entradas_Estoque')) > 1
          Return;
          
	DECLARE
		@QTD_ITENS_ATUAL INT,
		@ID_PRODUTO INT,
		@PRECO_UN NUMERIC(7,2),
		@ID_ENTRADA INT,
		@LOTE_ATUAL VARCHAR(20)


		SELECT	@ID_PRODUTO = I.ID_PRODUTO,
				@PRECO_UN = I.PRECO_UN,
				@ID_ENTRADA = I.ID_ENTRADA,
				@QTD_ITENS_ATUAL = I.NUM_ITENS_ATUAL
		FROM inserted I



	--VERIFICA SE O LOTE EM ABERTO AINDA POSSUI PRODUTOS, CASO NÃO, FECHA O LOTE ATUAL E ABRE O PROXIMO COM A DATA MAIS PROXIMA
     IF UPDATE (NUM_ITENS_ATUAL)
	 BEGIN
		IF (@QTD_ITENS_ATUAL = 0)
		 BEGIN
			EXEC DBO.sp_Atualiza_Lote_Estoque @ID_PRODUTO
		 END

		 EXEC dbo.sp_Totaliza_Itens_Estoque @ID_PRODUTO
	 END

          
     Set NoCount Off;
End
Go

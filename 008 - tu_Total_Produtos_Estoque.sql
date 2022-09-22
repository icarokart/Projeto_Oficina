/*-------------------------------------------------------------------------------
Nome: tu_Total_Produtos_Estoque
Data de Cria��o: 15/09/2022
Autor: �caro Rodrigues
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.[tu_Total_Produtos_Estoque]'))
     Drop Trigger dbo.tu_Total_Produtos_Estoque
Go

Create Trigger dbo.tu_Total_Produtos_Estoque On Total_Produtos_Estoque for UPDATE As
Begin
     Set NoCount On;

     If TRIGGER_NESTLEVEL(OBJECT_ID('tu_Total_Produtos_Estoque')) > 1
          Return;
          
	Declare
		@ID_PRODUTO INT,
		@QTD_ITENS INT,
		@PRE�O_UN NUMERIC(7,2)


		SELECT @ID_PRODUTO = I.ID_PRODUTO
		FROM inserted I

	---alouu


     Set NoCount Off;
End
Go

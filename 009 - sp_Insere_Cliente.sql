/*-------------------------------------------------------------------------------
Nome: sp_Insere_Cliente
Data de Criação: 20/09/2022
Autor: Ícaro Rodrigues

Descrição: 
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.[sp_Insere_Cliente]'))
     Drop Procedure dbo.sp_Insere_Cliente
Go

Create Procedure dbo.sp_Insere_Cliente
(
	--TABELA "PESSOAS"
     @NOME_PESSOA VARCHAR(50),
	 @TELEFONE1 VARCHAR(14), 
	 @TELEFONE2 VARCHAR(14), 
	 @WHATSAPP VARCHAR(14), 
	 @CEP INT,
	 @LOGRADOURO VARCHAR(150), 
	 @COMPLEMENTO VARCHAR(50), 
	 @NUMERO_CASA SMALLINT, 
	 @ID_CIDADE INT, 
	 @CPF VARCHAR(11), 
	 @RG INT, 
	 @EMAIL VARCHAR(30), 
	 @GENERO CHAR, 
	 @OBSERVACOES VARCHAR(500),

	 --TABELA "CLIENTES"
	@ID_PESSOA INT, 
	@SIT_CLIENTE TINYINT

) As
Begin
     Set NoCount On;
     
	 BEGIN
		INSERT PESSOAS([NOME_PESSOA], [TELEFONE1], [TELEFONE2], [WHATSAPP], [CEP],[LOGRADOURO], [COMPLEMENTO], [NUMERO_CASA], [ID_CIDADE], [CPF], [RG], [EMAIL], [GENERO])
		VALUES (@NOME_PESSOA, @TELEFONE1, @TELEFONE2, @WHATSAPP, @CEP, @LOGRADOURO, @COMPLEMENTO, @NUMERO_CASA, @ID_CIDADE, @CPF, @RG, @EMAIL, @GENERO, @OBSERVACOES)
	 END

	 BEGIN
		INSERT CLIENTES ([ID_PESSOA], [SIT_CLIENTE], [DT_CADASTRO], [OBSERVACOES])
		VALUES (@ID_PESSOA, @SIT_CLIENTE, GETDATE(), @OBSERVACOES)
	 END
     
          
     Set NoCount Off;
End
Go

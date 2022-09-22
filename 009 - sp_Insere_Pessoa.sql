If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.sp_Insere_Pessoa'))
     Drop Procedure dbo.NOME_PROCEDURE
Go

Create Procedure dbo.sp_Insere_Pessoa
(
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
	 @OBSERVACOES VARCHAR(500)
) As
Begin
     Set NoCount On;
     
	BEGIN
				INSERT PESSOAS([NOME_PESSOA]
						 	 , [TELEFONE1]
						 	 , [TELEFONE2]
						 	 , [WHATSAPP]
						 	 , [CEP]
						 	 , [LOGRADOURO]
						 	 , [COMPLEMENTO]
						 	 , [NUMERO_CASA]
						 	 , [ID_CIDADE]
							 , [CPF]
							 , [RG]
							 , [EMAIL]
							 , [GENERO]
							 , [OBSERVACOES])
				
				VALUES (
							  @NOME_PESSOA
							, @TELEFONE1
							, @TELEFONE2
							, @WHATSAPP
							, @CEP
							, @LOGRADOURO
							, @COMPLEMENTO
							, @NUMERO_CASA
							, @ID_CIDADE
							, @CPF
							, @RG
							, @EMAIL
							, @GENERO
							, @OBSERVACOES)
			 END
          
     Set NoCount Off;
End
Go




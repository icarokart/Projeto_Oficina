If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.sp_Insere_Funcionario'))
     Drop Procedure dbo.sp_Insere_Funcionario
Go

Create Procedure dbo.sp_Insere_Funcionario
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
	 @OBSERVACOES VARCHAR(500),

	 @REG_FUNCIONARIO INT,
	 @DT_CONTRATACAO DATETIME,
	 @SALARIO NUMERIC(7,2),
	 @DT_CADASTRO DATETIME,
	 @OBS_FUNCIONARIO VARCHAR(500),
	 @SIT_FUNCIONARIO TINYINT
) As
Begin
     Set NoCount On;
     
	 BEGIN TRANSACTION
		--inserindo a pessoa
		BEGIN
			EXEC dbo.sp_Insere_pessoa @NOME_PESSOA
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
									, @OBSERVACOES
		END

		BEGIN
			
		END

	 COMMIT TRANSACTION

     Set NoCount Off;
End
Go




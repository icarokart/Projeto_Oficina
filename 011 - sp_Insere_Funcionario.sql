/*-------------------------------------------------------------------------------
Nome: sp_Insere_Funcionario
Data de Criação: 22/09/2022
Autor: Ícaro Rodrigues

Descrição: 
-------------------------------------------------------------------------------*/
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
	 @OBS_FUNCIONARIO VARCHAR(500)
) As
Begin
     Set NoCount On;

	 DECLARE
		@ID_PESSOA INT,
		@SIT_FUNCIONARIO TINYINT

	SET @SIT_FUNCIONARIO = 0 --ENTRA ATIVO POR PADRÃO
     
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

		SET @ID_PESSOA = (SELECT MAX(ID_PESSOA) FROM PESSOAS)

		BEGIN
			INSERT FUNCIONARIOS(  [ID_PESSOA]
								, [REGISTRO_FUNCIONARIO]
								, [DT_CONTRATACAO]
								, [SALARIO]
								, [DT_CADASTRO]
								, [OBSERVACOES]
								, [DT_DEMISSAO]
								, [SIT_FUNCIONARIO])
			VALUES(
								  @ID_PESSOA
								, @REG_FUNCIONARIO
								, @DT_CONTRATACAO
								, @SALARIO
								, GETDATE()
								, @OBS_FUNCIONARIO
								, NULL
								, @SIT_FUNCIONARIO)
		END

	 COMMIT TRANSACTION

     Set NoCount Off;
End
Go
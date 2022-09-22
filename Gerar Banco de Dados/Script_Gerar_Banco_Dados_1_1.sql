/*
SCRIPT DE GERAÇÃO DO BANCO DE DADOS

AUTOR: ICARO RODRIGUES
DATA DE CRIAÇÃO: 14/09/2022

ALTERAÇÕES:
	[19/09/2022 - Ícaro] => 1 - versão 1.0: Entradas de estoque funcionando e calculando corretamente os valores.
							
							2 - refatorado alguns dos procedimentos armazenados utilizados nos procedimentos.
							
							3 - Alterado a lógica de funcionamento do objeto "tu_Entradas_Estoque".
							
							4 - Criados os procedimentos "sp_Atualiza_Lote_Estoque" e "sp_Totaliza_Itens_Estoque" sendo:
								*** sp_Atualiza_Lote_Estoque: Fecha o lote atual cujo o numero de itens atuais do pacote chegou a zero, 
															  e abre (se houver) o novo pacote do mesmo produto atualizando as informações na tabela "TOTAL_PRODUTOS_ESTOQUE".

								*** sp_Totaliza_Itens_Estoque: faz a somatória da quantidade atual de itens do estoque e atualiza a tabela "TOTAL_PRODUTOS_ESTOQUE" com os valores.
							
							5 - Triggers atuais alteradas do tipo "FOR" para o tipo "AFTER".


	[22/09/2022 - Ícaro] => 1 - Ajustado a estrutura de tabelas e relacionamentos.

							2 - Ajustada a logica de cadastro de clientes. Como o sistema terá registros de funcionários, a tabela cliente foi refatorada nas 
								seguintes tabelas: PESSOAS, CLIENTES E FUNCIONARIOS.

							3 - Criado os procedimentos de inserção de pessoa, cliente e funcionário.

							4 - Criadas as views de Produtos e Clientes.

							5 - Criada a tabela SITUACOES_SISTEMA para guardar situações adversar das tabelas do BD.

*/


--001
/*-------------------------------------------------------------------------------
Nome: Tabelas e relacionamentos
Data de Criação: 10/09/2022
Autor: Icaro Rodrigues

Descrição: Todas as tabelas e relacionamentos (até então) do sistema.
-------------------------------------------------------------------------------*/

USE TESTE_ICARO
GO

CREATE TABLE ESTADOS(
	ID_ESTADO INT IDENTITY(1,1) NOT NULL,
	NOME_ESTADO VARCHAR(30) NOT NULL,
	NOME_PAIS VARCHAR(30) NOT NULL,
	SIGLA_ESTADO VARCHAR(2) NOT NULL
	
	CONSTRAINT PK_ID_ESTADO PRIMARY KEY (ID_ESTADO)
)
GO

CREATE TABLE CIDADES(
	ID_CIDADE INT IDENTITY(1,1) NOT NULL,
	NOME_CIDADE VARCHAR(30) NOT NULL,
	ID_ESTADO INT NOT NULL,
	COD_POSTAL INT NULL

	CONSTRAINT PK_ID_CIDADE PRIMARY KEY (ID_CIDADE),

	CONSTRAINT FK_ID_ESTADO__CIDADES FOREIGN KEY (ID_ESTADO)
	REFERENCES ESTADOS (ID_ESTADO)
)
GO

CREATE TABLE SITUACOES_SISTEMA(
	NOME_TABELA VARCHAR(50) NOT NULL,
	NOME_COLUNA VARCHAR(50) NOT NULL,
	VALOR TINYINT NULL,
	VALOR_CHAR CHAR NULL,
	SITUACAO VARCHAR(30) NOT NULL,
	DESC_SITUACAO VARCHAR(100) NULL
)

CREATE TABLE PESSOAS(
	ID_PESSOA INT IDENTITY(1,1) NOT NULL,
	NOME_PESSOA VARCHAR(50) NOT NULL,
	TELEFONE1 VARCHAR(14) NULL,
	TELEFONE2 VARCHAR(14) NULL,
	WHATSAPP VARCHAR(14) NULL,
	CEP INT NULL,
	LOGRADOURO VARCHAR(150) NULL,
	COMPLEMENTO VARCHAR (50) NULL, 
	NUMERO_CASA SMALLINT NULL,
	ID_CIDADE INT NULL,
	CPF VARCHAR(11) NULL, --SOMENTE NUMEROS
	RG INT NULL,
	EMAIL VARCHAR(30)NULL,
	GENERO CHAR NOT NULL,
	OBSERVACOES VARCHAR (500) NULL

	CONSTRAINT PK_ID_PESSOA PRIMARY KEY (ID_PESSOA),

	CONSTRAINT FK_ID_CIDADE__PESSOAS FOREIGN KEY (ID_CIDADE)
	REFERENCES CIDADES (ID_CIDADE), 
)
GO

CREATE TABLE CLIENTES(
	 ID_CLIENTE INT IDENTITY(1,1) NOT NULL,
	 ID_PESSOA INT NOT NULL,
	 SIT_CLIENTE TINYINT NOT NULL,
	 DT_CADASTRO DATETIME NOT NULL

	 CONSTRAINT PK_ID_CLIENTE PRIMARY KEY (ID_CLIENTE),

	 CONSTRAINT FK_ID_PESSOA__CLIENTES FOREIGN KEY (ID_PESSOA)
	 REFERENCES PESSOAS (ID_PESSOA)
)
GO

CREATE TABLE FUNCIONARIOS(
	ID_FUNCIONARIO INT IDENTITY(1,1) NOT NULL,
	ID_PESSOA INT NOT NULL,
	REGISTRO_FUNCIONARIO INT NULL,
	DT_CONTRATACAO DATETIME NULL,
	SALARIO NUMERIC(7,2) NULL,
	DT_CADASTRO DATETIME NOT NULL,
	OBSERVACOES VARCHAR(500) NULL,
	DT_DEMISSAO DATETIME NULL,
	SIT_FUNCIONARIO TINYINT NOT NULL

	CONSTRAINT PK_ID_FUNCIONARIO PRIMARY KEY (ID_FUNCIONARIO),

	CONSTRAINT FK_ID_PESSOA__FUNCIONARIOS FOREIGN KEY (ID_FUNCIONARIO)
	REFERENCES PESSOAS (ID_PESSOA)
)
GO

CREATE TABLE FORNECEDORES(
	ID_FORNECEDOR INT IDENTITY(1,1) NOT NULL,
	NOME_FORNECEDOR VARCHAR(50) NOT NULL,
	RAZAO_SOCIAL VARCHAR(100) NULL,
	CNPJ VARCHAR(14) NULL, --SOMENTE NUMEROS
	TELEFONE1 VARCHAR(14) NOT NULL,
	TELEFONE2 VARCHAR(14) NULL,
	EMAIL VARCHAR(30) NULL,
	RESPONSAVEL VARCHAR(30) NULL,
	SIT_FORNECEDOR TINYINT NOT NULL

	CONSTRAINT PK_ID_FORNECEDOR PRIMARY KEY (ID_FORNECEDOR)
)
GO

CREATE TABLE VEICULOS(
	ID_VEICULO INT IDENTITY(1,1) NOT NULL,
	PLACA VARCHAR(7) UNIQUE NOT NULL,
	TIPO_VEICULO VARCHAR(10) NOT NULL,
	COR VARCHAR(15) NOT NULL,
	ANO_MODELO SMALLINT NULL,
	MODELO_VEICULO VARCHAR(10) NOT NULL,
	OBSERVACOES VARCHAR(500) NULL

	CONSTRAINT PK_ID_VEICULO PRIMARY KEY (ID_VEICULO)
)
GO

CREATE TABLE CLIENTES_VEICULOS(
	ID_CLIENTE INT NOT NULL,
	ID_VEICULO INT NOT NULL,

	CONSTRAINT FK_ID_CLIENTE__CLIENTES_VEICULOS FOREIGN KEY (ID_CLIENTE)
	REFERENCES CLIENTES (ID_CLIENTE),

	CONSTRAINT FK_ID_VEICULO__CLIENTES_VEICULOS FOREIGN KEY (ID_VEICULO)
	REFERENCES VEICULOS (ID_VEICULO)
)
GO

CREATE TABLE PRODUTOS(
	ID_PRODUTO INT IDENTITY(1,1) NOT NULL,
	NOME_PRODUTO VARCHAR(50) NOT NULL,
	MARCA VARCHAR(25) NULL, --DIVIDIR EM POSSIVEL TABELA DE MARCAS
	LINHA VARCHAR(25) NULL,
	QTD_ESTOQUE INT NULL

	CONSTRAINT PK_ID_PRODUTO PRIMARY KEY (ID_PRODUTO)
)
GO

CREATE TABLE PROCEDIMENTOS(
	ID_PROCEDIMENTO INT IDENTITY(1,1) NOT NULL,
	NOME_PROCEDIMENTO VARCHAR(50) NOT NULL,
	OBSERVACOES VARCHAR(500) NULL

	CONSTRAINT PK_ID_PROCEDIMENTO PRIMARY KEY (ID_PROCEDIMENTO)
)
GO

CREATE TABLE ENTRADAS_ESTOQUE(
	ID_ENTRADA INT IDENTITY(1,1) NOT NULL,
	ID_PRODUTO INT NOT NULL,
	NOME_PRODUTO VARCHAR(50) NOT NULL,
	QTD_ENTRADA INT NOT NULL, 
	DT_ENTRADA DATETIME NOT NULL,
	DT_ULTIMA_ALTERACAO DATETIME NULL,
	NUM_ITENS_ATUAL INT NOT NULL,
	PRECO_UN NUMERIC(7,2) NOT NULL,
	VALOR_VENDA NUMERIC(7,2) NULL, --ALTERAR PARA NOT NULL POR QUESTÃO DE INTEGRIDADE DOS DADOS
	NUM_NOTA_FISCAL INT NULL,
	LOTE VARCHAR(20) NOT NULL,
	ID_FORNECEDOR INT NOT NULL,
	ABERTO BIT NOT NULL

	CONSTRAINT PK_ID_ENTRADA PRIMARY KEY (ID_ENTRADA),

	CONSTRAINT FK_ID_PRODUTO__ENTRADAS_ESTOQUE FOREIGN KEY (ID_PRODUTO)
	REFERENCES PRODUTOS (ID_PRODUTO),

	CONSTRAINT FK_ID_FORNECEDOR__ENTRADAS_ESTOQUE FOREIGN KEY (ID_FORNECEDOR)
	REFERENCES FORNECEDORES (ID_FORNECEDOR)
)
GO

CREATE TABLE SAIDAS_ESTOQUE(
	ID_SAIDA INT IDENTITY(1,1) NOT NULL,
	ID_PRODUTO INT NOT NULL,
	DT_SAIDA DATETIME NOT NULL,
	NOME_PRODUTO VARCHAR(50),
	QTD_SAIDA INT NOT NULL,
	PRECO_VENDA_UN NUMERIC(7,2) NOT NULL

	CONSTRAINT PK_ID_SAIDA PRIMARY KEY (ID_SAIDA),

	CONSTRAINT FK_ID_PRODUTO__SAIDAS_ESTOQUE FOREIGN KEY (ID_PRODUTO)
	REFERENCES PRODUTOS (ID_PRODUTO)
)
GO

--PRODUTOS QUE PERDEM, QUEBRAM, ESTRAGAM...
CREATE TABLE BAIXAS_ESTOQUE( 
	ID_BAIXA INT IDENTITY(1,1) NOT NULL,
	ID_PRODUTO INT NOT NULL,
	DT_BAIXA DATETIME NOT NULL,
	QTD_PRODUTO INT NOT NULL,
	LOTE VARCHAR(20) NULL,
	VALOR_PERDA NUMERIC(7,2) NULL

	CONSTRAINT PK_ID_BAIXA PRIMARY KEY (ID_BAIXA),

	CONSTRAINT FK_ID_PRODUTOS__BAIXAS_ESTOQUE FOREIGN KEY (ID_PRODUTO)
	REFERENCES PRODUTOS (ID_PRODUTO)
)
GO

CREATE TABLE ORDENS_SERVICOS(
	ID_ORDEM_SERVICO INT IDENTITY(1,1) NOT NULL,
	DT_SOLICITACAO DATETIME NOT NULL,
	DT_CONCLUSAO DATETIME NOT NULL,
	ID_CLIENTE INT NOT NULL, 
	VALOR_TOTAL NUMERIC(7,2) NOT NULL,
	NUM_NOTA_FISCAL INT NULL,
	OBSERVACOES VARCHAR(500) NULL

	CONSTRAINT PK_ID_ORDEM_SERVICO PRIMARY KEY (ID_ORDEM_SERVICO),

	CONSTRAINT FK_ID_CLIENTE__ORDENS_SERVICOS FOREIGN KEY (ID_CLIENTE)
	REFERENCES CLIENTES (ID_CLIENTE)
)
GO

CREATE TABLE PRODUTOS_ORDENS_SERVICOS(
	ID_ORDEM_SERVICO INT NOT NULL,
	ID_PRODUTO INT NULL,
	ID_PROCEDIMENTO INT NULL,
	QTD_PRODUTO INT NOT NULL

	CONSTRAINT FK_ID_ORDEM_SERVICO__PRODUTOS_ORDENS_SERVICOS FOREIGN KEY (ID_ORDEM_SERVICO)
	REFERENCES ORDENS_SERVICOS (ID_ORDEM_SERVICO),

	CONSTRAINT FK_ID_PRODUTO__PRODUTOS_ORDENS_SERVICOS FOREIGN KEY (ID_PRODUTO)
	REFERENCES PRODUTOS (ID_PRODUTO),

	CONSTRAINT FK_ID_PROCEDIMENTO__PRODUTOS_ORDENS_SERVICOS FOREIGN KEY (ID_PROCEDIMENTO)
	REFERENCES PROCEDIMENTOS (ID_PROCEDIMENTO)
)
GO

CREATE TABLE TOTAL_PRODUTOS_ESTOQUE(
	ID_PRODUTO INT UNIQUE NOT NULL ,
	NOME_PRODUTO VARCHAR(50) NOT NULL,
	QTD_ESTOQUE INT NOT NULL,
	PRECO_UND NUMERIC(7,2) NOT NULL,
	LOTE_ATUAL VARCHAR(20) NOT NULL

	CONSTRAINT FK_ID_PRODUTO__TOTAL_PRODUTOS_ESTOQUE FOREIGN KEY (ID_PRODUTO)
	REFERENCES PRODUTOS (ID_PRODUTO)
)
GO

--002
/*-------------------------------------------------------------------------------
Nome: sp_Totaliza_Itens_Estoque
Data de Criação: 19/09/2022
Autor: Icaro Rodrigues

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
Go

--003
/*-------------------------------------------------------------------------------
Nome: sp_Atualiza_Lote_Estoque
Data de Criação: 19/09/2022
Autor: Icaro Rodrigues
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.sp_Atualiza_Lote_Estoque'))
     Drop Procedure dbo.sp_Atualiza_Lote_Estoque
Go

Create Procedure [dbo].[sp_Atualiza_Lote_Estoque]
(
       @ID_PRODUTO INT
) As
Begin
     Set NoCount On;

		DECLARE
				@ID_ENTRADA INT,
				@NOVO_LOTE VARCHAR(20),
				@PRECO_UN_NOVO_LOTE NUMERIC(7,2),
				@ID_ENTRADA_ORIGEM INT
     

		--SELECIONA A ENTRADA DO PACOTE QUE SERÁ FECHADO
		SELECT @ID_ENTRADA = EE.ID_ENTRADA
		FROM ENTRADAS_ESTOQUE EE
		WHERE ID_PRODUTO = @ID_PRODUTO
			AND ABERTO = 1


		SET @ID_ENTRADA_ORIGEM = @ID_ENTRADA


		--FECHA O PACOTE ATUAL
		BEGIN
			UPDATE ENTRADAS_ESTOQUE
			SET ABERTO = 0,
				NUM_ITENS_ATUAL = 0
			WHERE ID_PRODUTO = @ID_PRODUTO
				AND ID_ENTRADA = @ID_ENTRADA
					AND ABERTO = 1
		END

		--SELECIONA A ENTRADA DO PACOTE QUE SERÁ ABERTO
		SELECT @ID_ENTRADA = EE.ID_ENTRADA,
			   @NOVO_LOTE = EE.LOTE,
			   @PRECO_UN_NOVO_LOTE = EE.PRECO_UN
		FROM ENTRADAS_ESTOQUE EE
		WHERE ID_PRODUTO = @ID_PRODUTO
			AND ABERTO = 0
			AND DT_ENTRADA = (SELECT TOP 1 MIN(DT_ENTRADA)
							  FROM ENTRADAS_ESTOQUE
							  WHERE ID_PRODUTO = @ID_PRODUTO
									AND ABERTO = 0
									AND NUM_ITENS_ATUAL > 0)

		--ABRINDO O NOVO PACOTE
		BEGIN
			UPDATE ENTRADAS_ESTOQUE
			SET ABERTO = 1
			WHERE ID_PRODUTO = @ID_PRODUTO
				AND ID_ENTRADA = @ID_ENTRADA
		END

		IF EXISTS(SELECT 1 FROM ENTRADAS_ESTOQUE WHERE ID_PRODUTO = @ID_PRODUTO AND ID_ENTRADA <> @ID_ENTRADA_ORIGEM)
		--ATUALIZANDO A TABELA DE ESTOQUE
		BEGIN
			UPDATE TOTAL_PRODUTOS_ESTOQUE
			SET PRECO_UND = @PRECO_UN_NOVO_LOTE,
				LOTE_ATUAL = @NOVO_LOTE
			WHERE ID_PRODUTO = @ID_PRODUTO

			BEGIN
				EXEC dbo.sp_Totaliza_Itens_Estoque @ID_PRODUTO
			END
		END


     Set NoCount Off;
End
Go

--004
/*-------------------------------------------------------------------------------
Nome: ti_Entradas_Estoque
Data de Criação: 12/09/2022
Autor: Icaro Rodrigues
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

--005
/*-------------------------------------------------------------------------------
Nome: tu_Entradas_Estoque
Data de Criação: 12/09/2022
Autor: Icaro Rodrigues 

Alterações:
	[19/09/2022 - Icaro] => Refatoração e alteração da lógica de funcionamento.
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

--006
/*-------------------------------------------------------------------------------
Nome: sp_Insere_Entrada_Estoque
Data de Criação: 13/09/2022
Autor: Icaro Rodrigues
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

--007
/*-------------------------------------------------------------------------------
Nome: sp_Retira_Itens_Estoque
Data de Criação: 15/09/2022
Autor: Icaro Rodrigues

Alterações: Removido as condicionais caso não haja o numero de itens necessário em estoque, 
			devido à tabela "TOTAL_PRODUTOS_ESTOQUE" já possuir essa informação totalizada.
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.sp_Retira_Itens_Estoque'))
     Drop Procedure dbo.sp_Retira_Itens_Estoque
Go

Create Procedure dbo.sp_Retira_Itens_Estoque
(
       @ID_PRODUTO INT
     , @N_ITENS_REMOVIDOS INT
) As
Begin
     Set NoCount On;
     DECLARE
			@N_ITENS_PACOTE_ATUAL INT
		  , @QTD_SOBRA INT


	SELECT @N_ITENS_PACOTE_ATUAL = EE.NUM_ITENS_ATUAL

	FROM ENTRADAS_ESTOQUE EE
		JOIN TOTAL_PRODUTOS_ESTOQUE TPE
			ON (EE.ID_PRODUTO = TPE.ID_PRODUTO
				AND EE.LOTE = TPE.LOTE_ATUAL)

	WHERE 0 = 0 
		AND EE.ID_PRODUTO = @ID_PRODUTO
		AND EE.ABERTO = 1



	 IF ((SELECT QTD_ESTOQUE FROM TOTAL_PRODUTOS_ESTOQUE WHERE ID_PRODUTO = @ID_PRODUTO) > @N_ITENS_REMOVIDOS) -- SE O NUMERO DE ITENS NO ESTOQUE FOR MAIOR QUE A RETIRADA
		BEGIN
			IF(@N_ITENS_REMOVIDOS > @N_ITENS_PACOTE_ATUAL) --SE O NUMERO DE ITENS RETIRADOS FOR MAIOR QUE A QTD DE ITENS DO PACOTE ATUAL EM ABERTO
			BEGIN
				SELECT @QTD_SOBRA = @N_ITENS_REMOVIDOS - @N_ITENS_PACOTE_ATUAL

				BEGIN
					EXEC dbo.sp_Atualiza_Lote_Estoque @ID_PRODUTO --ZERA E FECHA O PACOTE ATUAL QUE SE ESGOTOU E ABRE O PROXIMO
				END

				BEGIN
					UPDATE ENTRADAS_ESTOQUE --ATUALIZA A QUANTIDADE DE ITENS RESTANTES DO NOVO PACOTE EM ABERTO
					SET NUM_ITENS_ATUAL = (EE.NUM_ITENS_ATUAL - @QTD_SOBRA)
					FROM ENTRADAS_ESTOQUE EE
					WHERE EE.ID_PRODUTO = @ID_PRODUTO
						AND ABERTO = 1
						AND NUM_ITENS_ATUAL > 0
				END
			END

			--SE HOUVER ITENS SUFICIENTE NO PACOTE ATUAL, SÓ REALIZA A REMOÇÃO
			ELSE IF(@N_ITENS_REMOVIDOS < @N_ITENS_PACOTE_ATUAL)
			BEGIN
				UPDATE ENTRADAS_ESTOQUE
				SET NUM_ITENS_ATUAL = (EE.NUM_ITENS_ATUAL - @N_ITENS_REMOVIDOS)
				FROM ENTRADAS_ESTOQUE EE
				WHERE  0 = 0 
					AND ID_PRODUTO = @ID_PRODUTO
					AND ABERTO = 1
					AND NUM_ITENS_ATUAL > 0
			END
		
			--ATUALIZA A QUANTIDADE NA TABELA DE ESTOQUE
			BEGIN
				 EXEC dbo.sp_Totaliza_Itens_Estoque @ID_PRODUTO
			END

			--CRIA A SAIDA DO ESTOQUE ---------------------------------------------------------------
			BEGIN
				--
				DECLARE
					@NOME_PRODUTO VARCHAR(50),
					@PRECO_VENDA NUMERIC(7,2)

					SELECT @NOME_PRODUTO = P.NOME_PRODUTO,
						   @PRECO_VENDA = EE.PRECO_UN

					FROM PRODUTOS P
						LEFT JOIN ENTRADAS_ESTOQUE EE
							ON (P.ID_PRODUTO = EE.ID_PRODUTO)

					WHERE P.ID_PRODUTO = @ID_PRODUTO
						AND EE.ABERTO = 1

				--SERÁ NECESSÁRIO CRIAR UMA NOVA COLUNA NA TABELA "TOTAL_PRODUTOS_ESTOQUE" OU EM "ENTRADAS_ESTOQUE" PARA GUARDAR O PREÇO DE VENDA
				--UTILIZANDO O VALOR DE ENTRADA DO ESTOQUE COMO PREÇO DE VENDA, MAS SERÁ NECESSÁRIO AJUSTAR
				BEGIN
					INSERT SAIDAS_ESTOQUE ([ID_PRODUTO], [NOME_PRODUTO], [QTD_SAIDA], [PRECO_VENDA_UN])
					VALUES (@ID_PRODUTO, @NOME_PRODUTO, @N_ITENS_REMOVIDOS, @PRECO_VENDA)
				END
			END

		END

	ELSE IF((SELECT QTD_ESTOQUE FROM TOTAL_PRODUTOS_ESTOQUE WHERE ID_PRODUTO = @ID_PRODUTO) < @N_ITENS_REMOVIDOS) --SE NAO EXISTIR A QUANTIDADE DE ITENS NO ESTOQUE
		BEGIN
			PRINT 'A QUANTIDADE DE ITENS SOLICITADOS NÃO EXISTE NO ESTOQUE'
		END
		
     Set NoCount Off;
End
Go

--008
/*-------------------------------------------------------------------------------
Nome: tu_Total_Produtos_Estoque
Data de Criacao: 15/09/2022
Autor: Icaro Rodrigues
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
		@PRECO_UN NUMERIC(7,2)


		SELECT @ID_PRODUTO = I.ID_PRODUTO
		FROM inserted I

	---alouu


     Set NoCount Off;
End
Go

--009
/*-------------------------------------------------------------------------------
Nome: sp_Insere_Pessoa
Data de Criacao: 21/09/2022
Autor: Icaro Rodrigues
-------------------------------------------------------------------------------*/
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

--010
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
	 @OBSERVACOES VARCHAR(500)
) As
Begin
     Set NoCount On;

		 DECLARE
			@SIT_CLIENTE TINYINT,
			@ID_PESSOA INT

		SET @SIT_CLIENTE = 0 --Por padrão, o cliente entrará como ativo no sistema


		BEGIN TRANSACTION --OU ADICIONA TODOS OS CADASTROS, OU NENHUM
			
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

			 
			 SET @ID_PESSOA = ( SELECT MAX(ID_PESSOA) 
								FROM PESSOAS)						--PRECISO MUDAR ESSA LÓGICA KKKKKKKKKKKKK TEORICAMENTE FUNCIONARÁ MUITO BEM ENQUANTO FOR APENAS 1 
																	--TERMINAL ACESSANDO O SISTEMA E CADASTRANDO PESSOAS, PORÉM PODE DAR ZICA SE TIVER MAIS DE UMA PESSOA 
																	--CADASTRANDO AO MESMO TEMPO

			--inserindo cliente
			BEGIN
				INSERT CLIENTES ( [ID_PESSOA]
								, [SIT_CLIENTE]
								, [DT_CADASTRO])

				VALUES (		  
								  @ID_PESSOA
								, @SIT_CLIENTE
								, GETDATE())
			 END

		COMMIT TRANSACTION
     
          
     Set NoCount Off;
End
Go

--011
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

--012
/*-------------------------------------------------------------------------------
Nome: vw_Produtos
Data de Criação: 22/09/2022
Autor: Ícaro Rodrigues
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
	   , TPE.PRECO_UND AS PREÇO_UN_ATUAL
	   , TPE.LOTE_ATUAL

FROM PRODUTOS P
	JOIN TOTAL_PRODUTOS_ESTOQUE TPE
		ON (P.ID_PRODUTO = TPE.ID_PRODUTO)

Go

--013
/*-------------------------------------------------------------------------------
Nome: vw_Clientes
Data de Criação: 22/09/2022
Autor: Ícaro Rodrigues
-------------------------------------------------------------------------------*/

If Exists (Select 1 From Sysobjects Where Id = Object_Id('dbo.[vw_Clientes]'))
	Drop View dbo.vw_Clientes
Go

Create View dbo.vw_Clientes As

SELECT    C.ID_CLIENTE
		, C.SIT_CLIENTE
		, C.DT_CADASTRO
		, P.ID_PESSOA
		, P.NOME_PESSOA
		, P.TELEFONE1
		, P.TELEFONE2
		, P.WHATSAPP
		, P.CEP
		, P.LOGRADOURO
		, P.COMPLEMENTO
		, P.NUMERO_CASA
		, CD.NOME_CIDADE
		, E.NOME_ESTADO
		, E.SIGLA_ESTADO
		, E.NOME_PAIS
		, P.CPF
		, P.RG
		, P.EMAIL
		, P.GENERO
		, P.OBSERVACOES

FROM CLIENTES C
	JOIN PESSOAS P
		ON (C.ID_PESSOA = P.ID_PESSOA)
	LEFT JOIN CIDADES CD
		ON (P.ID_CIDADE = CD.ID_CIDADE)
	LEFT JOIN ESTADOS E
		ON (CD.ID_ESTADO = E.ID_ESTADO)

Go

--014
/*
DADOS ESSENCIAIS PARA FUNCIONAMENTO

TABELA: SITUACOES_SISTEMA
*/

--001 - PRODUTOS PARA TESTE
INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('PARAFUSO', 'GERDAU', 'A-02')
GO

INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('VELA', 'MARCA01', 'V50')
GO

INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('CABO DE AÇO', 'MARCA02', 'BX10')
GO

INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('RETROVISOR', 'HONDA', 'CG TITAN')
GO

INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('PNEU', 'LEVORIN', 'XT15')
GO

--002 - SITUACOES CLIENTES
INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('CLIENTES', 'SIT_CLIENTE', 0, NULL, 'Ativo', 'Cliente ativo')
GO

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('CLIENTES', 'SIT_CLIENTE', 1, NULL, 'Inativo', 'Cliente inativo')
GO

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('CLIENTES', 'SIT_CLIENTE', 2, NULL, 'Suspenso', 'Cliente não pode realizar abertura de ordens de serviço devido inadimplência')
GO

--003 - SITUACOES FUNCIONARIOS
INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 0, NULL, 'Ativo', 'Funcionário ativo')
GO

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 1, NULL, 'Desligado', 'Funcionário inativo')
GO

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 2, NULL, 'Afastado', 'Funcionário afastado por tempo indeterminado do trabalho por motivo de força maior')
GO

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 3, NULL, 'Férias', 'Funcionário de férias')
GO

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 4, NULL, 'Suspenso', 'Funcionário suspenso do trabalho')
GO

--004 - CIDADES E ESTADOS PARA TESTE
INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('Espírito Santo', 'Brasil', 'ES')
GO

INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('Minas Gerais', 'Brasil', 'MG')
GO

INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('Rio de Janeiro', 'Brasil', 'RJ')
GO

INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('São Paulo', 'Brasil', 'SP')
GO

INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('Bahia', 'Brasil', 'BA')
GO

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Vitória', 1, 123456789)
GO

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Serra', 1, 234567891)
GO

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Vila Velha', 1, 345678912)
GO

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Cariacica', 1, 456789123)
GO

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Rio de Janeiro', 3, 567891234)
GO

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Belo Horizonte', 2, 678912345)
GO
--TESTE DO M�DULO DE ESTOQUE
--001  
/*
INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('PARAFUSO', 'GERDAU', 'A-02')

INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('VELA', 'MARCA01', 'V50')

INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('CABO DE A�O', 'MARCA02', 'BX10')

INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('RETROVISOR', 'HONDA', 'CG TITAN')

INSERT PRODUTOS ([NOME_PRODUTO], [MARCA], [LINHA])
VALUES ('PNEU', 'LEVORIN', 'XT15')


--002 PRIMEIRAS ENTRADAS DO ESTOQUE

EXEC dbo.sp_Insere_Entrada_Estoque 1, 10, 25.00, 123456789, 'AA-B15'
EXEC dbo.sp_Insere_Entrada_Estoque 2, 15, 15.00, 123456789, 'BB-C15'
EXEC dbo.sp_Insere_Entrada_Estoque 3, 8, 35.00, 123456789, 'CC-D15'
EXEC dbo.sp_Insere_Entrada_Estoque 4, 20, 45.00, 123456789, 'DD-E15'
EXEC dbo.sp_Insere_Entrada_Estoque 5, 10, 75.00, 123456789, 'EE-F15'
SELECT * FROM ENTRADAS_ESTOQUE
SELECT * FROM TOTAL_PRODUTOS_ESTOQUE

--003 PARAFUSO
--JA EXISTE O PACOTE COM ITENS
EXEC dbo.sp_Insere_Entrada_Estoque 1, 35, 5.00, 123456789, 'FF-G15' --<<-----1
SELECT * FROM ENTRADAS_ESTOQUE
SELECT * FROM TOTAL_PRODUTOS_ESTOQUE

--004 VELA
--O PACOTE DO PRODUTO SE ESGOTOU
UPDATE ENTRADAS_ESTOQUE SET NUM_ITENS_ATUAL = 0 WHERE ID_ENTRADA = 2
EXEC dbo.sp_Insere_Entrada_Estoque 2, 20, 25.00, 123456789, 'GG-H15'
SELECT * FROM ENTRADAS_ESTOQUE
SELECT * FROM TOTAL_PRODUTOS_ESTOQUE

--005 CABO DE A�O
--ENTRA UM NOVO PACOTE, E O PACOTE VIGENTE ACABA
EXEC dbo.sp_Insere_Entrada_Estoque 3, 21, 50.00, 123456789, 'HH-I15'
SELECT * FROM ENTRADAS_ESTOQUE
SELECT * FROM TOTAL_PRODUTOS_ESTOQUE
------
UPDATE ENTRADAS_ESTOQUE SET NUM_ITENS_ATUAL = 0 WHERE ID_ENTRADA = 3
SELECT * FROM ENTRADAS_ESTOQUE
SELECT * FROM TOTAL_PRODUTOS_ESTOQUE

--006 RETROVISOR
EXEC dbo.sp_Insere_Entrada_Estoque 4, 30, 55.00, 123456789, 'II-J15'

--007 PNEU
EXEC dbo.sp_Insere_Entrada_Estoque 5, 15, 82.00, 123456789, 'JJ-K15'




TRUNCATE TABLE ENTRADAS_ESTOQUE
TRUNCATE TABLE TOTAL_PRODUTOS_ESTOQUE
TRUNCATE TABLE SAIDAS_ESTOQUE

SELECT * FROM ENTRADAS_ESTOQUE
SELECT * FROM TOTAL_PRODUTOS_ESTOQUE
SELECT * FROM PRODUTOS

DELETE ENTRADAS_ESTOQUE
WHERE ID_ENTRADA = 12
*/


--TESTE DO M�DULO DE CADASTRO

--001 inserindo as situa��es iniciais
INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('CLIENTES', 'SIT_CLIENTE', 0, NULL, 'Ativo', 'Cliente ativo')

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('CLIENTES', 'SIT_CLIENTE', 1, NULL, 'Inativo', 'Cliente inativo')

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('CLIENTES', 'SIT_CLIENTE', 2, NULL, 'Suspenso', 'Cliente n�o pode realizar abertura de ordens de servi�o devido inadimpl�ncia')

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 0, NULL, 'Ativo', 'Funcion�rio ativo')

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 1, NULL, 'Desligado', 'Funcion�rio inativo')

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 2, NULL, 'Afastado', 'Funcion�rio afastado por tempo indeterminado do trabalho por motivo de for�a maior')

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 3, NULL, 'F�rias', 'Funcion�rio de f�rias')

INSERT SITUACOES_SISTEMA ([NOME_TABELA], [NOME_COLUNA], [VALOR], [VALOR_CHAR], [SITUACAO], [DESC_SITUACAO])
VALUES ('FUNCIONARIOS', 'SIT_FUNCIONARIO', 4, NULL, 'Suspenso', 'Funcion�rio suspenso do trabalho')


--002
INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('Esp�rito Santo', 'Brasil', 'ES')

INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('Minas Gerais', 'Brasil', 'MG')

INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('Rio de Janeiro', 'Brasil', 'RJ')

INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('S�o Paulo', 'Brasil', 'SP')

INSERT ESTADOS ([NOME_ESTADO], [NOME_PAIS], [SIGLA_ESTADO])
VALUES ('Bahia', 'Brasil', 'BA')

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Vit�ria', 1, 123456789)

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Serra', 1, 234567891)

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Vila Velha', 1, 345678912)

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Cariacica', 1, 456789123)

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Rio de Janeiro', 3, 567891234)

INSERT CIDADES([NOME_CIDADE], [ID_ESTADO], [COD_POSTAL])
VALUES ('Belo Horizonte', 2, 678912345)


--003 INSERINDO CLIENTES

EXEC DBO.sp_Insere_Cliente '�caro Rodrigues', '27999999999', '27998888888', '27997777777', 
29056210, 'Rua Periquito da Silva Sauro', 'Casa verde com telhado azul', 
651, 1, 11122233345, 1654789, 'icaroicaro@email.com', 'M', '� para o teste'



delete pessoas
where ID_PESSOA = 1

delete clientes
where ID_PESSOA = 1


select * from CIDADES
select * from ESTADOS
SELECT * FROM SITUACOES_SISTEMA
select * from clientes
select * from pessoas



ALTER TABLE ESTADOS
ADD SIGLA_ESTADO VARCHAR(2) NOT NULL
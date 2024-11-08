/* PROCEDURES 

SHOW TABLES, SHOW DATABASE
NO SQL SERVER S�O PROCEDURES
SP_STORAGE PROCEDURE
*/

CREATE TABLE PESSOA(
	IDPESSOA INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(30) NOT NULL,
	SEXO CHAR(1) NOT NULL CHECK (SEXO IN('M','F')), --ENUM NO MY SQL
	NASCIMENTO DATE NOT NULL
)
GO

CREATE TABLE CONTATO( --TABELA TELEFONE 
	IDTELEFONE INT PRIMARY KEY IDENTITY,
	TIPO CHAR(3) NOT NULL CHECK( TIPO IN('CEL','COM')),
	NUMERO CHAR(10) NOT NULL,
	ID_PESSOA INT
)  
GO

SELECT * FROM CONTATO

ALTER TABLE CONTATO ADD CONSTRAINT FK_CONTATO_PESSOA
FOREIGN KEY(ID_PESSOA) REFERENCES PESSOA(IDPESSOA)
GO

INSERT INTO PESSOA VALUES('ANTONIO','M', '1981-02-13')
INSERT INTO PESSOA VALUES('DANIEL','M', '1985-03-18')
INSERT INTO PESSOA VALUES('CLEIDE','F', '1979-10-13')
GO

INSERT INTO CONTATO VALUES('CEL','4556987',1)
INSERT INTO CONTATO VALUES('COM','4746454',1)
INSERT INTO CONTATO VALUES('CEL','3498344',2)
INSERT INTO CONTATO VALUES('CEL','2986764',2)
INSERT INTO CONTATO VALUES('COM','5748754',3)
INSERT INTO CONTATO VALUES('COM','4545435',2)
INSERT INTO CONTATO VALUES('CEL','6767677',3)
GO

--CRIANDO PROCEDURE
CREATE PROC SOMA
AS 
	SELECT 10 + 10 AS SOMA
GO

EXEC SOMA 
GO

--CRIANDO PROCEDURE DINAMICAS, COM PARAMETROS
CREATE PROC CONTA @NUM1 INT, @NUM2 INT
AS
	SELECT @NUM1 + @NUM2
GO

EXEC CONTA 10, 10
GO

--APAGANDO PROCEDURE
DROP PROC CONTA
GO
-- TRABALHANDO COM PROCEDURE EM TABELAS
SELECT NOME, NUMERO
FROM PESSOA
INNER JOIN CONTATO
ON IDPESSOA = ID_PESSOA
WHERE TIPO = 'CEL'
GO

CREATE PROC CONTATOS @TIPO CHAR(3)
AS
	SELECT NOME, NUMERO
	FROM PESSOA
	INNER JOIN CONTATO
	ON IDPESSOA = ID_PESSOA
	WHERE TIPO = @TIPO
GO

EXEC CONTATOS 'CEL'
GO

EXEC CONTATOS 'COM'
GO

/*PARAMETRS DE OUTPUT*/
SELECT TIPO, COUNT(*) AS QUANTIDADE
FROM CONTATO
GROUP BY TIPO
GO

/*PARAMETROS DE ETRADA E SAPIDA */
CREATE PROCEDURE GETTIPO @TIPO CHAR(3), @CONTADOR INT OUTPUT
AS
	SELECT @CONTADOR = COUNT(*)
	FROM CONTATO
	WHERE TIPO = @TIPO
GO

/* EXECU�AO DA PROC COM PARAMETRO DE SA�DA */

/* TRANSACTION SQL -> LINGUAGEM QUE SQL SERVER TRABALHA (TSQL)*/
DECLARE @SAIDA INT
EXEC GETTIPO @TIPO = 'CEL', @CONTADOR = @SAIDA OUTPUT
SELECT @SAIDA
GO

DECLARE @SAIDA INT
EXEC GETTIPO 'CEL', @SAIDA OUTPUT
SELECT @SAIDA
GO

use empresa
GO
/* PROCEDURE DE CADASTRO */
CREATE PROC CADASTRO @NOME VARCHAR(30), @SEXO CHAR(1), @NASCIMENTO DATE,
@TIPO CHAR(3), @NUMERO VARCHAR(10)
AS 
	DECLARE @FK INT 

	INSERT INTO PESSOA VALUES (@NOME,@SEXO,@NASCIMENTO)

	SET @FK = (SELECT IDPESSOA FROM PESSOA WHERE IDPESSOA = @@IDENTITY)

	INSERT INTO CONTATO VALUES (@TIPO,@NUMERO,@FK)
GO

CADASTRO 'JORGE','M','1981-01-01','CEL','97273822'

GO
SELECT PESSOA. *, CONTATO.*
FROM PESSOA
INNER JOIN CONTATO
ON IDPESSOA = ID_PESSOA
GO
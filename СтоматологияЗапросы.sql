USE MASTER

GO

CREATE DATABASE ������������

ON

(NAME='������������_Data',
FILENAME='C:\Users\User\Desktop\labs\�������������� ������� ������\������������\������������_Data.mdf',
SIZE=3,
MAXSIZE=10,
FILEGROWTH=1)

LOG ON

(NAME='������������_log', 
FILENAME='C:\Users\User\Desktop\labs\�������������� ������� ������\������������\������������_Data.ldf',
SIZE=3,
MAXSIZE=10,
FILEGROWTH=1)

USE ������������
Go

CREATE TABLE ������
(��� smallint NOT NULL PRIMARY KEY,
�������� varchar(50) NOT NULL)

CREATE TABLE ��������
(����� smallint NOT NULL PRIMARY KEY,
������� varchar (40) NOT NULL,
����� varchar (80),
[��� ��������] smallint NOT NULL )

CREATE TABLE ���������������
(������� smallint NOT NULL,
������ smallint NOT NULL,
����� time NOT NULL,
��������� smallmoney NOT NULL,
FOREIGN KEY (�������)REFERENCES ��������(�����)/*ON DELETE CASCADE*/,
FOREIGN KEY (������) REFERENCES ������(���)
)/*ON DELETE CASCADE)*/

ALTER TABLE ������
ADD CONSTRAINT Unique_�������� UNIQUE (��������)

ALTER TABLE ���������������
ADD CONSTRAINT PK_����� PRIMARY KEY (�����, �������)

ALTER TABLE ��������
ADD CHECK ([��� ��������]>=1920)

INSERT INTO ������
VALUES 
(100, '�������� �����'),
(101, '������� �����'),
(102, '��������������'),
(103, '�����������'),
(104, '������ ������� ���'),
(105, '������������ ��������� �����'),
(106, '�������������������'),
(107, '��������������'),
(108, '����������� �������'),
(109, '����������� �����')

INSERT INTO ��������
VALUES 
(1, '������', '���������, 8, 46', 1989),
(2, '������', '��������, 22, 22', 1961),
(3, '��������', '��������, 37, 12', 1968),
(4, '�����', '�������, 1, 10', 1984),
(5, '��������', '�������, 81, 70', 1989),
(7, '������', '��������, 65, 6', 1961),
(8, '����������', '��������, 2, 10', 1975),
(9, '�����', '��������, 67, 3', 1987),
(10, '���������', '�������, 13, 20', 1980)

INSERT INTO ��������(�����, �������, [��� ��������])
VALUES  (6, '�������',  1989)

INSERT INTO ���������������
VALUES
(1, 102, '12:00:00', 600),
(8, 104, '15:00:00', 500),
(8, 109, '10:00:00', 100),
(10, 107, '08:00:00', 250),
(6, 104, '17:00:00', 1000),
(2, 105, '21:00:00', 750),
(4, 103, '19:00:00', 400),
(7, 102, '12:00:00', 5000),
(3, 109, '11:30:00', 260),
(4, 106, '10:40:00', 340),
(1, 102, '17:10:00', 560),
(9, 104, '15:00:00', 50),
(10, 107, '08:45:00', 100),
(7, 100, '09:00:00', 2500),
(3, 100, '10:30:00', 400),
(2, 103, '11:00:00', 980),
(1, 100, '16:00:00', 120),
(4, 101, '12:40:00', 300),
(9, 100, '14:35:00', 460),
(6, 105, '20:00:00', 900)

CREATE TYPE ������_�����
FROM varchar(5)

/*ALTER TABLE ��������
ADD [������ �����] ������_����� DEFAULT 'O' CHECK ([������ �����] IN ('O', 'A', 'B', 'AB'))*/
 
GO
-- �������� DEFAULT ��������
CREATE DEFAULT dbo.Default������_����� AS 'O';

GO

ALTER TABLE ��������
ADD ������_����� varchar(5) DEFAULT dbo.Default������_����� WITH VALUES;

ALTER TABLE ��������
ADD CONSTRAINT CK_������_����� CHECK (������_����� IN ('O', 'A', 'B', 'AB'));







--- 14.02.2024 ���� ---

		/* 1. �������� ��������� CREATE RULE ��� �������� ������, 
		������������� ��������� �������� ��������� sp_bindrule ��� 
		���������� ������� � ��������� ��.*/

/* 1.1. ������� �������, ������� ��������� ������������ � �������� 
�������� �������� ������ �� ��������, ������� ���������� � 
������� �����.*/

GO
CREATE RULE R_startswrus
	AS @str LIKE '[�-�]%'
GO

/*1.2. ������� ������� �� �������� ������� �������� � �� �������� 
�������� ������.*/
EXEC sp_bindrule 'R_startswrus', '��������.�������'
EXEC sp_bindrule 'R_startswrus', '������.��������'

		/*2. �������� ��������� CREATE DEFAULT ��� �������� ���������, 
		������������� ��������� �������� ��������� sp_binddefault ��� 
		���������� ��������� � ��������� ��.*/

/*2.1. ������� ��������� 200.*/
GO
CREATE DEFAULT D_200
	AS 200
GO

/*2.2. ������� ��������� �� �������� ��������� �����.*/
EXEC sp_bindefault 'D_200', '���������������.���������'

		/*3. �������� ��������� CREATE VIEW ��� �������� �������������, 
		���������� �������� � ��������������.*/

/*3.1. ������� ������������� � ����������� � ������. 
������������� ������ �������� ������� ������� ��������, 
�������� ������, �����, ��������� (� ���.).*/
GO
CREATE VIEW V_����� AS
	SELECT �������, ��������, �����, STR(���������) + '���.' AS ���������
	  FROM (������ JOIN ��������������� ON ������.��� = ���������������.������) JOIN �������� ON ���������������.������� = ��������.�����

/*3.2. ��������� ������, ������� �� ������ ���������� � �.3.1 
������������� ��� ������� �������� ������� ������� 
�������� � ��������� ���������� ��������� ��� �����.*/
GO
SELECT �������, COUNT(��������) AS [���������� ������]
	FROM V_�����
	GROUP BY �������


/*4. �������� ������������� � ������������ WITH CHECK OPTION. 
����������� ������� ������ ����� �������������.*/

/*4.1������� ������������� � ����������� � ���������, ������� 
�������� �� 1995 ����.
*/
GO
CREATE VIEW V_��������_��95 AS
 SELECT*
 FROM ��������
 WHERE [��� ��������]<1995
 WITH CHECK OPTION

 /*4.2. ����������� ������� ��� ����������, �������� � ����������
����� ������ � �������� �� ������ ���������� � �. 4.1 
�������������.
*/
GO
UPDATE ��������
SET ��������.������� = '�����'
FROM V_��������_��95
WHERE ��������.������� = '�����'

GO
DELETE ��������
FROM V_��������_��95
WHERE ��������.�������='������'

GO
INSERT INTO V_��������_��95
VALUES (12,'�������', '���������, 15, 34', 1996)


--- ������ �� ����� �� 28.02.24 ---

-- ������� �������������, ���. ������� ������, �� ������� �� ���� ���������
GO
CREATE VIEW useless_������ AS
	SELECT ���, ��������
	FROM ������
	WHERE ��� NOT IN (SELECT ������ FROM ���������������)

GO

-- ������� �������, ��� ������� ������ 18 ���
GO
CREATE RULE R_older18
	AS YEAR(GETDATE()) - @birthYear >=18
GO

EXEC sp_bindrule 'R_older18', '��������.[��� ��������]'


--* ���� �� �������� ���������� 28.02.24 *--

/*1.1. ����������� �������� ���������, ������� �� ��������� 
������ �������� ���������� ��� ������� � �����.*/

GO
CREATE PROCEDURE GetPacient @pacientNum smallint AS
	SELECT �������, �����
	FROM ��������
	WHERE ����� = @pacientNum

EXEC GetPacient 2

/*1.3. ����������� �������� ���������, ������� �� �������� 
��������� ������ ��������, �������� ������ � ������� 
������ ������� �������� ��������� � ������, �������� 
�������������.*/
DROP PROCEDURE PrintPrice
GO
CREATE PROCEDURE PrintPrice
	@pacientNum smallint,
	--@serviceName varchar(50),
	@serviceTime time(7),
	@currency varchar(15) = '������'		
	AS

	IF(@currency NOT IN('�����', '����', '������'))
		BEGIN
			PRINT '����������� ������!'
			Return -4
		END

	DECLARE @pacientName varchar(40)
	SELECT @pacientName = ������� FROM �������� WHERE ����� = @pacientNum
	
	IF(@pacientName IS NULL)
		BEGIN
			PRINT '�������� ����� ��������!'
			Return -1
		END

	DECLARE @servicePrice smallmoney--varchar(20)
	SELECT @servicePrice = ��������� FROM ��������������� WHERE ������� = @pacientNum AND ����� = @serviceTime
	
	IF(@servicePrice IS NULL)
		BEGIN
			PRINT '�� ������� ������ �� ����!'
			Return -3
		END

	DECLARE @serviceName varchar(50)
	SELECT @serviceName = �������� FROM ������ WHERE ��� = (SELECT ������ FROM ��������������� WHERE ������� = @pacientNum AND ����� = @serviceTime)

	PRINT '����� �����: ' + CONVERT(varchar(10), @serviceTime)
	PRINT '�������: ' + @pacientName + ', ������: ' + @serviceName

	IF(@currency = '����')
		PRINT '���������: ' + CONVERT(varchar(20), @servicePrice/100.0) + ' ����'
	ELSE IF(@currency = '������')
		PRINT '���������: ' + CONVERT(varchar(20), @servicePrice/70.0) + ' ��������'
	ELSE
		PRINT '���������: ' + CONVERT(varchar(20), @servicePrice) + ' ������'

GO
EXEC PrintPrice 3, '11:30:00'

--1.2. ����������� �������� ���������, ������� ������������ 
--������� ������� � ������� ��������. �������� ��������� 
--������ ���������� ������ ������ �� ������������ �������� 
--���������� �������: ����������� ����� �������� �������� 
--� ����������� ���������, �� � ��� ������ ���� ������ 
--�������� ������.
GO
CREATE PROCEDURE AddPacient 
	@num smallint,
	@LastName varchar (40),
	@Adress varchar (80),
	@BitrhDay smallint
	as
	if not exists (Select 1 From �������� Where ������� =@LastName and  ����� =@Adress)
		begin
			Insert into �������� (�����,�������,�����, [��� ��������])
			Values (@num,@LastName,@Adress, @BitrhDay)
			print '������ ������� ���������'
		end
	else print '������ ��� ����������'
go

exec AddPacient 11,'������','���������, 9, 46',1990
go

--1.4 ����������� �������� ���������, ������� �������� ��������� 
--���� ������ � ����������� ��� �������� ������������� 
--������ �������� �������, ��������� �  �������
DROP PROCEDURE ChangeCoast
GO

Create procedure ChangeCoast
	@num smallint
as 
	DECLARE @count smallint
	SET @count = 0

	Select @count = count(���������������.�������) 
		From ��������������� Join �������� on ���������������.������� = ��������.�����
		Where ���������������.�������= @num

	UPDATE ���������������
	SET ��������� = CASE
		WHEN @count = 1				 THEN ��������� - ��������� *0.2
		WHEN @count between 2 and 10 THEN ��������� - ���������*0.3
		WHEN @count >10				 THEN ��������� - ���������*0.7
		ELSE ���������
		END
	WHERE ���������������.������� = @num


	--if (@count =1)
	--	begin
	--		Update ���������������
	--		Set ��������� =��������� - ���������*0.2
	--		Where ���������������.�������=@num 
	--	end

	--if(@count between 2 and 10)
	--	begin
	--		Update ���������������
	--		Set ��������� = ��������� - ���������*0.3
	--		Where ���������������.�������=@num
	--	end

	--if (@count >10)
	--	begin
	--		Update ���������������
	--		Set ��������� = ��������� - ���������*0.7
	--		Where ���������������.�������=@num
	--	end
go 

exec ChangeCoast 1
go

--* ����� ���� �� �������� ���������� 27.03.24 *--
DROP PROCEDURE CHECK_IF_LESS_3_USLUGI
GO
-- 1)	���������, ���. ���������, ��� � ������� ������ � ��������� ���� ������ 3 �����
CREATE PROCEDURE CHECK_IF_LESS_3_USLUGI
	@pacientNum smallint
	AS

	IF(SELECT COUNT(������)
		FROM ���������������
		WHERE ������� = @pacientNum) < 3
	--RETURN 1
	PRINT '�� �����, ����� ������ 3'

	ELSE
	--RETURN 0
	PRINT '�� �����, ����� ��� 3+'

GO
EXEC CHECK_IF_LESS_3_USLUGI 1

-- 2)	���������, ���. ������� ���������� ������-�������
GO
CREATE PROCEDURE STATISTIC_USLUGA_PROFIT
AS
	SELECT �������� as '������', SUM(���������) as '�������'
		FROM ��������������� JOIN ������ on ������ = ���
		GROUP BY ��������

GO
EXEC STATISTIC_USLUGA_PROFIT

--- 06,04,24 �������� ---

--����� ����������� ������������ ������������ �� �������.
--������ �� ����������� �������� ���������,
-- ������ ����������� �������
--������� ��������� �� ������ ��������
--� ������ ����������� ����������� ��������, ��� �������� � ������� �� ��������� ���� �� ������

--��������: ������, �������, �������, (��������, ��� ��������, �������)?, ������ ��������

--�����:
--������� ��������� � ������ �� ������ ��������
--� ������ ���� �������
--������� ���. ���������
--������� ���. ��� ���������
-- ������� ��� ���������


--- �� ���������� ������� ---

--1.1  ����������� �������, ������������ ������ ���������, 
--������� �� ��������������� �� ����� ������� � ��������� 
--�����.
GO
CREATE FUNCTION ����������������_������()
RETURNS TABLE
AS
RETURN
(
    SELECT P.�����, P.�������
    FROM �������� P
    LEFT JOIN ��������������� S ON P.����� = S.�������
    WHERE S.������� IS NULL
);
GO
SELECT * FROM ����������������_������();

--1.2. ����������� �������, ������������ ������ ���������, 
--������� �� ���������� ����

GO

CREATE FUNCTION ��_����������_����()
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT P.�����, P.�������
	FROM �������� P
	WHERE ����� NOT IN ( SELECT DISTINCT �������
							FROM ��������������� JOIN ������ ON ������ = ���
							WHERE ������.�������� = '�����������'	)
	
);
GO
drop FUNCTION ��_����������_����;

SELECT * FROM ��_����������_����();
GO

--1.3.����������� �������, ������������ ������ ���������, 
--������� ��������������� ����� ������ ����� �����������
CREATE FUNCTION ��������_�_�����_������_�����()
RETURNS TABLE
AS
RETURN
(
    SELECT �.�����, �.�������
    FROM �������� �
    LEFT JOIN (
        SELECT �������, COUNT(DISTINCT ������) AS ���������������
        FROM ���������������
        GROUP BY �������
    ) AS ����������������� ON �.����� = �����������������.�������
    CROSS JOIN (
        SELECT COUNT(*) AS ��������������������
        FROM ������
    ) AS ��������������������
    WHERE �����������������.��������������� = ��������������������.��������������������
);
GO

drop FUNCTION ��������_�_�����_������_�����;

SELECT * FROM ��������_�_�����_������_�����();

--1.4. ����������� �������, ������� ���������� ������ ������, �� 
--������� ����������� �������� ������
GO
CREATE FUNCTION �����_��_������(@ID_������ INT)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT  �����, �������
    FROM ���������������
    WHERE ���������������.������ = @ID_������
);
GO
SELECT * FROM �����_��_������(100);

--1.5����������� �������, ������� ��������� ��������� 
--���������� ������ � ����������� ��� ������ ������ � 
--���������� ��� �� �������� ���������� ���������� ������
GO
CREATE FUNCTION ���������_����������_�����_�_����������()
RETURNS TABLE
AS
RETURN
(
    SELECT ������,
        
        COUNT(*) AS ���������_����������_�����,
        COUNT(*) - AVG(COUNT(*)) OVER() AS ����������
    FROM 
        ���������������
		GROUP BY ������
   
);
GO
drop FUNCTION ���������_����������_�����_�_����������;

SELECT * FROM ���������_����������_�����_�_����������();
-- 1
-- ����������� AFTER-�������, ������� ��������� �������� ���������� � ����� ������ � ������� ����� � ��� ������, ���� ����� ������ �� ��������� 1000 ������. 
-- ������������ ������ ���� ������������� ����������� ���������� ��������� ������� � �������. 
-- ���� � ��������� �������������� ������� ���������� ���� ���� ������, ��� ����� ������ ��������� 1000 ������, ������� ������ �������� ���������� � ������ ��������� �� ������ (�������� ���� ��� ������).

DROP TRIGGER After_CheckPaymentAmount
GO

CREATE TRIGGER After_CheckPaymentAmount
ON �����
AFTER INSERT
AS
    IF EXISTS (SELECT 1 FROM inserted WHERE ����� > 1000)
	BEGIN
		PRINT('������: ����� ������ ��������� 1000 ������. ���������� ��������.')
        ROLLBACK TRANSACTION
	END
GO

INSERT INTO �����
	VALUES(5, 7, '2022-09-01 00:00:00',3000),
	(2, 8, '2022-09-01 00:00:00',1000)

-- 2
-- ����������� INSTEAD OF-�������, ������� ��������� �������� ���������� � ����� ������ � ������� ����� � ��� ������, ���� ����� ������ �� ��������� 1000 ������.
-- ������������ ������ ���� ������������� ����������� ����������� ��������� ������� � �������. 
-- ������� ������ ������������ ���������� ������ ��� �������, ��� ����� ������ ��������� 1000 ������ � �������� ��������� � ��������� ���������� ����������� ������� � ������ ���������� ������� (�������� ������� ������).

ALTER TABLE ����� DISABLE TRIGGER After_CheckPaymentAmount
ALTER TABLE ����� ENABLE TRIGGER After_CheckPaymentAmount


DROP TRIGGER InsteadOf_CheckPaymentAmount
DROP TRIGGER CheckDateTimeOnInsert

GO
CREATE TRIGGER InsteadOf_CheckPaymentAmount
ON �����
INSTEAD OF INSERT
AS
    DECLARE @TotalInserted INT
    DECLARE @TotalValid INT

	 -- �������� ���������� ����������� �������
    SET @TotalInserted = (SELECT COUNT(*) FROM inserted)

	-- ����������� ���������� �������
	SET @TotalValid = (SELECT COUNT(*) FROM �����)

    -- ��������� ������ �������� ������ �� ��������� �������
    INSERT INTO ����� 
    SELECT * FROM inserted WHERE ����� <= 1000

    -- �������� ���������� �������� �������
    SET @TotalValid = (SELECT COUNT(*) FROM �����) - @TotalValid

    -- ���� ���� ���� �� ���� ���������� ������, ������� ���������
    IF @TotalInserted > @TotalValid
		PRINT('��������: ' + CONVERT(varchar(20), @TotalInserted - @TotalValid) + ' ������� �� ���� ���������, ��� ��� ����� ������ ��������� 1000 ������.')
GO

INSERT INTO �����
	VALUES  (5, 7, '2022-09-01 00:00:00',3000),
			(2, 8, '2022-09-11 00:00:00',222)


GO
-- 4
-- �������� � AFTER-�������� �� �. 1 ����������� ���������� ������� � ������� ����� � ��� ������, ���� ����� ������ �� ��������� 1000 ������.
DROP TRIGGER After_CheckPaymentAmount

CREATE TRIGGER After_CheckPaymentAmount
ON �����
AFTER INSERT, UPDATE
AS
    IF EXISTS (SELECT 1 FROM inserted WHERE ����� > 1000)
	BEGIN
		PRINT('������: ����� ������ ��������� 1000 ������. ���������� ��������.')
        ROLLBACK TRANSACTION
	END
GO

UPDATE �����
	SET ����� = 500
	WHERE ���� = 1 AND ������� = 2

GO
-- 5
-- ����������� INSTEAD OF-�������, ������� ��� �������� ���������� �� ������� ������� ��������� ������� ����� ������, ����� ������� � ��������� � �������� 1 � 10.
-- ������������ ������ ���� ������������� ����������� ����������� ��������� ������� � �������. 
-- ������� ������ ������������ �������� ������ ��������� ������� � �������� ��������� � ��������� ���������� ��������� ������� � ������ ���������� ������� (�������� ������� ������).
DROP TRIGGER DeletePatientRecordsInsteadOf
GO

CREATE TRIGGER DeletePatientRecordsInsteadOf
ON �������
INSTEAD OF DELETE
AS
    DECLARE @TotalDeleted INT
    DECLARE @TotalValid INT

	-- �������� ����� ���������� �������
    SET @TotalValid = (SELECT COUNT(*) FROM �������)
	
    -- �������� ���������� ��������� �������
    SET @TotalDeleted = (SELECT COUNT(*) FROM deleted);

    -- ������� ����������� ������ �� �������� �������
    DELETE FROM ������� WHERE [��������� �����] IN 
		(SELECT [��������� �����] FROM deleted WHERE [��������� �����] NOT IN (1, 10))

	SET @TotalValid = @TotalValid - (SELECT COUNT(*) FROM �������)

    -- ���� ���� ������� ������, ������� ���������
    IF @TotalValid > 0
        PRINT ('������� �������: ' + CONVERT(varchar(20), @TotalValid) + '. ����� ���������� �������: ' + CONVERT(varchar(20), @TotalDeleted))
GO

DELETE FROM �������
	WHERE [��������� �����] IN (1,2,10)

-- 6
-- ����������� �������, ������� ��� ���������� ����������� ������� ������� �������� �������, ������� ������� �������.
CREATE TRIGGER LogTriggerAction
ON �����
AFTER INSERT, UPDATE, DELETE
AS
    IF EXISTS (SELECT * FROM inserted)
		IF EXISTS(SELECT * FROM deleted)
		    PRINT '������� ������� ������� UPDATE'
		ELSE
		    PRINT '������� ������� ������� INSERT'
	ELSE
		PRINT '������� ������� ������� DELETE'
GO
DELETE FROM �����
 WHERE ���� = 1 AND ������� = 2


UPDATE �����
	SET ����� = �����

-- 7
-- ����������� INSTEAD OF-�������, ������� ��� ���������� ������� � ������� ����� 
-- ��������� ��������� ������ �� ������, � ������� ��������� ������ �� ��������� ������� ���� � �����.
CREATE TRIGGER CheckDateTimeOnInsert
ON �����
INSTEAD OF INSERT
AS
    DECLARE @CurrentDateTime DATETIME;
    SET @CurrentDateTime = GETDATE();

    INSERT INTO ����� 
    SELECT * FROM inserted WHERE ��������� <= @CurrentDateTime
GO

INSERT INTO �����
	VALUES  (5, 7, '2025-09-01 00:00:00',333),
			(3, 8, '2022-09-11 00:00:00',222)

-- 1
-- ����������� AFTER-�������, ������� ��������� �������� ���������� � ����� ������ � ������� ����� � ��� ������, ���� ����� ������ �� ��������� 1000 ������. 
-- ������������ ������ ���� ������������� ����������� ���������� ��������� ������� � �������. 
-- ���� � ��������� �������������� ������� ���������� ���� ���� ������, ��� ����� ������ ��������� 1000 ������, ������� ������ �������� ���������� � ������ ��������� �� ������ (�������� ���� ��� ������).

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

-- 2
-- ����������� INSTEAD OF-�������, ������� ��������� �������� ���������� � ����� ������ � ������� ����� � ��� ������, ���� ����� ������ �� ��������� 1000 ������.
-- ������������ ������ ���� ������������� ����������� ����������� ��������� ������� � �������. 
-- ������� ������ ������������ ���������� ������ ��� �������, ��� ����� ������ ��������� 1000 ������ � �������� ��������� � ��������� ���������� ����������� ������� � ������ ���������� ������� (�������� ������� ������).

CREATE TRIGGER InsteadOf_CheckPaymentAmount
ON Talon
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
		PRINT('��������: ' + (@TotalInserted - @TotalValid) + '������� �� ���� ���������, ��� ��� ����� ������ ��������� 1000 ������.')
GO

-- 4
-- �������� � AFTER-�������� �� �. 1 ����������� ���������� ������� � ������� ����� � ��� ������, ���� ����� ������ �� ��������� 1000 ������.
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

-- 5
-- ����������� INSTEAD OF-�������, ������� ��� �������� ���������� �� ������� ������� ��������� ������� ����� ������, ����� ������� � ��������� � �������� 1 � 10.
-- ������������ ������ ���� ������������� ����������� ����������� ��������� ������� � �������. 
-- ������� ������ ������������ �������� ������ ��������� ������� � �������� ��������� � ��������� ���������� ��������� ������� � ������ ���������� ������� (�������� ������� ������).
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
        PRINT '������� �������: ' + @TotalValid + '. ����� ���������� �������: ' + @TotalValid
GO

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
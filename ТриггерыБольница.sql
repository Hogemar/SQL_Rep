-- 1
-- Разработать AFTER-триггер, который разрешает заносить информацию о новом талоне в таблицу Талон в том случае, если Сумма оплаты не превышает 1000 рублей. 
-- Пользователю должна быть предоставлена возможность добавление множества записей в таблице. 
-- Если в множестве модифицируемых записей существует хоть одна запись, где Сумма оплаты превышает 1000 рублей, триггер должен откатить транзакцию и выдать сообщение об ошибке (Алгоритм «Все или ничего»).

CREATE TRIGGER After_CheckPaymentAmount
ON Талон
AFTER INSERT
AS
    IF EXISTS (SELECT 1 FROM inserted WHERE Сумма > 1000)
	BEGIN
		PRINT('Ошибка: Сумма оплаты превышает 1000 рублей. Транзакция отменена.')
        ROLLBACK TRANSACTION
	END
GO

-- 2
-- Разработать INSTEAD OF-триггер, который разрешает заносить информацию о новом талоне в таблицу Талон в том случае, если Сумма оплаты не превышает 1000 рублей.
-- Пользователю должна быть предоставлена возможность модификации множества записей в таблице. 
-- Триггер должен осуществлять добавление только тех записей, где Сумма оплаты превышает 1000 рублей и выдавать сообщение с указанием количества добавленных записей и общего количества записей (Алгоритм «Только нужное»).

CREATE TRIGGER InsteadOf_CheckPaymentAmount
ON Talon
INSTEAD OF INSERT
AS
    DECLARE @TotalInserted INT
    DECLARE @TotalValid INT

	 -- Получаем количество вставленных записей
    SET @TotalInserted = (SELECT COUNT(*) FROM inserted)

	-- Изначальное количество записей
	SET @TotalValid = (SELECT COUNT(*) FROM Талон)

    -- Вставляем только валидные записи во временную таблицу
    INSERT INTO Талон 
    SELECT * FROM inserted WHERE Сумма <= 1000

    -- Получаем количество валидных записей
    SET @TotalValid = (SELECT COUNT(*) FROM Талон) - @TotalValid

    -- Если есть хотя бы одна невалидная запись, выводим сообщение
    IF @TotalInserted > @TotalValid
		PRINT('Внимание: ' + (@TotalInserted - @TotalValid) + 'записей не были добавлены, так как сумма оплаты превышает 1000 рублей.')
GO

-- 4
-- Добавить к AFTER-триггеру из п. 1 возможность обновления записей в таблице Талон в том случае, если Сумма оплаты не превышает 1000 рублей.
CREATE TRIGGER After_CheckPaymentAmount
ON Талон
AFTER INSERT, UPDATE
AS
    IF EXISTS (SELECT 1 FROM inserted WHERE Сумма > 1000)
	BEGIN
		PRINT('Ошибка: Сумма оплаты превышает 1000 рублей. Транзакция отменена.')
        ROLLBACK TRANSACTION
	END
GO

-- 5
-- Разработать INSTEAD OF-триггер, который при удалении информации из таблицы Пациент разрешает удалять любые записи, кроме записей о пациентах с номерами 1 и 10.
-- Пользователю должна быть предоставлена возможность модификации множества записей в таблице. 
-- Триггер должен осуществлять удаление только требуемых записей и выдавать сообщение с указанием количества удаленных записей и общего количества записей (Алгоритм «Только нужное»).
CREATE TRIGGER DeletePatientRecordsInsteadOf
ON Пациент
INSTEAD OF DELETE
AS
    DECLARE @TotalDeleted INT
    DECLARE @TotalValid INT

	-- Получаем общее количество записей
    SET @TotalValid = (SELECT COUNT(*) FROM Пациент)
	
    -- Получаем количество удаленных записей
    SET @TotalDeleted = (SELECT COUNT(*) FROM deleted);

    -- Удаляем разрешенные записи из основной таблицы
    DELETE FROM Пациент WHERE [Страховой полис] IN 
		(SELECT [Страховой полис] FROM deleted WHERE [Страховой полис] NOT IN (1, 10))

	SET @TotalValid = @TotalValid - (SELECT COUNT(*) FROM Пациент)

    -- Если были удалены записи, выводим сообщение
    IF @TotalValid > 0
        PRINT 'Удалено записей: ' + @TotalValid + '. Общее количество записей: ' + @TotalValid
GO

-- 6
-- Разработать триггер, который при выполнении модификации таблицы выводит название команды, которая вызвала триггер.
CREATE TRIGGER LogTriggerAction
ON Талон
AFTER INSERT, UPDATE, DELETE
AS
    IF EXISTS (SELECT * FROM inserted)
		IF EXISTS(SELECT * FROM deleted)
		    PRINT 'Триггер вызвала команда UPDATE'
		ELSE
		    PRINT 'Триггер вызвала команда INSERT'
	ELSE
		PRINT 'Триггер вызвала команда DELETE'
GO

-- 7
-- Разработать INSTEAD OF-триггер, который при добавлении записей в таблице Талон 
-- разрешает добавлять только те строки, в которых ДатаВремя талона не превышают текущие дату и время.
CREATE TRIGGER CheckDateTimeOnInsert
ON Талон
INSTEAD OF INSERT
AS
    DECLARE @CurrentDateTime DATETIME;
    SET @CurrentDateTime = GETDATE();

    INSERT INTO Талон 
    SELECT * FROM inserted WHERE ДатаВремя <= @CurrentDateTime
GO
USE MASTER

GO

CREATE DATABASE Стоматология

ON

(NAME='Стоматология_Data',
FILENAME='C:\Users\User\Desktop\labs\Проектирование моделей данных\Стоматология\Стоматология_Data.mdf',
SIZE=3,
MAXSIZE=10,
FILEGROWTH=1)

LOG ON

(NAME='Стоматология_log', 
FILENAME='C:\Users\User\Desktop\labs\Проектирование моделей данных\Стоматология\Стоматология_Data.ldf',
SIZE=3,
MAXSIZE=10,
FILEGROWTH=1)

USE Стоматология
Go

CREATE TABLE Услуги
(Код smallint NOT NULL PRIMARY KEY,
Название varchar(50) NOT NULL)

CREATE TABLE Пациенты
(Номер smallint NOT NULL PRIMARY KEY,
Фамилия varchar (40) NOT NULL,
Адрес varchar (80),
[Год рождения] smallint NOT NULL )

CREATE TABLE ОказанныеУслуги
(Пациент smallint NOT NULL,
Услуга smallint NOT NULL,
Время time NOT NULL,
Стоимость smallmoney NOT NULL,
FOREIGN KEY (Пациент)REFERENCES Пациенты(Номер)/*ON DELETE CASCADE*/,
FOREIGN KEY (Услуга) REFERENCES Услуги(Код)
)/*ON DELETE CASCADE)*/

ALTER TABLE Услуги
ADD CONSTRAINT Unique_Название UNIQUE (Название)

ALTER TABLE ОказанныеУслуги
ADD CONSTRAINT PK_Время PRIMARY KEY (Время, Пациент)

ALTER TABLE Пациенты
ADD CHECK ([Год рождения]>=1920)

INSERT INTO Услуги
VALUES 
(100, 'Удаление зубов'),
(101, 'Лечение зубов'),
(102, 'Протезирование'),
(103, 'Отбеливание'),
(104, 'Чистка полости рта'),
(105, 'Декоративное украшение зубов'),
(106, 'Рентгенодиагностика'),
(107, 'Пародонтология'),
(108, 'Исправление прикуса'),
(109, 'Реставрация зубов')

INSERT INTO Пациенты
VALUES 
(1, 'Петров', 'Солнечная, 8, 46', 1989),
(2, 'Иванов', 'Радищева, 22, 22', 1961),
(3, 'Потапова', 'Горького, 37, 12', 1968),
(4, 'Зотов', 'Павлова, 1, 10', 1984),
(5, 'Ковалева', 'Свободы, 81, 70', 1989),
(7, 'Фролов', 'Почтовая, 65, 6', 1961),
(8, 'Татаринова', 'Соборная, 2, 10', 1975),
(9, 'Ильин', 'Урицкого, 67, 3', 1987),
(10, 'Сафронова', 'Каляева, 13, 20', 1980)

INSERT INTO Пациенты(Номер, Фамилия, [Год рождения])
VALUES  (6, 'Сидоров',  1989)

INSERT INTO ОказанныеУслуги
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

CREATE TYPE Группа_крови
FROM varchar(5)

/*ALTER TABLE Пациенты
ADD [Группа крови] Группа_крови DEFAULT 'O' CHECK ([Группа крови] IN ('O', 'A', 'B', 'AB'))*/
 
GO
-- Создание DEFAULT значения
CREATE DEFAULT dbo.DefaultГруппа_крови AS 'O';

GO

ALTER TABLE Пациенты
ADD Группа_крови varchar(5) DEFAULT dbo.DefaultГруппа_крови WITH VALUES;

ALTER TABLE Пациенты
ADD CONSTRAINT CK_Группа_крови CHECK (Группа_крови IN ('O', 'A', 'B', 'AB'));







--- 14.02.2024 Лаба ---

		/* 1. Изучение оператора CREATE RULE для создания правил, 
		использование системной хранимой процедуры sp_bindrule для 
		связывания правила с объектами БД.*/

/* 1.1. Создать правило, которое позволяет использовать в качестве 
значений атрибута только те значения, которые начинаются с 
русской буквы.*/

GO
CREATE RULE R_startswrus
	AS @str LIKE '[А-Я]%'
GO

/*1.2. Связать правило со столбцом Фамилия пациента и со столбцом 
Название услуги.*/
EXEC sp_bindrule 'R_startswrus', 'Пациенты.Фамилия'
EXEC sp_bindrule 'R_startswrus', 'Услуги.Название'

		/*2. Изучение оператора CREATE DEFAULT для создания умолчаний, 
		использование системной хранимой процедуры sp_binddefault для 
		связывания умолчания с объектами БД.*/

/*2.1. Создать умолчание 200.*/
GO
CREATE DEFAULT D_200
	AS 200
GO

/*2.2. Связать умолчание со столбцом Стоимость приёма.*/
EXEC sp_bindefault 'D_200', 'ОказанныеУслуги.Стоимость'

		/*3. Изучение оператора CREATE VIEW для создания представлений, 
		выполнение запросов к представлениям.*/

/*3.1. Создать представление с информацией о приёмах. 
Представление должно включать столбцы Фамилия пациента, 
Название услуги, Время, Стоимость (в руб.).*/
GO
CREATE VIEW V_Приёмы AS
	SELECT Фамилия, Название, Время, STR(Стоимость) + 'руб.' AS Стоимость
	  FROM (Услуги JOIN ОказанныеУслуги ON Услуги.Код = ОказанныеУслуги.Услуга) JOIN Пациенты ON ОказанныеУслуги.Пациент = Пациенты.Номер

/*3.2. Выполнить запрос, который на основе созданного в п.3.1 
представления для каждого пациента выводит фамилию 
пациента и суммарное количество оказанных ему услуг.*/
GO
SELECT Фамилия, COUNT(Название) AS [Количество приёмов]
	FROM V_Приёмы
	GROUP BY Фамилия


/*4. Создание представлений с ограничением WITH CHECK OPTION. 
Модификация базовых таблиц через представление.*/

/*4.1Создать представление с информацией о пациентах, которые 
родились до 1995 года.
*/
GO
CREATE VIEW V_Пациенты_до95 AS
 SELECT*
 FROM Пациенты
 WHERE [Год рождения]<1995
 WITH CHECK OPTION

 /*4.2. Разработать запросы для добавления, удаления и обновления
одной записи о пациенте на основе созданного в п. 4.1 
представления.
*/
GO
UPDATE Пациенты
SET Пациенты.Фамилия = 'Ильич'
FROM V_Пациенты_до95
WHERE Пациенты.Фамилия = 'Ильин'

GO
DELETE Пациенты
FROM V_Пациенты_до95
WHERE Пациенты.Фамилия='Фролов'

GO
INSERT INTO V_Пациенты_до95
VALUES (12,'Тихонов', 'Солнечная, 15, 34', 1996)


--- ЗАДАЧИ на сдачу от 28.02.24 ---

-- Создать представление, кот. выводит услуги, на которые не было посещений
GO
CREATE VIEW useless_услуги AS
	SELECT Код, Название
	FROM Услуги
	WHERE Код NOT IN (SELECT Услуга FROM ОказанныеУслуги)

GO

-- Создать правило, что пациент старше 18 лет
GO
CREATE RULE R_older18
	AS YEAR(GETDATE()) - @birthYear >=18
GO

EXEC sp_bindrule 'R_older18', 'Пациенты.[Год рождения]'


--* Лаба по хранимым процедурам 28.02.24 *--

/*1.1. Разработать хранимую процедуру, которая по заданному 
номеру пациента возвращает его фамилию и адрес.*/

GO
CREATE PROCEDURE GetPacient @pacientNum smallint AS
	SELECT Фамилия, Адрес
	FROM Пациенты
	WHERE Номер = @pacientNum

EXEC GetPacient 2

/*1.3. Разработать хранимую процедуру, которая по заданным 
значениям номера пациента, названия услуги и времени 
приема выводит значение стоимости в валюте, заданной 
пользователем.*/
DROP PROCEDURE PrintPrice
GO
CREATE PROCEDURE PrintPrice
	@pacientNum smallint,
	--@serviceName varchar(50),
	@serviceTime time(7),
	@currency varchar(15)		AS

	IF(@currency NOT IN('рубль', 'евро', 'доллар'))
		BEGIN
			PRINT 'Неизвестная валюта!'
			Return -4
		END

	DECLARE @pacientName varchar(40)
	SELECT @pacientName = Фамилия FROM Пациенты WHERE Номер = @pacientNum
	
	IF(@pacientName IS NULL)
		BEGIN
			PRINT 'Неверный номер пациента!'
			Return -1
		END

	DECLARE @servicePrice smallmoney--varchar(20)
	SELECT @servicePrice = Стоимость FROM ОказанныеУслуги WHERE Пациент = @pacientNum AND Время = @serviceTime
	
	IF(@servicePrice IS NULL)
		BEGIN
			PRINT 'Не найдена запись на приём!'
			Return -3
		END

	DECLARE @serviceName varchar(50)
	SELECT @serviceName = Название FROM Услуги WHERE Код = (SELECT Услуга FROM ОказанныеУслуги WHERE Пациент = @pacientNum AND Время = @serviceTime)

	PRINT 'Время приёма: ' + CONVERT(varchar(10), @serviceTime)
	PRINT 'Пациент: ' + @pacientName + ', Услуга: ' + @serviceName

	IF(@currency = 'евро')
		PRINT 'Стоимость: ' + CONVERT(varchar(20), @servicePrice/100.0) + ' евро'
	ELSE IF(@currency = 'доллар')
		PRINT 'Стоимость: ' + CONVERT(varchar(20), @servicePrice/70.0) + ' долларов'
	ELSE
		PRINT 'Стоимость: ' + CONVERT(varchar(20), @servicePrice) + ' рублей'

GO
EXEC PrintPrice 3, '11:30:00', 'евро' 
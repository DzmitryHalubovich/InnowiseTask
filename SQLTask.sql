create database BankSectorDB

create table Clients(
	[ID] [int] PRIMARY KEY,
	[Name] [varchar] (50) NOT NULL,
	[Surname] [varchar] (50) NOT NULL,
	[SocialStatus] [int] NOT NULL
	CONSTRAINT FK_SocialStatus FOREIGN KEY (SocialStatus) REFERENCES SocialStatus(ID)
)

alter table SocialStatus Alter column [ID] [int] NOT NULL

create table SocialStatus(
	[ID] [int] NOT NULL,
	[SocialStatus] [varchar] (20) NOT NULL
	CONSTRAINT PK_ID PRIMARY KEY (ID)
)

create table Banks(
	[ID] [int] PRIMARY KEY,
	[Name] [varchar] (60) NOT NULL,
)

create table Cities(
	[ID] [int] PRIMARY KEY,
	[Name] [varchar] (30) NOT NULL
)

create table Branches(
	[Bank_id] [int] REFERENCES Banks(ID),
	[City_id] [int] REFERENCES Cities(ID),
	CONSTRAINT Banks_Cities_PK PRIMARY KEY (Bank_id, City_id) 
) 

CREATE TABLE Accounts(
	[Client_id] [int] NOT NULL,
	[Bank_id] [int] NOT NULL,
	[Client_Bank_id] [int] PRIMARY KEY,
	[Amount] [money] NULL,
	CONSTRAINT Client_id_FK FOREIGN KEY (Client_id) REFERENCES Clients(ID),
	CONSTRAINT Bank_id_FK FOREIGN KEY (Bank_id) REFERENCES Banks(ID)
)

CREATE TABLE Cards(
	[Client_Bank_id] [int] NULL,
	[Card_Number] [int] NULL,
	CONSTRAINT Card_Number_FK FOREIGN KEY (Client_Bank_id) REFERENCES Accounts(Client_Bank_id)
)

--Заполняю таблицу данными

INSERT INTO Clients
	values (1, 'Владимир', 'Котляров', 2),
		   (2, 'Олег', 'Трубный', 3),
		   (3, 'Андрей', 'Малахов', 5),
		   (4, 'Генадий', 'Тищенко', 1),
		   (5, 'Инокентий', 'Трофимов', 5)

INSERT INTO SocialStatus
	values (1, 'Безработный'),
		   (2, 'Пенсионер'),
		   (3, 'Инвалид'),
		   (4, 'Школьник'),
		   (5, 'Бюджетник')

INSERT INTO Cities
	values (1, 'Минск'),
		   (2, 'Гомель'),
		   (3, 'Могилев'),
		   (4, 'Витебск'),
		   (5, 'Брест'),
		   (6, 'Гродно')

INSERT INTO Banks
	values (1, 'ВорГосБанк'),
		   (2, 'БСТРБанк'),
		   (3, 'АгроСтройБанк'),
		   (4, 'БанкМедленныхРешений'),
		   (5, 'ПроцентБанк')

INSERT INTO Branches
	values (1,1),
		   (1,3),
		   (1,4),
		   (2,1),
		   (2,2),
		   (2,3),
		   (2,4),
		   (3,3),
		   (3,4),
		   (4,5),
		   (5,1),
		   (5,2)

INSERT INTO Accounts
	values (1,1,1, 500),
		   (1,3,2, 400),
		   (2,5,3, 260),
		   (3,4,4, 1300),
		   (4,2,5, 250),
		   (5,1,6, 680) 

INSERT INTO Cards
	values (1, 45231234),
		   (1, 22113344),
		   (2, 43443333),
		   (3, 55422177),
		   (4, NULL),
		   (5, NULL)

INSERT INTO Cards
	values (4, NULL),
		   (5, NULL)

--Список банков у которых есть филиалы в городе Витебск (ID = 4)

select Branches.Bank_id as [ID банка], Banks.Name as [Название банка]
from Branches
LEFT JOIN Banks ON Branches.Bank_id = Banks.ID
where Branches.City_id =4

--Список карточек с указанием имени владельца, баланса и названия банка

select C.Card_Number as [Номер карты], Cl.Name [Имя владельца], Acc.Amount [Сумма на счете], B.Name as [Название банка]
from Cards as C, Accounts as Acc, Clients as Cl, Banks as B
where C.Client_Bank_id = Acc.Client_Bank_id 
and Acc.Client_id = Cl.ID
and Acc.Bank_id = B.ID
and C.Card_Number IS NOT NULL

--Показать список банковских аккаунтов у которых баланс не совпадает с суммой баланса по карточкам.
--В отдельной колонке вывести разницу

select Client_Bank_id
from Accounts

--Вывести кол-во банковских карточек для каждого соц статуса (2 реализации, GROUP BY и подзапросом)

select COUNT()
from Cards as C, Accounts as Acc, Clients as Cl, SocialStatus as SS
where Acc.Client_id = Cl.ID and SS.ID = 





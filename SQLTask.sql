create database BankSectorDB

create table Clients(
	[ID] [int] PRIMARY KEY,
	[Name] [varchar] (50) NOT NULL,
	[Surname] [varchar] (50) NOT NULL,
	[SocialStatus] [int] NOT NULL
	CONSTRAINT FK_SocialStatus FOREIGN KEY (SocialStatus) REFERENCES SocialStatus(ID)
)

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
	[Cash] [money] NULL
	CONSTRAINT Card_Number_FK FOREIGN KEY (Client_Bank_id) REFERENCES Accounts(Client_Bank_id)
)

--�������� ������� �������

INSERT INTO Clients
	values (1, '��������', '��������', 2),
		   (2, '����', '�������', 3),
		   (3, '������', '�������', 5),
		   (4, '�������', '�������', 1),
		   (5, '���������', '��������', 5)

INSERT INTO SocialStatus
	values (1, '�����������'),
		   (2, '���������'),
		   (3, '�������'),
		   (4, '��������'),
		   (5, '���������')

INSERT INTO Cities
	values (1, '�����'),
		   (2, '������'),
		   (3, '�������'),
		   (4, '�������'),
		   (5, '�����'),
		   (6, '������')

INSERT INTO Banks
	values (1, '����������'),
		   (2, '��������'),
		   (3, '�������������'),
		   (4, '��������������������'),
		   (5, '�����������')

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
	values (1, 45231234, 795),
		   (1, 22113344, 1540),
		   (2, 43443333, 1230),
		   (3, 55422177, 560),
		   (4, NULL, NULL),
		   (5, NULL, NULL),
		   (1, 66667777, 500),
		   (2, 99885544, 400)


GO

--������ ������ � ������� ���� ������� � ������ ������� (ID = 4)

select Branches.Bank_id as [ID �����], Banks.Name as [�������� �����]
from Branches
LEFT JOIN Banks ON Branches.Bank_id = Banks.ID
where Branches.City_id =4

--������ �������� � ��������� ����� ���������, ������� � �������� �����

select C.Card_Number as [����� �����], Cl.Name [��� ���������], Acc.Amount [����� �� �����], B.Name as [�������� �����]
from Cards as C, Accounts as Acc, Clients as Cl, Banks as B
where C.Client_Bank_id = Acc.Client_Bank_id 
and Acc.Client_id = Cl.ID
and Acc.Bank_id = B.ID
and C.Card_Number IS NOT NULL

--�������� ������ ���������� ��������� � ������� ������ �� ��������� � ������ ������� �� ���������.
--� ��������� ������� ������� �������

select Ac.Client_Bank_id as [����� ��������], Ac.Amount as [����� �� ��������], 
C.Cash [����� �� �����], Ac.Amount - C.Cash as [������� �������-�����]
from Accounts as Ac, Cards as C
where C.Client_Bank_id = Ac.Client_Bank_id and C.Cash <> Ac.Amount

--������� ���-�� ���������� �������� ��� ������� ��� ������� (2 ����������, GROUP BY � �����������)

--GROUP BY
select SS.SocialStatus as [���. ������], Count(Cr.Card_Number) as [���-�� ��������]
from SocialStatus as SS
left join Clients as Cl on SS.ID = Cl.SocialStatus
left join Accounts as Acc on Cl.ID = Acc.Client_id
left join Cards as Cr on Acc.Client_Bank_id = Cr.Client_Bank_id
GROUP BY SS.SocialStatus

--select Q1.[���-�� ��������]
--from(select Count(Cr.Card_Number) as '���-�� ��������'
--	 from Cards as Cr) as Q1

--���������
select Q1.[���. ������], Q1.[���-�� ��������]
from (select SS.SocialStatus as [���. ������], Count(Cr.Card_Number) as [���-�� ��������]
		from SocialStatus as SS
		left join Clients as Cl on SS.ID = Cl.SocialStatus
		left join Accounts as Acc on Cl.ID = Acc.Client_id
		left join Cards as Cr on Acc.Client_Bank_id = Cr.Client_Bank_id
		GROUP BY SS.SocialStatus) as Q1




--�������� ������� �� ������� Account/Cards ����� ������ ���� ������� �������� � ���� 
--������ ���� ��� ������������ ��������  (�� ���� ������ �������� �������� � Account �� �������, 
--��� ����� �������� �� ���� ���������. � �������������� ������ �������� ������ ����� 
--���� � ����� ����� �� ������ ����� ������ ��� ������ ��������)




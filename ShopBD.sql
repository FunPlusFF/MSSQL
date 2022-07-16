CREATE DATABASE testSQL
go
Use testSQL
--Создание таблиц
CREATE TABLE Atributs(
IDAtributs int identity(1,1) primary key,
screenwriter nvarchar(50),
produser nvarchar(50),
mainRole nvarchar(100)
)
go
CREATE TABLE Casets(
IDCasets int identity(1,1) primary key,
nameFilm nvarchar(50),
yearFilm int,
IDAtribut int unique references dbo.Atributs(IDAtributs),
CountCasets int
)
go
CREATE TABLE Prize(
IDPrize int identity(1,1) primary key,
nameFestival nvarchar(50),
countPrize int
)
go
Create table KinoPrize(
IDFilm int foreign key references dbo.Atributs(IDAtributs),
IDPrize int foreign key references dbo.Prize(IDPrize)
)
go
--Проверочка на наличие бд
sp_helpdb testSQL
go 
--Создание процедур первая добаление фильмов, вторая добавление касеты, третья добавление прозов и награждение фильмов
Create procedure AddAtributs(@screenwriter nvarchar(50) , @produser nvarchar(50), @ManeRole nvarchar(100)) as
insert into Atributs
values 
(@screenwriter, @produser, @ManeRole)
go 

Create procedure AddCasets(@nameFilm nvarchar(50),@yearFilm int,@IDAtribut int, @CountCasets int) as
insert into Casets
values 
(@nameFilm, @yearFilm, @IDAtribut, @CountCasets)
go

Create procedure AddPrize(@nameFestival nvarchar(50),@countPrize int)
as
insert into Prize
values
(@nameFestival, @countPrize)
go

Create procedure NominateFilm(@IDfilm int, @IDPrize int)
as
insert INTO KinoPrize
values
(@IDfilm, @IDPrize)
go
--запрос на обновление таблиц
create procedure UpdateCasets (@ID int,
@nameFilm nvarchar(50),
@yearFilm int,
@IDAtribut int,
@CountCasets int)
as update Casets 
set Casets.nameFilm = @nameFilm, Casets.yearFilm = @yearFilm,
Casets.IDAtribut = @IDAtribut, Casets.CountCasets = @CountCasets
where Casets.IDCasets = @ID

go
Create procedure UpdateAtributs(@ID int, @screenwriter nvarchar(50) , @produser nvarchar(50), @ManeRole nvarchar(100)) 
as
update Atributs
set screenwriter = @screenwriter,produser = @produser,mainRole = @ManeRole
where IDAtributs = @ID
go 

Create procedure UpdatePrize(@Id int, @nameFestival nvarchar(50),@countPrize int) 
as
update Prize
set nameFestival = @nameFestival,countPrize = @countPrize
where IDPrize = @ID
go 

--запросы на удаление строк по ID
Create procedure DeleteCasets(@ID int)
as 
delete from Casets
where IDCasets = @ID
go

Create procedure DeleteAtribute(@ID int)
as 
delete from Atributs
where IDAtributs = @ID
go

Create procedure DeletePrize(@ID int) 
as 
delete from Prize
where IDPrize = @ID
go

Create procedure DeleteNomination(@ID int)
as
delete from KinoPrize
where IDFilm = @ID
--Заполнение таблиц

Exec AddAtributs 'Adam Smith', 'Teador Manth', 'Aliot Jam'
Exec AddAtributs 'Adam Gin', 'Teador Fins', 'Saden Lon'
Exec AddAtributs 'Gindan Inds', 'Ensan Milse', 'Londs Finds'
Exec AddAtributs 'Adam Gin', 'Teador Fins', 'Saden Lon'
Exec AddAtributs 'Teador Fins', 'Ensan Lon', 'Aliot Jam'
Exec AddAtributs 'Adam Gin', 'Teador Fins', 'Saden Lon'

EXEC AddCasets 'find over', 2000,1, 10
EXEC AddCasets 'My Name', 2010,2, 5
EXEC AddCasets 'Fikus', 2001,3, 20
EXEC AddCasets 'Filler', 2005,4, 2
EXEC AddCasets 'Vartugon', 2000,5, 4

exec AddPrize 'Niom', 2
exec AddPrize 'Miadom', 1
exec AddPrize 'Oscar', 3
exec AddPrize 'avi', 5

exec NominateFilm 1, 2
exec NominateFilm 1, 4
exec NominateFilm 2, 4
exec NominateFilm 2, 3
exec NominateFilm 4, 1
exec NominateFilm 5, 3

--Создание представлений
go
Create view ViewCaset as
Select c.IDCasets, c.nameFilm, c.yearFilm, a.screenwriter, a.produser, a.mainRole, c.CountCasets
from Casets as c Inner Join Atributs as a
on c.IDAtribut = a.IDAtributs
go
--Cоздание представлений с расчетными полями
Create view SumCaset as
Select SUM(c.CountCasets) as CountCasets
from Casets as c
go
Create view AvgCasets as
Select AVG(c.CountCasets) as AvgCasets
from Casets as c
go
Create view CountCasets as
Select Count(c.CountCasets) as AvgCasets
from Casets as c
go
--Создание польлзователей и ролей
Create Login Lord with password='1', default_database = testSQL
Create User Administrator for login Lord

Create Login Slave with password='1', default_database = testSQL
Create User SimpleUser for login Slave
go 
Create Role Administrators
Go
sp_addrolemember 'Administrators', 'Administrator'
go

Create Role SimpleUsers
go
sp_addrolemember 'SimleUsers', 'SimpleUser'
go

--GRANT 
Grant Select, Exec, update to SimpleUsers
GRANT Select, exec, update, create table, create proc, delete, backup Log, backup database to Administrators

--DENY 
deny Delete to SimpleUsers
DENY Backup database to SimpleUsers
--Создание резервного копирования базы данных
go
Alter Database testSQL set recovery full 
go
sp_addumpdevice 'disk', Database_testSQL,
'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\testSQL.bak'
go

Backup database testSQL to Database_testSQL 
go
--Создание бэкапа лог файлов
Alter Database testSQL set recovery full 
go
sp_addumpdevice 'disk', log_testSQL,
'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\log_testSQL.bak'
go
backup log testSQL to log_testSQL 
go
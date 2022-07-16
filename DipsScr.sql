--Удаление Базы Данных
--use master
--DROP DATABASE Class_Manager 
--go

--Создание Базы данных
Create DATABASE Class_Manager
go 

use Class_Manager
go
--Создание главной таблицы Студентов 
CREATE TABLE Students (
Student_ID int identity(1 , 1) Primary Key,
First_Name nvarchar(20) not null, 
Second_Name nvarchar(20) NOT NULL, 
Fathers_Name nvarchar(20) NOT NULL
)
GO 
--Создание таблицы Родители студентов 
CREATE TABLE Parents (
Student_ID int PRIMARY KEY  foreign key references Students(Student_ID),
First_Name nvarchar(20) not null, 
Second_Name nvarchar(20) NOT NULL, 
Fathers_Name nvarchar(20) NOT NULL, 
Address_ nvarchar(80) NOt NULL,
Phone_Number char(11) NOT NULL,

)
go

--СОздание таблицы контактов студента
CREATE TABLE Contacts (
Student_ID int PRIMARY KEY  foreign key references Students(Student_ID),
Address_Name nvarchar(80) NOT NULL,
Phone_Number char(11) NOT NULL,
Email nvarchar(60) Not NULL,
Data_Born date NOT NULL
)
--Создание таблицы оценки
go 
CREATE TABLE Estimates (
Student_ID int PRIMARY KEY foreign key references Students(Student_ID),
MDK_0202 int NOT NULL,
MDK_0301 int NOT null, 
Web int NOT NULL,
PPEP int NOT NULL,
Applied_Programming int NOT NULL,
Enterprise_Economy int NOT NULL,
Certification int NOT NULL, 
Law int NOT NULL
)
go
--Создание тоблицы посещаймость
Create table Attendance (
Student_ID int foreign key references Students(Student_ID),
A_Month int NOT NULL,
A_Year int NOT NULL,
Count_pass int NOT NULL,
Constraint table_PK PRIMARY KEY (Student_ID, A_Month, A_Year), --Создание составного ключа 
)
go

CREATE TABLE Soc_State(
Student_ID int PRIMARY KEY foreign key references Students(Student_ID),
Preferential_payments money NOT null, --Количество выдавемых денег
Reason nvarchar(128) NOT NULL, --Причина выплат
Term date NOT NULL --Срок
)
go

--Создание Процедура на заполнение 
--Добавляет студента 
Create proc add_Student
@name NVARCHAR(20), @last_Name NVARCHAR(20), @father_Name NVARCHAR(20)
as
insert into Students Values(
@name, @last_Name, @father_Name)

go
--Создание Процедуры Заполнения контактов
CREATE PROC add_Contacts_Student
@Student_ID int, @Address_Name nvarchar(80), @phone_Number char(11), @email nvarchar(60), @data_born date
as 
insert into Contacts VALUES(
@Student_ID, @address_Name, @phone_Number, @email, @data_born
)
go
--Добавление Родителей
CREATE PROC add_Perents_Student
@Student_ID int, @first_name NVARCHAR(20), @last_Name NVARCHAR(20), @father_Name NVARCHAR(20), @Address_Parents NVARCHAR(60),@phone_Number char(11)
as 
insert into Parents VALUES(
@Student_ID , @first_name , @last_Name , @father_Name , @Address_Parents ,@phone_Number 
)
go

--Добавление Оценочек 
CREATE PROC add_Estimates_Student
@Student_ID int, @MDK_0202 int, @MDK_0301 int, @Web int, @PPEP int, @Applied_progremming int, @enterprise_economy int, @Certification int, @Law int
as 
insert into Estimates VALUES(
@Student_ID , @MDK_0202 , @MDK_0301 , @Web , @PPEP , @Applied_progremming , @enterprise_economy , @Certification , @Law 
)
go
--Добавение студенту соц статуса для льгот 
CREATE PROC add_SocStatus_Student
@Student_ID int, @Preferential money, @Reason nvarchar(60), @Term date
as 
insert into Soc_State VALUES(
@Student_ID , @Preferential,  @Reason, @Term
)
go
--Добавление Пропусков студента
CREATE PROC add_Attendace 
@ID_Student int, @A_Month int, @A_Year int, @Count_pass int
as
insert into Attendance VALUES (
@ID_Student,@A_Month, @A_Year, @Count_pass
)

go
--Просмотр таблиц
--Создание Процедуры вывода студентов
CREATE proc out_students as
select * from Students
go

--Создание Процедуры вывода студентов
CREATE proc out_SocSttatus as
select * from Soc_State
go
--Создание Процедуры вывода Пропусков
CREATE proc out_Attendance as
select * from Attendance
go
--Создание Процедуры вывода Оценнок
CREATE proc out_Estimates as
select * from Estimates
go
--Создание Процедуры вывода Родителей
CREATE proc out_Parents as
select * from Parents
go
--Создание Процедуры вывода студентов
CREATE proc out_Contacts as
select * from Contacts
go

----создание процедуры для поика Id студента
CREATE PROC Find_IDStudent
@NAME NVARCHAR(20), @SECONDNAME NVARCHAR(20)
AS
Select * from Students
Where @NAME = First_Name and @SECONDNAME = Second_Name 
go

--ПОиск двоешников
Create proc Bad_Students 
AS
select * from Estimates
where MDK_0202 = 2 or 
MDK_0301 = 2 or
Web = 2 or
PPEP = 2 or
Applied_Programming = 2 or
Enterprise_Economy = 2 or
Certification = 2 or
Law = 2

go

--Поиск студента, который пропустил более 40 часов и выдача его имени и связей с родителями
Create proc Pass_StudParents as
select T.Student_ID, T.First_Name, T.Second_Name,
T.Fathers_Name, Attendance.Count_pass, P.First_Name, 
P.Second_Name, P.Fathers_Name, P.Phone_Number 
from Students as T, Attendance, Parents as P
where count_pass > 40 
go


--Поиск Хороших студентов !исправить!!!!!
Create proc good_Students 
AS
select * from Estimates
where MDK_0202 >= 4 and 
MDK_0301 >= 4  and
Web >= 4  and
PPEP >= 4  and
Applied_Programming >= 4  and
Enterprise_Economy >= 4  and
Certification >= 4  and
Law >= 4
go

Create proc Sr_Ball
@id int
AS
select e.Student_ID , (e.MDK_0202 + e.MDK_0301 + e.Web + e.PPEP + e.Applied_Programming + e.Enterprise_Economy + e.Certification + e.Law) / 8 as 'avg mark' from Estimates e
where e.Student_ID = @id
go
--exec Sr_Ball 2
--drop proc Sr_Ball
--Ищем отличных студентом
Create proc Pefect_Students 
AS
select * from Estimates
where MDK_0202 = 5 or 
MDK_0301 = 5  or
Web = 5  or
PPEP = 5 or
Applied_Programming = 5  or
Enterprise_Economy = 5  or
Certification = 5 or
Law = 5 
go
 --Связь со студентом
 Create PROC Find_Students @IdStudent int
 as 
 select S.Student_ID, S.First_Name, S.Second_Name, S.Fathers_Name, C.Phone_Number, C.Email
 from Contacts as C
 inner join Students s on c.Student_ID = s.Student_ID
 Where @IdStudent = S.Student_ID 
 
 go 

 --Связь с Студентом по Id
 Create PROC Find_Contacts_Stud
@First_Name nvarchar(20), @Second_Name nvarchar(20)
 as 
 select S.Student_ID, S.First_Name, S.Second_Name, S.Fathers_Name, C.Phone_Number, C.Email
 from  Contacts as C
  inner join Students s on c.Student_ID = s.Student_ID
 Where @First_Name = S.First_Name and
@Second_Name = S.Second_Name
go
--drop proc Find_Contacts_Stud
--exec Find_Contacts_Stud 'Иван', 'Иванов'
--Просмотр оценок студентов
Create proc Student_Marks
@StudentsID int
 as 
 select S.Student_ID, S.First_Name, S.Second_Name, S.Fathers_Name, E.MDK_0202, 
MDK_0301,Web, PPEP, Applied_Programming, Enterprise_Economy,
Certification, Law
 from Estimates as E
 inner join Students s on e.Student_ID = s.Student_ID
 Where @StudentsID = S.Student_ID
 go


  --Показывает студента и его пропуски
 Create proc Student_pass
 @ID int 
 as
 SELECT s.First_Name, s.Second_Name, a.A_Month, a.A_Year, a.Count_pass
 from Attendance as a
 inner join Students s on a.Student_ID = s.Student_ID
 where @ID = s.Student_ID
 go
 exec Student_pass 1
 drop proc Student_pass


 --Показывает Пропуски всех студентов
 Create view view_Stud_Pass as 
 select s.First_Name, s.Second_Name, a.A_Month, a.A_Year, a.Count_pass
 --from Students as s, Attendance as a
 from Students s
inner join Attendance a on a.Student_ID = s.Student_ID
 go

--drop view view_Stud_Estimates
 --Показывает оценки всех студентов
 create view view_Stud_Estimates as 
 select s.Student_ID, s.First_Name, s.Second_Name, e.MDK_0202, e.MDK_0301, e.PPEP, e.Web, e.Applied_Programming, e.Certification, e.Enterprise_Economy, e.Law
 from Students s  
 inner join Estimates e on e.Student_ID = s.Student_ID
  go


  --Показывает соц статус всех студентов
 Create view view_Soc_State_Student as
 select s.First_Name, s.Second_Name, c.Preferential_payments, c.Reason, c.Term
 from Soc_State c
 inner join Students s on s.Student_ID = c.Student_ID
  go 

 --Показать всех родителей студентов
 Create view view_Studens_Parents as
 select s.First_Name 'Name', s.Second_Name'Second name', p.First_Name 'Parents name', p.Second_Name 'psrents second nsme', p.Fathers_Name, p.Phone_Number 
 From Parents p
 inner join Students s on s.Student_ID = p.Student_ID
 go


 --средняя оценка студента
 Create view view_Sr_Estimates_Stud as
 select First_Name, s.Second_Name, (e.MDK_0202+ e.MDK_0301+ e.PPEP+ e.Student_ID+ e.Web+ e.Applied_Programming+ e.Certification + e.Enterprise_Economy + e.Law) / 8  as 'Avg Estimates'
 from Students as s
 inner join Estimates e on e.Student_ID = s.Student_ID
 go 
 
 --select * from view_Sr_Estimates_Stud
 --drop view view_Sr_Estimates_Stud
 go




 Create view view_grEstimates as
 select s.First_Name, s.Second_Name, (e.MDK_0202+ e.MDK_0301+ e.PPEP+ e.Student_ID+ e.Web+ e.Applied_Programming+ e.Certification + e.Enterprise_Economy + e.Law) / 8  as 'Avg Estimates'
 from  Estimates e
 inner join Students s on e.Student_ID = s.Student_ID
 Where 'Avg Estimates' > 2
 go 

  -- select * from view_grEstimates
 --drop view view_grEstimates





 --Средняя количство пропусков студента
 --Create view view_Sr_Pass_Count as
 --select s.First_Name, s.Second_Name, AVG(a.Count_pass) 'AVG Count_Pass'
 --from Students as s
 --inner join Attendance a on a.Student_ID = s.Student_ID
 --go
     
	 Create view view_Sr_Estimates as
 select Avg(e.MDK_0202) 'Avg MDK_0202', Avg(e.MDK_0301) 'Avg MDK_0301', Avg(e.PPEP)'Avg PPEP', Avg(e.Student_ID)'Avg Student_ID',  Avg(e.Web) 'Avg Web', Avg(e.Applied_Programming) 'Avg Applied_Programming', Avg(e.Certification) 'Avg Certification', Avg(e.Enterprise_Economy) 'Avg Enterprise_Economy', Avg(e.Law) 'Avg low'
 from Students as s
 inner join Estimates e on e.Student_ID = s.Student_ID
 go 
  --drop view view_Sr_Estimates
  --select * from view_Sr_Estimates
 --Группировка По посещаемости
 --Create view view_OrderName_Sr_CountBy_Stud as
 --select s.First_Name, s.Second_Name, Avg(a.Count_pass) as 'AVG Count_Pass' 
 --from Students s, Attendance a
 --Group By s.First_Name, s.Second_Name
 --go
 -- select * from view_OrderName_Sr_CountBy_Stud
 -- drop view view_OrderName_Sr_CountBy_Stud
 --Группировка по Успеваймости
--  Create view view_OrderName_Sr_Estimates_Stud as
--select s.First_Name, s.Second_Name, AVG(e.MDK_0202+ e.MDK_0301+ e.PPEP+ e.Student_ID+ e.Web+ e.Applied_Programming+ e.Certification + e.Enterprise_Economy + e.Law) 'Avg Estimates'
-- from Students as s, Estimates as e
-- Group By s.First_Name, s.Second_Name
----Create view view_OrderName__Stud
----select s.First_Name, s.Second_Name
----from Students as s




--go
--Создание пользователей

use Class_Manager
go
Create LOGIN YA 
With Password = '1'
go
Create user Ya
for LOGIN YA

Create LOGIN YU 
With Password = '1'


Create user Yu
for LOGIN YU

Create Login YI
With Password = '1'
go
Create user Yi
for LOGIN YI
go
Create Login YO
WITH Password = '1'
go
Create user Yo
for LOGIN YO

Grant select to Yo
--drop user Yi
--drop login YI[jack]

--drop user Ya
--drop login YA
--drop user Yu
--drop login YU


--drop ROLE PREPODAV_BD
--DROP ROLE Simpl_Student
--Создание ролей и добавление ролей

CREATE ROLE PREPODAV_BD  

Exec sp_addrolemember @rolename= 'PREPODAV_BD', @membername='Ya'

go
Create ROLE Simpl_Student

Exec sp_addrolemember @rolename= 'Simpl_Student', @membername='Yi'

Exec sp_addrolemember @rolename= 'Simpl_Student', @membername='Yu'

go
deny CREATE to Simpl_Student
deny Insert TO Simpl_Student
Grant select to Simpl_student
grant exec Student_pass to Simpl_student


GRANT create TO PREPODAV_BD
GRANT iNSERT TO PREPODAV_BD
GRANT EXEC TO PREPODAV_BD
go

sp_addumpdevice 'disk', 'BackupDatabase', '..BACKUPS\FullBackup.bak'
GO
BACKUP DATABASE Class_Manager
TO BackupDatabase with init
--Диференциированная копия
BACKUP DATABASE Class_Manager
TO BackupDatabase
WITH INIT,DIFFERENTIAL 
go
sp_addumpdevice 'disk', 'BackupDatabaseLOG', '..BACKUPS\LogBackup.bak'
BACKUP log Class_Manager

exec add_Student Иван, Иванов, Иванович
exec add_Student Мария, Кузнецова, Игоревна
exec add_Student Григорий, Куликов, Степанович
exec add_Student Никита, Ульянов, Алексеевич
exec add_Student Никита, Масковцев, Никитович
exec add_Student Николай, Маленов, Григорьевич
exec add_Student Константин, Ульянов, Валерьевич



exec add_Contacts_Student 1, 'Пр Новичков д13', 89683414857, 'ggFiz@gmail.com', '10/10/2001'
exec add_Contacts_Student 2, 'Пр Новичков д15', 89685318497, 'ofibz@gmail.com', '18/02/2001'
exec add_Contacts_Student 3, 'Ул Рябиновая д3', 89683414857, 'ujvds@gmail.com', '11/11/2001'
exec add_Contacts_Student 4, 'Пр Галинский д18', 89683414857, 'ibof@gmail.com', '01/10/2001'
exec add_Contacts_Student 5, 'Ул Рудная д1', 89683414857, 'pdsjfs@gmail.com', '26/03/2001'
exec add_Contacts_Student 6, 'Пр Новичков д1', 89683414857, 'qwery@gmail.com', '07/10/2001'

 

exec add_Perents_Student 1, Иван, Иванов, Игоревич, 'Пр Новичков д13', 89785448578
exec add_Perents_Student 2, Ольга, Кузнецова, Николаевна,  'Пр Новичков д15', 89785448578
exec add_Perents_Student 3, Алиса, Куликов, Алексеевна, 'Ул Рябиновая д3', 86589523584
exec add_Perents_Student 4, Антанина, Иванова, Константиновна, 'Пр Галинский д18', 8923578452
exec add_Perents_Student 5, Мария, Маленов, Валерьевна, 'Ул Рудная д1', 6358952658
exec add_Perents_Student 6, Ольга, Ульянов, Игоревна, 'Пр Новичков д1', 89558564688

exec add_Estimates_Student 1, 5, 5, 5, 5, 5, 5, 5, 5
exec add_Estimates_Student 2, 5, 4, 4, 4, 4, 5, 5, 5
exec add_Estimates_Student 3, 2, 2, 2, 2, 2, 2, 2, 2
exec add_Estimates_Student 4, 3, 5, 4, 5, 4, 3, 3, 5
exec add_Estimates_Student 5, 5, 5, 5, 5, 5, 5, 5, 5
exec add_Estimates_Student 6, 5, 4, 4, 4, 4, 5, 3, 5

select *from Attendance
exec add_SocStatus_Student 1, 10000, 'Отец одиночка', '31/12/2020'
exec add_SocStatus_Student 4, 2500, 'Облимпиадник', '31/07/2021'
exec add_SocStatus_Student 5, 25000, 'Победитель конкурса талантов', '31/07/2021'

exec add_Attendace 1, 1, 2020, 20
exec add_Attendace 2, 1, 2020, 60
exec add_Attendace 3, 1, 2020, 20
exec add_Attendace 4, 1, 2020, 10
exec add_Attendace 5, 1, 2020, 1
exec add_Attendace 6, 1, 2020, 12
 
 -- удаление студента по ID
 go
 CREATE PROC delStud_ID(@id int) as 
	delete from Students
	where Student_ID = @id
go


go

--создание процедуры для удаления студента по имени и фамилии 
 go
 CREATE PROC delStud_NameAndSecondName(@n nvarchar(20), @sn nvarchar(20)) as 
	delete from Students
	where Students.First_Name = @n and Students.Second_Name = @sn
go






create proc updateDateStudents_ID(@id int, @name nvarchar(20),
@secName nvarchar(20), @fathName nvarchar(20))
as
begin
	update Students
	set First_Name = @name, Second_Name = @secName, Fathers_Name = @fathName
	where Student_ID = @id
end
go
go
create proc updateDateEstimates_ID(@id int, @MDK_0202 int,
@MDK_0301 int , @Web int ,@PPEP int ,@Applied_Programming int ,
@Enterprise_Economy int, @Certification int , 
@Law int)
as
begin
	update Estimates
	set MDK_0202 = @MDK_0202 , MDK_0301 = @MDK_0301 , Web = @Web , PPEP = @PPEP,
	Applied_Programming = @Applied_Programming ,
	Enterprise_Economy = @Enterprise_Economy, Certification = @Certification,
	Law = @Law
	where Student_ID = @id
end
go
--процедура подсчитывающая количество студентов которые вышли на степендию
go
Create view Count_Scholarship
as
	select  Count(e.Student_ID) 'Count Students'
 from  Estimates e
 Where  e.MDK_0202 > 4 and
e.Certification > 4 and
e.Enterprise_Economy > 4 and
e.MDK_0301 > 4 and
e.PPEP > 4 and
e.Web > 4 
go

Create view allPefectStudent
as 
	select s.Student_ID, s.First_Name, s.Second_Name
	from Estimates as e, Students as s
	where e.MDK_0202 = 5 and
e.Certification = 5 and
e.Enterprise_Economy = 5 and
e.MDK_0301 = 5 and
e.PPEP = 5 and
e.Web = 5 and e.Student_ID = s.Student_ID
go 

Create view allTruant
as 
	select s.First_Name, s.Second_Name, a.Count_pass
	from Attendance as a, Students as s
	where a.Count_pass > 30 and a.Student_ID = s.Student_ID
go
select * from allTruant
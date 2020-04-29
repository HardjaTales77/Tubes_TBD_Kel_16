/*
		Merupakan fungsi untuk menambah user ke dalam tabel users
		Masukan : Nama User
*/

alter procedure addUser(@Nama_user varchar(40))
AS

DECLARE @jumlah INT
SET @jumlah=(
SELECT COUNT(*) FROM Users
)

INSERT INTO Users
SELECT @jumlah+1,@Nama_user
go

exec addUser Udin

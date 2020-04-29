/*
		Merupakan fungsi untuk menambah user ke dalam tabel users, dengan asumsi tidak ada nama yang sama
		Masukan : Nama User
*/

alter procedure addUser(@Nama_user varchar(40))
AS

DECLARE @jumlah INT
SET @jumlah=(
SELECT COUNT(*) FROM Users
)

DECLARE curUser CURSOR
	FOR
	SELECT Nama_user
	FROM Users

	OPEN curUser

	DECLARE @varUser varchar(40)
	DECLARE @tanda int
	SET @tanda=1
	FETCH NEXT FROM curUser INTO @varUser

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		if(@Nama_user=@varUser)
		BEGIN
			SET @tanda=0
		END

		FETCH NEXT FROM curUser INTO @varUser
	END

	CLOSE curUser
	DEALLOCATE curUser

	if(@tanda=1)
	BEGIN
		INSERT INTO Users
		SELECT @jumlah+1,@Nama_user
	END
go
/*
exec addUser Udin

select * from Users
*/

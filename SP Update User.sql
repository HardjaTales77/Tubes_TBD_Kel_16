/*
   sp ini merupakan procedure untuk meng-update nama user
   sp ini menerima parameter masukan berupa id user yang 
   akan di ubah namanya, dan nama user baru yang akan 
   dimasukkan kedalam database
*/

ALTER PROCEDURE updateUser (
	@idU int,
	@namaUser varchar(40)
) as
	DECLARE @res varchar(60)

	DECLARE @stats int
	SET @stats = 0

	DECLARE curCariUser CURSOR
	FOR
		SELECT Nama_user
		FROM Users
	
	OPEN curCariUser
		DECLARE @temp varchar(40)
		FETCH NEXT FROM curCariUser INTO @temp

		WHILE(@@FETCH_STATUS=0)
		BEGIN
			IF(@temp != @namaUser)
			BEGIN
				SET @stats = 1
			END
		END

	CLOSE curCariUser
	DEALLOCATE curCariUser

	IF(@stats = 1)
	BEGIN
		UPDATE Users
		SET Nama_user = @namaUser
		WHERE IdU = @idU
		
		SET @res = 'Update user dengan nama '+@namaUser+' telah berhasil'
	END
	ELSE
	BEGIN
		SET @res = 'Nama sudah terdaftar di keanggotaan'
	END

	print(@res)

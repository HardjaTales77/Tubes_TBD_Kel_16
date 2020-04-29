CREATE PROCEDURE updateUser (
	@idU int,
	@namaUser varchar(40)
) as
	UPDATE Users
	SET Nama_user = @namaUser
	WHERE IdU = @idU
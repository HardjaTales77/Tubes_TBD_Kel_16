ALTER FUNCTION cariIdUser
(
	@namaUser varchar(40)
)
RETURNS int
BEGIN
	DECLARE @idUser int
	SET @idUser = 
	(
		SELECT IdU
		FROM Users
		WHERE Nama_user = @namaUser
	)
	RETURN @idUser
END
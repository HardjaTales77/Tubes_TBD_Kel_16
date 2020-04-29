/*
- Function ini digunakan untuk mencari Id User
- Input Function ini merupakan nama dari User
*/

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

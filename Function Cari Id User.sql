/*
- Function ini digunakan untuk mencari Id Dari seornang User/Anggota
- Input Function ini memiliki parameter masukan berupa nama dari dari seorang User/Anggota
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

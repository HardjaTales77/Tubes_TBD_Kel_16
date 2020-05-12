/*
- Funtion ini digunakan untuk mencari Id dari sebuah Buku
- Function ini memiliki parameter masukan berupa judul dari buku yang akan di cari Id nya
*/
ALTER FUNCTION cariIdBuku(
	@judul varchar(100)
)
RETURNS int
BEGIN
	DECLARE @idBuku int
	SET @idBuku = (
		SELECT IdB
		FROM Buku
		WHERE Judul_buku = @judul)

	RETURN @idBuku
END

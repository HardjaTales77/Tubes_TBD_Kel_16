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

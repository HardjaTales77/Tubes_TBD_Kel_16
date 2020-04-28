ALTER FUNCTION cariIdBuku(
	@judul varchar(100)
)
RETURNS @res table(
	id int
) 
BEGIN
	INSERT INTO @res
	SELECT IdB
	FROM Buku
	WHERE Judul_buku = @judul

	RETURN
END
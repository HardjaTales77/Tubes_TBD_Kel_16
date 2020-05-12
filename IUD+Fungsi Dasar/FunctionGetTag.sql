/*
	Fungsi ini digunakan untuk mengembalikan semua tag dari sebuah buku
	Menerima input id buku dan mengembalikan tag
*/
CREATE FUNCTION getTag
(
	@IdBuku int
)
RETURNS @res table(
	Tag varchar(25)
)
BEGIN
	INSERT INTO @res
	SELECT Tag.Nama_Tag
	FROM Tag INNER JOIN Punya on Tag.IdT=Punya.IdT
		INNER JOIN Buku on Punya.IdB=Buku.IdB
	WHERE Buku.IdB=@IdBuku

	RETURN
END

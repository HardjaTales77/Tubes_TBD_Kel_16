/*
	Fungsi ini berfungsi untuk mengembalikan seluruh eksemplar sebuah buku
	Input : Id Buku
	Output : Id Eksemplar dan status(bisa di pinjam atau tidak)
*/
ALTER FUNCTION getEksemplar
(
	@idBuku int
)
RETURNS @res table(
	IdE int,
	status int
)
BEGIN
	INSERT INTO @res
	SELECT IdE, Status
	FROM Eksemplar
	WHERE IdB=@idBuku

	RETURN
END

SELECT *
FROM getEksemplar(3)

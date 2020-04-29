/*
	Prosedur ini berfungsi untuk menambahkan kopi dari sebuah buku.
	Menerima masukan judul buku.
	Tidak ada output.
*/
ALTER PROCEDURE addEksemplar @judul varchar(100)
AS
	DECLARE @idB int
	SELECT @idB= IdB FROM Buku WHERE Judul_buku=@judul

	DECLARE @countIdE int
	SELECT @countIdE = COUNT(IdE)FROM Eksemplar
	SET @countIdE=@countIdE+1

	INSERT INTO Eksemplar
	SELECT @countIdE,@idB,1


EXEC addEksemplar 'Overlord'

SELECT *
FROM Eksemplar

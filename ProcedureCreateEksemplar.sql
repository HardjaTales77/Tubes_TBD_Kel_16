ALTER PROCEDURE addEksemplar @judul varchar(100)
AS
	DECLARE @idB int
	SELECT @idB= IdB FROM Buku WHERE Judul_buku=@judul

	DECLARE @countIdE int
	SELECT @countIdE = COUNT(IdE)FROM Eksemplar
	SET @countIdE=@countIdE+1

	INSERT INTO Eksemplar
	SELECT @countIdE,@idB,1

	SELECT *
	FROM Eksemplar

	go

EXEC addEksemplar'Overlord'
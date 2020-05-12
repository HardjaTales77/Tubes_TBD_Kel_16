/*
	Prosedur ini berfungsi untuk mencari judul buku yang paling mirip dengan masukan
	Prosedur menerima masukan berupa id user dan String query masukan
	Prosedur ini mengeluarkan judul buku yang paling mungkin adalah maksud dari user
*/
ALTER PROCEDURE searchByTitle @idU int,@query varchar(100)
AS
	DECLARE @hasil table(
		Judul varchar(100),
		similarity float
	)

	DECLARE @temp table(
		Judul varchar(100),
		id int
	)

	DECLARE curJudul CURSOR
	FOR
	SELECT Judul_buku
	FROM Buku
	ORDER BY IdB

	OPEN curJudul

	DECLARE @cJudul varchar(100)

	FETCH NEXT FROM curJudul INTO @cJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @hasil
		SELECT @cJudul, dbo.cSimilarity(@query,@cJudul)

		FETCH NEXT FROM curJudul INTO @cJudul
	END

	CLOSE curJudul
	DEALLOCATE curJudul

	INSERT INTO @temp
	SELECT TOP 1 Judul,1
	FROM @hasil
	ORDER BY similarity DESC

	DECLARE @mostLikely varchar(100)
	SELECT @mostLikely = Judul FROM @temp WHERE id=1

	DECLARE @idB int
	SELECT @idB = IdB FROM Buku WHERE Judul_buku=@mostLikely

	DECLARE @tanggalSekarang DATE
	SET @tanggalSekarang = CONVERT(DATE,GETDATE())

	INSERT INTO Mencari
	SELECT @idU,@idB,@tanggalSekarang

	SELECT @mostLikely as 'Hasil Pencarian'

	go

EXEC searchByTitle 1,'Harry of Art'

SELECT * FROM Mencari
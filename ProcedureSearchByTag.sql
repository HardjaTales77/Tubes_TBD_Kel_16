ALTER PROCEDURE searchByTag @masukan varchar(50)
AS
	DECLARE @temp table(
		IdTag int,
		NamaTag varchar(25),
		IdBuku int,
		Judul varchar(100)
	)

	DECLARE @res table(
		IdBuku int,
		Judul_Buku varchar(100),
		NamaTag varchar(25)
	)

	INSERT INTO @temp
	SELECT Tag.IdT,Tag.Nama_Tag,Buku.IdB,Buku.Judul_buku
	FROM Tag INNER JOIN Punya on Tag.IdT=Punya.IdT
		INNER JOIN Buku on Punya.IdB=Buku.IdB

	DECLARE curTag CURSOR
	FOR
	SELECT kata
	FROM wordSplit(@masukan)

	DECLARE @cTag varchar(25)

	OPEN curTag

	FETCH NEXT FROM curTag INTO @cTag

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @res
		SELECT IdBuku,Judul,NamaTag
		FROM @temp
		WHERE NamaTag=@cTag

		FETCH NEXT FROM curTag INTO @cTag
	END

	CLOSE curTag
	DEALLOCATE curTag

	
	SELECT Judul_Buku,COUNT(NamaTag) as 'Skor'
	FROM @res
	GROUP BY Judul_Buku
	ORDER BY Skor DESC

	go

EXEC searchByTag 'Education,Historical,Adventure'
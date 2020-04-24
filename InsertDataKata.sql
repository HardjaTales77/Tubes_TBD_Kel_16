ALTER FUNCTION insertTabelKata
(
)
RETURNS @res table(
	id int,
	kata varchar(50),
	IDF float
)
BEGIN
	DECLARE @temp table(
		kata varchar(50)
	)
	DECLARE @temp2 table(
		kata varchar(50),
		idf float
	)

	DECLARE @totalBuku int
	SELECT @totalBuku = COUNT(IdB) FROM Buku

	DECLARE curJudul CURSOR
	FOR
	SELECT Judul_Buku
	FROM Buku
	ORDER BY IdB

	OPEN curJudul

	DECLARE @varJudul varchar(50)

	FETCH NEXT FROM curJudul INTO @varJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @temp
		SELECT kata 
		FROM wordSplit(@varJudul)

		FETCH NEXT FROM curJudul INTO @varJudul
	END

	CLOSE curJudul
	DEALLOCATE curJudul

	INSERT INTO @temp2
	SELECT kata, CAST(COUNT(kata) as float)/CAST(@totalBuku as float)
	FROM @temp
	GROUP BY kata

	DECLARE curKata CURSOR 
	FOR
	SELECT kata
	FROM @temp2
	ORDER BY kata

	DECLARE curIdf CURSOR
	FOR
	SELECT idf
	FROM @temp2
	ORDER BY kata

	OPEN curKata
	OPEN curIdf

	DECLARE @cK varchar(50)
	DECLARE @cI float
	DECLARE @counter int
	SET @counter=1

	FETCH NEXT FROM curKata INTO @ck
	FETCH NEXT FROM curIdf INTO @cI

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @res
		SELECT @counter,@ck,@cI

		SET @counter=@counter+1
		FETCH NEXT FROM curKata INTO @ck
		FETCH NEXT FROM curIdf INTO @cI
	END

	CLOSE curKata
	CLOSE curIdf
	DEALLOCATE curKata
	DEALLOCATE curIdf

RETURN
END

INSERT INTO Kata
SELECT id,kata,idf
FROM insertTabelKata()

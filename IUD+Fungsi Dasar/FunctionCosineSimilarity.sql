/*
	Fungsi ini digunakan untuk menghitung cosine similarity dari query dan judul buku masukan
	Menerima masukan query dan judul buku
	Memberikan keluaran hasil similarity distance
*/
ALTER FUNCTION cSimilarity(
	@query varchar(100),
	@judul varchar(100)
)
RETURNS float
BEGIN
	DECLARE @kQ table(
		Kata varchar(100)
	)
	DECLARE @kJ table(
		Kata varchar(100)
	)
	DECLARE @temp1 table(
		Kata varchar(100),
		frekuensi int
	)
	DECLARE @temp2 table(
		Kata varchar(100),
		frekuensi int
	)
	DECLARE @idf table(
		Kata varchar(100),
		idf float
	)
	DECLARE @bobot1 table(
		Kata varchar(100),
		bobot float
	)
	DECLARE @bobot2 table(
		Kata varchar(100),
		bobot float
	)
	
	INSERT INTO @kQ
	SELECT kata
	FROM wordSplit(@query)

	INSERT INTO @kJ
	SELECT kata
	FROM wordSplit(@judul)

	DECLARE @hasil float

	DECLARE curKQ CURSOR
	FOR
	SELECT Kata
	FROM @kQ
	ORDER BY Kata

	DECLARE @cQKata varchar(100)

	OPEN curKQ

	FETCH NEXT FROM curKQ INTO @cQKata

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		IF EXISTS(SELECT Kata FROM @kJ WHERE Kata=@cQKata)
		BEGIN
			IF NOT EXISTS(SELECT Kata FROM @temp1 WHERE Kata=@cQKata)
			BEGIN
				INSERT INTO @temp1
				SELECT Kata,COUNT(Kata)
				FROM @kJ
				WHERE Kata=@cQKata
				GROUP BY Kata
			END
		END
		ELSE
		BEGIN
			IF NOT EXISTS(SELECT Kata FROM @temp1 WHERE Kata=@cQKata)
			BEGIN
				INSERT INTO @temp1
				SELECT @cQKata,0
			END
		END

		FETCH NEXT FROM curKQ INTO @cQKata
	END

	CLOSE curKQ
	DEALLOCATE curKQ

	INSERT INTO @temp2
	SELECT Kata, COUNT(Kata)
	FROM @kQ
	GROUP BY Kata

	INSERT INTO @idf
	SELECT Kata.Kata,Kata.Bobot
	FROM Kata INNER JOIN @kQ as Q on Kata.Kata=Q.Kata

	INSERT INTO @bobot1
	SELECT J.Kata,CAST(J.frekuensi as float)*I.idf
	FROM @temp1 as J INNER JOIN @idf as I on J.Kata=I.Kata
	WHERE J.Kata=I.Kata

	INSERT INTO @bobot2
	SELECT Q.Kata,CAST(Q.frekuensi as float)*I.idf
	FROM @temp2 as Q INNER JOIN @idf as I on Q.Kata=I.Kata
	WHERE Q.Kata=I.Kata

	DECLARE curBJ CURSOR
	FOR 
	SELECT bobot
	FROM @bobot1
	ORDER BY Kata

	DECLARE curBQ CURSOR
	FOR
	SELECT bobot
	FROM @bobot2
	ORDER BY Kata

	OPEN curBJ
	OPEN curBQ

	DECLARE @cB1 float
	DECLARE @cB2 float
	DECLARE @flag int
	SET @flag=1

	FETCH NEXT FROM curBJ INTO @cB1
	FETCH NEXT FROM curBQ INTO @cB2

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		IF(@flag=1)
		BEGIN
			SET @hasil=@cB1*@cB2
			SET @flag=0
		END
		ELSE
		BEGIN
			SET @hasil=@hasil+(@cB1*@cB2)
		END

		FETCH NEXT FROM curBJ INTO @cB1
		FETCH NEXT FROM curBQ INTO @cB2
	END

	CLOSE curBJ
	CLOSE curBQ
	DEALLOCATE curBJ
	DEALLOCATE curBQ

	RETURN @hasil
END

SELECT dbo.cSimilarity('Art of Harry','The Art of War')
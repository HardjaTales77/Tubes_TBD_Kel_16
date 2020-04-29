/*
	Prosedur ini berfungsi untuk memasukkan data kepada tabel kata dan mengandung.
	Prosedur ini juga menghitung bobot dari setiap kata yang ada.
	Prosedur tidak menerima masukan dan tidak menghasilkan output.
*/
ALTER PROCEDURE InsertBobotKatadanMengandung
AS
	DECLARE @temp table(
		id int,
		Kata varchar(50)
	)

	DECLARE @temp2 table(
		word varchar(25)
	)

	DECLARE @mengandung table(
		IdK int,
		IdB int
	)

	DECLARE @banyak table(
		Kata varchar(50),
		Banyak int
	)

	DELETE FROM Kata
	DELETE FROM Mengandung

	DECLARE @totalBuku int
	SELECT @totalBuku = COUNT(IdB) FROM Buku

	INSERT INTO @temp
	SELECT id,kata
	FROM insertTabelKata()

	DECLARE curJB CURSOR
	FOR
	SELECT Judul_buku
	FROM Buku
	ORDER BY IdB

	DECLARE curIdB CURSOR
	FOR
	SELECT IdB
	FROM Buku
	ORDER BY IdB

	DECLARE @curB varchar(100)
	DECLARE @curI int

	OPEN curIdB
	OPEN curJB

	FETCH NEXT FROM curJB INTO @curB
	FETCH NEXT FROM curIdB INTO @curI

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @temp2
		SELECT kata
		FROM wordSplit(@curB)

		INSERT INTO @mengandung
		SELECT a.id, @curI
		FROM @temp as a INNER JOIN @temp2 as t on a.kata=t.word
		WHERE a.kata=t.word
		GROUP BY a.id

		DELETE FROM @temp2

		FETCH NEXT FROM curJB INTO @curB
		FETCH NEXT FROM curIdB INTO @curI
	END

	CLOSE curJB
	CLOSE curIdB
	DEALLOCATE curJB
	DEALLOCATE curIdB

	INSERT INTO @banyak
	SELECT a.Kata, COUNT(B.IdB)
	FROM @temp as a INNER JOIN @mengandung as b on a.id=b.IdK 
	GROUP BY a.Kata

	INSERT INTO Mengandung
	SELECT IdK,IdB
	FROM @mengandung

	DECLARE curKata CURSOR
	FOR
	SELECT Kata
	FROM @banyak
	ORDER BY Kata

	DECLARE curBanyak CURSOR
	FOR
	SELECT Banyak
	FROM @banyak
	ORDER BY Kata

	OPEN curKata
	OPEN curBanyak

	DECLARE @cKata varchar(50)
	DECLARE @cBanyak int
	DECLARE @count int
	SET @count=1

	FETCH NEXT FROM curKata INTO @cKata
	FETCH NEXT FROM curBanyak INTO @cBanyak

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO Kata
		SELECT @count,@cKata,LOG(CAST(@totalBuku as float)/CAST(@cBanyak as float))

		SET @count=@count+1
		FETCH NEXT FROM curKata INTO @cKata
		FETCH NEXT FROM curBanyak INTO @cBanyak
	END

	CLOSE curKata
	CLOSE curBanyak
	DEALLOCATE curKata
	DEALLOCATE curBanyak
	
	go

EXEC InsertBobotKatadanMengandung

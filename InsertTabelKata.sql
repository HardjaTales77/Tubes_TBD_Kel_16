/*
	Fungsi ini untuk mengembalikan semua kata yang ada.
*/
ALTER FUNCTION insertTabelKata
(
)
RETURNS @res table(
	id int,
	kata varchar(50)
)
BEGIN
	DECLARE @temp table(
		kata varchar(50)
	)
	
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

	DECLARE curKata CURSOR 
	FOR
	SELECT kata
	FROM @temp
	ORDER BY kata
	
	OPEN curKata
	
	DECLARE @cK varchar(50)
	DECLARE @counter int
	SET @counter=1

	FETCH NEXT FROM curKata INTO @ck

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @res
		SELECT @counter,@ck

		SET @counter=@counter+1
		FETCH NEXT FROM curKata INTO @ck
	END

	CLOSE curKata
	CLOSE curIdf
	DEALLOCATE curKata
	DEALLOCATE curIdf

RETURN
END


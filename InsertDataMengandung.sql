ALTER FUNCTION insertDataMengandung
(
)
RETURNS @res table(
	IdK int,
	IdB int
)
BEGIN
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

	DECLARE @temp table(
		word varchar(25)
	)

	DECLARE @curB varchar(100)
	DECLARE @curI int

	OPEN curIdB
	OPEN curJB

	FETCH NEXT FROM curJB INTO @curB
	FETCH NEXT FROM curIdB INTO @curI

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @temp
		SELECT kata
		FROM wordSplit(@curB)

		INSERT INTO @res
		SELECT Kata.IdK, @curI
		FROM Kata INNER JOIN @temp as t on Kata.Kata=t.word
		WHERE Kata.Kata=t.word
		GROUP BY Kata.IdK

		FETCH NEXT FROM curJB INTO @curB
		FETCH NEXT FROM curIdB INTO @curI
	END

	CLOSE curJB
	CLOSE curIdB
	DEALLOCATE curJB
	DEALLOCATE curIdB

	RETURN
END

INSERT INTO Mengandung
SELECT IdK,IdB
FROM insertDataMengandung()


SELECT *
FROM Kata
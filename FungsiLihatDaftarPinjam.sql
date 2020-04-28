alter procedure LihatDaftarPinjam(@idMember INT) AS
DECLARE @idM INT
SET @idM=@idMember

DECLARE @tbl_temp table(
		JudulBuku varchar(50)
	)

CREATE TABLE #tbl_temp2(
		IdE INT
	)

INSERT INTO #tbl_temp2
SELECT IdE
FROM Meminjam
WHERE IdU=@idM

DECLARE curBuku CURSOR
	FOR
	SELECT IdE
	FROM #tbl_temp2

	OPEN curBuku

	DECLARE @varBuku INT

	FETCH NEXT FROM curBuku INTO @varBuku

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_temp
		SELECT Judul_Buku
		FROM #tbl_temp2 INNER JOIN Eksemplar ON #tbl_temp2.IdE=Eksemplar.IdE INNER JOIN Buku ON Buku.IdB=Eksemplar.IdB

		FETCH NEXT FROM curBuku INTO @varBuku
	END

	CLOSE curBuku
	DEALLOCATE curBuku


	SELECT DISTINCT*
	FROM @tbl_temp
go

exec LihatDaftarPinjam 1
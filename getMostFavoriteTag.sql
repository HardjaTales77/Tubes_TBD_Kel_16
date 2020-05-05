/*
	merupakan fitur untuk menampilkan tag terfavorit sesuai dengan IdMember dan 
	difilter berdasarkan waktunya.
	INPUT	 : IdMember, waktuAwal, waktuAkhir
	OUTPUT	 : berisi TOP 5 tag dengan total terbanyak
			   yaitu IdTag, Nama Tag, Total 
*/

alter procedure getMostFavoriteTag(@IdMember INT,@waktuAwal DATETIME,@waktuAkhir DATETIME) as
DECLARE @idM INT
SET @idM=@idMember

CREATE TABLE #tbl_temp(
		JudulBuku varchar(50)
	)

CREATE TABLE #tbl_temp2(
		IdE INT
	)

INSERT INTO #tbl_temp2
SELECT IdE
FROM Meminjam
WHERE IdU=@idM AND waktuPinjam BETWEEN @waktuAwal and @waktuAkhir

DECLARE curBuku CURSOR
	FOR
	SELECT IdE
	FROM #tbl_temp2

	OPEN curBuku

	DECLARE @varBuku INT

	FETCH NEXT FROM curBuku INTO @varBuku

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO #tbl_temp
		SELECT Judul_Buku
		FROM #tbl_temp2 INNER JOIN Eksemplar ON #tbl_temp2.IdE=Eksemplar.IdE INNER JOIN Buku ON Buku.IdB=Eksemplar.IdB

		FETCH NEXT FROM curBuku INTO @varBuku
	END

	CLOSE curBuku
	DEALLOCATE curBuku

create table #temp(
	IdT INT,
	Total INT
)

create table #distinct(
	JudulBuku varchar(50)
)

INSERT INTO #distinct
SELECT DISTINCT*
FROM #tbl_temp

insert into #temp
SELECT Punya.IdT,COUNT(Punya.IdT) as Total
FROM Punya INNER JOIN Buku ON Punya.IdB=Buku.IdB 
INNER JOIN #distinct ON Buku.Judul_buku=#distinct.JudulBuku
GROUP BY Punya.IdT 

SELECT TOP 5 #temp.IdT,Nama_Tag,#temp.Total
FROM Tag INNER JOIN #temp ON Tag.idT=#temp.IdT
ORDER BY #temp.Total DESC


go

/*
exec getMostFavoriteTag 1,'2020-05-05 00:00:00.000','2020-05-10 00:00:00.000'
*/

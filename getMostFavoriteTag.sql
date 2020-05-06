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

create table #temp(
	IdT INT,
	Total INT
)

create table #distinct(
	IdB INT
)

INSERT INTO #distinct
SELECT DISTINCT IdB
FROM #tbl_temp2 INNER JOIN Eksemplar ON #tbl_temp2.IdE=Eksemplar.IdE

insert into #temp
SELECT Punya.IdT,COUNT(Punya.IdT) as Total
FROM Punya INNER JOIN Buku ON Punya.IdB=Buku.IdB 
INNER JOIN #distinct ON Buku.IdB=#distinct.IdB
GROUP BY Punya.IdT 

/*kalau mau lihat jumlahnya tinggal tambah #temp.Total*/
SELECT TOP 5 Nama_Tag
FROM Tag INNER JOIN #temp ON Tag.idT=#temp.IdT
ORDER BY #temp.Total DESC

go

/*
exec getMostFavoriteTag 1,'2020-05-05 00:00:00.000','2020-05-10 00:00:00.000'
*/

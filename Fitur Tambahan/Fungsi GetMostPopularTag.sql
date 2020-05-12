/*
- Fungsi ini digunakan untuk mencari 5 tag(maksimal) dari buku yang paling sering di pinjam oleh user dalam periode tertentu
- Fungsi ini memiliki 2 masukan berupa tanggal awal dan tanggal akhir dari peminjaman buku
- Fungsi ini menghasilkan 5 tag(maksimal) dari buku yang paling sering dipinjam pada periode masukkan fungsi
*/

CREATE FUNCTION getMostPopularTag(
	@tanggalAwal date,
	@tanggalAkhir date
)
RETURNS @res table(
	Nama_Tag varchar(25)
)
BEGIN
	DECLARE @tableCount as table(
		IdB int,
		Total int
	)

	INSERT INTO @tableCount
	SELECT IdB, COUNT(Meminjam.IdE) AS 'Count'
	FROM Meminjam INNER JOIN Eksemplar
	ON Meminjam.IdE = Eksemplar.IdE
	WHERE Meminjam.waktuPinjam >= @tanggalAwal AND Meminjam.waktuPinjam<=@tanggalAkhir
	GROUP BY IdB

	DECLARE @tableJoined as table(
		IdT int,
		Total int
	)

	INSERT INTO @tableJoined
	SELECT Punya.IdT, SUM(temp.Total)
	FROM @tableCount as temp INNER JOIN Punya
	ON temp.IdB = Punya.IdB
	GROUP BY IdT

	INSERT INTO @res
	SELECT TOP 5 Tag.Nama_Tag
	FROM Tag INNER JOIN @tableJoined as temp2
	ON Tag.IdT = temp2.IdT
	ORDER BY temp2.Total DESC

	RETURN
END

go

select *
from getMostPopularTag('2018-03-03','2018-03-27')



/*
	Fungsi ini digunakan untuk mencari buku yang 
	paling sering dipinjam.
	Fungsi ini tidak menerima masukan apapun
	dan akan mengeluarkan hasil TOP 3 judul buku
	dan jumlah tertinggi yang dipinjam
*/


ALTER PROCEDURE getMostPopularBorrowBook
AS
	DECLARE @tbl_res_PopularBorrowBook TABLE(
		buku varchar(100),
		jumlah int
	)

	DECLARE @temp_res TABLE(
		id_eksemplar int
	)

	DECLARE @temp_res_buku TABLE(
		nama_buku varchar(100)
	)

	DECLARE @temp_buku TABLE(
	   id_buku_asli varchar(100)
	)

	INSERT INTO @temp_res
	SELECT Meminjam.IdE
	FROM Meminjam

	INSERT INTO @temp_res_buku
	SELECT Eksemplar.IdB
	FROM @temp_res himp_tbl_temp_res inner join Eksemplar ON himp_tbl_temp_res.id_eksemplar = Eksemplar.IdE


	INSERT INTO @temp_buku
	SELECT Buku.Judul_buku
	FROM @temp_res_buku himp_temp_res_buku inner join Buku ON himp_temp_res_buku.nama_buku = Buku.IdB

	INSERT INTO @tbl_res_PopularBorrowBook
	SELECT id_buku_asli, COUNT(id_buku_asli)
	FROM @temp_buku
	GROUP BY id_buku_asli


	SELECT TOP 3 buku AS 'Judul Buku', jumlah AS 'Jumlah'
	FROM @tbl_res_PopularBorrowBook
	ORDER BY jumlah DESC

	EXEC getMostPopularBorrowBook

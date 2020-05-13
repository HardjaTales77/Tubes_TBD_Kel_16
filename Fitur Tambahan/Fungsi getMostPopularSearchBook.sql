/*
	Fungsi ini digunakan untuk mencari buku yang 
	paling sering dicari.
	Fungsi ini tidak menerima masukan apapun
	dan akan mengeluarkan hasil TOP 3 judul buku
	dan jumlah tertinggi yang dicari
*/


ALTER PROCEDURE getMostPopularSearchBook
AS
	DECLARE @tbl_res_PopularSearchBook TABLE(
		buku varchar(100),
		jumlah int
	)

	DECLARE @temp_res TABLE(
		id_buku int
	)

	DECLARE @temp_res_buku TABLE(
		nama_buku varchar(100)
	)

	INSERT INTO @temp_res
	SELECT Mencari.IdB
	FROM Mencari

	INSERT INTO @temp_res_buku
	SELECT Buku.Judul_buku
	FROM @temp_res  himp_res inner join Buku ON himp_res.id_buku = Buku.IdB

	INSERT INTO @tbl_res_PopularSearchBook
	SELECT nama_buku, COUNT(nama_buku) AS Jumlah
	FROM @temp_res_buku
	GROUP BY nama_buku 


	SELECT TOP 3 buku AS 'Judul Buku', jumlah AS 'Jumlah'
	FROM @tbl_res_PopularSearchBook
	ORDER BY jumlah DESC

	EXEC getMostPopularSearchBook

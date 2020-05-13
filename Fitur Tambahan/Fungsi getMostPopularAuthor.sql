
/*
	Fungsi ini digunakan untuk mencari Pengarang yang 
	paling sering bukunya dipinjam.
	Fungsi ini tidak menerima masukan apapun
	dan akan mengeluarkan hasil TOP 3 nama pengarang
	dan jumlah tertinggi buku yang dikarang oleh pengarang tersebut 
	dipinjam
*/


ALTER PROCEDURE getMostPopularAuthor
AS
	DECLARE @tbl_res_PopularAuthor TABLE(
		nama_author varchar(100),
		jumlah int
	)

	DECLARE @temp_res_author TABLE(
		id_eksemplar_author int
	)

	DECLARE @temp_res_buku_author TABLE(
		temp_id_buku_author varchar(100)
	)

	DECLARE @temp_buku_author TABLE(
	   nama_buku_asli_author varchar(100)
	)

	INSERT INTO @temp_res_author
	SELECT Meminjam.IdE
	FROM Meminjam

	INSERT INTO @temp_res_buku_author
	SELECT Eksemplar.IdB
	FROM @temp_res_author himp_tbl_temp_res_author inner join Eksemplar ON himp_tbl_temp_res_author.id_eksemplar_author = Eksemplar.IdE

	INSERT INTO @temp_buku_author
	SELECT Author.Nama
	FROM @temp_res_buku_author himp_temp_res_buku_author inner join Author ON himp_temp_res_buku_author.temp_id_buku_author = Author.IdAuthor 

	INSERT INTO @tbl_res_PopularAuthor
	SELECT nama_buku_asli_author, COUNT(nama_buku_asli_author)
	FROM @temp_buku_author
	GROUP BY nama_buku_asli_author

	SELECT TOP 3 nama_author AS 'Nama Author', jumlah AS 'Jumlah' 
	FROM @tbl_res_PopularAuthor
	ORDER BY jumlah DESC


	EXEC getMostPopularAuthor

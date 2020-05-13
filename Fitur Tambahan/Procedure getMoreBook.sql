
/*
	Procedure ini berfungsi untuk menampilkan
	semua buku yang mengandung kata dari judul 
	yang dicari.
	Procedure ini memiliki parameter masukan
	yaitu berupa string dari kata yang akan dicari,
	lalu memiliki output keluaran hasil yaitu semua
	buku yang judul bukunya mengandung dari kata 
	yang dicari
*/


ALTER PROCEDURE getMoreBook
	@masukan_judul varchar(100)
AS
	DECLARE @tbl_res TABLE(
		nama_buku varchar(100)
	)

	DECLARE @tbl_temp_buku TABLE(
		judul_buku varchar(100)
	)

	/*
		Query ini berfungsi untuk mengambil 
		semua buku yang ada didalam tabel buku
	*/
	DECLARE currTempBuku CURSOR
	FOR 
		SELECT Buku.Judul_buku
		FROM Buku

	OPEN currTempBuku
	DECLARE @varcurrTempBuku varchar(100)

	FETCH NEXT FROM currTempBuku INTO @varcurrTempBuku

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_temp_buku
		SELECT @varcurrTempBuku

		FETCH NEXT FROM currTempBuku INTO @varcurrTempBuku
	END

	CLOSE currTempBuku
	DEALLOCATE currTempBuku

	/*
		Query ini berfungsi untuk mengecek 
		judul yang dicari dengan judul yang ada didalam tabel
	*/

	INSERT INTO @tbl_res
	SELECT judul_buku
	FROM @tbl_temp_buku
	WHERE judul_buku LIKE '%' +@masukan_judul+'%'


	SELECT nama_buku AS 'Buku'
	FROM @tbl_res

EXEC getMoreBook 'harry potter'

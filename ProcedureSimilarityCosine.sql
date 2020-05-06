/*
	(!! Ingat fungsi kuadrat juga ada yang diupdate menjadi float !!)
	Fungsi ini digunakan untuk mencari judul buku yang memiliki kesamaan dengan
	judul buku yang terdapat dalam database

	Input : Buku yang ingin dicari
	Output : Buku yang ingin dicari, Buku yang ada didalam database, kesamaan

*/

ALTER PROCEDURE MencariByJudul(
	@masukan_judul varchar(100)
)

AS
	/*Tabel yang akan ditampilkan yangmana menyimpan similarity dari buku yang dicari
	  dengan buku yang ada di tabel
	*/
	DECLARE @tbl_result TABLE(
		id int,
		judul_dicari varchar(100),
		judul_didapat varchar(100),
		similarity float
	)

	/*Tabel yang menyimpan jumlah bobot(tf*idf) judul yang dicari*/
	DECLARE @tbl_temp_cari_judul TABLE(
		input_judul varchar(100),
		bobot_input_judul float
	)

	/*Tabel untuk mengambil seluruh judul buku yang ada di dalam tabel buku*/
	DECLARE @tbl_temp_judul TABLE(
		temp_buku_judul varchar(100)
	)

	/*Tabel yang menyimpan jumlah bobot(tf*idf) judul yang didalam tabel buku*/
	DECLARE @tbl_temp_buku_judul TABLE(
		buku_judul varchar(100),
		bobot_buku_judul float
	)

	/*Tabel yang menyimpan hasil kuadrat dari bobot(tf*idf) judul yang dicari*/
	DECLARE @tbl_kuadrat_cari_judul TABLE(
		kuadrat_cari_judul_buku varchar(100),
		kuadrat_cari_judul float
	)

	/*Tabel yang menyimpan hasil kuadrat dari bobot(tf*idf) judul yang didalam tabel buku*/
	DECLARE @tbl_kuadrat_input_judul TABLE(
		kuadrat_input_judul_buku varchar(100),
		kuadrat_input_judul float
	)

	/*Menghitung jumlah bobot judul yang ingin dicari*/
	DECLARE currInputJudul CURSOR
	FOR
		SELECT @masukan_judul

	OPEN currInputJudul
	DECLARE @varInputJudul varchar(100)

	FETCH NEXT FROM currInputJudul INTO @varInputJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_temp_cari_judul
		SELECT judul,bobot_judul
		FROM BobotJudul(@varInputJudul)

		FETCH NEXT FROM currInputJudul INTO @varInputJudul
	END

	CLOSE currInputJudul
	DEALLOCATE currInputJudul

	/*Mengambil semua buku yang ada di table*/
	DECLARE currTempJudul CURSOR
	FOR
		SELECT Buku.Judul_Buku
		FROM Buku

	OPEN currTempJudul
	DECLARE @varTempJudul varchar(100)

	FETCH NEXT FROM currTempJudul INTO @varTempJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_temp_judul
		SELECT @varTempJudul

		FETCH NEXT FROM currTempJudul INTO @varTempJudul
	END

	CLOSE currTempJudul
	DEALLOCATE currTempJudul


	/*Menghitung jumlah bobot judul yang ada di table*/

	DECLARE currTempBukuJudul CURSOR
	FOR
		SELECT temp_buku_judul
		FROM @tbl_temp_judul
		ORDER BY temp_buku_judul

	OPEN currTempBukuJudul
	DECLARE @varTempBukuJudul varchar(100)

	FETCH NEXT FROM currTempBukuJudul INTO @varTempBukuJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_temp_buku_judul
		SELECT judul,bobot_judul
		FROM BobotJudul(@varTempBukuJudul)

		FETCH NEXT FROM currTempBukuJudul INTO @varTempBukuJudul
	END

	CLOSE currTempBukuJudul
	DEALLOCATE currTempBukuJudul

	
	/*Menghitung Kuadrat bobot(tf*idf) judul yang dicari*/

	DECLARE currKuadratInputJudul CURSOR
	FOR
		SELECT bobot_input_judul
		FROM @tbl_temp_cari_judul

	OPEN currKuadratInputJudul
	DECLARE @varKuadratInputJudul float

	FETCH NEXT FROM currKuadratInputJudul INTO @varKuadratInputJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_kuadrat_cari_judul
		SELECT @masukan_judul,dbo.Kuadrat(@varKuadratInputJudul)

		FETCH NEXT FROM currKuadratInputJudul INTO @varKuadratInputJudul
	END

	CLOSE currKuadratInputJudul
	DEALLOCATE currKuadratInputJudul


	/*Menghitung Kuadrat bobot(tf*idf) judul yang didalam tabel*/

	
	DECLARE currKuadratBukuNamaJudul CURSOR
	FOR
		SELECT buku_judul
		FROM @tbl_temp_buku_judul
		ORDER BY buku_judul


	DECLARE currKuadratBukuJudul CURSOR
	FOR
		SELECT bobot_buku_judul
		FROM @tbl_temp_buku_judul
		ORDER BY buku_judul


	OPEN currKuadratBukuNamaJudul
	OPEN currKuadratBukuJudul
	DECLARE @varKuadratBukuNamaJudul varchar(100)
	DECLARE @varKuadratBukuJudul float

	FETCH NEXT FROM currKuadratBukuNamaJudul INTO @varKuadratBukuNamaJudul
	FETCH NEXT FROM currKuadratBukuJudul INTO @varKuadratBukuJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_kuadrat_input_judul
		SELECT @varKuadratBukuNamaJudul,dbo.Kuadrat(@varKuadratBukuJudul)

		FETCH NEXT FROM currKuadratBukuNamaJudul INTO @varKuadratBukuNamaJudul
		FETCH NEXT FROM currKuadratBukuJudul INTO @varKuadratBukuJudul
	END

	CLOSE currKuadratBukuNamaJudul
	CLOSE currKuadratBukuJudul
	DEALLOCATE currKuadratBukuNamaJudul
	DEALLOCATE currKuadratBukuJudul
	

	/*Menghitung Similarity*/

	DECLARE currResultInputJudul CURSOR
	FOR
		SELECT input_judul
		FROM @tbl_temp_cari_judul

	DECLARE currResultBobotInputJudul CURSOR
	FOR
		SELECT bobot_input_judul
		FROM @tbl_temp_cari_judul

	DECLARE currResultKuadratInputJudul CURSOR
	FOR
		SELECT kuadrat_cari_judul
		FROM @tbl_kuadrat_cari_judul

/**************/
	DECLARE currResultBukuJudul CURSOR
	FOR
		SELECT buku_judul
		FROM @tbl_temp_buku_judul

	DECLARE currResultBobotBukuJudul CURSOR
	FOR
		SELECT bobot_buku_judul
		FROM @tbl_temp_buku_judul

	DECLARE currResultKuadratBukuJudul CURSOR
	FOR
		SELECT kuadrat_input_judul
		FROM @tbl_kuadrat_input_judul


	OPEN currResultInputJudul
	OPEN currResultBobotInputJudul
	OPEN currResultKuadratInputJudul
	OPEN currResultBukuJudul
	OPEN currResultBobotBukuJudul
	OPEN currResultKuadratBukuJudul
	DECLARE @varResultInputJudul varchar(100)
	DECLARE @varResultBobotInputJudul float
	DECLARE @varResultKuadratInputJudul float
	DECLARE @varResultBukuJudul varchar(100)
	DECLARE @varResultBobotBukuJudul float
	DECLARE @varResultKuadratBukuJudul float
	DECLARE @tanda int
	SET @tanda = 1

	FETCH NEXT FROM currResultInputJudul INTO @varResultInputJudul
	FETCH NEXT FROM currResultBobotInputJudul INTO @varResultBobotInputJudul
	FETCH NEXT FROM currResultKuadratInputJudul INTO @varResultKuadratInputJudul
	FETCH NEXT FROM currResultBukuJudul INTO @varResultBukuJudul
	FETCH NEXT FROM currResultBobotBukuJudul INTO @varResultBobotBukuJudul
	FETCH NEXT FROM currResultKuadratBukuJudul INTO @varResultKuadratBukuJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_result
		SELECT @tanda,@varResultInputJudul,@varResultBukuJudul,
		((@varResultBobotInputJudul * @varResultBobotBukuJudul)/(SQRT(@varResultKuadratInputJudul) * SQRT(@varResultKuadratBukuJudul)))

		FETCH NEXT FROM currResultInputJudul INTO @varResultInputJudul
		FETCH NEXT FROM currResultBobotInputJudul INTO @varResultBobotInputJudul
		FETCH NEXT FROM currResultKuadratInputJudul INTO @varResultKuadratInputJudul
		FETCH NEXT FROM currResultBukuJudul INTO @varResultBukuJudul
		FETCH NEXT FROM currResultBobotBukuJudul INTO @varResultBobotBukuJudul
		FETCH NEXT FROM currResultKuadratBukuJudul INTO @varResultKuadratBukuJudul
	END

	CLOSE currResultInputJudul
	CLOSE currResultBobotInputJudul
	CLOSE currResultKuadratInputJudul
	CLOSE currResultBukuJudul
	CLOSE currResultBobotBukuJudul
	CLOSE currResultKuadratBukuJudul
	DEALLOCATE currResultInputJudul
	DEALLOCATE currResultBobotInputJudul
	DEALLOCATE currResultKuadratInputJudul
	DEALLOCATE currResultBukuJudul
	DEALLOCATE currResultBobotBukuJudul
	DEALLOCATE currResultKuadratBukuJudul





	SELECT *
	FROM @tbl_result


EXEC MencariByJudul 'Harry Potter and The Deathly Hallow'








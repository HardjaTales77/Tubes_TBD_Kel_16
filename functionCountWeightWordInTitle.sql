/*
	Fungsi ini digunakan untuk menghitung berapa banyak kata yang muncul
	lalu dikalikan dengan bobot kata yang berasal dari table kata

	Input : judul buku
	Keluaran : id kata, kata, jumlah(berapa kali kata yang muncul), 
	bobot kata(jumlah muncul kata tersebut * bobot kata yang ada di table kata)
*/

ALTER FUNCTION bobotTiapKataJudul(
	@masukan_judul varchar(100)
)

RETURNS @tbl_res TABLE(
	id_kata int,
	kata varchar(100),
	jumlah float,
	bobot_kata float
)

BEGIN
	DECLARE @tbl_temp_res TABLE(
		id_kata int,
		temp_kata varchar(100),
		jumlah_kata int
	)
	
	DECLARE curjumlahKata CURSOR
	FOR
	SELECT @masukan_judul

	OPEN curjumlahKata

	DECLARE @varJudul varchar(100)

	FETCH NEXT FROM curjumlahKata INTO @varJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_temp_res
		SELECT id_kata,kata,jumlah
		FROM countWord(@masukan_judul)

		FETCH NEXT FROM curjumlahKata INTO @varJudul
	END

	CLOSE curjumlahKata
	DEALLOCATE curjumlahKata

	DECLARE currTempKata CURSOR
	FOR
	SELECT temp_kata
	FROM @tbl_temp_res
	ORDER BY temp_kata

	DECLARE currBobot CURSOR
	FOR
	SELECT jumlah_kata
	FROM @tbl_temp_res
	ORDER BY temp_kata

	OPEN currBobot
	OPEN currTempKata

	DECLARE @flag_kata varchar(100)
	DECLARE @flag_bobot float
	DECLARE @counter int
	SET @counter = 1

	FETCH NEXT FROM currTempKata INTO @flag_kata
	FETCH NEXT FROM currBobot INTO @flag_bobot

	WHILE(@@FETCH_STATUS=0)
		BEGIN
		INSERT INTO @tbl_res
		SELECT @counter,@flag_kata,@flag_bobot,@flag_bobot*Kata.Bobot
		FROM Kata
		WHERE Kata.Kata = @flag_kata

		SET @counter+=1

		FETCH NEXT FROM currTempKata INTO @flag_kata
		FETCH NEXT FROM currBobot INTO @flag_bobot

		END
	CLOSE currTempKata
	CLOSE currBobot
	DEALLOCATE currTempKata
	DEALLOCATE currBobot

RETURN
END

SELECT *
FROM bobotTiapKataJudul('Harry Potter and The Deathly Hallow')

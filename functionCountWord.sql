/*
	Fungsi ini digunakan untuk menghitung berapa banyak kata yang muncul

	Input : judul buku
	Keluaran : id kata, kata, jumlah(berapa kali kata yang muncul)
*/

ALTER FUNCTION countWord(
	@masukan_kalimat varchar(100)
)

RETURNS @tbl_res TABLE(
	id_kata int,
	kata varchar(100),
	jumlah int
)

BEGIN
	DECLARE @tbl_temp table(
		kata varchar(100)
	)
	DECLARE @tbl_temp2 table(
		kata varchar(100),
		jumlah_kata float
	)

	
	DECLARE curJudul CURSOR
	FOR
	SELECT @masukan_kalimat

	OPEN curJudul

	DECLARE @varJudul varchar(100)

	FETCH NEXT FROM curJudul INTO @varJudul

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_temp
		SELECT kata 
		FROM wordSplit(@masukan_kalimat)

		FETCH NEXT FROM curJudul INTO @varJudul
	END

	CLOSE curJudul
	DEALLOCATE curJudul

	INSERT INTO @tbl_temp2
	SELECT kata, CAST(COUNT(kata) as float)
	FROM @tbl_temp
	GROUP BY kata

	DECLARE curKata CURSOR 
	FOR
	SELECT kata
	FROM @tbl_temp2
	ORDER BY kata

	DECLARE curJumlahKata CURSOR
	FOR
	SELECT jumlah_kata
	FROM @tbl_temp2
	ORDER BY kata

	OPEN curKata
	OPEN curJumlahKata

	DECLARE @flag_Kata varchar(100)
	DECLARE @flag_jmlh float
	DECLARE @counter int
	SET @counter=1

	FETCH NEXT FROM curKata INTO @flag_Kata
	FETCH NEXT FROM curJumlahKata INTO @flag_jmlh

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO @tbl_res
		SELECT @counter,@flag_Kata,@flag_jmlh

		SET @counter=@counter+1
		FETCH NEXT FROM curKata INTO @flag_Kata
		FETCH NEXT FROM curJumlahKata INTO @flag_jmlh
	END

	CLOSE curKata
	CLOSE curJumlahKata
	DEALLOCATE curKata
	DEALLOCATE curJumlahKata

RETURN
END

SELECT *
FROM countWord('Harry Potter and The Deathly Hallow')

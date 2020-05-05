/*
	Prosedur ini berfungsi untuk mendelete sebuah buku dari database
	Menerima masukan judul buku
	Menghapus semua data yang berhubungan dengan judul buku tersebut
	Memperbaharui data lain yang terpengaruh karena data yang dihapus seperti urutannya
*/
ALTER PROCEDURE deleteBuku @judul varchar(100)
AS
	DECLARE @idInput int
	SELECT @idInput = IdB FROM Buku WHERE Judul_buku=@judul

	DECLARE @eksemplarD table(
		IdE int
	)

	INSERT INTO @eksemplarD
	SELECT IdE
	FROM getEksemplar(@idInput)

	DELETE FROM Mengarang WHERE IdB=@idInput
	DELETE FROM Punya WHERE IdB=@idInput
	DELETE FROM Mencari WHERE IdB=@idInput
	DELETE FROM Eksemplar WHERE IdB=@idInput

	DECLARE curP CURSOR
	FOR
	SELECT IdE
	FROM @eksemplarD

	OPEN curP

	DECLARE @curPE int

	FETCH NEXT FROM curP INTO @curPE

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		DELETE FROM Meminjam WHERE IdE=@curPE

		FETCH NEXT FROM curP INTO @curPE
	END

	CLOSE curP
	DEALLOCATE curP

	DELETE FROM Buku WHERE IdB=@idInput

	DECLARE curBuku CURSOR
	FOR
	SELECT IdB
	FROM Buku
	WHERE IdB>@idInput
	ORDER BY IdB

	OPEN curBuku

	DECLARE @idBU int
	SET @idBU=@idInput
	DECLARE @curBuku int

	FETCH NEXT FROM curBuku INTO @curBuku

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		UPDATE Mengarang
		SET IdB=@idBU
		WHERE IdB=@curBuku

		UPDATE Punya
		SET IdB=@idBU
		WHERE IdB=@curBuku

		UPDATE Eksemplar
		SET IdB=@idBU
		WHERE IdB=@curBuku

		UPDATE Buku
		SET IdB=@idBU
		WHERE IdB=@curBuku

		SET @idBU=@idBU+1
		FETCH NEXT FROM curBuku INTO @curBuku
	END

	CLOSE curBuku
	DEALLOCATE curBuku

	DECLARE @counter int
	SET @counter=1

	DECLARE curEks CURSOR
	FOR
	SELECT IdE
	FROM Eksemplar
	ORDER BY IdE

	OPEN curEks

	DECLARE @curE int
	FETCH NEXT FROM curEks INTO @curE

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		UPDATE Eksemplar
		SET IdE=@counter
		WHERE IdE=@curE

		SET @counter=@counter+1
		FETCH NEXT FROM curEks INTO @curE
	END

	CLOSE curEks
	DEALLOCATE curEks

	EXEC InsertBobotKatadanMengandung

	go

EXEC deleteBuku 'Sword Art Online'
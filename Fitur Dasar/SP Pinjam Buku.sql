/*
- SP ini merupakan procedure untuk peminjaman buku
- SP ini memiliki parameter masukan berupa nama dari user yang akan meminjam dan judul buku yang akan di pinjam
*/

CREATE PROCEDURE pinjamBuku
(
	@namaUser varchar(40),
	@judulBuku varchar(100)
) as
	DECLARE @res varchar(50)
	
	DECLARE @idBuku int
	SET @idBuku = dbo.cariIdBuku(@judulBuku)

	DECLARE @tabelEksemplar table(
		IdE int,
		status int
	)

	DECLARE @idUser int
	SET @idUser = dbo.cariIdUser(@namaUser)

	INSERT INTO @tabelEksemplar
	SELECT *
	FROM getEksemplar(@idBuku)

	DECLARE @statusAda int
	DECLARE @idEksemplar int
	set @statusAda = 0
	set @idEksemplar = 0

	DECLARE cariEksemplar CURSOR
	FOR
		SELECT IdE,status
		FROM @tabelEksemplar

	OPEN cariEksemplar
		DECLARE @temp int
		DECLARE @ide int
		FETCH NEXT FROM cariEksemplar INTO @ide,@temp
		WHILE(@@FETCH_STATUS=0)
		BEGIN
			IF(@statusAda = 0)
			BEGIN
				IF(@temp = 1)
				BEGIN
					set @statusAda = 1
					set @idEksemplar = @ide
				END
			END
			FETCH NEXT FROM cariEksemplar INTO @ide,@temp
		END
	CLOSE cariEksemplar
	DEALLOCATE cariEksemplar

	DECLARE @tanggalSekarang DATE
	DECLARE @tanggalJatuhTempo DATE
	SET @tanggalSekarang = CONVERT(DATE,GETDATE())
	SET @tanggalJatuhTempo = DATEADD(day,7,@tanggalSekarang)


	IF(@statusAda = 0)
	BEGIN
		set @res = 'Buku yang ingin dipinjam, sedang dipinjam'
	END
	ELSE
	BEGIN
		INSERT INTO Meminjam SELECT @idUser,@idEksemplar,@tanggalSekarang,@tanggalJatuhTempo
		
		UPDATE Eksemplar
		SET Status = 0
		WHERE IdE = @idEksemplar

		set @res = 'Buku yang ingin dipinjam tersedia, IdEksemplar : '+CONVERT(varchar(3),@idEksemplar)
	END
	print(@res)
go

exec pinjamBuku 'John Doe','Harry Potter and The Philosopher Stone'

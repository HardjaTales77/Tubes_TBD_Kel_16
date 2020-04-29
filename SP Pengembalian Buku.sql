/*
- SP ini merupakan procedure untuk pengembalianBuku, digunakan saat User akan mengembalikan buku yang telah dipinjam
- SP ini menerima parameter masukan berupa nama dari User yang meminjam, juga judul buku yang akan dikembalikan
*/

ALTER PROCEDURE pengembalianBuku
(
	@namaUser varchar(40),
	@judulBuku varchar(100)
) as
	DECLARE @idUser int
	SET @idUser = dbo.cariIdUser(@namaUser)

	DECLARE @idBuku int
	SET @idBuku = dbo.cariIdBuku(@judulBuku)

	DECLARE @listEksemplar table(
		IdE int
	)
	
	INSERT INTO @listEksemplar
	SELECT IdE
	FROM Eksemplar
	WHERE IdB = @idBuku AND Status = 0

	DECLARE @bukuDipinjam table(
		IdE int,
		waktuPinjam Date
	)

	INSERT INTO @bukuDipinjam
	SELECT listEkse.IdE, Meminjam.waktuPinjam
	FROM Meminjam INNER JOIN @listEksemplar as listEkse
	ON Meminjam.IdE = listEkse.IdE

	DECLARE @idEksemplar int
	SET @idEksemplar = (
		SELECT IdE
		FROM @bukuDipinjam
		WHERE waktuPinjam = (
			SELECT MAX(waktuPinjam)
			FROM @bukuDipinjam
		)
	)

	UPDATE Meminjam
	SET waktuPengembalian = CONVERT(DATE,GETDATE())
	WHERE waktuPinjam = (
		SELECT MAX(waktuPinjam)
		FROM @bukuDipinjam
	) AND IdE = @idEksemplar

	UPDATE Eksemplar
	SET Status = 1
	WHERE IdE = @idEksemplar

go

exec pengembalianBuku 'John Doe','Harry Potter and The Philosopher Stone'

/*Asumsi-asumsi
- Orang tidak akan mengembalikan buku yang tidak di pinjam
- Orang tidak akan meminjam 2 eksemplar dengan judul buku yang sama
- User yang meminjam pasti terdaftar di tabel user
*/

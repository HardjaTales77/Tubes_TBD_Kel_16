ALTER PROCEDURE pengembalianBuku
(
	@namaUser varchar(40),
	@idEksemplar int
) as
	DECLARE @res varchar(50)

	DECLARE @temp table(
		IdU int,
		IdE int,
		waktuPinjam date,
		waktuPengembalian date
	)

	DECLARE @idUser int
	SET @idUser = dbo.cariIdUser(@namaUser)

	INSERT INTO @temp
	SELECT *
	FROM Meminjam
	WHERE IdU = @idUser AND IdE = @idEksemplar

	UPDATE Meminjam
	SET waktuPengembalian = CONVERT(DATE,GETDATE())
	WHERE waktuPinjam = (
		SELECT MAX(waktuPinjam)
		FROM @temp
	) AND IdE = @idEksemplar
	UPDATE Eksemplar
	SET Status = 1
	WHERE IdE = @idEksemplar

exec pengembalianBuku 'John Doe',2
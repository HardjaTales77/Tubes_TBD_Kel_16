/*
	Prosedur ini berfungsi untuk menambahkan buku yang baru.
	Menerima masukan judul buku yang baru, tag yang berhubungan dan nama penulis buku tersebut.
*/
ALTER PROCEDURE addBuku @judul varchar(100), @tag varchar(100), @author varchar(100)
AS
	DECLARE @tags table(
		tag varchar(25)
	)

	DECLARE @tempTag table(
		id int,
		tag varchar(25)
	)

	DECLARE @tempTT table(
		id int,
		tag varchar(25)
	)

	INSERT INTO @tags
	SELECT kata
	FROM wordSplit(@tag)

	DECLARE @iddb int
	DECLARE @idBBaru int
	SELECT @idBBaru=COUNT(IdB)FROM Buku
	SET @idBBaru=@idBBaru+1

	DECLARE @idAB int
	SELECT @idAB=COUNT(IdAuthor)FROM Author
	SET @idAB=@idAB+1

	DECLARE @idAT int
	SELECT @idAT=COUNT(IdT)FROM Tag
	SET @idAT=@idAT+1
	
	DECLARE curTag CURSOR
	FOR
	SELECT tag
	FROM @tags
	ORDER BY tag

	OPEN curTag

	DECLARE @cT varchar(25)

	FETCH NEXT FROM curTag INTO @cT

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		IF NOT EXISTS(SELECT IdT FROM Tag WHERE Nama_Tag=@cT)
		BEGIN
			INSERT INTO @tempTag
			SELECT @idAT,@cT

			SET @idAT=@idAT+1
		END
		
		FETCH NEXT FROM curTag INTO @cT
	END

	CLOSE curTag
	DEALLOCATE curTag

	INSERT INTO Tag 
	SELECT id,tag
	FROM @tempTag

	DECLARE CJ CURSOR
	FOR
	SELECT Judul_buku
	FROM Buku

	DECLARE curAuthor CURSOR
	FOR
	SELECT Nama
	FROM Author

	OPEN curAuthor
	OPEN CJ

	DECLARE @flagJ int
	DECLARE @flagA int
	
	DECLARE @cj varchar(100)
	FETCH NEXT FROM CJ INTO @cj
	DECLARE @cAu varchar(100)
	FETCH NEXT FROM curAuthor INTO @cAu


	WHILE(@@FETCH_STATUS=0)
	BEGIN
		IF(@cAu=@author)
		BEGIN
			SET @flagA=0
		END
		ELSE IF(@cAu!=@author)
		BEGIN
			SET @flagA=1
		END
		IF(@cj=@judul)
		BEGIN
			SET @flagJ=0
		END
		ELSE IF(@cj!=@judul)
		BEGIN
			SET @flagJ=1
		END
		FETCH NEXT FROM curAuthor INTO @cAu
		FETCH NEXT FROM CJ INTO @cj
	END

	DECLARE @thisA int

	IF(@flagA=1)
	BEGIN
		INSERT INTO Author
		SELECT @idAB, @author

		IF(@flagJ=1)
		BEGIN
			INSERT INTO Mengarang
			SELECT @idAB,@idBBaru
		END
		ELSE
		BEGIN
			SELECT @iddb = IdB FROM Buku WHERE Judul_buku=@judul

			INSERT INTO Mengarang
			SELECT @idAB,@iddb
		END
	END
	ELSE IF(@flagA=0)
	BEGIN
		SELECT @thisA=IdAuthor FROM Author WHERE Nama=@author
		IF(@flagJ=1)
		BEGIN
			INSERT INTO Mengarang
			SELECT @thisA,@idBBaru
		END
	END

	DECLARE @countIdE int
	SELECT @countIdE = COUNT(IdE)FROM Eksemplar
	SET @countIdE=@countIdE+1

	IF(@flagJ=1)
	BEGIN
		INSERT INTO Buku
		SELECT @idBBaru,@judul

		INSERT INTO Eksemplar
		SELECT @countIdE,@idBBaru,1
	END
	ELSE IF(@flagJ=0)
	BEGIN
		INSERT INTO Eksemplar
		SELECT @countIdE,@iddb,1
	END

	CLOSE curAuthor
	CLOSE CJ
	DEALLOCATE curAuthor
	DEALLOCATE CJ

	IF(@flagJ=1)
	BEGIN
		INSERT INTO @tempTT
		SELECT Tag.IdT,Tag.Nama_Tag
		FROM Tag INNER JOIN @tags as t on Tag.Nama_Tag=t.tag
		ORDER BY Tag.IdT	
	
		DECLARE curTT CURSOR
		FOR
		SELECT id
		FROM @tempTT
		ORDER BY id

		OPEN curTT

		DECLARE @cTT int

		FETCH NEXT FROM curTT INTO @cTT

		WHILE(@@FETCH_STATUS=0)
		BEGIN
			INSERT INTO Punya
			SELECT @idBBaru,@cTT

			FETCH NEXT FROM curTT INTO @cTT
		END

		CLOSE curTT
		DEALLOCATE curTT

		EXEC InsertBobotKatadanMengandung
	END
	

	go

EXEC addBuku 'Sword Art Online','Adventure,Fantasy,Sci-Fi','Reki Kawahara'


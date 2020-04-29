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
		INSERT INTO @tempTag
		SELECT @idAT,@cT
		FROM Tag
		WHERE Nama_Tag!=@cT

		SET @idAT=@idAT+1
		FETCH NEXT FROM curTag INTO @cT
	END

	CLOSE curTag
	DEALLOCATE curTag

	INSERT INTO Tag 
	SELECT id,tag
	FROM @tempTag
	GROUP BY id,tag

	INSERT INTO Buku
	SELECT @idBBaru,@judul

	DECLARE curAuthor CURSOR
	FOR
	SELECT Nama
	FROM Author

	OPEN curAuthor

	DECLARE @flagA int
	DECLARE @cAu varchar(100)
	FETCH NEXT FROM curAuthor INTO @cAu

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		IF(@cAu=@author)
		BEGIN
			SET @flagA=0
		END
		ELSE
		BEGIN
			SET @flagA=1
		END
		FETCH NEXT FROM curAuthor INTO @cAu
	END

	IF(@flagA=1)
	BEGIN
		INSERT INTO Author
		SELECT @idAB, @author
	END

	CLOSE curAuthor
	DEALLOCATE curAuthor

	INSERT INTO Mengarang
	SELECT @idAB,@idBBaru

	INSERT INTO @tempTT
	SELECT Tag.IdT,Tag.Nama_Tag
	FROM Tag INNER JOIN @tempTag as t on Tag.IdT=t.id
	ORDER BY Tag.IdT

	DECLARE curTT CURSOR
	FOR
	SELECT id
	FROM @tempTT
	GROUP BY id,tag
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

	DECLARE @idEB int
	SELECT @idEB = COUNT(IdE)FROM Eksemplar
	SET @idEB=@idEB+1

	INSERT INTO Eksemplar
	SELECT @idEB,@idBBaru,1
	
	EXEC InsertBobotKatadanMengandung


	go

EXEC addBuku 'Overlord','Adventure,Dark,Isekai','Maruyama Kagune'
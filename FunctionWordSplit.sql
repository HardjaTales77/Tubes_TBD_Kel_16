ALTER FUNCTION wordSplit
(
	@barisKata varchar(100)
)
RETURNS @res table(
	kata varchar(50)
)
BEGIN
	DECLARE @panjang int
	SET @panjang = LEN(@barisKata)

	DECLARE @curP int
	SET @curP=1

	DECLARE @strp varchar(20)
	SET @strp=''

	DECLARE @temp char
	SET @temp=''

	DECLARE @counter int
	SET @counter=1

	WHILE(@counter<=@panjang)
	BEGIN
		SET @temp=SUBSTRING(@barisKata,@counter,1)
		IF(@temp=' ')
		BEGIN
			INSERT INTO @res
			SELECT @strp

			SET @strp=''
		END
		ELSE
		BEGIN
			SET @strp = @strp+@temp
		END
		
		IF(@counter=@panjang)
		BEGIN
			INSERT INTO @res
			SELECT @strp
		END

		SET @counter=@counter+1
	END
	RETURN
END

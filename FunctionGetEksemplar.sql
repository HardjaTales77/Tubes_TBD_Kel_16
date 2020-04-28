ALTER FUNCTION getEksemplar
(
	@idBuku int
)
RETURNS @res table(
	IdE int
)
BEGIN
	INSERT INTO @res
	SELECT IdE
	FROM Eksemplar
	WHERE IdB=@idBuku

	RETURN
END

SELECT *
FROM getEksemplar(3)
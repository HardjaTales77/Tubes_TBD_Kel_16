ALTER FUNCTION getEksemplar
(
	@idBuku int
)
RETURNS @res table(
	IdE int,
	status int
)
BEGIN
	INSERT INTO @res
	SELECT IdE, Status
	FROM Eksemplar
	WHERE IdB=@idBuku

	RETURN
END

SELECT *
FROM getEksemplar(3)
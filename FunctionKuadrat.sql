CREATE FUNCTION Kuadrat(
	@angka int
)
RETURNS int
BEGIN	
	DECLARE @hasil int
	SET @hasil=@angka*@angka

	RETURN @hasil
END

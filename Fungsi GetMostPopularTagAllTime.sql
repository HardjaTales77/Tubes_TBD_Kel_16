ALTER FUNCTION getMostPopularTagAllTime()
RETURNS @res table(
	Nama_Tag varchar(25)
)
BEGIN
	DECLARE @tableCount as table(
		IdB int,
		Total int
	)

	INSERT INTO @tableCount
	SELECT IdB, COUNT(Meminjam.IdE) AS 'Count'
	FROM Meminjam INNER JOIN Eksemplar
	ON Meminjam.IdE = Eksemplar.IdE
	GROUP BY IdB

	DECLARE @tableJoined as table(
		IdT int,
		Total int
	)

	INSERT INTO @tableJoined
	SELECT Punya.IdT, SUM(temp.Total)
	FROM @tableCount as temp INNER JOIN Punya
	ON temp.IdB = Punya.IdB
	GROUP BY IdT

	INSERT INTO @res
	SELECT TOP 5 Tag.Nama_Tag
	FROM Tag INNER JOIN @tableJoined as temp2
	ON Tag.IdT = temp2.IdT
	ORDER BY temp2.Total DESC

	RETURN
END

go

select *
from getMostPopularTagAllTime()


/*
	merupakan fitur untuk menampilkan tag terfavorit sesuai dengan IdMember
	TANPA filter waktu 
	INPUT	 : IdMember, waktuAwal, waktuAkhir
	OUTPUT	 : berisi TOP 5 tag dengan total terbanyak dalam waktu selamanya
			   yaitu IdTag, Nama Tag, Total 
*/

alter procedure getMostFavoriteTagAllTime(@IdMember INT) as
create table #judulPinjam(
	gtw varchar(50)
)
insert into #judulPinjam
exec LihatDaftarPinjam @IdMember

create table #temp(
	IdT INT,
	Total INT
)

create table #hasil(
	IdT INT,
	Nama_tag varchar(50),
	Total INT
)

insert into #temp
SELECT Punya.IdT,COUNT(Punya.IdT) as Total
FROM Punya INNER JOIN Buku ON Punya.IdB=Buku.IdB 
INNER JOIN #judulPinjam ON Buku.Judul_buku=#judulPinjam.gtw
GROUP BY Punya.IdT 

SELECT #temp.IdT,Nama_Tag,#temp.Total
FROM Tag INNER JOIN #temp ON Tag.idT=#temp.IdT
ORDER BY #temp.Total DESC


go
exec getMostFavoriteTagAllTime 1
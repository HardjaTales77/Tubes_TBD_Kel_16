DROP TABLE Tag
DROP TABLE Buku
DROP TABLE Author
DROP TABLE Mengarang
DROP TABLE Punya
DROP TABLE Eksemplar
DROP TABLE Users
DROP TABLE Mencari
DROP TABLE Meminjam
DROP TABLE Kata
DROP TABLE Mengandung

CREATE TABLE Tag(
	IdT int,
	Nama_Tag varchar(25)
)

CREATE TABLE Buku(
	IdB int,
	Judul_buku varchar(100)
)

CREATE TABLE Author(
	IdAuthor int,
	Nama varchar(100)
)

CREATE TABLE Mengarang(
	IdAuthor int,
	IdB int
)

CREATE TABLE Punya(
	IdT int,
	IdB int
)

CREATE TABLE Eksemplar(
	IdE int,
	IdB int,
	Status int
)

CREATE TABLE Users(
	IdU int,
	Nama_user varchar(40)
)

CREATE TABLE Mencari(
	IdU int,
	IdB int,
	waktuCari Datetime
)

CREATE TABLE Meminjam(
	IdU int,
	IdE int,
	waktuPinjam Datetime,
	waktuPengembalian Datetime
)

CREATE TABLE Kata(
	IdK int,
	Kata varchar(100),
	Bobot float
)

CREATE TABLE Mengandung(
	IdK int,
	IdB int
)
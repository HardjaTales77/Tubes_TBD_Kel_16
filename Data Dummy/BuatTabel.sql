/*
	Script ini berfungsi membuat tabel
*/

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
	Nama_Tag varchar(25),
	PRIMARY KEY(IdT)
)

CREATE TABLE Buku(
	IdB int,
	Judul_buku varchar(100),
	PRIMARY KEY(IdB)
)

CREATE TABLE Author(
	IdAuthor int,
	Nama varchar(100),
	PRIMARY KEY(IdAuthor)
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
	Status int,
	PRIMARY KEY(IdE)
)

CREATE TABLE Users(
	IdU int,
	Nama_user varchar(40),
	PRIMARY KEY(IdU)
)

CREATE TABLE Mencari(
	IdU int,
	IdB int,
	waktuCari Date
)

CREATE TABLE Meminjam(
	IdU int,
	IdE int,
	waktuPinjam Date,
	waktuPengembalian Date
)

CREATE TABLE Kata(
	IdK int,
	Kata varchar(100),
	Bobot float,
	PRIMARY KEY(IdK)
)

CREATE TABLE Mengandung(
	IdK int,
	IdB int
)

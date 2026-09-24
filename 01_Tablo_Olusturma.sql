USE OkulDB;
--create table Ogrenciler(
-- Id INT PRIMARY KEY IDENTITY(1,1),
-- Ad NVARCHAR(50),
-- Soyad NVARCHAR(50),
-- Yas INT,
-- Bolum NVARCHAR(100)
--);

--INSERT INTO Ogrenciler(Ad,Soyad,Yas,Bolum)
--VALUES('ALÝ' , 'YILMAZ',20,'YÖNETÝM BÝLÝÞÝM SÝSTEMLERÝ');

--INSERT INTO Ogrenciler(Ad,Soyad,Yas,Bolum)
--VALUES('Asuman','Tunç',23,'BST');

--INSERT INTO Ogrenciler(Ad,Soyad,Yas,Bolum)
--VALUES('Aslý','Türk',18,'Muhasebe');

-- VERÝLERÝ GÖRMEK ÝÇÝN "SELECT" KULLANILIR
--SELECT * FROM Ogrenciler;

-- TABLOLARIN ÝÇÝNDE KÝ VERÝLERÝ SÝLMEK ÝÇÝN "DELETE" KULLANILIR
DELETE FROM Ogrenciler;
INSERT INTO Ogrenciler (Ad, Soyad, Yas, Bolum)
VALUES ('Ali', 'Yýlmaz', 20, 'Yönetim Biliþim Sistemleri');

INSERT INTO Ogrenciler (Ad, Soyad, Yas, Bolum)
VALUES ('Asuman', 'Tunç', 23, 'BST');

INSERT INTO Ogrenciler (Ad, Soyad, Yas, Bolum)
VALUES ('Aslý', 'Türk', 18, 'Muhasebe');

select * from Ogrenciler;

-- DROP TABLE Ogrenciler Tabloyu tamamen siler

-- DROP DATABASE OkulDB Database'i tamamen siler

DELETE FROM Ogrenciler
WHERE Id=16;

use OkulDB;

--CREATE TABLE Musteriler(
  --MusteriId INT PRIMARY KEY IDENTITY(1,1),
  --Ad NVARCHAR(50)  not null,
  --Soyad NVARCHAR(50) NOT NULL,
  --Yas INT NULL,
  --Sehir NVARCHAR(50) NOT NULL,
  --ToplamHarcama DECIMAL(10,2) NOT NULL
--);


--INSERT INTO Musteriler(Ad,Soyad,Yas,Sehir,ToplamHarcama)
--VALUES('Mehmet','Yýlmaz',28,'Ýstanbul',4500.75);

/*SELECT *
FROM dbo.Musteriler
ORDER BY MusteriId;
DELETE FROM dbo.Musteriler
WHERE MusteriId = 2;*/

--INSERT INTO Musteriler(Ad,Soyad,Yas,Sehir,ToplamHarcama)
--VALUES('Ceren','Arslan',24,'Ankara',5200.80);
select * from dbo.Musteriler;
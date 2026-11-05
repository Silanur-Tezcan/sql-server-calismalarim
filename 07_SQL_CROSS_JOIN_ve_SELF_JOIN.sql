
/*
=========================================================
07 - SQL CROSS JOIN VE SELF JOIN
=========================================================

*/

USE OkulDB;
GO


-- =====================================================
-- 1. CROSS JOIN - CAPRAZ BIRLESTIRME
-- =====================================================

-- CROSS JOIN iki tablodaki her satiri diger tablodaki
-- butun satirlarla eslestirir.
--
-- Sonuc satir sayisi:
-- 1. tablonun satir sayisi * 2. tablonun satir sayisi
--
-- Ornek:
-- 3 urun * 4 renk = 12 kombinasyon


-- 1.1 Urunler tablosunu olusturma

/*
CREATE TABLE Urunler (
    UrunId INT PRIMARY KEY IDENTITY(1,1),
    UrunAdi NVARCHAR(100) NOT NULL
);
*/


-- 1.2 Renkler tablosunu olusturma

/*
CREATE TABLE Renkler (
    RenkId INT PRIMARY KEY IDENTITY(1,1),
    RenkAdi NVARCHAR(50) NOT NULL
);
*/


-- 1.3 Urunler tablosuna ornek veri ekleme

/*
INSERT INTO Urunler (UrunAdi)
VALUES
    (N'Tiþört'),
    (N'Pantolon'),
    (N'Gömlek');
*/


-- 1.4 Renkler tablosuna ornek veri ekleme

/*
INSERT INTO Renkler (RenkAdi)
VALUES
    (N'Siyah'),
    (N'Beyaz'),
    (N'Mavi'),
    (N'Kýrmýzý');
*/


-- 1.5 Tablolardaki kayitlari goruntuleme

SELECT *
FROM Urunler;

SELECT *
FROM Renkler;


-- 1.6 CROSS JOIN uygulamasi
-- Her urun butun renklerle eslesir.
-- Beklenen sonuc: 12 satir

SELECT
    u.UrunAdi,
    r.RenkAdi
FROM Urunler AS u
CROSS JOIN Renkler AS r;


-- =====================================================
-- 2. CROSS JOIN + WHERE
-- =====================================================

-- Sadece Tiþört urununun renk seceneklerini listeler.


SELECT
    u.UrunAdi,
    r.RenkAdi
FROM Urunler AS u
CROSS JOIN Renkler AS r
WHERE u.UrunAdi = N'Tiþört';


-- =====================================================
-- 3. SELF JOIN - OZ BIRLESTIRME
-- =====================================================

-- SELF JOIN bir tablonun kendisiyle birlestirilmesidir.
--
-- Calisanlar tablosunda:
-- CalisanId  = Calisanin kendi numarasi
-- YoneticiId = Yoneticisinin CalisanId numarasi
--
-- Ornek:
-- Zeynep'in YoneticiId degeri 2'dir.
-- CalisanId = 2 olan kisi Ayþe'dir.
-- Bu nedenle Zeynep'in yoneticisi Ayþe'dir.


-- 3.1 Calisanlar tablosunu olusturma

/*
CREATE TABLE Calisanlar (
    CalisanId INT PRIMARY KEY IDENTITY(1,1),
    Ad NVARCHAR(50) NOT NULL,
    YoneticiId INT NULL
);
*/


-- 3.2 Calisanlar tablosuna ornek veri ekleme

/*
INSERT INTO Calisanlar (Ad, YoneticiId)
VALUES
    (N'Ahmet', NULL),
    (N'Ayþe', 1),
    (N'Mehmet', 1),
    (N'Zeynep', 2),
    (N'Elif', 2),
    (N'Burak', 3),
    (N'Ceren', 3);
*/


-- 3.3 Calisanlar tablosunu goruntuleme

SELECT *
FROM Calisanlar
ORDER BY CalisanId;


-- =====================================================
-- 4. SELF JOIN + INNER JOIN
-- =====================================================

-- Ayni tablo iki farkli takma adla kullanilir.
-- c = Calisan
-- y = Yonetici
-- INNER JOIN sadece yoneticisiyle eslesen
-- calisanlari getirir.
--
-- Ahmet'in YoneticiId degeri NULL oldugu icin
-- Ahmet sonuc tablosunda gorunmez.


SELECT
    c.Ad AS CalisanAdi,
    y.Ad AS YoneticiAdi
FROM Calisanlar AS c
INNER JOIN Calisanlar AS y
    ON c.YoneticiId = y.CalisanId;


-- =====================================================
-- 5. SELF JOIN + LEFT JOIN
-- =====================================================

-- LEFT JOIN soldaki tablonun butun kayitlarini korur.
--
-- Bu nedenle yoneticisi olmayan Ahmet de listelenir.
-- Ahmet'in YoneticiAdi alani NULL gorunur.


SELECT
    c.Ad AS CalisanAdi,
    y.Ad AS YoneticiAdi
FROM Calisanlar AS c
LEFT JOIN Calisanlar AS y
    ON c.YoneticiId = y.CalisanId;


-- =====================================================
-- 6. ONEMLI NOTLAR
-- =====================================================

-- CROSS JOIN:
-- Her satiri diger tablonun her satiriyla eslestirir.
-- Normal kullaniminda ON kosulu bulunmaz.

-- SELF JOIN:
-- Ayni tabloyu kendisiyle birlestirir.
-- Ayri bir SELF JOIN SQL komutu yoktur.
-- INNER JOIN veya LEFT JOIN ile uygulanabilir.

-- INNER JOIN:
-- Yalnizca eslesen kayitlari getirir.

-- LEFT JOIN:
-- Soldaki tablonun butun kayitlarini korur.

-- NULL:
-- JOIN sonucunda eslesmeyen taraftaki alanlar
-- NULL gorunebilir.
-- Bu durum NOT NULL kisitlamasini ihlal etmez.



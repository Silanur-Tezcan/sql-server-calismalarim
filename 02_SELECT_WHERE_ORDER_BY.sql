
/*
========================================================
SQL SERVER ÇALIÞMALARIM
KONU: SELECT, WHERE, AND, OR, ORDER BY
VERÝTABANI: OkulDB
TABLO: dbo.Ogrenciler
========================================================

ÖÐRENÝLEN KONULAR:
1. SELECT ile veri sorgulama
2. Belirli sütunlarý seçme
3. WHERE ile koþullu sorgulama
4. Karþýlaþtýrma operatörleri
5. AND ve OR operatörleri
6. Parantezlerle koþullarý gruplama
7. ORDER BY ile sýralama

NOT:
-- ile baþlayan satýrlar yorum satýrýdýr.
SQL Server bu satýrlarý çalýþtýrmaz.

Birden fazla satýrlýk yorum için
/* ... */ yapýsý kullanýlabilir.
*/

USE OkulDB;
GO

-- =====================================================
-- 1. TÜM VERÝLERÝ GÖRÜNTÜLEME
-- =====================================================

-- SELECT: Verileri sorgular.
-- * : Tablodaki bütün sütunlarý getirir.
-- FROM: Verilerin hangi tablodan alýnacaðýný belirtir.
-- dbo: Tablonun ait olduðu þemadýr.
-- ; : SQL ifadesinin sonunu belirtir.

SELECT *
FROM dbo.Ogrenciler;


-- =====================================================
-- 2. BELÝRLÝ SÜTUNLARI GÖRÜNTÜLEME
-- =====================================================

-- Sadece Ad ve Soyad sütunlarý getirilir.
-- Sütun isimleri virgülle ayrýlýr.
-- SELECT içinde yazýlan sütunlarýn sýrasý,
-- sonuç ekranýndaki sütun sýrasýný belirler.

SELECT Ad, Soyad
FROM dbo.Ogrenciler;


-- =====================================================
-- 3. WHERE ÝLE FÝLTRELEME
-- =====================================================

-- WHERE: Belirli koþullara uyan kayýtlarý getirir.
-- = operatörü eþitlik kontrolü yapar.
-- Aþaðýdaki sorgu yaþý 20 olan öðrencileri getirir.

SELECT *
FROM dbo.Ogrenciler
WHERE Yas = 20;


-- =====================================================
-- 4. AND OPERATÖRÜ
-- =====================================================

-- AND: Bütün koþullarýn doðru olmasýný ister.
-- Yas <= 23: Yaþ 23 veya daha küçük olmalý.
-- Bolum = 'Yönetim Biliþim Sistemleri':
-- Öðrencinin bölümü belirtilen metinle eþleþmeli.
--
-- DÝKKAT:
-- Metinsel deðerler tek týrnak içinde yazýlýr.
-- 23 sayýsal deðer olduðu için týrnak kullanýlmaz.

SELECT *
FROM dbo.Ogrenciler
WHERE Yas <= 23
  AND Bolum = 'Yönetim Biliþim Sistemleri';


-- =====================================================
-- 5. OR OPERATÖRÜ
-- =====================================================

-- OR: Koþullardan en az birinin doðru olmasý yeterlidir.
-- Yas < 22: Yaþý 22'den küçük öðrenciler.
-- Yas = 18: Yaþý tam 18 olan öðrenciler.
--
-- DÝKKAT:
-- Bu örnekte Yas = 18 koþulu gereksizdir.
-- Çünkü 18 yaþ zaten 22'den küçüktür.
-- Dolayýsýyla sorgu Yas < 22 ile ayný sonucu verir.
-- Bu sorguyu OR mantýðýný göstermek için koruyoruz.

SELECT *
FROM dbo.Ogrenciler
WHERE Yas < 22 OR Yas = 18;


-- =====================================================
-- 6. AND VE OR OPERATÖRLERÝNÝ BÝRLÝKTE KULLANMA
-- =====================================================

-- ÖNEMLÝ:
-- SQL'de AND, OR operatöründen önce deðerlendirilir.
-- Parantezler koþullarýn hangi sýrayla
-- gruplanacaðýný açýkça belirtir.
--
-- Önce öðrencinin BST veya Muhasebe bölümünde
-- olup olmadýðý kontrol edilir.
-- Daha sonra yaþýnýn 20'den büyük olmasý istenir.

SELECT Ad, Soyad, Yas, Bolum
FROM dbo.Ogrenciler
WHERE (Bolum = 'Muhasebe' OR Bolum = 'BST')
  AND Yas > 20;


-- =====================================================
-- 7. EÞÝT DEÐÝLDÝR OPERATÖRÜ
-- =====================================================

-- Yaþý 20 veya 23 olan öðrencileri seçiyoruz.
-- Ayný zamanda bölümü Muhasebe olmamalý.
--
-- != : SQL Server'da eþit deðildir anlamýna gelir.
-- <> : Standart SQL'de eþit deðildir operatörüdür.
-- Her ikisi de SQL Server'da kullanýlabilir.
--
-- DÝKKAT:
-- NULL deðerleri != veya <> ile karþýlaþtýrmak,
-- NULL kayýtlarý otomatik olarak getirmez.
-- NULL kontrolü için IS NULL / IS NOT NULL kullanýlýr.

SELECT Ad, Soyad, Yas, Bolum
FROM dbo.Ogrenciler
WHERE (Yas = 20 OR Yas = 23)
  AND Bolum <> 'Muhasebe';


-- =====================================================
-- 8. ORDER BY ASC - ARTAN SIRALAMA
-- =====================================================

-- ORDER BY: Sorgu sonuçlarýný sýralar.
-- ASC: Küçükten büyüðe sýralama yapar.
-- Sayýlarda küçükten büyüðe,
-- metinlerde ilgili sýralama kurallarýna göre
-- artan sýralama uygulanýr.
--
-- ASC yazýlmasa da varsayýlan sýralama artandýr.

SELECT Ad, Soyad, Yas
FROM dbo.Ogrenciler
ORDER BY Yas ASC;


-- =====================================================
-- 9. ORDER BY DESC - AZALAN SIRALAMA
-- =====================================================

-- DESC: Büyükten küçüðe sýralama yapar.
-- Aþaðýdaki sorgu öðrencileri
-- yaþlarýna göre büyükten küçüðe sýralar.

SELECT Ad, Soyad, Yas
FROM dbo.Ogrenciler
ORDER BY Yas DESC;


-- =====================================================
-- 10. BÝRDEN FAZLA SÜTUNA GÖRE SIRALAMA
-- =====================================================

-- Önce Ad sütununa göre Z'den A'ya sýralanýr.
-- Ayný ada sahip öðrenciler varsa,
-- kendi aralarýnda Bolum sütununa göre
-- artan sýralama yapýlýr.
--
-- DÝKKAT:
-- ORDER BY içinde ilk yazýlan sütun önceliklidir.
-- Sýralama tablodaki verileri deðiþtirmez;
-- sadece sorgu sonucunun sýrasýný belirler.

SELECT Ad, Soyad, Yas, Bolum
FROM dbo.Ogrenciler
ORDER BY Ad DESC, Bolum ASC;


-- =====================================================
-- KISA TEKRAR
-- =====================================================

-- SELECT  : Hangi sütunlar getirilecek?
-- FROM    : Hangi tablodan?
-- WHERE   : Hangi koþullarý saðlayan kayýtlar?
-- AND     : Bütün koþullar doðru olmalý.
-- OR      : En az bir koþul doðru olmalý.
-- ORDER BY: Sonuçlar nasýl sýralanacak?
-- ASC     : Artan sýralama.
-- DESC    : Azalan sýralama.
-- <>      : Eþit deðildir.

-- DÝKKAT:
-- WHERE genellikle ORDER BY'dan önce yazýlýr.
-- SELECT, verileri deðiþtirmez.
-- UPDATE ve DELETE gibi komutlarda ise
-- yanlýþ koþul kullanýmý veri deðiþikliðine
-- veya kaybýna neden olabilir.

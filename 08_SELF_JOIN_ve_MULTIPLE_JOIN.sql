
/*
============================================================
SQL SERVER EÐÝTÝMÝ - DERS 09
============================================================

BU DERSTE ÖÐRENDÝKLERÝM:

1. SELF JOIN ile bir tabloyu kendi içerisinde birleþtirme.
2. Çalýþan ve yönetici iliþkisini sorgulama.
3. INFORMATION_SCHEMA.COLUMNS ile tablo yapýlarýný inceleme.
4. Birden fazla tabloyu JOIN kullanarak birleþtirme.
5. INNER JOIN ve LEFT JOIN iþlemlerini birlikte kullanma.
6. Sipariþ detaylarý üzerinden ürün ve müþteri bilgilerini getirme.
7. SQL içerisinde matematiksel hesaplamalar yapma.
8. Satýþ raporu oluþturma.

KULLANILAN TABLOLAR:
- Calisanlar
- Musteriler
- Siparisler
- SiparisDetaylari
- Urunler

NOT:
CREATE TABLE ve INSERT INTO komutlarý daha önce çalýþtýrýldýðý
için yorum satýrý içerisinde tutulmuþtur.
Bu sayede dosya yeniden çalýþtýrýldýðýnda ayný tablo veya
kayýtlarýn tekrar oluþturulmasý önlenir.

============================================================
*/

use OkulDB;
GO


/*
============================================================
1. SELF JOIN - TABLONUN KENDÝSÝYLE BÝRLEÞTÝRÝLMESÝ
============================================================

SELF JOIN NEDÝR?

Bir tablonun kendi içerisindeki kayýtlarý birbirleriyle
iliþkilendirmek için kullanýlýr.

ÖRNEK:
Bir þirkette çalýþanlarýn yöneticilerini listelemek.

Calisanlar tablosunda:
- CalisanId: Çalýþanýn benzersiz kimliði.
- Ad: Çalýþanýn adý.
- YoneticiId: Çalýþanýn baðlý olduðu yöneticinin kimliði.

SELF JOIN iþleminde ayný tabloya iki farklý takma ad verilir:

c = Çalýþan
y = Yönetici

LEFT JOIN kullanýlmasýnýn nedeni:
Yöneticisi bulunmayan çalýþanlarýn da listelenmesini saðlamaktýr.

YoneticiId deðeri NULL olan çalýþanlarýn YöneticiAdi
alaný da NULL olarak görüntülenir.

============================================================
*/

----------- SELF JOIN
SELECT 
  c.Ad as CalisanAdi,
  y.Ad as YöneticiAdi
From Calisanlar as c
LEFT JOIN Calisanlar  as y
  on c.YoneticiId = y.CalisanId;


/*
============================================================
2. MULTIPLE JOIN - ÇOKLU TABLO BÝRLEÞTÝRME
============================================================

MULTIPLE JOIN NEDÝR?

Ýkiden fazla tabloyu ortak sütunlar üzerinden
birleþtirme iþlemidir.

GERÇEK ÝÞ HAYATI ÖRNEÐÝ:

Bir e-ticaret þirketinde müþterilerin verdiði sipariþleri,
sipariþlerdeki ürünleri, ürün adetlerini ve fiyatlarýný
tek bir raporda görüntülemek isteyebiliriz.

Bunun için aþaðýdaki tablolar birleþtirilir:

Musteriler
    |
    | MusteriId
    |
Siparisler
    |
    | SiparisId
    |
SiparisDetaylari
    |
    | UrunId
    |
Urunler

ÝLÝÞKÝLER:

Musteriler.MusteriId = Siparisler.MusteriId

Siparisler.SiparisId = SiparisDetaylari.SiparisId

SiparisDetaylari.UrunId = Urunler.UrunId

============================================================
*/


/*
============================================================
3. INFORMATION_SCHEMA.COLUMNS ÝLE TABLO ÝNCELEME
============================================================

Yeni bir JOIN sorgusu yazmadan önce tablolarýn
hangi sütunlardan oluþtuðunu öðrenmek önemlidir.

INFORMATION_SCHEMA.COLUMNS:
Veritabanýndaki tablo sütunlarýnýn bilgilerini gösterir.

TABLE_NAME:
Sütunun ait olduðu tabloyu gösterir.

COLUMN_NAME:
Sütunun adýný gösterir.

DATA_TYPE:
Sütunun veri tipini gösterir.

WHERE TABLE_NAME IN (...):
Yalnýzca belirtilen tablolarýn sütunlarýný getirir.

ORDER BY TABLE_NAME, ORDINAL_POSITION:
Önce tablo adýna, ardýndan sütunlarýn tablodaki
sýrasýna göre sonuçlarý düzenler.

============================================================
*/

---------- MULTIPLE JOIN 
/*

INFORMATION_SCHEMA.COLUMNS	Veritabanýndaki sütun bilgilerini gösterir.
TABLE_NAME	Tablo adýný gösterir.
COLUMN_NAME	Sütun adýný gösterir.
DATA_TYPE	Sütunun veri tipini gösterir.
WHERE TABLE_NAME IN (...)	Yalnýzca belirttiðimiz üç tabloyu inceler.
ORDER BY	Sonuçlarý tablo ve sütun sýrasýna göre düzenler.
*/
SELECT
 TABLE_NAME,
 COLUMN_NAME,
 DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN(
  'Musteriler',
  'Siparisler',
  'Urunler'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;


/*
============================================================
4. SIPARISDETAYLARI TABLOSUNU OLUÞTURMA
============================================================

Bu tablo, bir sipariþin içerisindeki ürünleri tutar.

SÜTUNLAR:

SiparisDetayId:
Her sipariþ detayýný benzersiz þekilde tanýmlar.

PRIMARY KEY:
Birincil anahtar olarak kullanýlýr.

IDENTITY(1,1):
Kimlik numarasýnýn 1'den baþlayarak otomatik artmasýný saðlar.

SiparisId:
Ürünün hangi sipariþe ait olduðunu belirtir.

UrunId:
Sipariþ edilen ürünün kimliðini belirtir.

Adet:
Sipariþ edilen ürün miktarýdýr.

BirimFiyat:
Ürünün birim fiyatýdýr.

DECIMAL(10,2):
Toplam 10 basamaklý, virgülden sonra 2 basamaklý
sayýsal deðer saklar.

NOT NULL:
Ýlgili sütuna NULL deðer girilmesini engeller.

NOT:
Bu tabloda SiparisId ve UrunId sütunlarý iliþki kurmak
için kullanýlmýþtýr. Ancak CREATE TABLE komutunda
FOREIGN KEY kýsýtlarý tanýmlanmamýþtýr.

============================================================
*/

/*
CREATE TABLE SiparisDetaylari(
  SiparisDetayId INT PRIMARY KEY IDENTITY(1,1),
  SiparisId INT NOT NULL,
  UrunId INT NOT NULL,
  Adet INT NOT NULL,
  BirimFiyat DECIMAL(10,2)

);*/


/*
============================================================
5. SIPARIS DETAYLARINA ÖRNEK VERÝ EKLEME
============================================================

INSERT INTO:
Tabloya yeni kayýt eklemek için kullanýlýr.

VALUES:
Eklenecek kayýtlarýn deðerlerini belirtir.

Bir sipariþte birden fazla ürün bulunabilir.

ÖRNEK:

SiparisId = 1 olan sipariþte:

UrunId = 1, Adet = 2, BirimFiyat = 375.00

UrunId = 2, Adet = 1, BirimFiyat = 750.00

Bu nedenle ayný SiparisId birden fazla satýrda bulunabilir.

NOT:
Veriler daha önce eklendiði için INSERT komutu
yorum satýrýnda býrakýlmýþtýr.

============================================================
*/

/*INSERT INTO dbo.SiparisDetaylari
    (SiparisId, UrunId, Adet, BirimFiyat)
VALUES
    (1, 1, 2, 375.00),
    (1, 2, 1, 750.00),
    (2, 2, 1, 750.50),
    (3, 3, 2, 1100.00),
    (4, 1, 3, 400.00),
    (5, 2, 2, 775.00),
    (6, 3, 2, 1750.00),
    (7, 1, 1, 700.50),
    (7, 2, 2, 1000.00),
    (8, 3, 1, 1800.25);*/


/*
============================================================
6. INNER JOIN ÝLE MÜÞTERÝ VE SÝPARÝÞ BÝLGÝLERÝ
============================================================

AMAÇ:
Müþterilerin sipariþ numaralarýný ve sipariþ tutarlarýný
görüntülemek.

KULLANILAN TABLOLAR:

Musteriler AS m
Siparisler AS s

INNER JOIN:
Ýki tabloda eþleþen kayýtlarý getirir.

ON:
Tablolarýn hangi sütunlar üzerinden
birleþtirileceðini belirtir.

m.MusteriId = s.MusteriId:
Müþteri ile sipariþ arasýndaki iliþkiyi kurar.

ÖNEMLÝ:
Bir müþterinin birden fazla sipariþi varsa
müþterinin adý birden fazla satýrda görüntülenebilir.

============================================================
*/

SELECT 
  m.Ad,
  s.SiparisId,
  s.Tutar
FROM Musteriler as m
INNER JOIN Siparisler AS s
  on m.MusteriId = s.MusteriId;


/*
============================================================
7. DÖRT TABLOYU BÝRLEÞTÝREREK SATIÞ BÝLGÝLERÝNÝ GETÝRME
============================================================

AMAÇ:
Müþteri adý, sipariþ numarasý, ürün adý,
ürün numarasý, ürün adedi ve birim fiyatýný
ayný raporda görüntülemek.

KULLANILAN TABLOLAR:

1. Musteriler
2. Siparisler
3. SiparisDetaylari
4. Urunler

JOIN ÝÞLEMLERÝ:

INNER JOIN Siparisler:
Müþterilerin sipariþlerini getirir.

LEFT JOIN SiparisDetaylari:
Sipariþ detaylarý olmasa bile sipariþ kaydýný korur.

LEFT JOIN Urunler:
Sipariþ detayýndaki UrunId üzerinden ürün bilgilerini getirir.

LEFT JOIN NEDEN ÖNEMLÝ?

Örneðin SiparisId 9, 10 ve 11 için
sipariþ detaylarý bulunmuyorsa bu sipariþler
sonuçtan çýkarýlmaz.

Ýlgili ürün alanlarý NULL olarak görüntülenir.

NOT:
Bir sipariþte birden fazla ürün varsa
ayný SiparisId birden fazla satýrda görüntülenebilir.

============================================================
*/

SELECT 
  m.Ad as MüsteriAdi,
  s.SiparisId,
  u.UrunAdi as UrunAdi,
  sd.UrunId,
  sd.Adet,
  sd.BirimFiyat
FROM Musteriler AS M
INNER JOIN Siparisler as s
  on m.MusteriId = s.MusteriId
LEFT JOIN SiparisDetaylari as sd
 on s.SiparisId=sd.SiparisId

LEFT JOIN Urunler as u
 on sd.UrunId= u.UrunId 

ORDER BY s.SiparisId;


/*
============================================================
8. BAÐIMSIZ UYGULAMA - E-TÝCARET SATIÞ RAPORU
============================================================

SENARYO:

Bir e-ticaret þirketinde iþ analisti olarak çalýþýyoruz.

Satýþ departmaný bizden aþaðýdaki bilgileri içeren
bir rapor hazýrlamamýzý istiyor:

- Müþteri adý
- Sipariþ numarasý
- Satýn alýnan ürün adý
- Ürün adedi
- Toplam ürün tutarý


============================================================
*/

/*
============================================================
9. SQL ÝÇERÝSÝNDE HESAPLAMA YAPMA
============================================================

SQL'de SELECT bölümünde matematiksel iþlemler yapýlabilir.

MATEMATÝKSEL OPERATÖRLER:

+  Toplama
-  Çýkarma
*  Çarpma
/  Bölme

TOPLAM ÜRÜN TUTARI:

Adet * BirimFiyat

ÖRNEK:

Adet = 2
BirimFiyat = 375.00

ToplamUrunTutar = 750.00

sd.Adet:
Sipariþ edilen ürün miktarýný getirir.

sd.BirimFiyat:
Ürünün birim fiyatýný getirir.

sd.Adet * sd.BirimFiyat:
Ürünün toplam tutarýný hesaplar.

AS ToplamUrunTutar:
Hesaplanan sütuna isim verir.

ÖNEMLÝ:

Bu iþlem her sipariþ detayý satýrýnýn tutarýný hesaplar.

Bir sipariþin bütün ürünlerinin toplamýný bulmak
istersek ayrýca SUM() ve GROUP BY kullanabiliriz.


============================================================
*/

SELECT 
 m.Ad as MüsteriAdi,
 s.SiparisId,
 u.UrunAdi as UrununAdi,
 sd.Adet,
 sd.Adet * sd.BirimFiyat as ToplamUrunTutar
From Musteriler as m
INNER JOIN Siparisler as s
 on m.MusteriId=s.MusteriId

LEFT JOIN SiparisDetaylari as sd
  on s.SiparisId=sd.SiparisId

LEFT JOIN Urunler as u
  on sd.UrunId=u.UrunId
ORDER BY s.SiparisId ASC;


/*
============================================================
10. DERS SONU ÖZETÝ
============================================================

SELF JOIN:
Bir tablonun kendi kayýtlarý arasýnda iliþki kurar.

MULTIPLE JOIN:
Ýkiden fazla tabloyu birleþtirmemizi saðlar.

INNER JOIN:
Yalnýzca eþleþen kayýtlarý getirir.

LEFT JOIN:
Sol taraftaki kayýtlarý korur.
Sað tarafta eþleþme yoksa NULL deðerler oluþturur.

INFORMATION_SCHEMA.COLUMNS:
Tablolarýn sütun bilgilerini incelememizi saðlar.

AS:
Tablo veya sütunlara takma ad verir.

ORDER BY:
Sonuçlarý belirtilen sütuna göre sýralar.


*/

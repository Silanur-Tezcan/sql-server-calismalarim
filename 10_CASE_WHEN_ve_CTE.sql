
/*

KONU: CASE WHEN, NULL KONTROLÜ VE CTE
===========================================================

1. Alt sorgu (Subquery) ile müþteri sipariþ toplamý hesaplama
2. ISNULL() ile NULL deðerleri kontrol etme
3. CASE WHEN ile koþullu sonuçlar oluþturma
4. Birden fazla WHEN kullanarak kategorilendirme yapma
5. CASE WHEN içerisinde alt sorgu kullanma
6. CTE (Common Table Expression) oluþturma
7. CTE içerisinde WHERE ile filtreleme yapma
8. CTE ile CASE WHEN kullanma
9. CTE içerisinde SUM() ve GROUP BY kullanma

GERÇEK ÝÞ HAYATINDA KULLANIM ALANLARI:

- Müþteri harcama analizi
- VIP müþteri belirleme
- Sipariþ vermeyen müþterileri tespit etme
- Pazarlama segmentasyonu
- Satýþ raporlarý oluþturma
- Müþteri bazýnda sipariþ toplamlarýný hesaplama

===========================================================
*/

Use OkulDB
go

/*
===========================================================
1. ALT SORGU ÝLE MÜÞTERÝ SÝPARÝÞ TOPLAMLARI
===========================================================

AMAÇ:
Her müþterinin adýný, soyadýný ve toplam sipariþ tutarýný
göstermek.

ÖÐRENDÝKLERÝMÝZ:

Subquery (Alt Sorgu):
Baþka bir SQL sorgusunun içerisinde çalýþan sorgudur.

SUM():
Sayýsal deðerlerin toplamýný hesaplar.

ISNULL():
Ýlk ifade NULL ise ikinci parametredeki deðeri döndürür.

ISNULL(SUM(s.Tutar),0):
Sipariþ bulunmadýðýnda SUM() sonucu NULL olacaðý için
bunu 0 olarak gösterir.

WHERE m.MusteriId=s.MusteriId:
Alt sorguyu dýþ sorgudaki müþteriyle iliþkilendirir.
Buna Correlated Subquery (Ýliþkili Alt Sorgu) denir.

ÝÞ HAYATINDA:
Müþteri bazlý satýþ raporlarýnda kullanýlýr.
===========================================================
*/

SELECT
  m.Ad,
  m.Soyad,
  (
  SELECT ISNULL(SUM(s.Tutar),0)
  FROM Siparisler as s
  WHERE m.MusteriId=s.MusteriId
  ) as ToplamSiparisTutari
  From Musteriler as m;
 
 ----------- CASE WHEN

 /*
===========================================================
2. CASE WHEN - KOÞULLU ÝFADELER
===========================================================

CASE WHEN NEDÝR?

SQL sorgularýnda belirli koþullara göre farklý
sonuçlar oluþturmamýzý saðlar.

CASE    Koþullu ifadeyi baþlatýr.
WHEN    Kontrol edilecek koþulu belirtir.
THEN    Koþul doðruysa döndürülecek deðeri belirtir.
ELSE    Koþul saðlanmýyorsa döndürülecek deðeri belirtir.
END     CASE ifadesini bitirir.

SENARYO:
Müþterileri toplam harcamalarýna göre sýnýflandýrmak.

5000 TL üzeri   -> YÜKSEK HARCAMA
Diðerleri       -> NORMAL HARCAMA

ÝÞ HAYATINDA:
Müþteri segmentasyonu ve satýþ raporlarýnda kullanýlýr.
===========================================================
*/

/*
 CASE	Koþullu ifadeyi baþlatýr.
WHEN	Kontrol edilecek koþulu belirtir.
THEN	Koþul doðruysa döndürülecek deðeri belirtir.
ELSE	Koþul saðlanmýyorsa döndürülecek deðeri belirtir.
END	CASE ifadesini bitirir.
*/
SELECT 
  Ad,
  Soyad,
  ToplamHarcama,
 CASE 
   WHEN ToplamHarcama > 5000 THEN 'YÜKSEK HARCAMA'
   ELSE 'NORMAL HARCAMA'
 END as HarcamaDurumu
FROM Musteriler;

/*
===========================================================
3. BÝRDEN FAZLA WHEN ÝLE KATEGORÝLENDÝRME
===========================================================

AMAÇ:
Müþterileri üç farklý harcama kategorisine ayýrmak.

2000 TL altý       -> Düþük Harcama
2000 - 5000 TL     -> Orta Harcama
5000 TL üzeri      -> Yüksek Harcama

ÖNEMLÝ:

CASE WHEN koþullarý yukarýdan aþaðýya kontrol edilir.

Ýlk doðru koþulun THEN sonucu döndürülür.

Bu nedenle koþullarýn sýralamasý önemlidir.

ORDER BY ToplamHarcama ASC:
Sonuçlarý harcama tutarýna göre küçükten büyüðe sýralar.

ÝÞ HAYATINDA:
Pazarlama kampanyalarý için müþteri gruplarý oluþturulur.
===========================================================
*/

SELECT
  Ad,
  Soyad,
  ToplamHarcama,
   CASE 
     WHEN ToplamHarcama <2000 THEN 'Düþük Harcama'
	 WHEN ToplamHarcama <=5000 THEN 'Orta Harcama'
	 ELSE 'Yüksek Harcama'
   END AS HarcamaKategorisi
FROM Musteriler
ORDER BY ToplamHarcama ASC;

----------------- CASE WHEN ile NULL Kontrolü

/*
===========================================================
4. CASE WHEN ÝLE NULL KONTROLÜ
===========================================================

AMAÇ:
Müþterilerin sipariþ verip vermediðini belirlemek.

ÖNEMLÝ:

NULL:
Bir deðerin bulunmadýðýný veya bilinmediðini ifade eder.

IS NULL:
Deðerin NULL olup olmadýðýný kontrol eder.

SUM(s.Tutar):
Ýlgili müþterinin sipariþlerinin toplamýný hesaplar.

Eþleþen sipariþ bulunmadýðýnda SUM() NULL döndürür.

CASE WHEN içerisindeki alt sorgu her müþteriyle
iliþkilendirilerek deðerlendirilir.

ÝÞ HAYATINDA:
Sipariþ vermeyen müþterileri tespit etmek ve
yeniden kazaným kampanyalarý hazýrlamak için kullanýlýr.
===========================================================
*/

/* SENARYO: Sistemdeki bütün müþterilerin adýný,
soyadýný ve sipariþ durumunu göster.
Sipariþi olmayan müþterileri de rapora dahil et.
*/
SELECT
 m.Ad,
 m.Soyad,
  CASE 
    WHEN(
	   SELECT SUM(s.Tutar)
	   FROM Siparisler AS s
	   WHERE s.MusteriId=m.MusteriId
	) IS NULL THEN 'Siparis Vermedi'
	ELSE 'Siparis Verdi'
   END AS SiparisDurumu
FROM Musteriler AS m;

/*
===========================================================
5. ALT SORGU + CASE WHEN ÝLE MÜÞTERÝ SINIFLANDIRMA
===========================================================

AMAÇ:
Müþterileri toplam sipariþ tutarlarýna göre sýnýflandýrmak.

Hiç sipariþ yok     -> Siparis Yok
3000 TL veya altý   -> Normal Siparis
3000 TL üzeri       -> VIP Müsteri

ÖNEMLÝ:

Bu sorguda SUM() sonucu NULL ise müþteri
'Siparis Yok' kategorisine girer.

SUM() sonucu 3000 veya daha küçükse
'Normal Siparis' kategorisine girer.

Diðer müþteriler VIP kategorisine girer.

<= operatörü:
Küçük veya eþit anlamýna gelir.

ÖRNEK:
3000 TL tutarýndaki bir sipariþ toplamý
Normal Siparis kategorisindedir.

NOT:
ToplamSiparis takma adý alt sorgunun dýþýnda
doðrudan kullanýlamadýðý için alt sorgu
ilgili WHEN koþullarýnda tekrar yazýlmýþtýr.

ÝÞ HAYATINDA:
Müþteri sadakat programlarý ve VIP müþteri
analizlerinde kullanýlabilir.
===========================================================
*/

/* 
Bir e-ticaret þirketinin pazarlama departmanýnda iþ analisti olarak çalýþýyorsun.

Yönetici senden müþterileri sipariþ toplamlarýna göre üç gruba ayýrmaný istiyor:
Koþul	Sipariþ Kategorisi
Hiç sipariþ vermemiþ	Sipariþ Yok
Toplam sipariþ tutarý 3.000 TL veya daha az	Normal Müþteri
Toplam sipariþ tutarý 3.000 TL'den fazla	VIP Müþteri
*/

SELECT 
  m.Ad,
  m.Soyad,
  CASE
     WHEN(
	    SELECT SUM(s.Tutar) AS ToplamSiparis
	    FROM Siparisler AS s
	    WHERE s.MusteriId=m.MusteriId
	 ) IS NULL THEN 'Siparis Yok' 
	 WHEN(
	    SELECT SUM(s.Tutar) AS ToplamSiparis
	    FROM Siparisler AS s
	    WHERE s.MusteriId=m.MusteriId
	 ) <=3000 THEN 'Normal Siparis'
	 ELSE 'VIP Müsteri'
  END AS SiparisKategorisi
FROM Musteriler as m;

---------------------------- CTE (Common Table Expression)

/*
===========================================================
6. CTE - COMMON TABLE EXPRESSION
===========================================================

CTE NEDÝR?

Common Table Expression:
Türkçesi Ortak Tablo Ýfadesi'dir.

Bir SQL sorgusunun sonucuna geçici bir isim
vermemizi saðlar.

CTE kalýcý bir tablo oluþturmaz.

CTE yalnýzca tanýmlandýðý SQL ifadesinden
hemen sonra gelen tek SQL ifadesinde kullanýlabilir.

TEMEL YAPI:

;WITH CTE_Adi AS
(
    SELECT ...
    FROM ...
)
SELECT *
FROM CTE_Adi;

ÖNEMLÝ:

WITH:
CTE tanýmýný baþlatýr.

AS:
CTE'nin sorgusunu tanýmlar.

;WITH:
Önceki SQL ifadesinin sonlandýrýlmasýný saðlar.

CTE_Adi:
Oluþturduðumuz sorgu sonucuna verdiðimiz isimdir.

ÝÞ HAYATINDA:
Karmaþýk sorgularý daha okunabilir ve yönetilebilir
hâle getirmek için kullanýlýr.
===========================================================
*/

/*
WITH	CTE tanýmýný baþlatýr.
MusteriListesi	CTE'ye verdiðimiz isimdir.
AS (...)	CTE'nin hangi sorgudan oluþacaðýný belirler.
SELECT * FROM MusteriListesi	Tanýmladýðýmýz CTE'nin sonuçlarýný getirir.
*/
WITH MusteriListesi AS
(
    SELECT Ad,Soyad
	FROM Musteriler
)
SELECT *
FROM MusteriListesi;

/*
===========================================================
7. CTE + WHERE + CASE WHEN
===========================================================

AMAÇ:
Belirli harcama tutarýna sahip müþterileri
CTE içerisinde filtrelemek ve sonrasýnda
CASE WHEN ile sýnýflandýrmak.

CTE ÝÇÝNDEKÝ WHERE:
Hangi müþterilerin CTE sonucuna dahil edileceðini belirler.

DIÞ SORGUDAKÝ CASE WHEN:
CTE'den gelen müþterileri sýnýflandýrýr.

ORDER BY ASC:
Harcama tutarýna göre artan sýralama yapar.

ÖNEMLÝ:

CTE içerisinde elenen müþteriler dýþ sorguda
görünmez.

BU UYGULAMADAKÝ KOÞULLAR:

ToplamHarcama >= 3000:
3000 TL ve üzerindeki müþterileri getirir.

ToplamHarcama < 4000:
Bu müþterileri 'Dusuk Harcama' olarak sýnýflandýrýr.

Diðerleri:
'Yuksek Harcama' olarak sýnýflandýrýlýr.

DÝKKAT:
Orijinal senaryoda 5000 TL üzeri müþteriler isteniyor.
Ancak uygulama kodunda >=3000 koþulu kullanýlmýþtýr.

Kod deðiþtirilmemiþtir; uygulama mevcut koþullara
göre sonuç üretir.

ÝÞ HAYATINDA:
Önce belirli müþteri kitlesini seçmek,
sonra bu kitleyi kategorilere ayýrmak için kullanýlýr.
===========================================================
*/

/* SENARYO: Pazarlama departmaný senden 5.000 TL'den fazla harcama
yapan müþterilerin adýný, soyadýný ve toplam harcamasýný listelemeni istiyor.
*/

;WITH YuksekHarcamaYapanlar AS
(
  SELECT Ad,Soyad,ToplamHarcama
  FROM Musteriler
  WHERE ToplamHarcama >=3000
)
SELECT Ad,Soyad,ToplamHarcama,
  CASE 
   WHEN ToplamHarcama  <4000 THEN 'Dusuk Harcama'
   else 'Yuksek Harcama'
  END AS Sonuc

FROM YuksekHarcamaYapanlar
ORDER BY ToplamHarcama asc ;

/*
===========================================================
8. CTE + SUM() + GROUP BY
===========================================================

SENARYO:
Her müþterinin toplam sipariþ tutarýný hesaplamak.

SUM(Tutar):
Sipariþ tutarlarýný toplar.

GROUP BY MusteriId:
Ayný müþteriye ait sipariþleri gruplar.

CTE:
Gruplanmýþ ve hesaplanmýþ sonuçlara
MusteriToplamSayisi ismini verir.

SELECT * FROM MusteriToplamSayisi:
CTE'nin hesapladýðý sonuçlarý gösterir.

ÖNEMLÝ BÝLGÝ:

SUM() her zaman GROUP BY gerektirmez.

ÖRNEK:

SELECT SUM(Tutar)
FROM Siparisler;

Bu sorgu bütün sipariþlerin genel toplamýný hesaplar.

ANCAK:

SELECT MusteriId, SUM(Tutar)
FROM Siparisler;

Bu sorgu SQL Server'da hata verir.

Çünkü MusteriId sütunu SUM() dýþýnda seçilmiþtir
ve GROUP BY içerisinde bulunmamaktadýr.

DOÐRU GRUPLAMA MANTIÐI:

SELECT MusteriId, SUM(Tutar)
FROM Siparisler
GROUP BY MusteriId;

Bu sorgu her müþterinin toplam sipariþ tutarýný
ayrý ayrý hesaplar.

NOT:
Sipariþ kaydý olmayan müþteriler bu sorguda
görünmez. Çünkü veri Siparisler tablosundan alýnýr.

ÝÞ HAYATINDA:
Müþteri bazlý satýþ analizi ve gelir raporlarýnda kullanýlýr.
===========================================================
*/

/* SENARYO: Her müþterinin toplam kaç TL'lik sipariþ verdiðini
gösteren bir rapor istiyorum.
*/
;WITH MusteriToplamSayisi as 
(
 SELECT
  MusteriId,
  SUM(Tutar) as ToplamSiparis
  FROM Siparisler
  GROUP BY MusteriId
)
SELECT *
FROM MusteriToplamSayisi;

/*
===========================================================
DERS ÖZETÝ
===========================================================

1. Subquery:
Baþka bir sorgu içerisinde kullanýlan SQL sorgusudur.

2. ISNULL:
NULL deðerler için alternatif bir deðer döndürür.

3. CASE WHEN:
Koþullara göre farklý sonuçlar üretir.

4. CTE:
Bir sorgunun sonucuna geçici bir isim verir.
Kalýcý tablo oluþturmaz.

5. SUM + GROUP BY:
Her grup için ayrý toplam hesaplamamýzý saðlar.

6. WHERE:
Gruplama öncesinde satýrlarý filtreler.

7. HAVING:
Gruplama sonrasýnda gruplarý filtreler.

8. ORDER BY:
Sonuçlarý belirlenen sütuna göre sýralar.


*/


/*
============================================================
10 - SUBQUERY (ALT SORGULAR)
============================================================

AMAÇ:
- Subquery (Alt Sorgu) mantýðýný öðrenmek
- AVG() ile alt sorgu kullanmak
- IN ve NOT IN operatörlerini öðrenmek
- EXISTS ve NOT EXISTS yapýlarýný kullanmak
- Correlated Subquery (Ýliþkili Alt Sorgu) oluþturmak
- SUM() ile müþteri bazýnda sipariþ toplamý hesaplamak
- ISNULL() ile NULL sonuçlarýný yönetmek

VERÝTABANI: OkulDB

KULLANILAN TABLOLAR:
- Musteriler
- Siparisler

NOT:
Bu dosyada eðitim sýrasýnda yazýlan SQL sorgularý
korunmuþ ve açýklayýcý yorumlar eklenmiþtir.
============================================================
*/


/*
============================================================
1. SUBQUERY (ALT SORGU)
============================================================

Subquery, bir SQL sorgusunun içerisinde baþka bir
SQL sorgusunun kullanýlmasýdýr.

Alt sorgular, bir sorgunun sonucunu baþka bir
sorguda kullanmamýzý saðlar.

ÖRNEK:
Müþterilerin ortalama harcamasýný hesaplayýp
bu ortalamanýn üzerinde harcama yapanlarý bulmak.
*/

----------- SUBQUERY (Alt Sorgular)

-- Müþterilerin ortalama harcama tutarýný hesaplar.
-- AVG(): Sayýsal deðerlerin aritmetik ortalamasýný alýr.
-- AS: Sonuç sütununa geçici bir isim verir.

SELECT AVG(ToplamHarcama) as HarcamaOrtalamasi
FROM Musteriler;


/*
SENARYO:
Ortalama harcama tutarýnýn üzerinde harcama yapan
müþterileri listelemek istiyoruz.

ÇALIÞMA MANTIÐI:
1. Ýç sorgu müþterilerin ortalama harcamasýný hesaplar.
2. Dýþ sorgu müþterilerin bilgilerini getirir.
3. WHERE koþulu, ortalamadan fazla harcama yapanlarý seçer.

ÖNEMLÝ:
Alt sorgu her çalýþtýrýldýðýnda mevcut verilere göre
ortalama yeniden hesaplanýr.
*/

SELECT 
 Ad,
 Soyad,
 ToplamHarcama
From Musteriler
WHERE ToplamHarcama >(
  select AVG(ToplamHarcama)
  From Musteriler
);


/*
Yeni müþteri ekleme örneði.

INSERT INTO: Tabloya yeni kayýt eklemek için kullanýlýr.

Bu kod yorum satýrýnda býrakýlmýþtýr.
Çalýþtýrmak için yorum iþaretleri kaldýrýlabilir.

DÝKKAT:
Ayný INSERT komutunu tekrar çalýþtýrmak,
ayný müþterinin yeniden eklenmesine neden olabilir.
*/

--INSERT INTO Musteriler(Ad,Soyad,Yas,Sehir,ToplamHarcama)
--VALUES('Osman','Aðaoðlu',20,'Isparta',8000.50);


/*
Bu sorguda karþýlaþtýrma operatörü olarak < kullanýlýr.

>  : Büyüktür
<  : Küçüktür
>= : Büyük veya eþittir
<= : Küçük veya eþittir

Amaç:
Ortalama harcamanýn altýnda kalan müþterileri bulmak.
*/

-- SENARYO: Ortalama harcama tutarýnýn altýnda kalan müþterileri listelemek istiyoruz. Bu müþterilere özel indirim kampanyasý hazýrlayacaðýz.
SELECT 
  Ad,
  Soyad,
  ToplamHarcama
FROM Musteriler
WHERE ToplamHarcama<(
  SELECT AVG(ToplamHarcama)
  From Musteriler
);


/*
============================================================
2. IN ÝLE SUBQUERY
============================================================

IN:
Bir deðerin belirtilen deðerler arasýnda bulunup
bulunmadýðýný kontrol eder.

SENARYO:
En az bir sipariþ vermiþ müþterileri listelemek.

ÇALIÞMA MANTIÐI:
1. Ýç sorgu Siparisler tablosundaki MusteriId
   deðerlerini getirir.
2. Dýþ sorgu Musteriler tablosunu inceler.
3. MusteriId, iç sorgunun sonuçlarýnda varsa
   müþteri listelenir.

ÖNEMLÝ:
Bir müþterinin birden fazla sipariþi olmasý,
IN nedeniyle müþterinin tekrar listelenmesine
neden olmaz.
*/

SELECT 
 Ad,
 Soyad,
 MusteriId
From Musteriler
WHERE MusteriId IN(
 SELECT MusteriId
 from Siparisler
);


/*
KONTROL SORGUSU:

MusteriId deðeri 9 olan müþterinin
Siparisler tablosunda sipariþi olup olmadýðýný
kontrol etmek için kullanýlýr.

Sonuç boþ gelirse bu müþteri numarasýyla
eþleþen sipariþ kaydý bulunmamaktadýr.
*/

select
 SiparisId,
 MusteriId,
 Tutar
FROM Siparisler
WHERE MusteriId=9;


/*
IN sorgusunun tekrar uygulanmasý.

Siparisler tablosunda müþteri numarasý bulunan
müþterilerin adýný, soyadýný ve numarasýný getirir.
*/

SELECT Ad,Soyad,MusteriId
FROM Musteriler
WHERE MusteriId IN(
 SELECT MusteriId
 FROM Siparisler
);


/*
DISTINCT:
Tekrarlanan deðerleri sonuç kümesinde bir kez gösterir.

ORDER BY:
Sonuçlarý sýralamak için kullanýlýr.
ASC varsayýlan olarak küçükten büyüðe sýralamadýr.

Bu sorgu, sipariþ vermiþ farklý müþteri
numaralarýný listeler.
*/

SELECT DISTINcT MusteriId
From Siparisler
ORDER BY MusteriId;


/*
============================================================
3. NOT IN ÝLE SUBQUERY
============================================================

NOT IN:
Bir deðerin alt sorgunun döndürdüðü deðerler
arasýnda bulunmamasý durumunda kaydý getirir.

IN     : Eþleþen deðerleri bulur.
NOT IN : Eþleþmeyen deðerleri bulur.

ÖNEMLÝ:
Alt sorgunun döndürdüðü deðerler arasýnda NULL
bulunmasý, NOT IN sonucunu etkileyebilir.

Bu nedenle NOT IN kullanýrken NULL deðerlerine
dikkat edilmelidir.
*/

/* SENARYO : Bir e-ticaret þirketinde iþ analisti olarak çalýþýyorsun. Pazarlama ekibi, kayýt olmuþ ancak henüz sipariþ vermemiþ müþterilere kampanya göndermek istiyor.

Senden þu raporu hazýrlamaný istiyorlar:

Hiç sipariþ vermemiþ müþterilerin adýný, soyadýný ve müþteri numarasýný listele.  */

SELECT
 Ad,
 Soyad,
 MusteriId
FROM Musteriler
WHERE MusteriId NOT IN(
 SELECT MusteriId
 FROM Siparisler
 );


/*
============================================================
4. EXISTS ÝLE SUBQUERY
============================================================

EXISTS:
Alt sorgunun en az bir satýr döndürüp
döndürmediðini kontrol eder.

Alt sorgu en az bir kayýt döndürüyorsa TRUE,
hiç kayýt döndürmüyorsa FALSE sonucu oluþur.

SENARYO:
En az bir sipariþ vermiþ müþterileri listelemek.

SELECT 1:
EXISTS içerisinde sýk kullanýlan bir ifadedir.

Buradaki 1 müþteri numarasý veya sipariþ sayýsý
anlamýna gelmez.

EXISTS için seçilen deðerden ziyade
eþleþen bir satýrýn bulunmasý önemlidir.
*/

-----------   EXISTS

SELECT
  M.Ad,
  m.Soyad,
  m.MusteriId
FROM Musteriler AS M
WHERE EXISTS (
   SELECT 1
   FROM Siparisler as s
   WHERE s.MusteriId=m.MusteriId
);


/*
IN VE EXISTS KARÞILAÞTIRMASI

IN:
- Deðerin sonuç kümesinde bulunup bulunmadýðýný
  kontrol eder.
- Genellikle deðer listeleriyle kullanýlýr.

EXISTS:
- Alt sorgunun en az bir satýr döndürüp
  döndürmediðini kontrol eder.
- Genellikle iliþkili alt sorgularla kullanýlýr.

Her iki yapý da uygun þekilde kullanýldýðýnda
ayný müþteri listesini oluþturabilir.
*/

/*
   -IN	                                                                                                          * EXISTS
-Deðerin bir sonuç kümesinde bulunup bulunmadýðýný kontrol eder.	                  *Alt sorgunun en az bir satýr döndürüp döndürmediðini kontrol eder.
-Genellikle deðer listeleriyle kullanýlýr.	                                      *Genellikle iliþkili alt sorgularla kullanýlýr.
*/


/*
============================================================
5. NOT EXISTS ÝLE SUBQUERY
============================================================

NOT EXISTS:
Alt sorgunun eþleþen hiçbir satýr döndürmemesi
durumunda TRUE olur.

SENARYO:
Hiç sipariþ vermemiþ müþterileri listelemek.

ÇALIÞMA MANTIÐI:
1. Dýþ sorgu Musteriler tablosundaki müþterileri inceler.
2. Ýç sorgu ilgili müþterinin sipariþini arar.
3. Sipariþ bulunmuyorsa NOT EXISTS koþulu saðlanýr.
4. Müþteri sonuçlara eklenir.

ÖNEMLÝ:
WHERE S.MusteriId=m.musteriId koþulu,
iki tablo arasýndaki iliþkiyi kurar.

Bu koþul kaldýrýlýrsa alt sorgu artýk
belirli bir müþterinin sipariþini kontrol etmez.
*/

SELECT
 M.Ad,
 m.Soyad,
 MusteriId
FROM Musteriler as m
WHERE  NOT EXISTS(
  SELECT 1
  FROM Siparisler AS S
  WHERE S.MusteriId=m.musteriId
);


/*
============================================================
6. CORRELATED SUBQUERY (ÝLÝÞKÝLÝ ALT SORGU)
============================================================

Correlated Subquery:
Ýç sorgunun dýþ sorgudaki bir sütuna baðlý
olarak çalýþtýðý alt sorgu türüdür.

NORMAL SUBQUERY:
- Ýç sorgu dýþ sorgudan baðýmsýzdýr.
- Tek baþýna çalýþtýrýlabilir.
- Örneðin bütün müþterilerin ortalamasýný hesaplar.

CORRELATED SUBQUERY:
- Ýç sorgu dýþ sorgudaki bir deðeri kullanýr.
- Dýþ sorguyla baðlantýlýdýr.
- Örneðin her müþterinin sipariþini kontrol eder.

NOT:
Ýliþkili alt sorgu mantýksal olarak dýþ sorgudaki
müþteriye göre deðerlendirilir.

SQL Server sorguyu çalýþtýrýrken farklý bir
yürütme planý kullanabilir.
*/

------------------- Correlated Subquery (Ýliþkili Alt Sorgu)

/*

                     *Normal (iliþkisiz) Subquery	                                       **Correlated Subquery
  *Ýç sorgu dýþ sorgudan baðýmsýzdýr.	                               ** Ýç sorgu dýþ sorgudaki sütunu kullanýr.
  *Örneðin tüm müþterilerin ortalamasýný hesaplar.	                   **Örneðin her müþterinin sipariþi olup olmadýðýný kontrol eder.
  *Tek baþýna çalýþtýrýlabilir.	                                       **Dýþ sorgudan gelen deðere ihtiyaç duyar.
*/


/*
SENARYO:
En az bir sipariþi 2000 TL'den fazla olan
müþterileri listelemek.

s.MusteriId=m.MusteriId:
Sipariþin hangi müþteriye ait olduðunu belirler.

s.Tutar>2000:
Her sipariþin tutarýný ayrý ayrý kontrol eder.

DÝKKAT:
Bu sorgu müþterinin bütün sipariþlerinin
toplamýný hesaplamaz.

Örneðin:
900 + 800 + 700 = 2400 TL olsa bile,
tek bir sipariþ 2000 TL'yi aþmadýðý için
müþteri bu sorguda listelenmez.
*/

select
  m.Ad,
  m.Soyad,
  m.MusteriId
FROM Musteriler as m
WHERE EXISTS(
 SELECT 1
 From Siparisler as s
 WHERE s.MusteriId=m.MusteriId
   AND s.Tutar>2000
);


/*
============================================================
7. CORRELATED SUBQUERY ÝLE SUM()
============================================================

SUM():
Sayýsal deðerlerin toplamýný hesaplar.

SENARYO:
Sistemde kayýtlý bütün müþterileri ve
her müþterinin sipariþlerinin toplam tutarýný
listelemek.

ÇALIÞMA MANTIÐI:
1. Dýþ sorgu müþterileri getirir.
2. Ýç sorgu ilgili müþterinin sipariþlerini bulur.
3. SUM() bu sipariþlerin tutarlarýný toplar.
4. Hesaplanan deðer müþterinin karþýsýnda gösterilir.

ÖNEMLÝ:
Ýç sorgu SELECT bölümünde kullanýlmýþtýr.

WHERE m.MusteriId=s.MusteriId koþulu
kaldýrýlýrsa her müþteri için bütün
sipariþlerin genel toplamý hesaplanýr.

Sipariþi olmayan müþterilerde SUM()
NULL sonucu döndürür.
*/

-- SENARYO: Sistemde kayýtlý bütün müþterileri ve her müþterinin sipariþlerinin toplam tutarýný göster.
SELECT 
 m.Ad,
 m.Soyad,
(
  select SUM(s.Tutar)
  from Siparisler as s
  where m.MusteriId=s.MusteriId
) as ToplamSipairisTutari
from Musteriler AS m;


/*
============================================================
8. ISNULL() FONKSÝYONU
============================================================

ISNULL():
Bir ifadenin sonucu NULL olduðunda,
belirtilen alternatif deðeri döndürür.

KULLANIM:
ISNULL(deger, alternatif_deger)

ÖRNEK:
ISNULL(NULL, 0) -> 0
ISNULL(2500, 0) -> 2500

SENARYO:
Sipariþ vermemiþ müþterilerin toplam
sipariþ tutarýný NULL yerine 0 göstermek.

ISNULL(SUM(s.Tutar),0):
- SUM() ile sipariþlerin toplamýný hesaplar.
- Sonuç NULL ise 0 gösterir.
- Sonuç NULL deðilse hesaplanan tutarý korur.

ÖNEMLÝ:
ISNULL() burada veritabanýndaki kayýtlarý
deðiþtirmez, yalnýzca sorgu sonucunu etkiler.

Sipariþi olmayan müþteride 0 görünmesi,
müþterinin 0 TL tutarýnda sipariþ verdiði
anlamýna gelmez.
*/

----------- ISNULL()

SELECT 
 m.Ad,
 m.Soyad,
(
  SELECT ISNULL(SUM(s.Tutar),0)
  FROM Siparisler AS s
  WHERE m.MusteriId = s.MusteriId
) AS ToplamSiparisTutari
FROM Musteriler AS m;


/*
============================================================
DERS 10 - ÖÐRENÝLEN KONULARIN ÖZETÝ
============================================================

1. SUBQUERY:
   Bir sorgunun içerisinde baþka sorgu kullanýlýr.

2. AVG() ÝLE SUBQUERY:
   Ortalama deðer üzerinden filtreleme yapýlabilir.

3. IN:
   Alt sorgunun sonuçlarýnda bulunan deðerleri seçer.

4. NOT IN:
   Alt sorgunun sonuçlarýnda bulunmayan deðerleri seçer.

5. EXISTS:
   Eþleþen en az bir kayýt olup olmadýðýný kontrol eder.

6. NOT EXISTS:
   Eþleþen kayýt bulunmayan durumlarý kontrol eder.

7. CORRELATED SUBQUERY:
   Ýç sorgu dýþ sorgudaki bir sütuna baðlýdýr.

8. SUM():
   Sipariþlerin toplam tutarýný hesaplar.

9. ISNULL():
   NULL sonuçlarýný alternatif deðerle gösterebilir.

============================================================
GERÇEK ÝÞ HAYATINDA KULLANIM ALANLARI
============================================================

- Ortalama harcamanýn üzerindeki müþterileri bulmak
- Ortalama harcamanýn altýndaki müþterileri belirlemek
- Sipariþ vermiþ müþterileri listelemek
- Hiç sipariþ vermemiþ müþterileri tespit etmek
- Belirli tutarýn üzerinde sipariþi olanlarý bulmak
- Müþteri bazýnda toplam sipariþ tutarýný hesaplamak
- NULL deðerleri raporlama amacýyla düzenlemek

*/

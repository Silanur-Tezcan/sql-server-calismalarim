
/*
========================================================

KONU: JOIN İŞLEMLERİ VE RAPORLAMA

========================================================
AMAÇ:
Musteriler ve Siparisler tabloları arasında
ilişki kurarak müşteri ve sipariş raporları
oluşturmak.

========================================================
*/

use OkulDB;

/*
--------------------------------------------------------
1. GROUP BY VE HAVING İLE TOPLAM SİPARİŞ TUTARI
--------------------------------------------------------

SUM(Tutar):
Her müşterinin sipariş tutarlarını toplar.

GROUP BY MusteriId:
Siparişleri müşteri numarasına göre gruplar.

HAVING SUM(Tutar)>1000:
Toplam sipariş tutarı 1000'den büyük olan
müşterileri listeler.

NOT:
HAVING, gruplandırılmış verileri filtrelemek
için kullanılır.
*/

/*select MusteriId ,
SUM(Tutar) as ToplamTutar
from Siparisler
Group BY MusteriId
HAVING SUM(Tutar)>1000;*/


/*
--------------------------------------------------------
2. INNER JOIN İLE TABLOLARI BİRLEŞTİRME
--------------------------------------------------------

INNER JOIN:
İki tabloda eşleşen kayıtları getirir.

Musteriler:
Müşterilerin bilgilerini tutar.

Siparisler:
Müşterilerin sipariş bilgilerini tutar.

ON:
Tabloların hangi sütun üzerinden
eşleştirileceğini belirtir.

m ve s:
Tablolara verilen kısa isimlerdir (alias).

Bu sorgu, sipariş vermiş müşterilerin
adını, soyadını ve sipariş tutarını getirir.
*/

/*SELECT 
  m. Ad,
  m.Soyad,
  s.Tutar
from Musteriler as m
INNER JOIN Siparisler AS s
   on m.MusteriId= s.MusteriId;*/


/*
--------------------------------------------------------
3. INNER JOIN + WHERE + ORDER BY
--------------------------------------------------------

INNER JOIN:
Müşteriler ile siparişleri birleştirir.

WHERE Tutar>2000:
Tutarı 2000'den büyük olan siparişleri seçer.

ORDER BY Tutar DESC:
Sipariş tutarlarını büyükten küçüğe sıralar.

DESC: Azalan sıralama.
ASC: Artan sıralama.

NOT:
WHERE, gruplama yapılmadan önce
satırları filtrelemek için kullanılır.
*/

SELECT 
  m.Ad,
  s.SiparisTarihi,
  m.MusteriId,
  s.Tutar
FROM Musteriler as m
INNER JOIN Siparisler AS s
  on m.MusteriId=s.MusteriId
where tutar>2000
order by  Tutar DESC;


/*
--------------------------------------------------------
4. INNER JOIN + GROUP BY + HAVING
--------------------------------------------------------

AMAÇ:
Her müşterinin ilk ve son sipariş tarihini,
toplam harcama tutarını hesaplamak.

MIN(SiparisTarihi):
Müşterinin en eski sipariş tarihini bulur.

MAX(SiparisTarihi):
Müşterinin en yeni sipariş tarihini bulur.

SUM(Tutar):
Müşterinin toplam harcamasını hesaplar.

GROUP BY:
Aynı müşteriye ait siparişleri gruplar.

HAVING SUM(Tutar)>2500:
Toplam harcaması 2500'den büyük olan
müşterileri getirir.

NOT:
GROUP BY kullanıldığında SELECT içerisindeki
toplama fonksiyonuna dahil olmayan sütunlar
GROUP BY içerisinde belirtilmelidir.
*/

SELECT 
  m.Ad,
  m.MusteriId,
 
  MIN(s.SiparisTarihi) as IlkSiparisTarihi,
  MAX(s.SiparisTarihi) as SonSiparisTarihi,
  SUM(s.Tutar) AS ToplamTutar
FROM Musteriler as m
INNER JOIN Siparisler AS s
  on m.MusteriId=s.MusteriId
GROUP BY m.MusteriId, m.Ad
HAVING SUM(Tutar)>2500;


/*
--------------------------------------------------------
5. SENARYO: EN AZ 2 SİPARİŞ VEREN MÜŞTERİLER
--------------------------------------------------------

AMAÇ:
Her müşterinin adını, soyadını,
toplam sipariş sayısını ve toplam
harcama tutarını listelemek.

COUNT(SiparisId):
Müşterinin sipariş sayısını hesaplar.

SUM(Tutar):
Müşterinin toplam harcamasını hesaplar.

GROUP BY:
Siparişleri müşterilere göre gruplar.

HAVING COUNT(SiparisId)>=2:
En az 2 siparişi bulunan müşterileri getirir.

NOT:
COUNT(s.SiparisId), NULL olmayan
sipariş numaralarını sayar.
*/

/* SENARYO 1: Her müşterinin adını, soyadını, toplam sipariş sayısını ve toplam harcama tutarını görmek istiyorum.
Ancak yalnızca en az 2 sipariş veren müşteriler listelensin.*/

SELECT
  m.Ad,
  m.Soyad,
  COUNT(s.SiparisId) as ToplamSiparis,
  SUM(s.Tutar) as ToplamHarcama
from Siparisler as s
INNER JOIN Musteriler as m
 on s.MusteriId=m.MusteriId
GROUP BY m.Ad,m.Soyad , m.MusteriId
HAVING COUNT(SiparisId)>=2;


/*
--------------------------------------------------------
6. TOPLAM HARCAMAYA GÖRE MÜŞTERİ FİLTRELEME
--------------------------------------------------------

INNER JOIN:
Sipariş veren müşterileri eşleştirir.

COUNT():
Her müşterinin sipariş sayısını hesaplar.

SUM():
Her müşterinin toplam harcamasını hesaplar.

HAVING SUM(Tutar)>3500:
Toplam harcaması 3500'den büyük olan
müşterileri listeler.

Bu sorgu yorum satırında tutulmuştur.
*/

/*
SELECT 
  m.Ad,
  m.Soyad,
  COUNT(s.SiparisId) as ToplamSiparisler,
  SUM(s.Tutar) AS ToplamTutar
FROM Siparisler as s
INNER JOIN Musteriler as m
 on m.MusteriId=s.MusteriId
Group By m.MusteriId, m.Ad, m.Soyad
HAVING SUM(Tutar)>3500;*/


/*
--------------------------------------------------------
7. LEFT JOIN İLE BÜTÜN MÜŞTERİLERİ LİSTELEME
--------------------------------------------------------

LEFT JOIN:
Soldaki Musteriler tablosundaki bütün
müşterileri getirir.

Siparişi olan müşterilerin sipariş
tutarları gösterilir.

Siparişi olmayan müşterilerin
Tutar alanı NULL olarak görünür.

NOT:
Bir müşterinin birden fazla siparişi varsa
müşteri birden fazla satırda görünebilir.
*/

SELECT 
  m.Ad,
  s.Tutar
FROM Musteriler AS m
LEFT JOIN Siparisler AS s
  on m.MusteriId=s.MusteriId;


/*
--------------------------------------------------------
8. LEFT JOIN + IS NULL
--------------------------------------------------------

AMAÇ:
Hiç sipariş vermemiş müşterileri bulmak.

LEFT JOIN:
Bütün müşterileri getirir.

WHERE s.SiparisId IS NULL:
Eşleşen sipariş kaydı bulunmayan
müşterileri filtreler.

ORDER BY:
Müşteri numarasına göre artan sıralama yapar.

NOT:
IS NULL, değerin NULL olup olmadığını
kontrol etmek için kullanılır.
*/

SELECT 
  m.Ad,
  m.Soyad,
  m.MusteriId
From Musteriler as m
LEFT JOIN Siparisler AS s
 on s.MusteriId=m.MusteriId
 WHERE s.SiparisId is null
 ORDER BY m.MusteriId;


/*
--------------------------------------------------------
9. LEFT JOIN + COUNT + GROUP BY
--------------------------------------------------------

AMAÇ:
Bütün müşterilerin sipariş sayısını bulmak.

LEFT JOIN:
Sipariş vermeyen müşterileri de getirir.

COUNT(s.SiparisId):
Her müşterinin sipariş sayısını hesaplar.

GROUP BY:
Kayıtları müşterilere göre gruplar.

ÖNEMLİ:
COUNT(s.SiparisId), NULL değerleri saymaz.

Bu nedenle hiç sipariş vermeyen müşterilerin
sipariş sayısı 0 olarak görünür.

COUNT(*) kullanılsaydı eşleşmeyen müşterinin
LEFT JOIN sonucundaki satırı da sayılırdı.
*/

/* SENARYO: Sistemdeki bütün müşterileri listele.
 Her müşterinin kaç sipariş verdiğini göster. Hiç sipariş vermeyen müşterilerin sipariş sayısı da 0 olarak görünsün. */

 SELECT 
   m.Ad,
   m.Soyad,
   COUNT(s.SiparisId) as ToplamSiparisler
FROM Musteriler as m
LEFT JOIN Siparisler as s
  on m.MusteriId=s.MusteriId
GROUP BY m.MusteriId,m.Ad,m.Soyad;


/*
--------------------------------------------------------
10. LEFT JOIN + HAVING COUNT() = 0
--------------------------------------------------------

AMAÇ:
Hiç sipariş vermeyen müşterileri bulmak
ve sipariş sayılarını 0 olarak göstermek.

LEFT JOIN:
Bütün müşterileri getirir.

GROUP BY:
Kayıtları müşterilere göre gruplar.

HAVING COUNT(s.SiparisId)=0:
Sipariş sayısı sıfır olan müşterileri seçer.

ÖNEMLİ FARK:
WHERE s.SiparisId IS NULL:
Satır düzeyinde filtreleme yapar.

HAVING COUNT(s.SiparisId)=0:
Gruplandırma sonrasında filtreleme yapar.
*/

/* SENARYO: Hiç sipariş vermemiş müşterilerin adını, soyadını ve sipariş sayısını listele. */
SELECT
   m.Ad,
   m.Soyad,
   COUNT(s.SiparisId) as SiparisSayisi
 FROM Musteriler AS m
 LEFT JOIN Siparisler AS s
  on m.MusteriId=s.MusteriId
GROUP BY m.Ad,m.MusteriId, M.Soyad
HAVING COUNT(s.SiparisId)=0;


/*
========================================================
11. RIGHT JOIN
========================================================

RIGHT JOIN:
Sağ tarafta bulunan tablonun bütün
kayıtlarını getirir.

Eşleşen sol tablo kayıtlarını da gösterir.

Eşleşmeyen sol tablo sütunları NULL olur.

Bu örnekte sağdaki tablo Musteriler olduğu
için bütün müşteriler listelenir.

NOT:
Tabloların sırası değiştirilerek LEFT JOIN
ile aynı sonuç elde edilebilir.
*/

---------------------------- RIGHT JOIN
SELECT
  m.Ad,
  s.SiparisId
FROM Siparisler AS s
RIGHT JOIN Musteriler AS m
 on m.MusteriId=s.MusteriId;


/*
--------------------------------------------------------
12. RIGHT JOIN İLE MÜŞTERİ RAPORU
--------------------------------------------------------

AMAÇ:
Sistemdeki bütün müşterileri listelemek.

RIGHT JOIN:
Sağdaki Musteriler tablosunun bütün
kayıtlarını getirir.

Siparişi olan müşterilerin tutarları görünür.

Siparişi olmayan müşterilerin
Tutar alanı NULL olarak görünür.

ORDER BY:
Müşteri numarasına göre sıralama yapar.
*/

/* SENARYO: Sistemde kayıtlı bütün müşterilerin adını, soyadını ve varsa sipariş tutarlarını listele. 
 Hiç sipariş vermemiş müşteriler de raporda bulunsun. */

 SELECT
  m.Ad,
  m.Soyad,
  s.Tutar
FROM Siparisler AS s
RIGHT JOIN Musteriler AS m
  on s.MusteriId=m.MusteriId
ORDER BY m.MusteriId;


/*
========================================================
13. JOIN TÜRLERİNİN KARŞILAŞTIRILMASI
========================================================

INNER JOIN:
Yalnızca iki tabloda eşleşen kayıtlar.

LEFT JOIN:
Soldaki tablonun bütün kayıtları.

RIGHT JOIN:
Sağdaki tablonun bütün kayıtları.

FULL OUTER JOIN:
Her iki tablonun bütün kayıtları.

Eşleşmeyen alanlar NULL olarak görünür.
*/

/* 
INNER JOIN → Yalnızca eşleşen kayıtlar.
LEFT JOIN → Soldaki tablonun bütün kayıtları.
RIGHT JOIN → Sağdaki tablonun bütün kayıtları.
FULL OUTER JOIN → Her iki tablonun bütün kayıtları.
*/


/*
--------------------------------------------------------
14. FULL OUTER JOIN UYGULAMASI
--------------------------------------------------------

FULL OUTER JOIN:
Musteriler ve Siparisler tablolarındaki
bütün kayıtları getirir.

Eşleşen müşteri ve siparişleri birleştirir.

Siparişi olmayan müşterileri de gösterir.

Müşteri kaydıyla eşleşmeyen siparişleri
de gösterir.

ORDER BY:
Müşteri numarasına göre sıralama yapar.

NOT:
FULL OUTER JOIN, iki tablodaki eşleşmeyen
kayıtları incelemek için kullanılabilir.
*/

SELECT
  m.Ad,
  s.SiparisId
FROM Musteriler as m
FULL OUTER JOIN Siparisler AS s
 on m.MusteriId=s.MusteriId
ORDER BY m.MusteriId;


/*
--------------------------------------------------------
15. FULL OUTER JOIN İLE DETAYLI RAPOR
--------------------------------------------------------

AMAÇ:
Bütün müşteri ve sipariş kayıtlarını
bir arada görüntülemek.

MusteriId:
Müşterinin benzersiz numarası.

Ad, Soyad:
Müşterinin kimlik bilgileri.

SiparisId:
Siparişin benzersiz numarası.

Tutar:
Siparişin parasal değeri.

FULL OUTER JOIN:
Eşleşen ve eşleşmeyen kayıtları getirir.

ORDER BY M.Ad:
Sonuçları müşteri adına göre sıralar.

NOT:
Sipariş kaydı bulunmayan müşterilerin
sipariş alanları NULL olur.

Müşteriyle eşleşmeyen siparişlerin
müşteri alanları NULL olur.
*/

SELECT
  M.MusteriId,
  m.Ad,
  m.Soyad,
  s.SiparisId,
  s.Tutar
FROM Musteriler AS m
FULL OUTER JOIN Siparisler AS S
 ON m.MusteriId=S.MusteriId
ORDER BY M.Ad;


/*
========================================================
DERS SONU ÖZETİ
========================================================

BU ÇALIŞMADA:

- INNER JOIN ile eşleşen kayıtlar getirildi.
- LEFT JOIN ile bütün müşteriler listelendi.
- RIGHT JOIN ile sağ tablodaki kayıtlar korundu.
- FULL OUTER JOIN ile iki tablodaki bütün
  kayıtlar görüntülendi.
- WHERE ile satırlar filtrelendi.
- GROUP BY ile müşteri bazlı gruplama yapıldı.
- HAVING ile gruplar filtrelendi.
- COUNT ile sipariş sayıları hesaplandı.
- SUM ile toplam harcamalar bulundu.
- MIN ve MAX ile ilk ve son sipariş
  tarihleri belirlendi.
- IS NULL ile sipariş vermeyen müşteriler bulundu.
- ORDER BY ile sonuçlar sıralandı.

ÖĞRENİLEN TEMEL FARKLAR:

WHERE:
Satırları filtreler.

GROUP BY:
Kayıtları gruplandırır.

HAVING:
Gruplandırılmış sonuçları filtreler.

ON:
JOIN işlemindeki eşleşme koşulunu belirtir.

COUNT(*):
Sonuçtaki satırları sayar.

COUNT(SiparisId):
NULL olmayan SiparisId değerlerini sayar.

=
*/

-- ============================================================
-- 6. ROW_NUMBER(), RANK() VE DENSE_RANK() KARÞILAÞTIRMASI
-- ============================================================

/*
ROW_NUMBER(): Her satýra benzersiz bir sýra numarasý verir.

RANK(): Eþit deðerlere ayný dereceyi verir.
Eþitlik sonrasýnda sýra numaralarýnda boþluk oluþur.

DENSE_RANK(): Eþit deðerlere ayný dereceyi verir.
Ancak sýra numaralarýnda boþluk oluþmaz.

Bu uygulamada satýþ tutarlarý büyükten küçüðe sýralanarak
üç fonksiyonun sonuçlarý karþýlaþtýrýlmýþtýr.
*/

;WITH Satislar AS (
    SELECT N'Ali' AS Ad, 6000 AS Tutar
    UNION ALL
    SELECT N'Ayþe', 6000
    UNION ALL
    SELECT N'Mehmet', 4000
    UNION ALL
    SELECT N'Zeynep', 3000
    UNION ALL
    SELECT N'Elif', 3000
)
SELECT
    Ad,
    Tutar,
    ROW_NUMBER() OVER(ORDER BY Tutar DESC) AS SiraNo,
    RANK() OVER(ORDER BY Tutar DESC) AS Derece,
    DENSE_RANK() OVER(ORDER BY Tutar DESC) AS KesintisizDerece
FROM Satislar
ORDER BY SiraNo;


-- ============================================================
-- 7. RUNNING TOTAL (KÜMÜLATÝF TOPLAM)
-- ============================================================

/*
Running Total, kayýtlarýn belirli bir sýralama düzenine göre
birikimli toplamýnýn hesaplanmasýný saðlar.

GROUP BY kullanýmýndan farklý olarak mevcut satýrlar korunur.

Bu uygulamada sipariþ tutarlarý büyükten küçüðe sýralanarak
kümülatif toplam hesaplanmýþtýr.

Kullaným alanlarý:
- Satýþ raporlarý
- Finansal analizler
- Gelir ve gider takibi
- Birikimli sipariþ tutarlarýnýn hesaplanmasý
*/

SELECT
    SiparisId,
    MusteriId,
    Tutar,
    SUM(Tutar) OVER(
        ORDER BY Tutar DESC
    ) AS KumulatifToplam
FROM Siparisler
ORDER BY Tutar DESC;


-- ============================================================
-- 8. ROWS BETWEEN (PENCERE ÇERÇEVESÝ)
-- ============================================================

/*
ROWS BETWEEN, hesaplama yapýlýrken hangi satýrlarýn
dikkate alýnacaðýný belirlememizi saðlar.

UNBOUNDED PRECEDING:
Sýralama düzenindeki ilk satýrdan baþlar.

CURRENT ROW:
Mevcut satýrý ifade eder.

ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW:
Ýlk satýrdan mevcut satýra kadar olan kayýtlarý
hesaplamaya dahil eder.
*/


-- ------------------------------------------------------------
-- 8.1. Tarih Aralýðýna Göre Kümülatif Satýþ Toplamý
-- ------------------------------------------------------------

/*
Ýþ gereksinimi:
2026 yýlýnýn aðustos ayýnda gerçekleþen satýþlarýn
tarih bazýnda kümülatif toplamýný hesaplamak.

CAST(): Tarih deðerini DATE veri tipine dönüþtürür.

UNION ALL: Örnek satýþ kayýtlarýný birleþtirir.

WHERE BETWEEN: Belirtilen tarih aralýðýndaki kayýtlarý filtreler.

ORDER BY Tarih ASC: Satýþlarý eskiden yeniye doðru sýralar.

WHERE koþulu pencere fonksiyonundan önce uygulandýðý için
yalnýzca aðustos ayýndaki satýþlar hesaplamaya dahil edilir.
*/

;WITH Satislar AS (
    SELECT N'Ali' AS Ad,
           6000 AS Tutar,
           CAST('2026-08-11' AS DATE) AS Tarih
    UNION ALL
    SELECT N'Ayþe', 6000, '2026-08-06'
    UNION ALL
    SELECT N'Mehmet', 4000, '2026-07-21'
    UNION ALL
    SELECT N'Zeynep', 3000, '2026-08-13'
    UNION ALL
    SELECT N'Elif', 3000, '2026-07-12'
)
SELECT
    Ad,
    Tutar,
    Tarih,
    SUM(Tutar) OVER(
        ORDER BY Tarih ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS KumulatifToplam
FROM Satislar
WHERE Tarih BETWEEN '2026-08-01' AND '2026-08-31'
ORDER BY Tarih ASC;




-- ============================================================
-- 9. ROWS VE RANGE KARÞILAÞTIRMASI
-- ============================================================

/*
ROWS (Satýrlar):
Kayýtlarý sýralama düzenindeki konumlarýna göre
tek tek hesaplamaya dahil eder.

RANGE (Deðer Aralýðý):
Sýralama kriterinde ayný deðere sahip kayýtlarý
birlikte hesaplamaya dahil eder.

Bu uygulamada kullanýlan pencere çerçevesinde:

ROWS:
Ýlk satýrdan mevcut satýra kadar hesaplama yapar.

RANGE:
Önceki sýralama deðerlerini ve mevcut satýrla ayný
sýralama deðerine sahip bütün kayýtlarý hesaplamaya
dahil eder.

ROWS hesaplamasýnda SatisId kullanýlarak ayný tarihli
kayýtlarýn kendi aralarýndaki sýrasý belirlenmiþtir.

RANGE hesaplamasýnda yalnýzca Tarih kullanýlarak
ayný tarihteki satýþlarýn birlikte hesaplanmasý saðlanmýþtýr.
*/

;WITH Satislar AS (
    SELECT 1 AS SatisId,
           N'Ali' AS Ad,
           500 AS Tutar,
           CAST('2026-08-01' AS DATE) AS Tarih
    UNION ALL
    SELECT 2, N'Ayþe', 1500, '2026-08-01'
    UNION ALL
    SELECT 3, N'Mehmet', 3000, '2026-08-02'
    UNION ALL
    SELECT 4, N'Zeynep', 4000, '2026-08-03'
)
SELECT
    SatisId,
    Ad,
    Tutar,
    Tarih,

    SUM(Tutar) OVER(
        ORDER BY Tarih ASC, SatisId ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RowsToplam,

    SUM(Tutar) OVER(
        ORDER BY Tarih ASC
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RangeToplam

FROM Satislar
ORDER BY Tarih ASC, SatisId ASC;

/*


ROWS:
Her iþlem sonrasýndaki birikimli bakiyenin hesaplanmasý.

RANGE:
Her kayýtta ilgili günün sonuna kadarki birikimli
satýþ tutarýnýn hesaplanmasý.
*/
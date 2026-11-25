
/*
========================================================
    SQL SERVER ÇALIÞMALARIM
    11 - WINDOW FUNCTIONS (Pencere Fonksiyonlarý)
========================================================

    Veritabaný: OkulDB

    Konular:
    1. Window Functions
    2. OVER()
    3. PARTITION BY
    4. ROW_NUMBER()
    5. RANK()
    6. DENSE_RANK() (Uygulama aþamasýnda)

    Amaç:
    Satýrlarý kaybetmeden hesaplama yapmak, müþteri
    bazýnda verileri analiz etmek ve sýralama iþlemleri
    gerçekleþtirmek.
========================================================
*/

USE OkulDB;
GO


-- =====================================================
-- 1. WINDOW FUNCTIONS (PENCERE FONKSÝYONLARI)
-- =====================================================

/*
Window Functions, satýrlarý birleþtirmeden veya azaltmadan
belirli satýr gruplarý üzerinde hesaplama yapmamýzý saðlar.

GROUP BY ile yapýlan gruplama satýr sayýsýný azaltabilir.
Window Functions ise mevcut satýrlarý korur.

Kullaným alanlarý:
- Satýþ ve müþteri analizleri
- Performans raporlarý
- Sýralama ve derecelendirme
- Toplam ve ortalama hesaplamalarý
*/


-- =====================================================
-- 2. OVER()
-- =====================================================

/*
OVER() ifadesi, bir fonksiyonun hangi satýrlar üzerinde
hesaplama yapacaðýný belirlememizi saðlar.

OVER() içerisi boþ býrakýldýðýnda bu örneklerde hesaplama,
sorgunun tüm sonuç satýrlarý üzerinde gerçekleþtirilir.
*/


-- 2.1. Tüm sipariþlerin toplam tutarýný hesaplama

SELECT
    SiparisId,
    MusteriId,
    Tutar,
    SUM(Tutar) OVER() AS ToplamTutar
FROM Siparisler;


-- 2.2. Window Functions ile istatistiksel hesaplamalar
-- Her sipariþ satýrýnda genel istatistikleri gösterir.

SELECT
    SiparisId,
    MusteriId,
    Tutar,
    SUM(Tutar) OVER() AS ToplamTutar,
    AVG(Tutar) OVER() AS OrtalamaTutar,
    MAX(Tutar) OVER() AS EnYuksekTutar,
    MIN(Tutar) OVER() AS EnKucukTutar,
    COUNT(*) OVER() AS SiparisSayisi
FROM Siparisler;


/*
SUM   : Toplam tutarý hesaplar.
AVG   : Ortalama tutarý hesaplar.
MAX   : En yüksek tutarý bulur.
MIN   : En düþük tutarý bulur.
COUNT : Sipariþ satýrlarýnýn sayýsýný hesaplar.

Bu iþlemler gerçekleþtirilirken sipariþ satýrlarý korunur.
*/


-- =====================================================
-- 3. PARTITION BY (BÖLÜMLERE AYIRMA)
-- =====================================================

/*
PARTITION BY, Türkçede bölümlere ayýrma anlamýna gelir.

Window Functions içerisinde verileri belirli bir sütuna
göre bölümlere ayýrarak her bölüm için ayrý hesaplama
yapmamýzý saðlar.

GROUP BY iþleminden farklý olarak mevcut satýrlarý korur.
*/


-- 3.1. Müþteri bazýnda sipariþ istatistiklerini hesaplama

SELECT
    SiparisId,
    MusteriId,
    Tutar,
    SUM(Tutar) OVER(PARTITION BY MusteriId)
        AS MusteriToplamTutar,
    AVG(Tutar) OVER(PARTITION BY MusteriId)
        AS MusteriOrtalamaTutar,
    MAX(Tutar) OVER(PARTITION BY MusteriId)
        AS MusteriEnYuksekTutar,
    MIN(Tutar) OVER(PARTITION BY MusteriId)
        AS MusteriEnDusukTutar,
    COUNT(*) OVER(PARTITION BY MusteriId)
        AS MusteriSiparisSayisi
FROM Siparisler;


/*
Ýþ gereksinimi:

Her müþterinin toplam harcamasýný, ortalama sipariþ
tutarýný, en yüksek ve en düþük sipariþ tutarýný ve
toplam sipariþ sayýsýný raporlamak.

Her müþterinin sipariþleri kendi içerisinde deðerlendirilir.
*/


-- =====================================================
-- 4. ROW_NUMBER() (SATIR NUMARALANDIRMA)
-- =====================================================

/*
ROW_NUMBER(), satýrlara belirli bir sýralama kriterine
göre birbirinden farklý sýra numaralarý verir.

Eþit deðerlere sahip satýrlar olsa bile her satýr,
kendi bölümü içerisinde farklý bir sýra numarasý alýr.

ASC  : Ascending  - Artan sýralama (küçükten büyüðe).
DESC : Descending - Azalan sýralama (büyükten küçüðe).
*/


-- 4.1. Sipariþleri tutarlarýna göre numaralandýrma
-- En yüksek tutarlý sipariþ 1 numarasýný alýr.

SELECT
    SiparisId,
    MusteriId,
    Tutar,
    ROW_NUMBER() OVER(ORDER BY Tutar DESC) AS SiraNo
FROM Siparisler
ORDER BY SiraNo;


-- 4.2. ROW_NUMBER() ve PARTITION BY kullanýmý
-- Her müþterinin sipariþlerini kendi içerisinde
-- küçükten büyüðe doðru numaralandýrma.

SELECT
    SiparisId,
    MusteriId,
    Tutar,
    ROW_NUMBER() OVER(
        PARTITION BY MusteriId
        ORDER BY Tutar ASC
    ) AS MusteriSiparisSirasi
FROM Siparisler
ORDER BY MusteriId, MusteriSiparisSirasi;


/*
PARTITION BY MusteriId:
Her müþterinin sipariþlerini ayrý bir bölüm olarak
deðerlendirir.

ORDER BY Tutar ASC:
Her müþterinin sipariþlerini küçükten büyüðe sýralar.

ROW_NUMBER():
Her müþteri için numaralandýrmayý yeniden 1'den baþlatýr.

NOT:
OVER() içerisindeki ORDER BY, hesaplama sýrasýný belirler.
Sorgunun sonundaki ORDER BY, sonuçlarýn gösterim sýrasýný
belirler.

Eþit tutarlý kayýtlarýn kendi aralarýndaki sýra, ek bir
sýralama kriteri belirtilmediðinde garanti edilmez.
*/


-- =====================================================
-- 5. RANK() (DERECELENDÝRME)
-- =====================================================

/*
ROW_NUMBER() kullanýrsak her çalýþana farklý bir sýra
numarasý verir.

RANK() kullanýrsak eþit satýþ tutarýna sahip çalýþanlara
ayný dereceyi verir.

Ancak eþitlik sonrasýnda derece atlanýr.

Örnek:

Satýþ Tutarý    ROW_NUMBER()    RANK()
6000                 1            1
6000                 2            1
4000                 3            3
3000                 4            4
3000                 5            4
*/


-- 5.1. CTE ile örnek satýþ verilerinin hazýrlanmasý
-- Mevcut veritabanýndaki kayýtlar deðiþtirilmeden
-- örnek bir sonuç kümesi oluþturulur.

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

-- 5.2. ROW_NUMBER() ve RANK() karþýlaþtýrmasý

SELECT
    Ad,
    Tutar,
    ROW_NUMBER() OVER(ORDER BY Tutar DESC) AS SiraNo,
    RANK() OVER(ORDER BY Tutar ASC) AS ArtanDerece,
    RANK() OVER(ORDER BY Tutar DESC) AS AzalanDerece
FROM Satislar
ORDER BY SiraNo;


/*
SiraNo:
Her çalýþana büyükten küçüðe farklý bir sýra numarasý verir.

ArtanDerece:
En düþük satýþ tutarýndan baþlayarak derecelendirme yapar.

AzalanDerece:
En yüksek satýþ tutarýndan baþlayarak derecelendirme yapar.

Eþit satýþ tutarýna sahip çalýþanlar ayný dereceyi alýr.
*/


-- =====================================================
-- 6. DENSE_RANK() (KESÝNTÝSÝZ DERECELENDÝRME)
-- =====================================================

/*
DENSE_RANK(), eþit deðerlere ayný dereceyi veren ancak
eþitlik sonrasýnda sýra numarasý atlamayan bir Window
Function'dýr.

ROW_NUMBER() : 1, 2, 3, 4, 5
RANK()       : 1, 1, 3, 4, 4
DENSE_RANK() : 1, 1, 2, 3, 3

RANK() ve DENSE_RANK() arasýndaki temel fark,
eþitlik sonrasýnda derece atlanýp atlanmamasýdýr.
*/


-- 6.1. ROW_NUMBER(), RANK() ve DENSE_RANK() karþýlaþtýrmasý





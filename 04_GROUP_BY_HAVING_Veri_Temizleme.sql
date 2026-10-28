
-- ============================================================
-- SQL DERS 3: GROUP BY, HAVING VE VERI TEMIZLEME
-- ============================================================

-- ============================================================
-- 1. TUM OGRENCILERI LISTELEME
-- ============================================================

-- SELECT *
-- FROM dbo.Ogrenciler
-- ORDER BY Id;


-- ============================================================
-- 2. TRIM() - METINLERDEKI BOSLUKLARI TEMIZLEME
-- ============================================================

-- TRIM(), metnin basindaki ve sonundaki bosluklari temizler.
-- SELECT ile kullanildiginda veritabanindaki kayitlar degismez.
-- Yalnizca sorgu sonucunda temizlenmis metin goruntulenir.

-- SELECT
--     Id,
--     Ad,
--     Bolum,
--     TRIM(Bolum) AS TemizBolum
-- FROM dbo.Ogrenciler;


-- ============================================================
-- 3. UPDATE - VERILERI KALICI OLARAK GUNCELLEME
-- ============================================================

-- UPDATE: Tablodaki mevcut kayitlari degistirir.
-- SET: Hangi sutunun hangi degerle guncellenecegini belirtir.
-- WHERE: Yalnizca kosula uyan kayitlari gunceller.
--
-- Bu sorgu Bolum sutunundaki gereksiz bosluklari
-- veritabaninda kalici olarak temizler.
--
-- DIKKAT:
-- UPDATE komutunu calistirmadan once WHERE kosulunu kontrol et.

-- UPDATE dbo.Ogrenciler
-- SET Bolum = TRIM(Bolum)
-- WHERE Bolum <> TRIM(Bolum);


-- ============================================================
-- 4. GROUP BY - BOLUMLERE GORE OGRENCI SAYISI
-- ============================================================

-- GROUP BY: Ayni degeri tasiyan kayitlari gruplandirir.
-- COUNT(*): Her gruptaki toplam kayit sayisini hesaplar.
-- AS: Sonuc sutununa isim verir.
--
-- Amac: Her bolumde kac ogrenci oldugunu bulmak.

-- SELECT
--     Bolum,
--     COUNT(*) AS OgrenciSayisi
-- FROM dbo.Ogrenciler
-- GROUP BY Bolum;


-- ============================================================
-- 5. GROUP BY - YASLARA GORE OGRENCI SAYISI
-- ============================================================

-- Ogrencileri yaslarina gore gruplandirir.
-- Her yasta kac ogrenci oldugunu hesaplar.
--
-- Ornek:
-- 23 yasinda 3 ogrenci varsa sonuc 23 | 3 olur.

-- SELECT
--     Yas,
--     COUNT(*) AS OgrenciSayisi
-- FROM dbo.Ogrenciler
-- GROUP BY Yas
-- ORDER BY Yas ASC;


-- ============================================================
-- 6. GROUP BY + AVG() - BOLUMLERIN YAS ORTALAMASI
-- ============================================================

-- AVG(): Sayisal degerlerin ortalamasini hesaplar.
-- GROUP BY Bolum: Ortalamayi her bolum icin ayri hesaplar.
--
-- DIKKAT:
-- Yas sutunu INT veri tipindedir.
-- SQL Server'da AVG(INT) tam sayi sonuc dondurur.
-- Bu nedenle ortalamanin kesirli kismi kaybolabilir.

-- SELECT
--     Bolum,
--     AVG(Yas) AS YasOrtalamasi
-- FROM dbo.Ogrenciler
-- GROUP BY Bolum;


-- ============================================================
-- 7. GROUP BY + MAX() - EN BUYUK OGRENCI YASI
-- ============================================================

-- MAX(): En buyuk degeri bulur.
-- GROUP BY ile kullanildiginda her bolumun
-- en buyuk ogrenci yasini ayri ayri hesaplar.

-- SELECT
--     Bolum,
--     MAX(Yas) AS EnBuyukYas
-- FROM dbo.Ogrenciler
-- GROUP BY Bolum;


-- ============================================================
-- 8. GROUP BY + AVG() + CAST() - ONDALIKLI ORTALAMA
-- ============================================================

-- CAST(): Bir degeri farkli veri tipine donusturur.
-- DECIMAL(10,2): Toplam 10 basamakli, ondalik kismi
-- 2 basamakli sayisal veri tipidir.
--
-- CAST islemini AVG fonksiyonunun icinde kullaniyoruz.
-- Boylece yaslar once ondalikli tipe donusturulur.
-- Ardindan her bolumun yas ortalamasi hesaplanir.
--
-- Ornek: BST bolumunun yas ortalamasi 24.25 olur.

-- SELECT
--     Bolum,
--     AVG(CAST(Yas AS DECIMAL(10,2))) AS YasOrtalamasi
-- FROM dbo.Ogrenciler
-- GROUP BY Bolum;


-- ============================================================
-- 9. HAVING - DORTTEN FAZLA OGRENCISI OLAN BOLUMLER
-- ============================================================

-- HAVING: GROUP BY ile olusturulan gruplari filtreler.
-- COUNT(*) > 4: Ogrenci sayisi 4'ten fazla olan bolumler.
--
-- NOT:
-- Mevcut verilerimizde her bolumde 4 ogrenci var.
-- Bu nedenle sorgu sonucunda kayit gelmez.
-- Bu durum SQL hatasi degildir.

-- SELECT
--     Bolum,
--     COUNT(*) AS OgrenciSayisi
-- FROM dbo.Ogrenciler
-- GROUP BY Bolum
-- HAVING COUNT(*) > 4;


-- ============================================================
-- 10. WHERE + GROUP BY + HAVING
-- ============================================================

-- WHERE: Gruplandirmadan once kayitlari filtreler.
-- GROUP BY: Filtrelenen kayitlari gruplandirir.
-- HAVING: Olusturulan gruplari filtreler.
--
-- Senaryo:
-- 20 yasindan buyuk ogrencileri sec.
-- Ogrencileri bolumlerine gore grupla.
-- 2'den fazla ogrencisi olan bolumleri listele.

-- SELECT
--     Bolum,
--     COUNT(*) AS OgrenciSayisi
-- FROM dbo.Ogrenciler
-- WHERE Yas > 20
-- GROUP BY Bolum
-- HAVING COUNT(*) > 2;


-- ============================================================
-- 11. BAGIMSIZ UYGULAMA - SQL MINI SINAVI
-- ============================================================

-- Senaryo:
-- 20 yas ve uzerindeki ogrencileri sec.
-- Bolumlerine gore grupla.
-- En az 3 ogrencisi olan bolumleri listele.
--
-- Bu sorgu mini sinavda bagimsiz olarak yazildi.

-- SELECT
--     Bolum,
--     COUNT(*) AS OgrenciSayisi
-- FROM dbo.Ogrenciler
-- WHERE Yas >= 20
-- GROUP BY Bolum
-- HAVING COUNT(*) >= 3;


-- ============================================================
-- DERS OZETI
-- ============================================================

-- 1. TRIM(): Metinlerin basindaki ve sonundaki bosluklari siler.
-- 2. UPDATE: Mevcut kayitlari kalici olarak gunceller.
-- 3. GROUP BY: Ayni degerlere sahip kayitlari gruplandirir.
-- 4. HAVING: Gruplandirilmis verileri kosula gore filtreler.
-- 5. WHERE: Gruplandirma oncesinde satirlari filtreler.
--
-- COUNT(): Kayit sayisini hesaplar.
-- AVG(): Ortalama hesaplar.
-- MAX(): En buyuk degeri bulur.
-- CAST(): Veri tipi donusumu yapar.
--
-- WHERE ve HAVING arasindaki temel fark:
-- WHERE  -> Satirlari filtreler.
-- HAVING -> Gruplari filtreler.


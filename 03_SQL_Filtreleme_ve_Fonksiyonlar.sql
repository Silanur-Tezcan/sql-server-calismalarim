
-- ============================================================
-- SQL SERVER DERS 2
-- KONU: FILTRELEME, SIRALAMA VE TOPLAMA FONKSIYONLARI
-- VERITABANI: OkulDB
-- TABLO: dbo.Ogrenciler
-- ============================================================


-- ============================================================
-- 1. TOP KOMUTU
-- ============================================================
-- TOP: Belirtilen sayida kayit getirir.
-- ORDER BY: Verileri siralar.
-- DESC: Buyukten kucuge siralama yapar.
-- TOP 2: Siralanan sonuctan ilk 2 kaydi getirir.
-- AMAC: Yasi en buyuk 2 ogrenciyi listelemek.

USE OkulDB;
SELECT TOP 2 *
from dbo.Ogrenciler
order by Yas desc;


-- TOP 1: Yalnizca bir kayit getirir.
-- ASC: Kucukten buyuge siralama yapar.
-- AMAC: Yasi en kucuk ogrenciyi bulmak.

select top 1 Ad,Soyad,Yas 
from dbo.Ogrenciler
order by Yas asc;


-- ============================================================
-- 2. DISTINCT KOMUTU
-- ============================================================
-- DISTINCT: Tekrar eden sonuclari kaldirir.
-- Her farkli degeri yalnizca bir kez gosterir.
-- Tablodaki gercek kayitlari silmez.
-- AMAC: Okulda bulunan farkli bolumleri listelemek.

select DISTINCT Bolum
from dbo.Ogrenciler;


-- ============================================================
-- 3. LIKE KOMUTU
-- ============================================================
-- LIKE: Metinlerde belirli bir desene gore arama yapar.
-- % : Sifir veya daha fazla karakteri temsil eder.
-- 'A%'  : A ile baslayan isimler.
-- '%a'  : a ile biten isimler.
-- '%an%': Icerisinde an gecen isimler.
-- AMAC: Isminde an bulunan ogrencileri bulmak.

select *
from dbo.Ogrenciler
where Ad like '%an%';


-- _ : Tam olarak bir karakteri temsil eder.
-- 'a_i': a ile baslayan, i ile biten 3 karakterli isimler.
-- ORNEK: Ali.
-- NOT: Buyuk/kucuk harf duyarliligi collation ayarina baglidir.

select Ad,Soyad
from dbo.Ogrenciler
where Ad like 'a_i'


-- ============================================================
-- 4. IN OPERATORU
-- ============================================================
-- IN: Bir sutundaki degerin belirtilen seceneklerden
-- herhangi biriyle eslesip eslesmedigini kontrol eder.
-- IN(18,23): Yasi 18 veya 23 olanlari getirir.
-- OR operatorune alternatif olarak kullanilabilir.

select Ad,Soyad,Yas
from dbo.Ogrenciler
where Yas IN(18,23);


-- IN metinsel degerlerle de kullanilabilir.
-- Metinsel degerler tek tirnak icinde yazilir.
-- AMAC: BST veya Muhasebe bolumundeki ogrencileri bulmak.

select Ad,Soyad,Yas, Bolum
from dbo.Ogrenciler
where Bolum IN('BST','Muhasebe');


-- ============================================================
-- 5. BETWEEN OPERATORU
-- ============================================================
-- BETWEEN: Belirli iki deger arasindaki kayitlari getirir.
-- Baslangic ve bitis degerleri de dahildir.
-- BETWEEN 18 AND 20: 18, 19 ve 20 yaslarini kapsar.
-- AMAC: Belirli yas araligindaki ogrencileri listelemek.

select Ad,Yas
from dbo.Ogrenciler
where Yas BETWEEN 18 and 20;


-- LIKE ile bir ismin baslangic ve bitis harfi aranabilir.
-- 'A%i': A ile baslayan ve i ile biten isimleri getirir.
-- N: Unicode metin sabiti kullanilmasini saglar.
-- AMAC: Ali gibi isimleri bulmak.
-- NOT: BETWEEN metinlerde alfabetik karsilastirma yapar;
-- ilk ve son harfi ayri ayri kontrol etmez.

SELECT Ad, Soyad, Yas
FROM dbo.Ogrenciler
WHERE Ad LIKE N'A%i';


-- ============================================================
-- 6. IS NULL VE IS NOT NULL
-- ============================================================
-- NULL: Degerin bulunmamasi veya bilinmemesidir.
-- IS NULL: NULL olan kayitlari getirir.
-- AMAC: Bolum bilgisi bulunmayan ogrencileri listelemek.
-- SONUC: 0 satir.
-- NOT: NULL ile bos metin ('') ayni degildir.

select *
from dbo.Ogrenciler
where Bolum IS NULL;


-- IS NOT NULL: NULL olmayan degerleri getirir.
-- AMAC: Bolum bilgisi bulunan ogrencileri listelemek.
-- SONUC: 3 ogrenci.

select Ad,Soyad,Bolum
from dbo.Ogrenciler
where Bolum IS NOT NULL;


-- ============================================================
-- 7. COUNT() FONKSIYONU
-- ============================================================
-- COUNT(*): Tablodaki tum satirlari sayar.
-- NULL iceren satirlar da sayilir.
-- AS: Sonuc sutununa gecici isim verir.
-- AMAC: Toplam ogrenci sayisini bulmak.
-- SONUC: 3.

SELECT COUNT(*) as ToplamOgrenci
FROM dbo.Ogrenciler;


-- COUNT(Ad): Ad sutunundaki NULL olmayan degerleri sayar.
-- COUNT(*) ile COUNT(Ad) her zaman ayni sonucu vermeyebilir.
-- AMAC: Ad bilgisi NULL olmayan kayitlari saymak.
-- SONUC: 3.

select count(Ad) as ToplamOgrenciIsimleri
from dbo.Ogrenciler;


-- COUNT() + WHERE
-- WHERE: Belirli kosulu saglayan kayitlari filtreler.
-- COUNT(*): Filtrelenen kayitlari sayar.
-- AMAC: YBS bolumundeki ogrenci sayisini bulmak.
-- SONUC: 1.

select count(*) as YBSOgrenciSayisi
from dbo.Ogrenciler
where Bolum='Yönetim Bilişim Sistemleri';


--Ogrenciler tablosunda yaşı 20 ve üzeri olan kaç öğrenci bulunduğunu hesapla.
-- >= : Buyuk veya esit anlamina gelir.
-- Yas >=20: 20 yasini da dahil eder.
-- SONUC: 2.

select count(*) as YirmiYasveUzeri
from dbo.Ogrenciler
where Yas >=20;


-- Senaryo: Okul yönetimi senden "Muhasebe bölümünde 20 yaşından küçük kaç öğrenci var?" bilgisini istiyor.
-- AND: Iki kosulun birlikte saglanmasini ister.
-- DIKKAT: Burada Yas<=20 yazilmis.
-- <= operatoru 20 yasini da dahil eder.
-- Senaryoya uygun kosul Yas<20 olmalidir.
-- ORIJINAL KOD DEGISTIRILMEDI.
-- MEVCUT SONUC: 1.

select count(*) as YirmiYaşMuhasebe
from dbo.Ogrenciler
where Yas<=20 and Bolum='Muhasebe';


-- ============================================================
-- 8. SUM() FONKSIYONU
-- ============================================================
-- SUM(): Sayisal degerlerin toplamini hesaplar.
-- COUNT(): Kayit sayisini bulur.
-- SUM(): Degerlerin toplamini bulur.
-- NULL degerleri toplama dahil etmez.
-- AMAC: Ogrencilerin yaslari toplamini hesaplamak.
-- SONUC: 20 + 23 + 18 = 61.

select sum(Yas) as YaslarToplami
from dbo.Ogrenciler;


--Senaryo: Okul yönetimi, yalnızca 20 yaş ve üzerindeki öğrencilerin yaşları toplamını öğrenmek istiyor.
-- SUM() ve WHERE birlikte kullanildi.
-- Yas >=20: 20 yas ve uzerindeki ogrencileri filtreler.
-- SUM(Yas): Bu ogrencilerin yaslarini toplar.
-- SONUC: 20 + 23 = 43.

select sum(Yas) as YaslarToplami
from dbo.Ogrenciler
where Yas >=20;


-- ============================================================
-- 9. AVG() FONKSIYONU
-- ============================================================
-- AVG(): Sayisal degerlerin aritmetik ortalamasini hesaplar.
-- NULL degerleri ortalama hesabina dahil etmez.
-- AMAC: Ogrencilerin yas ortalamasini bulmak.
-- MATEMATIKSEL SONUC: 61 / 3 = 20,33.
-- Yas INT oldugu icin SQL Server sonucu 20 verir.

select AVG(Yas) as YasOrtalamasi
from dbo.Ogrenciler;


--CAST() → Bir değerin veri tipini dönüştürür.
--Yas AS DECIMAL(10,2) → Yaş değerlerini ondalıklı sayıya dönüştürür.
--AVG(...) → Dönüştürülmüş değerlerin ortalamasını hesaplar.
-- DECIMAL(10,2): Toplam 10 basamak, ondalik kisimda 2 basamak.
-- AVG() DECIMAL degerlerle daha yuksek hassasiyet dondurebilir.
-- AMAC: Yas ortalamasini ondalikli olarak hesaplamak.
-- SONUC: 20,3333.

select AVG(cast(Yas as decimal(10,2))) as OrtalamaYas
from dbo.Ogrenciler;


-- ============================================================
-- 10. MIN() VE MAX() FONKSIYONLARI
-- ============================================================
-- MIN(): En kucuk degeri bulur.
-- MAX(): En buyuk degeri bulur.
-- Iki fonksiyon ayni SELECT sorgusunda kullanilabilir.
-- AMAC: En kucuk ve en buyuk ogrenci yasini bulmak.
-- MIN(Yas) = 18.
-- MAX(Yas) = 23.
-- NOT: Bu fonksiyonlar ogrenci isimlerini degil,
-- yas degerlerini getirir.

select
	MIN(Yas) as EnKucukYas,
	MAX(Yas) as EnBuyukYas
from dbo.Ogrenciler;


-- ============================================================
-- 11. GUN SONU UYGULAMASI
-- ============================================================
-- GOREV: 20 yas ve uzerindeki ogrencilerin
-- ortalama yasini hesaplamak.
-- WHERE Yas>=20: Ilgili ogrencileri filtreler.
-- AVG(Yas): Yaslarinin ortalamasini hesaplar.
-- MATEMATIKSEL SONUC: (20 + 23) / 2 = 21,5.
-- Yas INT oldugu icin sorgu sonucu 21 olur.
-- Ondalikli sonuc icin CAST() kullanilabilir.

select AVG(Yas) as OrtalamaYas
from dbo.Ogrenciler
where Yas>=20;


-- ============================================================
-- DERS SONU OZETI
-- ============================================================
-- TOP         : Belirli sayida kayit getirir.
-- DISTINCT    : Tekrar eden sonuclari kaldirir.
-- LIKE        : Metinlerde desen arar.
-- IN          : Birden fazla degerle eslesme kontrolu yapar.
-- BETWEEN     : Belirli bir araligi filtreler.
-- IS NULL     : NULL olan kayitlari bulur.
-- IS NOT NULL : NULL olmayan kayitlari bulur.
-- COUNT()     : Kayit sayisini hesaplar.
-- SUM()       : Sayisal degerleri toplar.
-- AVG()       : Aritmetik ortalamayi hesaplar.
-- CAST()      : Veri tipini donusturur.
-- MIN()       : En kucuk degeri bulur.
-- MAX()       : En buyuk degeri bulur.


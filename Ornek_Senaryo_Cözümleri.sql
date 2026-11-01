use OkulDB;
/*
SELECT Ad,Soyad,Sehir,ToplamHarcama
from dbo.Musteriler
WHERE ToplamHarcama > 2000 AND Sehir ='Ýstanbul'
ORDER BY ToplamHarcama DESC;
*/
SELECT Sehir , COUNT(*) AS MüsteriSayisi
FROM dbo.Musteriler
GROUP BY Sehir
HAVING COUNT(*)>=2
ORDER BY MüsteriSayisi DESC;

/* SENARYO 3: 25 yaþ ve üzerindeki müþterilerimizi incelemek istiyorum. Bu müþterileri yaþadýklarý þehirlere göre grupla ve her þehrin ortalama harcamasýný hesapla. 
Ancak yalnýzca ortalama harcamasý 3.000 TL'den fazla olan þehirleri göster. Ortalamalarý iki ondalýk basamakla listele */
SELECT *
FROM DBO.Musteriler;

SELECT Sehir , avg( ToplamHarcama ) as OrtalamaToplamHarcama
FROM dbo.Musteriler
where Yas>=25 
GROUP BY Sehir
HAVING AVG(CAST (ToplamHarcama AS DECIMAL(10,2)))>3000
;

/* SENARYO 4: 30 yaþýndan küçük müþterilerimizi analiz etmek istiyorum. Bu müþterileri yaþadýklarý þehirlere göre grupla. 
Her þehirdeki müþterilerin toplam harcamasýný hesapla. Ancak yalnýzca toplam harcamasý 4.000 TL'den fazla olan þehirleri listele.*/
SELECT Sehir, SUM(ToplamHarcama) AS ToplamHarcama
FROM dbo.Musteriler
WHERE Yas<30
GROUP BY Sehir
HAVING SUM(ToplamHarcama)>4000;

/* SENARYO 5: 25 yaþ ve üzerindeki müþterilerimizi incelemek istiyorum. Bu müþterileri yaþadýklarý þehirlere göre grupla. 
Her þehirde kaç müþterimiz olduðunu ve müþteri baþýna ortalama alýþveriþ tutarýný göster. Ancak raporda yalnýzca en az 2 uygun müþterisi bulunan ve ortalama harcamasý 
3.000 TL'den fazla olan þehirler yer alsýn. 
Sonuçlarý ortalama harcamaya göre büyükten küçüðe sýrala. */

SELECT Sehir, AVG(ToplamHarcama) as OrtalamaHarcama, COUNT(*) AS MüsteriSayisi
FROM dbo.Musteriler
WHERE Yas>=25
GROUP BY Sehir
HAVING AVG(ToplamHarcama)>3000 AND COUNT(*)>=2
ORDER BY OrtalamaHarcama DESC;

/* SENARYO 6: Ýstanbul ve Ankara'da yaþayan müþterilerimizin satýþ performansýný karþýlaþtýrmak istiyorum. 
Yalnýzca 2.000 TL ve üzerinde harcama yapan müþterileri deðerlendirmeye al. 
Bu müþterileri þehirlere göre grupla. Her þehirde kaç uygun müþteri olduðunu ve bu müþterilerin toplam harcamasýný göster. 
Ancak yalnýzca toplam harcamasý 5.000 TL'den fazla olan þehirleri listele. Sonuçlarý toplam harcamaya göre büyükten küçüðe sýrala.  */

SELECT Sehir, COUNT(*) AS MusteriSayisi, sum(ToplamHarcama) as SehirToplamHarcama
FROM dbo.Musteriler
WHERE (Sehir='Ýstanbul' or Sehir='Ankara') and ToplamHarcama>=2000 
GROUP BY Sehir
HAVING SUM(ToplamHarcama)>5000
ORDER BY SehirToplamHarcama DESC;

/* SENARYO 7: 25 yaþ ve üzerindeki müþterilerimizi incelemek istiyorum. 
Bu müþterileri yaþlarýna göre grupla. Her yaþta kaç müþteri olduðunu ve ortalama ne kadar harcama yaptýklarýný göster. 
Ancak yalnýzca ortalama harcamasý 3.000 TL'nin üzerinde olan yaþ gruplarýný listele. Sonuçlarý ortalama harcamaya göre büyükten küçüðe sýrala. */

SELECT Yas, COUNT(*) AS MusteriSayisi , AVG(ToplamHarcama) as OrtalamaHarcama
FROM dbo.Musteriler
WHERE Yas>=25 
GROUP BY Yas
HAVING AVG(ToplamHarcama)>3000
ORDER BY OrtalamaHarcama desc;


use OkulDB;
----- JOIN KONUSU
/* CREATE TABLE Siparisler(
   SiparisId INT PRIMARY KEY IDENTITY(1,1),
   MusteriId INT NOT NULL ,
   SiparisTarihi DATE NOT NULL,
   Tutar DECIMAL(10,2) NOT NULL
   
   CONSTRAINT FK_Siparisler_Musteriler
   FOREIGN KEY (MusteriId)
   REFERENCES dbo.Musteriler(MusteriId)
); */

/*  CONSTRAINT FK_Siparisler_Musteriler → Yabancı anahtar kısıtına isim verir.
    FOREIGN KEY (MusteriId) → Siparişler tablosundaki müşteri numarasını ilişki sütunu olarak belirler.
    REFERENCES dbo.Musteriler(MusteriId) → Bu numaranın Musteriler tablosunda bulunmasını zorunlu kılar.
*/
/*INSERT INTO dbo.Siparisler(MusteriId,SiparisTarihi,Tutar)
VALUES(6,'2026-10-25',2000.00);*/

-------------- INNER JOIN

SELECT
  s.SiparisId,
  m.Ad,
  m.Soyad,
  s.SiparisTarihi,
  s.Tutar
FROM dbo.Siparisler AS s
INNER JOIN dbo.Musteriler AS m
  ON s.MusteriId = m.MusteriId;







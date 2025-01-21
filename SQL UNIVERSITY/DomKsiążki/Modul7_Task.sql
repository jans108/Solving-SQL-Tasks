-- S1_1
SELECT NazwiskoTworcy
FROM Tworcy
WHERE RokUrodzenia BETWEEN 1980 AND 1990;

-- S1_2
SELECT TytulKsiazki
FROM Ksiazki
WHERE TytulKsiazki COLLATE Polish_CS_AS LIKE '%[Mb]%';

-- S1_3
SELECT COUNT(IdEgzemplarza) AS liczba_wypozyczonych_egzemplarzy
FROM Wypozyczenia
WHERE DataWypozyczenia BETWEEN '2024-02-01' AND '2024-02-29';

-- S1_4
SELECT IdCzytelnika, IdEgzemplarza, DataWypozyczenia, DATEDIFF(DAY, DataWypozyczenia, GETDATE()) AS liczba_dni_po_terminie
FROM Wypozyczenia
WHERE DataZwrotu IS NULL
ORDER BY liczba_dni_po_terminie DESC;

-- S1_5
SELECT DataUrodzenia AS data, 'data_urodzenia' AS typ_daty
FROM Czytelnicy
WHERE DataUrodzenia IS NOT NULL
UNION ALL
SELECT DataWprowadzenia, 'data_wprowadzenia' AS typ_daty
FROM Czytelnicy
WHERE DataWprowadzenia IS NOT NULL
UNION ALL
SELECT DataWypozyczenia, 'data_wypozyczenia' AS typ_daty
FROM Wypozyczenia
WHERE DataWypozyczenia IS NOT NULL
UNION ALL
SELECT DataZwrotu, 'data_zwrotu' AS typ_daty
FROM Wypozyczenia
WHERE DataZwrotu IS NOT NULL
ORDER BY data;

-- S1-6
SELECT NazwiskoCzytelnika, DataUrodzenia, DataWprowadzenia
FROM Czytelnicy
WHERE Miejscowosc = 'Kraków'
AND (DataWprowadzenia BETWEEN '2021-01-01' AND '2021-12-31' OR DataWprowadzenia BETWEEN '2023-01-01' AND '2023-12-31')
AND (MONTH(DataUrodzenia) BETWEEN 1 AND 6)
ORDER BY DataUrodzenia;

-- S1-7
SELECT DISTINCT(Gatunek)
FROM KsiazkiGatunki

-- S1-8
SELECT *
FROM KsiazkiGatunki
WHERE Gatunek = 'historia' OR Gatunek = 'sport'
ORDER BY IdKsiazki DESC

-- S1-9
SELECT IdKsiazki
FROM KsiazkiTworcy
WHERE TypTworcy = 'autor'
INTERSECT
SELECT IdKsiazki
FROM KsiazkiTworcy
WHERE TypTworcy = 'redaktor'

-- S1-10
SELECT IdKsiazki
FROM KsiazkiTworcy
WHERE TypTworcy = 'autor'
EXCEPT
SELECT IdKsiazki
FROM KsiazkiTworcy
WHERE TypTworcy = 'redaktor'
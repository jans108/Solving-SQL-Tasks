CREATE TABLE [dbo].[Czytelnicy] (
    [idCzytelnika] INT IDENTITY(1,1) NOT NULL, 
    [numerDowodu] VARCHAR(11) NOT NULL,         
    [imie] VARCHAR(50) NOT NULL,              
    [nazwisko] VARCHAR(50) NOT NULL,        
    [ulica] VARCHAR(100) NOT NULL,           
    [nrDomu] VARCHAR(10) NOT NULL, 
    [miasto] VARCHAR(50) NOT NULL,            
    [plec] CHAR(1) CHECK (plec IN ('M', 'K')), 
    [wiek] INT,                                
    [dataZapisania] DATE NOT NULL,            
    CONSTRAINT [PK_Czytelnicy] PRIMARY KEY CLUSTERED ([idCzytelnika]) 
);
GO

ALTER TABLE [dbo].[Czytelnicy]
ALTER COLUMN [plec] CHAR(1) NOT NULL;

ALTER TABLE [dbo].[Czytelnicy]
ADD CONSTRAINT [CHK_plec] CHECK (plec IN ('M', 'K'));

ALTER TABLE [dbo].[Czytelnicy]
ALTER COLUMN [wiek] TINYINT NOT NULL;


GO

CREATE TABLE RodzajeKsiazki (
    rodzajKsiazki VARCHAR(15) PRIMARY KEY,   
    cenaKsiazki MONEY NOT NULL               
);
GO

CREATE TABLE Ksiazki (
    idKsiazki INT IDENTITY(1,1) PRIMARY KEY, 
    tytul VARCHAR(255) NOT NULL,       
    rokWydania DATE NOT NULL,          
    rodzajKsiazki VARCHAR(15) NOT NULL,  
    CONSTRAINT FK_Ksiazki_RodzajeKsiazki FOREIGN KEY (rodzajKsiazki)
        REFERENCES RodzajeKsiazki (rodzajKsiazki)
);
GO

INSERT INTO RodzajeKsiazki (rodzajKsiazki, cenaKsiazki)
VALUES
	('bestseller', 14.00),
	('hit', 7.00),
	('nowoœæ', 10.50),
	('standard', 3.50);

INSERT INTO Ksiazki (tytul, rokWydania, rodzajKsiazki)
VALUES 
    ('W³adca Pierœcieni', '1999-1-1', 'bestseller'),
    ('Hobbit', '1997-5-4', 'nowoœæ'),
    ('Sherlock Holmes', '1954-4-8', 'standard');
GO

CREATE TABLE dbo.Egzemplarze (
    idEgzemplarza INT IDENTITY(1,1) PRIMARY KEY,
    idKsiazki INT,                              
    FOREIGN KEY (idKsiazki) REFERENCES dbo.Ksiazki(idKsiazki)
);


ALTER TABLE dbo.Egzemplarze
ALTER COLUMN idKsiazki INT NOT NULL;
GO

CREATE TABLE dbo.Gatunki (
	idGatunku INT IDENTITY(1,1) PRIMARY KEY,
	nazwaGatunku VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO dbo.Gatunki (nazwaGatunku)
VALUES 
    ('bajka'),
    ('beletrystyka'),
    ('fantastyka'),
    ('historia'),
    ('krymina³'),
    ('nauka'),
    ('poezja'),
    ('przygoda');
GO

CREATE TABLE dbo.Ksiazki_Gatunki (
    idKsiazki INT NOT NULL,                 
    idGatunku INT NOT NULL,              
    PRIMARY KEY (idKsiazki, idGatunku),  
    FOREIGN KEY (idKsiazki) REFERENCES dbo.Ksiazki(idKsiazki),
    FOREIGN KEY (idGatunku) REFERENCES dbo.Gatunki(idGatunku)
);
GO

CREATE TABLE dbo.Tworcy (
    idTworcy INT IDENTITY(1,1) PRIMARY KEY,   
    imie VARCHAR(50) NOT NULL,                 
    nazwisko VARCHAR(50) NOT NULL,         
    rokUrodzenia DATE NOT NULL,                     
    typTworcy VARCHAR(20) CHECK (typTworcy IN ('Autor', 'Redaktor', 'T³umacz')) 
);
GO

CREATE TABLE dbo.Ksiazki_Tworcy (
    idKsiazki INT,                            
    idTworcy INT,                        
    PRIMARY KEY (idKsiazki, idTworcy),
    FOREIGN KEY (idKsiazki) REFERENCES dbo.Ksiazki(idKsiazki),
    FOREIGN KEY (idTworcy) REFERENCES dbo.Tworcy(idTworcy)
);
GO

CREATE TABLE dbo.Wypozyczenia (
    idWypozyczenia INT IDENTITY(1,1) PRIMARY KEY,   
    idEgzemplarza INT NOT NULL,                   
    idCzytelnika INT NOT NULL,                    
    dataWypozyczenia DATE NOT NULL,                  
    oplataZaTydzien MONEY NOT NULL,                   
    dataZwrotu DATE NULL,                          
    oplataDodatkowa MONEY NULL,               
    FOREIGN KEY (idEgzemplarza) REFERENCES dbo.Egzemplarze(idEgzemplarza),
    FOREIGN KEY (idCzytelnika) REFERENCES dbo.Czytelnicy(idCzytelnika)
);
GO

CREATE TRIGGER ObliczDodatkowaOplate
ON dbo.Wypozyczenia
AFTER UPDATE
AS
BEGIN
    DECLARE @dataWypozyczenia DATE, @dataZwrotu DATE, @oplataZaTydzien MONEY, @oplataDodatkowa MONEY;

    SELECT @dataWypozyczenia = dataWypozyczenia, 
           @dataZwrotu = dataZwrotu, 
           @oplataZaTydzien = oplataZaTydzien
    FROM inserted;


    IF @dataZwrotu IS NOT NULL AND DATEDIFF(DAY, @dataWypozyczenia, @dataZwrotu) > 7
    BEGIN
        SET @oplataDodatkowa = DATEDIFF(DAY, @dataWypozyczenia, @dataZwrotu) * (@oplataZaTydzien / 7.0);

        UPDATE dbo.Wypozyczenia
        SET oplataDodatkowa = @oplataDodatkowa
        WHERE idWypozyczenia IN (SELECT idWypozyczenia FROM inserted);
    END
END;




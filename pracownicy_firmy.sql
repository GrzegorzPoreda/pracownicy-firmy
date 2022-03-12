-- autor: Grzegorz Poreda

-- Baza danych pracowników pewnej firmy.
-- Przy pomocy transakcji proszę podnieść pensję o 10% wszystkim pracownikom.
-- Pracownikom, którzy pracują w firmie 20 lat i więcej proszę (przy pomocy transakcji) zwiększyć pensję o 20%.


DROP TABLE IF EXISTS Pracownicy; 

CREATE TABLE Pracownicy (
	ID INT NOT NULL AUTO_INCREMENT,
	Imie VARCHAR(30) NOT NULL,
    Nazwisko VARCHAR(30) NOT NULL,
    Stanowisko VARCHAR(30) NOT NULL,
    Data_Dolaczenia DATE NOT NULL,
    Numer_Konta VARCHAR(30) NOT NULL,
    Pensja DOUBLE NOT NULL,
    Numer_Telefonu INT NOT NULL,
    Czy_Istnieje BOOL NOT NULL,
	PRIMARY KEY (ID)
) ENGINE=InnoDB;

INSERT INTO Pracownicy (Imie, Nazwisko, Stanowisko, Data_Dolaczenia, Numer_Konta, Pensja, Numer_Telefonu, Czy_Istnieje) VALUES
	('Jan','Kowalski','Dyrektor','2011-09-13','1231231123123123',3000.0,123123123,TRUE),
	('Piotr','Nowak','Doradca Biznesowy','2014-08-11','2300923429800923',2000.0,111111111,TRUE),
	('Grzegorz','Bak','Pracownik Biurowy','2020-09-13','6273948939399090',3000.0,222222222,TRUE),
	('Marek','Gornicki','Pracownik Biurowy','2021-09-13','527364239801284',3000.0,333333333,TRUE),
	('Bartlomiej','Dudek','Pracownik Biurowy','1998-09-13','12349823492091',3000.0,444444444,TRUE),
	('Anna','Talaga','Pracownik Biurowy','2016-09-13','223948729387491',3000.0,555555555,TRUE),
	('Maria','Senna','Pracownik Biurowy','2016-10-13','1237498179481989',3000.0,666666666,TRUE),
    ('Adam','Rylko','Pracownik Biurowy','2016-09-13','1746987928379829',3000.0,777777777,TRUE),
	('Roman','Iwaszko','Pracownik Biurowy','2016-09-13','134728374982939',3000.0,888888888,TRUE),
	('Tymon','Rybnik','Pracownik Biurowy','2016-09-13','2347982379487293',3000.0,999999999,TRUE),
	('Lukasz','Feledy','Pracownik Biurowy','2016-09-13','1243124141421532',3000.0,101010101,TRUE),
	('Robert','Trocin','Pracownik Biurowy','2016-09-13','234848939221231',3000.0,123456789,TRUE),
	('Magdalena','Lalek','Pracownik Biurowy','2016-09-13','13525238492389',3000.0,987654321,TRUE),
	('Zaneta','Malnik','Pracownik Biurowy','2016-09-13','124781368723682',3000.0,121314151,TRUE),
    ('Albert','Iwaszko','Pracownik Biurowy','2016-09-13','126713842374982',3000.0,343213234,TRUE),
    ('Elzbieta','Gaban','Pracownik Biurowy','1999-09-13','325689198828933',3000.0,364815274,TRUE),
    ('Przemyslaw','Dykta','Pracownik Biurowy','2016-09-13','35623712879891',3000.0,234222154,TRUE),
    ('Grazyna','Remys','Pracownik Biurowy','2016-09-13','34223423523522',3000.0,987123456,TRUE),
    ('Halina','Igla','Pracownik Biurowy','2001-09-13','1461627127481248',3000.0,345123234,TRUE);


SELECT * FROM Pracownicy;



-- PODNIESIENIE PENSJI WSZYSTKIM PRACOWNIKOM O 10% -----

START TRANSACTION;

DROP PROCEDURE IF EXISTS podniesPensjeWszystkimPracownikomO10Procent;
DELIMITER //
CREATE PROCEDURE podniesPensjeWszystkimPracownikomO10Procent()
BEGIN
	SET @pensja_pracownika=0;
	SET @nowa_pensja_pracownika=0;

	SET @i = 0;
	SET @n = (SELECT COUNT(*) FROM Pracownicy);
    
	WHILE @i < @n DO
        SET @i = @i + 1;
        SELECT @pensja_pracownika := Pensja FROM Pracownicy WHERE ID = @i;
        SET @nowa_pensja_pracownika=@pensja_pracownika + (0.1 * @pensja_pracownika);
        UPDATE Pracownicy SET Pensja = @nowa_pensja_pracownika WHERE ID = @i;
	END WHILE;
END //
DELIMITER ;

CALL podniesPensjeWszystkimPracownikomO10Procent();

COMMIT;

-- KONIEC TRANSAKCJI -----

SELECT * FROM Pracownicy;




-- PODNIESIENIE PENSJI WSZYSTKIM PRACOWNIKOM PRACUJACYM 20 LAT LUB DLUZEJ O 20% -----

START TRANSACTION;

DROP PROCEDURE IF EXISTS podniesPensjeWszystkimPracownikomPracujacym20LatO20Procent;
DELIMITER //
CREATE PROCEDURE podniesPensjeWszystkimPracownikomPracujacym20LatO20Procent()
BEGIN
	SET @pensja_pracownika=0;
	SET @nowa_pensja_pracownika=0;
	SET @data_dolaczenia='1111-11-11';
    
    SELECT @aktualna_data := CURRENT_DATE();
    SELECT @graniczny_rok := YEAR(@aktualna_data) - 20;
    SELECT @graniczna_data := STR_TO_DATE(CONCAT(@graniczny_rok,'-',MONTH(@aktualna_data),'-',DAY(@aktualna_data)), '%Y-%m-%d');
    
	SET @i = 0;
	SET @n = (SELECT COUNT(*) FROM Pracownicy);

	WHILE @i < @n DO
        SET @i = @i + 1;
        SELECT @data_dolaczenia := Data_Dolaczenia FROM Pracownicy WHERE ID = @i;
		IF (@data_dolaczenia <= @graniczna_data) THEN
			SELECT @pensja_pracownika := Pensja FROM Pracownicy WHERE ID = @i;
			SET @nowa_pensja_pracownika=@pensja_pracownika + (0.2 * @pensja_pracownika);
			UPDATE Pracownicy SET Pensja = @nowa_pensja_pracownika WHERE ID = @i;
		END IF;
	END WHILE;
END //
DELIMITER ;

CALL podniesPensjeWszystkimPracownikomPracujacym20LatO20Procent();

COMMIT;

-- KONIEC TRANSAKCJI -----

SELECT * FROM Pracownicy;


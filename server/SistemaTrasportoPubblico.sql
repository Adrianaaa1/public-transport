-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema SistemaTrasportoPubblico3
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `SistemaTrasportoPubblico3` ;

-- -----------------------------------------------------
-- Schema SistemaTrasportoPubblico3
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `SistemaTrasportoPubblico3` DEFAULT CHARACTER SET utf8 ;
USE `SistemaTrasportoPubblico3` ;

-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Veicolo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Veicolo` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Veicolo` (
  `Matricola` INT NOT NULL,
  `Data_acquisto` DATE NOT NULL,
  PRIMARY KEY (`Matricola`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`WayPoint`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`WayPoint` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`WayPoint` (
  `Latitudine` VARCHAR(12) NOT NULL,
  `Longitudine` VARCHAR(12) NOT NULL,
  `OrarioPartenze` TIME NULL,
  `Cod_fermata` INT NULL,
  `Cod_capolinea` INT NULL,
  PRIMARY KEY (`Latitudine`, `Longitudine`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Tratta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Tratta` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Tratta` (
  `idTratta` INT NOT NULL,
  `Latitudine_inziale` VARCHAR(12) NOT NULL,
  `Longitudine_inziale` VARCHAR(12) NOT NULL,
  `Latitudine_finale` VARCHAR(12) NOT NULL,
  `Longitudine_finale` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`idTratta`),
  INDEX `fk_Tratta_WayPoint1_idx` (`Latitudine_inziale` ASC, `Longitudine_inziale` ASC) VISIBLE,
  INDEX `fk_Tratta_WayPoint2_idx` (`Latitudine_finale` ASC, `Longitudine_finale` ASC) VISIBLE,
  CONSTRAINT `fk_Tratta_WayPoint1`
    FOREIGN KEY (`Latitudine_inziale` , `Longitudine_inziale`)
    REFERENCES `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine` , `Longitudine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tratta_WayPoint2`
    FOREIGN KEY (`Latitudine_finale` , `Longitudine_finale`)
    REFERENCES `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine` , `Longitudine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Utente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Utente` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Utente` (
  `Username` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NULL,
  `Ruolo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Conducente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Conducente` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Conducente` (
  `CF` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Data_nascita` DATE NOT NULL,
  `Luogo_nascita` VARCHAR(45) NOT NULL,
  `Scadenza_patente` DATE NOT NULL,
  `Numero_patente` VARCHAR(10) NOT NULL,
  `Utente_Username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CF`),
  INDEX `fk_Conducente_Utente1_idx` (`Utente_Username` ASC) VISIBLE,
  CONSTRAINT `fk_Conducente_Utente1`
    FOREIGN KEY (`Utente_Username`)
    REFERENCES `SistemaTrasportoPubblico3`.`Utente` (`Username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Tratta_effettiva`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Tratta_effettiva` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Tratta_effettiva` (
  `Data` DATE NOT NULL,
  `Tratta` INT NOT NULL,
  `Conducente` VARCHAR(16) NOT NULL,
  `Veicolo` INT NOT NULL,
  PRIMARY KEY (`Data`, `Tratta`, `Veicolo`),
  INDEX `fk_Tratta effettiva_Tratta_idx` (`Tratta` ASC) VISIBLE,
  INDEX `fk_Tratta effettiva_Conducente1_idx` (`Conducente` ASC) VISIBLE,
  INDEX `fk_Tratta effettiva_Veicolo1_idx` (`Veicolo` ASC) VISIBLE,
  CONSTRAINT `fk_Tratta effettiva_Tratta`
    FOREIGN KEY (`Tratta`)
    REFERENCES `SistemaTrasportoPubblico3`.`Tratta` (`idTratta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Tratta effettiva_Conducente1`
    FOREIGN KEY (`Conducente`)
    REFERENCES `SistemaTrasportoPubblico3`.`Conducente` (`CF`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Tratta effettiva_Veicolo1`
    FOREIGN KEY (`Veicolo`)
    REFERENCES `SistemaTrasportoPubblico3`.`Veicolo` (`Matricola`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Biglietto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Biglietto` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Biglietto` (
  `idBiglietto` INT NOT NULL AUTO_INCREMENT,
  `Stato` INT NULL DEFAULT 0,
  `Data` DATE NULL,
  `Tratta` INT NULL,
  `Veicolo` INT NULL,
  PRIMARY KEY (`idBiglietto`),
  INDEX `fk_Biglietto_Tratta_effettiva1_idx` (`Data` ASC, `Tratta` ASC, `Veicolo` ASC) VISIBLE,
  CONSTRAINT `fk_Biglietto_Tratta_effettiva1`
    FOREIGN KEY (`Data` , `Tratta` , `Veicolo`)
    REFERENCES `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data` , `Tratta` , `Veicolo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Abbonamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Abbonamento` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Abbonamento` (
  `idAbbonamento` INT NOT NULL AUTO_INCREMENT,
  `Ultimo_utilizzo` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`idAbbonamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Turno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Turno` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Turno` (
  `Ora_inizio` TIME NOT NULL,
  `Ora_fine` TIME NOT NULL,
  PRIMARY KEY (`Ora_inizio`, `Ora_fine`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Manutenzione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Manutenzione` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Manutenzione` (
  `Tipo_manutenzione` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Tipo_manutenzione`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Turno_effettivo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Turno_effettivo` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Turno_effettivo` (
  `Data_turno` DATE NOT NULL,
  `Conducente` VARCHAR(16) NOT NULL,
  `Ora_inizio` TIME NOT NULL,
  `Ora_fine` TIME NOT NULL,
  PRIMARY KEY (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`),
  INDEX `fk_Turno effettivo_Conducente1_idx` (`Conducente` ASC) VISIBLE,
  INDEX `fk_Turno effettivo_Turno1_idx` (`Ora_inizio` ASC, `Ora_fine` ASC) VISIBLE,
  CONSTRAINT `fk_Turno effettivo_Conducente1`
    FOREIGN KEY (`Conducente`)
    REFERENCES `SistemaTrasportoPubblico3`.`Conducente` (`CF`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Turno effettivo_Turno1`
    FOREIGN KEY (`Ora_inizio` , `Ora_fine`)
    REFERENCES `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio` , `Ora_fine`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Manutenzione_Veicolo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Manutenzione_Veicolo` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Manutenzione_Veicolo` (
  `Manutenzione` VARCHAR(45) NOT NULL,
  `Veicolo` INT NOT NULL,
  PRIMARY KEY (`Manutenzione`, `Veicolo`),
  INDEX `fk_Manutenzione_has_Veicolo_Veicolo1_idx` (`Veicolo` ASC) VISIBLE,
  INDEX `fk_Manutenzione_has_Veicolo_Manutenzione1_idx` (`Manutenzione` ASC) VISIBLE,
  CONSTRAINT `fk_Manutenzione_has_Veicolo_Manutenzione1`
    FOREIGN KEY (`Manutenzione`)
    REFERENCES `SistemaTrasportoPubblico3`.`Manutenzione` (`Tipo_manutenzione`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Manutenzione_has_Veicolo_Veicolo1`
    FOREIGN KEY (`Veicolo`)
    REFERENCES `SistemaTrasportoPubblico3`.`Veicolo` (`Matricola`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`In_programma`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`In_programma` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`In_programma` (
  `Veicolo` INT NOT NULL,
  `Tratta` INT NOT NULL,
  `Numero` INT NOT NULL,
  `Data` DATE NOT NULL,
  PRIMARY KEY (`Veicolo`, `Tratta`, `Data`),
  INDEX `fk_Veicolo_has_Tratta_Tratta1_idx` (`Tratta` ASC) VISIBLE,
  INDEX `fk_Veicolo_has_Tratta_Veicolo1_idx` (`Veicolo` ASC) VISIBLE,
  CONSTRAINT `fk_Veicolo_has_Tratta_Veicolo1`
    FOREIGN KEY (`Veicolo`)
    REFERENCES `SistemaTrasportoPubblico3`.`Veicolo` (`Matricola`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Veicolo_has_Tratta_Tratta1`
    FOREIGN KEY (`Tratta`)
    REFERENCES `SistemaTrasportoPubblico3`.`Tratta` (`idTratta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Convalidato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Convalidato` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Convalidato` (
  `idAbbonamento` INT NOT NULL,
  `Data` DATE NOT NULL,
  `Tratta` INT NOT NULL,
  `Veicolo` INT NOT NULL,
  PRIMARY KEY (`idAbbonamento`, `Data`, `Tratta`, `Veicolo`),
  INDEX `fk_Abbonamento_has_Tratta_effettiva_Tratta_effettiva1_idx` (`Data` ASC, `Tratta` ASC, `Veicolo` ASC) VISIBLE,
  INDEX `fk_Abbonamento_has_Tratta_effettiva_Abbonamento1_idx` (`idAbbonamento` ASC) VISIBLE,
  CONSTRAINT `fk_Abbonamento_has_Tratta_effettiva_Abbonamento1`
    FOREIGN KEY (`idAbbonamento`)
    REFERENCES `SistemaTrasportoPubblico3`.`Abbonamento` (`idAbbonamento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Abbonamento_has_Tratta_effettiva_Tratta_effettiva1`
    FOREIGN KEY (`Data` , `Tratta` , `Veicolo`)
    REFERENCES `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data` , `Tratta` , `Veicolo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Passato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Passato` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Passato` (
  `Data` DATE NOT NULL,
  `Tratta` INT NOT NULL,
  `Veicolo` INT NOT NULL,
  `WayPoint_Latitudine` VARCHAR(12) NOT NULL,
  `WayPoint_Longitudine` VARCHAR(12) NOT NULL,
  `Orario` TIME NOT NULL,
  PRIMARY KEY (`Data`, `Tratta`, `Veicolo`, `Orario`),
  INDEX `fk_Tratta_effettiva_has_WayPoint_WayPoint1_idx` (`WayPoint_Latitudine` ASC, `WayPoint_Longitudine` ASC) VISIBLE,
  INDEX `fk_Tratta_effettiva_has_WayPoint_Tratta_effettiva1_idx` (`Data` ASC, `Tratta` ASC, `Veicolo` ASC) VISIBLE,
  CONSTRAINT `fk_Tratta_effettiva_has_WayPoint_Tratta_effettiva1`
    FOREIGN KEY (`Data` , `Tratta` , `Veicolo`)
    REFERENCES `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data` , `Tratta` , `Veicolo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Tratta_effettiva_has_WayPoint_WayPoint1`
    FOREIGN KEY (`WayPoint_Latitudine` , `WayPoint_Longitudine`)
    REFERENCES `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine` , `Longitudine`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Presente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Presente` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Presente` (
  `idTratta` INT NOT NULL,
  `Latitudine` VARCHAR(12) NOT NULL,
  `Longitudine` VARCHAR(12) NOT NULL,
  `Numero_WayPoint` INT NULL,
  PRIMARY KEY (`idTratta`, `Latitudine`, `Longitudine`),
  INDEX `fk_Tratta_has_WayPoint_WayPoint1_idx` (`Latitudine` ASC, `Longitudine` ASC) VISIBLE,
  INDEX `fk_Tratta_has_WayPoint_Tratta1_idx` (`idTratta` ASC) VISIBLE,
  CONSTRAINT `fk_Tratta_has_WayPoint_Tratta1`
    FOREIGN KEY (`idTratta`)
    REFERENCES `SistemaTrasportoPubblico3`.`Tratta` (`idTratta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Tratta_has_WayPoint_WayPoint1`
    FOREIGN KEY (`Latitudine` , `Longitudine`)
    REFERENCES `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine` , `Longitudine`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaTrasportoPubblico3`.`Fermata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SistemaTrasportoPubblico3`.`Fermata` ;

CREATE TABLE IF NOT EXISTS `SistemaTrasportoPubblico3`.`Fermata` (
  `idTratta` INT NOT NULL,
  `Latitudine` VARCHAR(12) NOT NULL,
  `Longitudine` VARCHAR(12) NOT NULL,
  `Numero_fermata` INT NULL,
  PRIMARY KEY (`idTratta`, `Latitudine`, `Longitudine`),
  INDEX `fk_Tratta_has_WayPoint_WayPoint2_idx` (`Latitudine` ASC, `Longitudine` ASC) VISIBLE,
  INDEX `fk_Tratta_has_WayPoint_Tratta2_idx` (`idTratta` ASC) VISIBLE,
  CONSTRAINT `fk_Tratta_has_WayPoint_Tratta2`
    FOREIGN KEY (`idTratta`)
    REFERENCES `SistemaTrasportoPubblico3`.`Tratta` (`idTratta`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Tratta_has_WayPoint_WayPoint2`
    FOREIGN KEY (`Latitudine` , `Longitudine`)
    REFERENCES `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine` , `Longitudine`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `SistemaTrasportoPubblico3` ;

-- -----------------------------------------------------
-- procedure Assegna_turno_al_conducente
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Assegna_turno_al_conducente`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Assegna_turno_al_conducente` (IN var_conducente VARCHAR(16),IN var_data DATE , IN var_OraInizio TIME, IN var_OraFine TIME)
BEGIN


	INSERT INTO `turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) values (var_data, var_conducente, var_OraInizio, var_OraFine);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Assegna_veicolo_alla_tratta
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Assegna_veicolo_alla_tratta`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Assegna_veicolo_alla_tratta` (IN var_Veicolo INT, In var_Tratta INT, IN var_Conducente VARCHAR(16),IN var_Data DATE)
BEGIN
		set transaction isolation level repeatable read;
		start transaction;
		IF var_Conducente in (Select Turno_effettivo.Conducente
								From `Turno_effettivo`
								Where Turno_effettivo.Conducente = var_Conducente AND Turno_effettivo.Data_turno = var_Data)
		AND var_Conducente not in( Select Tratta_effettiva.Conducente
									FROM `Tratta_effettiva`
									WHERE Tratta_effettiva.Conducente=var_Conducente  and Tratta_effettiva.Data = var_Data )
								THEN
								IF var_veicolo not in (Select Tratta_effettiva.Veicolo
														From `Tratta_effettiva`
														Where Tratta_effettiva.Veicolo = var_veicolo and Tratta_effettiva.Data = var_Data) 
														THEN
														INSERT into `Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) values (var_Data,var_Tratta,var_Conducente,var_Veicolo);
								ELSE
								signal sqlstate '45002' set message_text = "Veicolo non disponibile";
								end if;
		ELSE 
		signal sqlstate '45002' set message_text = "Conducenti non disponibile";
		end if;
        commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Assumi_conducente
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Assumi_conducente`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Assumi_conducente` (IN var_CF VARCHAR(16), IN var_Nome VARCHAR(45), IN var_Cognome VARCHAR(45), IN var_Data_nascita DATE , IN var_Luogo_nascita VARCHAR(45), IN var_Scadenza_patente DATE, IN var_Numero_patente VARCHAR(10), IN var_username VARCHAR(45))
BEGIN
	set transaction isolation level repeatable read;
    start transaction;
	insert into `Conducente` (CF, Nome, Cognome, Data_nascita, Luogo_nascita, Scadenza_patente, Numero_patente, Utente_Username) values (var_CF, var_Nome, var_Cognome, var_Data_nascita, var_Luogo_nascita, var_Scadenza_patente, var_Numero_patente,var_username);
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Elimina_conducente
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Elimina_conducente`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Elimina_conducente` (IN var_CF VARCHAR(16), IN var_Numero_patente VARCHAR(10))
BEGIN
	Delete 
    from `Conducente` 
	where Conducente.CF = var_CF   AND  Conducente.Numero_patente =  var_Numero_patente ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Calcola_distanza_veicolo
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Calcola_distanza_veicolo`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Calcola_distanza_veicolo` (IN var_fermata INT)
BEGIN		

		SELECT WayPoint.latitudine, WayPoint.longitudine
		FROM `WayPoint`
		WHERE WayPoint.Cod_Fermata = var_fermata;
			
		
		SELECT P.WayPoint_Latitudine, P.WayPoint_Longitudine, P.Veicolo
		FROM `Passato` as P 
		JOIN `Tratta_effettiva` as TE on (P.Veicolo = TE.Veicolo AND P.Tratta = TE.Tratta and P.Data = TE.Data)
		JOIN `Tratta` as T on (TE.Tratta = T.IdTratta) 
		JOIN `Fermata` as F on (F.IdTratta = T.IdTratta)
		JOIN `WayPoint` as W on (W.latitudine = F.Latitudine AND W.Longitudine = F.Longitudine)
		WHERE W.Cod_Fermata = var_fermata 
		AND TE.Data = CURRENT_DATE AND P.orario= (
										SELECT MAX(Passato.Orario)
										FROM `Passato` 
										WHERE Passato.Veicolo = TE.Veicolo AND Passato.Data = CURRENT_DATE);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Cambia_conducente_turno
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Cambia_conducente_turno`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Cambia_conducente_turno` (IN var_conducente1 VARCHAR(16),IN var_Data DATE,IN var_conducente2 VARCHAR(16))
BEGIN
		declare var_OraInizio TIME;
		declare var_OraFine TIME;
		declare var_Tratta int;
		declare var_Veicolo int;
		if exists (Select turno_effettivo.Conducente
				FROM `turno_effettivo`
				WHERE turno_effettivo.Conducente = var_Conducente1 and turno_effettivo.Data_turno= var_Data) /*ritorna true o false*/
				then
				Select turno_effettivo.Ora_inizio, turno_effettivo.Ora_fine
				FROM `turno_effettivo`
				WHERE turno_effettivo.Conducente = var_Conducente1 and turno_effettivo.Data_turno = var_Data into var_OraInizio, var_OraFine; /*ritorna inizio e fine di quel turno*/
				if not exists( Select turno_effettivo.Conducente
								FROM `turno_effettivo`
								WHERE turno_effettivo.Conducente = var_Conducente2 and turno_effettivo.Data_turno= var_Data)/*ritorna true o false*/
								then
								Delete
								FROM `turno_effettivo`
								where turno_effettivo.Conducente = var_conducente1 AND turno_effettivo.Data_turno = var_Data;/*non ritorna nulla*/
								
								insert into `turno_effettivo` (Conducente,data_turno, Ora_inizio,Ora_fine) 
								values (var_conducente2, var_Data, var_OraInizio, var_OraFine); /*non ritorna nulla*/
								

								if exists (Select tratta_effettiva.Conducente
											FROM `tratta_effettiva`
											WHERE tratta_effettiva.Conducente = var_Conducente1 and tratta_effettiva.Data= var_Data)/*ritorna true o false*/
											THEN
											Select tratta_effettiva.Tratta, tratta_effettiva.Veicolo
											FROM `tratta_effettiva`
											WHERE tratta_effettiva.Conducente = var_Conducente1 and tratta_effettiva.Data = var_Data into var_Tratta, var_Veicolo; /*ritorna tratta e veicolo di quella tratta*/
											
											DELETE
											FROM `tratta_effettiva`
											WHERE tratta_effettiva.Conducente = var_Conducente1 and tratta_effettiva.Data = var_Data;/*non ritorna nulla*/
											
											if not exists( Select tratta_effettiva.Conducente
															FROM `tratta_effettiva`
															WHERE tratta_effettiva.Conducente = var_Conducente2 and tratta_effettiva.Data= var_Data)/*ritorna true o false*/
															THEN
															insert into `tratta_effettiva` (Data,Tratta,Veicolo,Conducente) values (var_Data,var_Tratta,var_Veicolo,var_Conducente2);/*non ritorna nulla*/
								ELSE 
									signal sqlstate '45002' set message_text = "Il conducente1 non sta guidando un veicolo in quella data";
									end if;
											ELSE 
												signal sqlstate '45002' set message_text = "Il conducente2 gia sta guidando un veicolo in quella data";
												end if;
								
				ELSE 
					signal sqlstate '45002' set message_text = "Il conducente2 ha gia un turno in quella data";
					end if;
	ELSE 
		signal sqlstate '45002' set message_text = "Il conducente1 non ha un turno in quella data";
		end if;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Convalida_abbonamento
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Convalida_abbonamento`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Convalida_abbonamento` (IN var_Abbonamento INT, IN var_Tratta INT, IN var_Veicolo INT)
BEGIN
	insert into `Convalidato` (idAbbonamento, Data, Tratta,  Veicolo) values (var_Abbonamento, current_date(),  var_Tratta, var_Veicolo);
	update `Abbonamento`
	set  Ultimo_utilizzo = now()
	WHERE Abbonamento.IdAbbonamento = var_Abbonamento;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Calcola_prossima_tratta_veicolo
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Calcola_prossima_tratta_veicolo`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Calcola_prossima_tratta_veicolo` (IN var_Veicolo INT,OUT var_Tratta INT)
BEGIN
		if exists  (Select INP.Veicolo
							from `In_programma` as INP 
							WHERE INP.Veicolo = var_veicolo and INP.Data = current_date)
							then
							SELECT I.Tratta
FROM `in_programma` as I 
WHERE I.Veicolo = var_veicolo AND I.Data = CURRENT_DATE AND I.Numero = 1 +
																			(SELECT I.Numero 
																			FROM In_Programma as I
																			JOIN Veicolo as V on (I.Veicolo = V.Matricola)
																			JOIN Tratta_Effettiva as TE on (TE.Veicolo = V.Matricola)
																			WHERE V.Matricola = var_Veicolo and I.Data = CURRENT_DATE AND I.Tratta = TE.Tratta AND TE.Data = current_date)into var_Tratta   ;  
			
			else
			signal sqlstate '45002' set message_text = "Il veicolo non sta percorrendo nessuna tratta oggi";
				end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Timbra_biglietto
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Timbra_biglietto`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Timbra_biglietto` (IN var_id_Biglietto int, IN var_Tratta INT,  IN var_Veicolo INT )
BEGIN	
	IF EXISTS  
			(Select *
			FROM `Tratta_effettiva`
			WHERE Tratta_effettiva.Veicolo = var_veicolo and Tratta_effettiva.Tratta = var_tratta and Tratta_effettiva.Data = CURRENT_DATE)
	THEN
			UPDATE  `biglietto`
			SET biglietto.Stato = 1,  biglietto.Data=current_date() ,biglietto.Tratta = var_Tratta  , biglietto.Veicolo = var_Veicolo
			WHERE biglietto.idBiglietto = var_id_Biglietto;
	ELSE 
			signal sqlstate '45002' set message_text = "Tratta effettiva non esistente";
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Visualizza_conducenti_attivi
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Visualizza_conducenti_attivi`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Visualizza_conducenti_attivi` ()
BEGIN
	set transaction isolation level serializable;
    start transaction;
	drop temporary table if exists `Utenti_attivi`;
	create temporary table `Utenti_attivi` (
	`CF` varchar(45));


    insert into `Utenti_attivi`
	SELECT DISTINCT Conducente.CF
    FROM `Conducente` 
	JOIN `Turno_effettivo` on (Conducente.CF = Turno_effettivo.Conducente)
    WHERE Turno_effettivo.Data_turno = CURRENT_DATE 
	OR Conducente.cf in (Select Tratta_effettiva.Conducente	
						from `Tratta_effettiva`
						where Tratta_effettiva.Conducente = Conducente.cf and Tratta_effettiva.Data = current_date());
    
    	
    select * from `Utenti_attivi`;
    drop temporary table `Utenti_attivi`;
    commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Visualizza_conducenti_fermi
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Visualizza_conducenti_fermi`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Visualizza_conducenti_fermi` ()
BEGIN
	drop temporary table if exists `Utenti_fermi`;
	create temporary table `Utenti_fermi` ( `CF` varchar(45));

	set transaction isolation level serializable;
    start transaction;
    insert into `Utenti_fermi`
	SELECT Conducente.CF
    FROM `Conducente` 
    WHERE Conducente.CF not in (Select t.Conducente
								FROM `Turno_effettivo` as `t` JOIN `Conducente` as `c` on (t.Conducente= c.CF)
								WHERE c.CF = Conducente.CF and t.Data_turno = CURRENT_DATE)
	AND Conducente.CF not in 
							(SELECT Tratta_effettiva.Conducente
								FROM `Tratta_effettiva`
								WHERE Tratta_effettiva.Conducente = Conducente.CF AND Tratta_effettiva.Data = CURRENT_DATE);
	commit;						
	select * from `Utenti_fermi`;
    drop temporary table `Utenti_fermi`;
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Visualizza_veicoli_attivi
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Visualizza_veicoli_attivi`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Visualizza_veicoli_attivi` ()
BEGIN
	set transaction isolation level serializable;
    start transaction;
	SELECT veicolo.matricola
    FROM `veicolo` JOIN `Tratta_effettiva` on (Tratta_effettiva.Veicolo = Veicolo.Matricola)
    WHERE Tratta_effettiva.Data = CURRENT_DATE ;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Visualizza_veicoli_fermi
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Visualizza_veicoli_fermi`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Visualizza_veicoli_fermi` ()
BEGIN
	set transaction isolation level serializable;
    start transaction;
	SELECT veicolo.matricola
    FROM `veicolo` 
    WHERE  veicolo.matricola  not in (Select t.Veicolo
									FROM `Tratta_effettiva` as `t` JOIN `veicolo` as `v`  on (t.Veicolo = v.Matricola)
									WHERE v.Matricola = veicolo.Matricola AND t.Data = CURRENT_DATE);
		commit;							
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Login
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Login`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Login` (in var_username varchar(45), in var_pass varchar(45), out var_role INT)
BEGIN
	declare var_user_role ENUM('amministratore', 'conducente','passeggero');
	select ruolo from `utente`
		where `username` = var_username
        and `password` = md5(var_pass)
        into var_user_role;
        
        -- See the corresponding enum in the client
		if var_user_role = 'AMMINISTRATORE' then
			set var_role = 1;
		elseif var_user_role = 'CONDUCENTE' then
			set var_role = 2;
		elseif var_user_role = 'PASSEGGERO' then
			set var_role = 3;
		else
			set var_role = 4;
		end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Emetti_abbonamenti
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Emetti_abbonamenti`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Emetti_abbonamenti` ()
BEGIN
	insert into `Abbonamento`() values ();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Emetti_biglietto
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Emetti_biglietto`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Emetti_biglietto` ()
BEGIN
	insert into `Biglietto` (Stato) values ("0");
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Aggiungi_utente
-- -----------------------------------------------------

USE `SistemaTrasportoPubblico3`;
DROP procedure IF EXISTS `SistemaTrasportoPubblico3`.`Aggiungi_utente`;

DELIMITER $$
USE `SistemaTrasportoPubblico3`$$
CREATE PROCEDURE `Aggiungi_utente` (IN var_username VARCHAR(45), IN var_password VARCHAR(45), IN var_ruolo VARCHAR(16))
BEGIN
	set transaction isolation level repeatable read;
    start transaction;
	insert into `Utente` (`Username`, `Password`, `Ruolo`) values (var_username, MD5(var_password), var_ruolo);
    commit;
END$$

DELIMITER ;
SET SQL_MODE = '';
DROP USER IF EXISTS Amministratore;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Amministratore' IDENTIFIED BY 'amministratore';

SET SQL_MODE = '';
DROP USER IF EXISTS Conducente;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Conducente' IDENTIFIED BY 'conducente';

SET SQL_MODE = '';
DROP USER IF EXISTS Passeggero;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Passeggero' IDENTIFIED BY 'passeggero';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Veicolo`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Veicolo` (`Matricola`, `Data_acquisto`) VALUES (1, '2006-5-4');
INSERT INTO `SistemaTrasportoPubblico3`.`Veicolo` (`Matricola`, `Data_acquisto`) VALUES (2, '2005-8-4');
INSERT INTO `SistemaTrasportoPubblico3`.`Veicolo` (`Matricola`, `Data_acquisto`) VALUES (3, '2000-6-9');
INSERT INTO `SistemaTrasportoPubblico3`.`Veicolo` (`Matricola`, `Data_acquisto`) VALUES (4, '1999-02-9');

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`WayPoint`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('21.568746', '12.457415', NULL, 1, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('15.265498', '52.548745', '16:00:00', NULL, 1);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('12.568547', '85.698547', NULL, NULL, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('52.567895', '43.357586', NULL, 2, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('98.653242', '54.563245', NULL, NULL, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('10.254856', '43.245874', '13:00:00', NULL, 2);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('11.256547', '52.632412', NULL, NULL, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('14.495850', '35.586837', NULL, 3, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('43.543543', '54.543545', '10:00:00', NULL, 3);
INSERT INTO `SistemaTrasportoPubblico3`.`WayPoint` (`Latitudine`, `Longitudine`, `OrarioPartenze`, `Cod_fermata`, `Cod_capolinea`) VALUES ('54.543545', '76.986747', '19:00:00', NULL, 4);

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Tratta`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta` (`idTratta`, `Latitudine_inziale`, `Longitudine_inziale`, `Latitudine_finale`, `Longitudine_finale`) VALUES (1, '15.265498', '52.548745', '10.254856', '43.245874');
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta` (`idTratta`, `Latitudine_inziale`, `Longitudine_inziale`, `Latitudine_finale`, `Longitudine_finale`) VALUES (2, '10.254856', '43.245874', '15.265498', '52.548745');
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta` (`idTratta`, `Latitudine_inziale`, `Longitudine_inziale`, `Latitudine_finale`, `Longitudine_finale`) VALUES (3, '43.543543', '54.543545', '54.543545', '76.986747');

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Utente`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Utente` (`Username`, `Password`, `Ruolo`) VALUES ('mauro', '0c88028bf3aa6a6a143ed846f2be1ea4', 'AMMINISTRATORE');
INSERT INTO `SistemaTrasportoPubblico3`.`Utente` (`Username`, `Password`, `Ruolo`) VALUES ('mattia', '0c88028bf3aa6a6a143ed846f2be1ea4', 'CONDUCENTE');
INSERT INTO `SistemaTrasportoPubblico3`.`Utente` (`Username`, `Password`, `Ruolo`) VALUES ('giovanni', '0c88028bf3aa6a6a143ed846f2be1ea4', 'CONDUCENTE');
INSERT INTO `SistemaTrasportoPubblico3`.`Utente` (`Username`, `Password`, `Ruolo`) VALUES ('antonio', '0c88028bf3aa6a6a143ed846f2be1ea4', 'PASSEGGERO');
INSERT INTO `SistemaTrasportoPubblico3`.`Utente` (`Username`, `Password`, `Ruolo`) VALUES ('franco', '0c88028bf3aa6a6a143ed846f2be1ea4', 'PASSEGGERO');
INSERT INTO `SistemaTrasportoPubblico3`.`Utente` (`Username`, `Password`, `Ruolo`) VALUES ('lauro', '0c88028bf3aa6a6a143ed846f2be1ea4', 'CONDUCENTE');
INSERT INTO `SistemaTrasportoPubblico3`.`Utente` (`Username`, `Password`, `Ruolo`) VALUES ('ivan', '0c88028bf3aa6a6a143ed846f2be1ea4', 'CONDUCENTE');

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Conducente`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Conducente` (`CF`, `Nome`, `Cognome`, `Data_nascita`, `Luogo_nascita`, `Scadenza_patente`, `Numero_patente`, `Utente_Username`) VALUES ('PLMVNI128H32', 'mattia', 'Palmieri', '1998-10-28', 'Tivoli', '2025-10-10', 'PTIGH576', 'mattia');
INSERT INTO `SistemaTrasportoPubblico3`.`Conducente` (`CF`, `Nome`, `Cognome`, `Data_nascita`, `Luogo_nascita`, `Scadenza_patente`, `Numero_patente`, `Utente_Username`) VALUES ('MDJEBN85JFJ3', 'giovanni', 'Rossi', '1996-10-12', 'Milano', '2027-10-12', 'PODED597', 'giovanni');
INSERT INTO `SistemaTrasportoPubblico3`.`Conducente` (`CF`, `Nome`, `Cognome`, `Data_nascita`, `Luogo_nascita`, `Scadenza_patente`, `Numero_patente`, `Utente_Username`) VALUES ('KDJEJCNF7RM1', 'lauro', 'verdi', '1990-10-12', 'Roma', '2027-10-12', 'NDSJXMEU', 'lauro');
INSERT INTO `SistemaTrasportoPubblico3`.`Conducente` (`CF`, `Nome`, `Cognome`, `Data_nascita`, `Luogo_nascita`, `Scadenza_patente`, `Numero_patente`, `Utente_Username`) VALUES ('NSNSJWU73ND', 'ivan', 'Palma', '1978-10-12', 'Tivoli', '2025-10-10', 'NDJQIU32', 'ivan');

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Tratta_effettiva`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, 'NSNSJWU73ND', 1);
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, 'KDJEJCNF7RM1', 2);
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, 'MDJEBN85JFJ3', 3);
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 3, 'PLMVNI128H32', 4);
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) VALUES (DATE_ADD(CURDATE(), INTERVAL 2 DAY), 3, 'NSNSJWU73ND', 1);
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) VALUES (DATE_ADD(CURDATE(), INTERVAL 2 DAY), 3, 'KDJEJCNF7RM1', 4);
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 'MDJEBN85JFJ3', 1);
INSERT INTO `SistemaTrasportoPubblico3`.`Tratta_effettiva` (`Data`, `Tratta`, `Conducente`, `Veicolo`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 'PLMVNI128H32', 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Biglietto`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Biglietto` (`idBiglietto`, `Stato`, `Data`, `Tratta`, `Veicolo`) VALUES (1, 0, NULL, NULL, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`Biglietto` (`idBiglietto`, `Stato`, `Data`, `Tratta`, `Veicolo`) VALUES (2, 0, NULL, NULL, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`Biglietto` (`idBiglietto`, `Stato`, `Data`, `Tratta`, `Veicolo`) VALUES (3, 0, NULL, NULL, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`Biglietto` (`idBiglietto`, `Stato`, `Data`, `Tratta`, `Veicolo`) VALUES (4, 0, NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Abbonamento`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Abbonamento` (`idAbbonamento`, `Ultimo_utilizzo`) VALUES (1, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`Abbonamento` (`idAbbonamento`, `Ultimo_utilizzo`) VALUES (2, NULL);
INSERT INTO `SistemaTrasportoPubblico3`.`Abbonamento` (`idAbbonamento`, `Ultimo_utilizzo`) VALUES (3, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Turno`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('8:00:00', '16:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('9:00:00', '17:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('10:00:00', '18:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('11:00:00', '19:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('12:00:00', '20:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('13:00:00', '21:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('14:00:00', '22:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('15:00:00', '23:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('16:00:00', '1:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('17:00:00', '2:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('18:00:00', '3:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('19:00:00', '4:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('20:00:00', '5:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('21:00:00', '6:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('22:00:00', '7:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('23:00:00', '8:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('1:00:00', '9:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('2:00:00', '10:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('3:00:00', '11:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('4:00:00', '12:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('5:00:00', '13:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('6:00:00', '14:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno` (`Ora_inizio`, `Ora_fine`) VALUES ('7:00:00', '15:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Manutenzione`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Manutenzione` (`Tipo_manutenzione`) VALUES ('Cambio dell\'olio');
INSERT INTO `SistemaTrasportoPubblico3`.`Manutenzione` (`Tipo_manutenzione`) VALUES ('Tagliando');
INSERT INTO `SistemaTrasportoPubblico3`.`Manutenzione` (`Tipo_manutenzione`) VALUES ('Cambio pasticche dei freni');
INSERT INTO `SistemaTrasportoPubblico3`.`Manutenzione` (`Tipo_manutenzione`) VALUES ('Cambio pistone');
INSERT INTO `SistemaTrasportoPubblico3`.`Manutenzione` (`Tipo_manutenzione`) VALUES ('Modifiche estetiche');
INSERT INTO `SistemaTrasportoPubblico3`.`Manutenzione` (`Tipo_manutenzione`) VALUES ('Revisione');
INSERT INTO `SistemaTrasportoPubblico3`.`Manutenzione` (`Tipo_manutenzione`) VALUES ('Cambio ruota');

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Turno_effettivo`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) VALUES (DATE_ADD(CURDATE(), INTERVAL 0 DAY), 'PLMVNI128H32', '12:00:00', '20:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) VALUES (DATE_ADD(CURDATE(), INTERVAL 0 DAY), 'MDJEBN85JFJ3', '12:00:00', '20:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 'KDJEJCNF7RM1', '12:00:00', '20:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 'NSNSJWU73ND', '12:00:00', '20:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) VALUES (DATE_ADD(CURDATE(), INTERVAL 2 DAY), 'NSNSJWU73ND', '13:00:00', '21:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) VALUES (DATE_ADD(CURDATE(), INTERVAL 2 DAY), 'KDJEJCNF7RM1', '15:00:00', '23:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 'PLMVNI128H32', '15:00:00', '23:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Turno_effettivo` (`Data_turno`, `Conducente`, `Ora_inizio`, `Ora_fine`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 'MDJEBN85JFJ3', '14:00:00', '22:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`In_programma`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 0 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (1, 2, 2, DATE_ADD(CURDATE(), INTERVAL 0 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (2, 2, 1, DATE_ADD(CURDATE(), INTERVAL 0 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (2, 3, 2, DATE_ADD(CURDATE(), INTERVAL 0 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (3, 2, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (3, 1, 2, DATE_ADD(CURDATE(), INTERVAL 1 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (3, 3, 3, DATE_ADD(CURDATE(), INTERVAL 1 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (1, 1, 1, DATE_ADD(CURDATE(), INTERVAL 3 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (1, 3, 2, DATE_ADD(CURDATE(), INTERVAL 3 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (3, 1, 1, DATE_ADD(CURDATE(), INTERVAL 3 DAY));
INSERT INTO `SistemaTrasportoPubblico3`.`In_programma` (`Veicolo`, `Tratta`, `Numero`, `Data`) VALUES (3, 2, 2, DATE_ADD(CURDATE(), INTERVAL 3 DAY));

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Passato`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, 1, '12.568547', '85.698547', '12:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, 2, '98.653242', '54.563245', '12:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, 3, '11.256547', '52.632412', '12:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 3, 4, '12.568547', '85.698547', '12:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1, 1, '98.653242', '54.563245', '12:05:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, 2, '11.256547', '52.632412', '12:05:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 2 DAY), 3, 1, '11.256547', '52.632412', '11:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 2 DAY), 3, 4, '98.653242', '54.563245', '11:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 2 DAY), 3, 4, '11.256547', '52.632412', '11:20:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 2 DAY), 3, 1, '98.653242', '54.563245', '11:25:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 3, '11.256547', '52.632412', '16:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 3, '98.653242', '54.563245', '16:05:23');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 3, '12.568547', '85.698547', '16:07:45');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 1, '12.568547', '85.698547', '16:00:00');
INSERT INTO `SistemaTrasportoPubblico3`.`Passato` (`Data`, `Tratta`, `Veicolo`, `WayPoint_Latitudine`, `WayPoint_Longitudine`, `Orario`) VALUES (DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 1, '98.653242', '54.563245', '16:05:34');

COMMIT;


-- -----------------------------------------------------
-- Data for table `SistemaTrasportoPubblico3`.`Fermata`
-- -----------------------------------------------------
START TRANSACTION;
USE `SistemaTrasportoPubblico3`;
INSERT INTO `SistemaTrasportoPubblico3`.`Fermata` (`idTratta`, `Latitudine`, `Longitudine`, `Numero_fermata`) VALUES (1, '21.568746', '12.457415', 1);
INSERT INTO `SistemaTrasportoPubblico3`.`Fermata` (`idTratta`, `Latitudine`, `Longitudine`, `Numero_fermata`) VALUES (1, '52.567895', '43.357586', 2);
INSERT INTO `SistemaTrasportoPubblico3`.`Fermata` (`idTratta`, `Latitudine`, `Longitudine`, `Numero_fermata`) VALUES (2, '21.568746', '12.457415', 1);
INSERT INTO `SistemaTrasportoPubblico3`.`Fermata` (`idTratta`, `Latitudine`, `Longitudine`, `Numero_fermata`) VALUES (2, '52.567895', '43.357586', 2);
INSERT INTO `SistemaTrasportoPubblico3`.`Fermata` (`idTratta`, `Latitudine`, `Longitudine`, `Numero_fermata`) VALUES (3, '21.568746', '12.457415', 1);
INSERT INTO `SistemaTrasportoPubblico3`.`Fermata` (`idTratta`, `Latitudine`, `Longitudine`, `Numero_fermata`) VALUES (3, '52.567895', '43.357586', 2);

COMMIT;


-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: Giovacto.mysql.pythonanywhere-services.com    Database: Giovacto$gestionale_dati
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `anagrafiche`
--

DROP TABLE IF EXISTS `anagrafiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `anagrafiche` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ragione_sociale` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nome` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `cognome` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `codice_fiscale` varchar(16) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cellulare` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_inserimento` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_utente` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codice_fiscale` (`codice_fiscale`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anagrafiche`
--

LOCK TABLES `anagrafiche` WRITE;
/*!40000 ALTER TABLE `anagrafiche` DISABLE KEYS */;
INSERT INTO `anagrafiche` VALUES (1,'Page93','Mario','Rossi','RSSMRA80A01H501U','mario@test.com','3355800156','2025-12-14 19:28:11',NULL),(4,'Anfossi','Giorgio','Vacchetto','VCCGRG64T04B573D','giovacto@hotmail.com','333222555','2025-12-14 19:58:04',NULL),(5,'Cipi Ropi','Giuseppe','test@test.com','GGGGGGDFERWTDDD','test@test.com','None','2025-12-14 20:16:35',2),(6,'Cippero merlo','davide','ziofaus@pippo.it','HHHUUUEETTT','ziofaus@pippo.it','123456','2025-12-14 20:17:07',2),(7,'Faccenda Cascina Chicco','Marco','Faccenda','IT03307150049','','','2025-12-18 14:54:06',1),(8,'Studio Bertolino','Giorgio','Dott. Bertolino','01623040050','','','2025-12-18 14:55:37',1),(9,'Condominio Orchidea teleriscaldamento','','','1111','','','2026-01-04 16:06:15',1),(10,'Pallapugno','','','12345+6','','','2026-01-05 13:24:13',1),(11,'Extra Lavoro','','','000000','','','2026-01-07 07:26:09',1),(12,'Commercialista FEA ','Andrea','Fea','1313131331','','','2026-01-09 15:53:17',1),(13,'GPTecnica','mimmo','','123456','','','2026-01-12 17:01:23',1),(14,'Rey','Roberto','Rey','121212','','','2026-01-12 17:51:02',1);
/*!40000 ALTER TABLE `anagrafiche` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorie_acquisto`
--

DROP TABLE IF EXISTS `categorie_acquisto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorie_acquisto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome_categoria` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorie_acquisto`
--

LOCK TABLES `categorie_acquisto` WRITE;
/*!40000 ALTER TABLE `categorie_acquisto` DISABLE KEYS */;
INSERT INTO `categorie_acquisto` VALUES (1,'Carburante'),(2,'Cancelleria'),(3,'Utenze'),(4,'Consulenza'),(5,'Alimentari'),(6,'Telefonia'),(8,'Spese Condominio Orchidea'),(9,'Pensione'),(10,'Extralavoro'),(13,'Cinema'),(14,'Ristorante'),(15,'Sport'),(16,'Pallapugno'),(17,'Vestiario'),(18,'Caffetteria'),(19,'Farmacia'),(20,'Lavori Casalinghi'),(21,'Amazon'),(22,'Mercedes C200'),(23,'Spese Alloggio Canale'),(24,'Lavanderia'),(25,'Macelleria'),(26,'Accessori Bagno'),(27,'Prodotti di bellezza'),(28,'Spese Alloggio San Lorenzo al Mare'),(29,'Mobili'),(30,'Nonno Guido'),(31,'Spese Personali'),(32,'Pettinatrice'),(33,'Stipendio Cinzia');
/*!40000 ALTER TABLE `categorie_acquisto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interventi`
--

DROP TABLE IF EXISTS `interventi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interventi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `data_intervento` date NOT NULL,
  `id_staff` int NOT NULL,
  `id_anagrafica` int NOT NULL,
  `descrizione` text COLLATE utf8mb4_general_ci,
  `link_documento` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_chiamata` tinyint(1) DEFAULT '0',
  `stato` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_staff` (`id_staff`),
  KEY `id_anagrafica` (`id_anagrafica`),
  CONSTRAINT `interventi_ibfk_1` FOREIGN KEY (`id_staff`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `interventi_ibfk_2` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafiche` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interventi`
--

LOCK TABLES `interventi` WRITE;
/*!40000 ALTER TABLE `interventi` DISABLE KEYS */;
INSERT INTO `interventi` VALUES (1,'2025-12-16',1,5,'problemi con il nas','https://www.dropbox.com/scl/fi/1zmaf1e4jasga2knunywk/Offerta-passaggio-a-Centralino-Ucloud.paper?rlkey=19hdwxcbsdgvfcldcfi2595lz&dl=0',1,1),(2,'2025-12-18',2,7,'problemi con la posta , che se aperta più volte quando poi la chiudo rimangono dei dati agganziati e quindi il programma non riparte ','',0,1),(3,'2025-12-18',2,8,'prova per chiamata ','',1,1),(4,'2025-12-16',1,5,'fdfdfdfdfddf','',1,1),(6,'2026-01-04',2,9,'storico teleriscaldamento','https://www.dropbox.com/scl/fi/nb81w8au2octo45djn53h/Teleriscaldamento-storia-a-partire-dal-18022023.paper?rlkey=q8rnvbpni5j1xhudwcodt6dpt&dl=0',0,0),(7,'2026-01-05',2,10,'Creo il Sito per la CIJB ','https://www.dropbox.com/scl/fi/e4u3hgkpace3nb7d699a0/Creo-il-Sito-per-la-CIJB.paper?rlkey=c6nydjry5sszv8lr3d9w1zz9s&dl=0',0,0),(8,'2026-01-05',2,10,'Campionato Nazionale Italiano OW','https://www.dropbox.com/scl/fi/xg3cumok0y2msoypp2cg1/Campionato-Nazionale-OW.paper?rlkey=k10zukvlplmnghywtley6fnj6&dl=0',0,0),(9,'2026-01-05',2,10,'Monidale Argentina a Mendoza organizzazione','https://www.dropbox.com/scl/fi/387np0osjh5zyac9slbfo/Monidale-Argentina-a-mendoza.paper?rlkey=l565b4a84ph9g5g43nr0jeiah&st=y2rg7l22&dl=0',0,0),(10,'2026-01-05',2,10,'Creare sito Accademia della pallapugno','https://www.dropbox.com/scl/fi/azkz7p7qlhgaigqguwzxe/Creazione-di-un-Sito-per-far-conoscere-la-Pallapugno.paper?rlkey=bya6amebb873c10fozlg5yogh&st=cbpwwl9i&dl=0',0,0),(11,'2026-01-07',2,11,'A partire da oggi 07 Gennaio lavori che devo portare avanti ','https://www.dropbox.com/scl/fi/1t9zj5n0jucrt3cuqmyv6/A-partire-da-oggi-07-Gennaio-lavori-che-devo-portare-avanti.paper?rlkey=fydzm16lsnnjr6j0d01yuilea&dl=0',0,0),(12,'2026-01-07',2,10,'Gestione Palestra Scontrini e quant\'altro ','https://www.dropbox.com/scl/fi/i9mtnvqbeb6ovtnlplbu9/One-wall-Italia.paper?rlkey=5rnbky2tu8j1xearv5824g9um&dl=0',0,0),(13,'2026-01-07',2,10,'Open It 2026','https://www.dropbox.com/scl/fi/d3tyouwzwg891fh23pdhk/Open-It-2026.paper?rlkey=luv7i5z8udvxfxynkc1esnq0d&dl=0',0,0),(14,'2026-01-08',2,8,'Servizio Web per il collegamento di corrispettivi e POS','https://www.dropbox.com/scl/fi/pkx81rtoegoix5jppvc8f/Servizio-Web-per-il-collegamento-di-corrispettivi-e-POS.paper?rlkey=au4o1yyk2lfsi06kld9q3pqfq&dl=0',0,0),(15,'2026-01-08',2,8,'RENTRI chi sono i soggetti obbligati all\' iscrizione dal 15 dicembre 2025 ?','https://www.dropbox.com/scl/fi/g0jtxv0ssdri60f1gslle/RENTRI-chi-sono-i-soggetti-obbligati-all-iscrizione-dal-15-dicembre-2025.paper?rlkey=br9002w4wcs7nr67y4tkrrqwp&dl=0',0,0),(16,'2026-01-08',2,8,'Lavori in sospeso da portare avanti','https://www.dropbox.com/scl/fi/0fo7q5jl7t736uw3kw1jr/Lavori-in-sospeso-da-portare-avanti.paper?rlkey=c5iv4djrtipvmvslywy435txh&dl=0',1,0),(17,'2026-01-09',2,7,'Hano un PC , quello di MARCO che sarebbe da formattare , l\'ho installato sulla scrivania della ragazza. Ha un monitor piccolo su cui non si riesce a lavorare, ha già windows 11 creare la procedura per poter procedere ','https://www.dropbox.com/scl/fi/1qkxyb5dojatb8ec9plii/PC-da-formattare-di-MARCO.paper?rlkey=2s1pgjo8knaf3k3yukyvxhxxz&dl=0',1,0),(18,'2026-01-09',2,12,'Per creare la Partita IVA ','https://www.dropbox.com/scl/fi/hzzg09fi7a765dq3sf3ck/Per-creare-la-Partita-IVA.paper?rlkey=5b5ymiyor36hxskogc3bmz6pb&dl=0',0,0),(19,'2026-01-11',2,7,'Provo a costruire un programma per la gestione delle visite programmate alla Cantina','https://www.dropbox.com/scl/fi/ouozbwo5kgeepb4yxqfvi/Provo-a-costruire-un-programma-per-la-gestione-delle-visite-programmate-alla-Cantina.paper?rlkey=llwt4eqrxdzrnyrj3midwpz9n&dl=0',0,0),(20,'2026-01-12',2,7,'proposta progetto Montalcino_consulenza ','https://www.dropbox.com/scl/fi/4fad94hw1x4uijeqziahv/Proposta-progetto-Montalcino_consulenza.paper?rlkey=x7c0mu4kqba0j6k7vptflpmqu&dl=0',0,0),(21,'2026-01-12',2,13,'Offerta di reteria per collegamento macchinare industria 5 dot zero ','https://www.dropbox.com/scl/fi/34ys6a0tox8ytu9i83ky7/Offerta-di-reteria-per-collegamento-macchinare-industria-5-dot-zero.paper?rlkey=l3ttdsz5lsxo5yokdw0140997&dl=0',0,0),(22,'2026-01-12',2,14,'Open Fiber sta lavorando: Da: Maximilian Cazzuola <mcazzuola@telecomtd.it>\r\nInviato: venerdì 9 gennaio 2026 11:11\r\nA: amministrazione - Studio Rey <amministrazione@studiorey.com>\r\nCc: Alessandro Luceri <aluceri@telecomtd.it>\r\nOggetto: Attivazione\r\n\r\nBuongiorno, Open Fiber ha preso in carico l’attività, riferiscono che sono in attesa dei permessi.\r\n\r\nViste anche le festività Natalizie, l’attivazione potrebbe subire ritardi per cause non imputabili a Telecomunicazioni e dati, seguiranno aggiornamenti.\r\n\r\nSaluti','',1,1),(23,'2026-01-13',2,5,'Mi chiede di creare etichette su indirizzo di salvatore in modo che i messaggi che arrivano appartenenti a gruppi in cui lui partecipa vadano direttamente in queste etichette verificare come è masso Daniele ','https://www.dropbox.com/scl/fi/67ixgnnfclq8pmfbr89ma/Nuova-postazione-per-Salvatore-ex-FedeX-e-casella-di-posta-elettronica.paper?rlkey=7c569yfg0hlui0z8ramcki9m0&dl=0',0,0),(24,'2026-01-14',2,10,'Riunione per lo sviluppo e diffusione delle discipline affini anno 2026','https://www.dropbox.com/scl/fi/b9bg3ndhyp6a0s7tcyxau/Riunione-per-lo-sviluppo-e-diffusione-delle-discipline-affini-anno-2026.paper?rlkey=a0qb261of7ml11ix1x8kt9aar&dl=0',0,0),(25,'2026-01-16',2,7,'Mettere a posto la Cantina di MONTALCINO','https://www.dropbox.com/scl/fi/4r2wij5fzz4d6noewt0gc/Mettere-a-posto-la-Cantina-di-MONTALCINO.paper?rlkey=c13o2eotbcoj9lm51sf4mlzre&dl=0',0,1),(26,'2026-01-20',2,8,'pc di gabriella che apre piu le ricevute','https://www.dropbox.com/scl/fi/0b3jda40lwuiw54mbgipf/Pc-di-gabriella-che-apre-piu-le-ricevute.paper?rlkey=qoy3b6k8724iptt8qwuzgg6r6&dl=0',0,1),(27,'2026-01-27',2,8,'Condivisione del Calendario Dotcom istruzioni gemini e numero assistenza','https://www.dropbox.com/scl/fi/sokdafx33m3m7q89pk5ss/Condivisione-del-Calendario-Dotcom-istruzioni-gemini-e-numero-assistenza.paper?rlkey=i7egfl4sb15camekjo4qebkix&dl=0',0,0),(28,'2026-01-29',2,14,'Cambio ADSL BBBELL con FIBRA  problemi con il firewall Zyxel USG FLEX 100','https://www.dropbox.com/scl/fi/df4oggcq5oi595v4i23ld/Cambio-ADSL-BBBELL-con-FIBRA-problemi-con-il-firewall-Zyxel-USG-FLEX-100.paper?rlkey=epwktodrre4wtozup08ns6sk7&dl=0',0,0),(29,'2026-02-02',2,11,'il mio SPeech da imparare a memoria','C:\\Users\\Giorgio\\Dropbox (Personale)\\Public\\AnnoDomini\\2026\\Extralavoro\\Speech',0,0),(30,'2026-02-02',2,14,'Mi chiede attivazione di Drobbox Advanced , vado a creare offerta da dare a REY ','https://www.dropbox.com/scl/fi/xpasoe6nc4mfhpv6yopqx/Mi-chiede-attivazione-di-Drobbox-Advanced-vado-a-creare-offerta-da-dare-a-REY.paper?rlkey=fwwyifst298m5hrzpg6n296qg&dl=0',0,0);
/*!40000 ALTER TABLE `interventi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prima_nota`
--

DROP TABLE IF EXISTS `prima_nota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prima_nota` (
  `id` int NOT NULL AUTO_INCREMENT,
  `data` date NOT NULL,
  `costo` decimal(10,2) DEFAULT '0.00',
  `incassato` decimal(10,2) DEFAULT '0.00',
  `id_categoria` int DEFAULT NULL,
  `id_pagamento` int DEFAULT NULL,
  `descrizione` text COLLATE utf8mb4_general_ci,
  `id_staff` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_pagamento` (`id_pagamento`),
  CONSTRAINT `prima_nota_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_acquisto` (`id`),
  CONSTRAINT `prima_nota_ibfk_2` FOREIGN KEY (`id_pagamento`) REFERENCES `tipologie_pagamento` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prima_nota`
--

LOCK TABLES `prima_nota` WRITE;
/*!40000 ALTER TABLE `prima_nota` DISABLE KEYS */;
INSERT INTO `prima_nota` VALUES (1,'2025-12-27',118.83,0.00,6,2,'Migrazione Numero telefonico aziendale su telefono personale fatto alla TIM ',2),(3,'2025-12-23',75.35,75.35,8,6,'ENel energia ',2),(4,'2025-12-23',184.30,184.30,8,6,'Egea Acque Spa',2),(5,'2025-12-24',4.77,0.00,5,4,'Centro Frutta lano',2),(6,'2025-12-27',5.00,0.00,5,4,'Biologicamente ',2),(7,'2026-01-01',19.00,0.00,13,2,'Cinrms checco zelone ',2),(8,'2025-12-31',165.00,0.00,14,2,'Cena di Capodanno alla Pignatta Torre Paponi',2),(9,'2026-01-02',19.00,0.00,13,2,'Norimberga Imperia',2),(10,'2026-01-02',36.42,0.00,5,4,'Pam Imperia',2),(11,'2026-01-02',10.00,0.00,15,8,'Biciclette Nolo 10 dalle 11.00 sino 13.00',2),(12,'2026-01-03',10.00,0.00,15,8,'Biciclette San Lorenzo x Santo Stefano al mare sia io che Cinzia male alla schiena',2),(13,'2026-01-04',50.00,0.00,14,9,'Bar U nostromo pranzo prima della partenza per casa',2),(14,'2025-12-30',10.00,0.00,16,4,'Acquisto Nastri di Carta per One Wall',2),(16,'2026-01-04',52.00,0.00,16,4,'Pagamento a Rino palestra mese di Dicembre ',2),(17,'2026-01-05',59.90,0.00,17,5,'Acquisto pantaloni Benetton on line',2),(18,'2026-01-05',85.16,0.00,5,4,'Big Store ',2),(19,'2026-01-05',5.60,0.00,18,4,'Ospedale Verduno',2),(20,'2026-01-05',0.00,1242.63,9,1,'Mese di Gennaio',2),(21,'2026-01-05',107.36,0.00,16,5,'Acquisto dominio gestito wordpress per accademia della pallapugno',2),(22,'2026-01-06',0.00,50.00,17,8,'Ricevuti da Cinzia x i suoi pantaloni',2),(23,'2026-01-08',70.03,0.00,1,9,'Fatto carburante da Centro Calor prima di vezza ',2),(24,'2026-01-07',9.40,0.00,19,4,'Farmacia Gaelica',2),(25,'2026-01-08',15.70,0.00,19,4,'Farmacia gaelica per mio papa',2),(27,'2026-01-09',58.84,0.00,21,10,'Testina spazzolini - cotton fioc - cartucce stamante office jet 6950',2),(28,'2026-01-09',14.97,0.00,15,4,'Palline per il One wall da farmi rendere Federazione ',2),(29,'2026-01-09',270.00,0.00,22,9,'Copertura sotto motore cambio che si era squarciata',2),(30,'2026-01-09',79.00,0.00,22,9,'Revisione che scadrà tra due anni quindi 2028',2),(32,'2026-01-09',96.16,0.00,5,4,'Spesa per noi e per Nonno Guido Mercato Big',2),(33,'2026-01-09',5.80,0.00,5,4,'Mercato local per farine e lievito per fare focaccia ',2),(34,'2026-01-09',0.00,80.00,5,8,'Ricevuti da Nonno Guido',2),(35,'2026-01-10',27.40,0.00,23,5,'Acquisto Sifone Piletta per la doccia in bagno',2),(36,'2026-01-10',25.00,0.00,24,4,'Pantaloni nostri e Giubotto Nonno Guido ( 9,00 € ) ',2),(37,'2026-01-10',9.30,0.00,25,4,'Macelleria Del Nostro Sacco Canale',2),(38,'2026-01-11',5.70,0.00,18,4,'Bar Centro e gramaldi alba',2),(39,'2026-01-11',42.99,0.00,26,5,'Gillette Fusion 5 Proglide Lamette Da Barba per Rasoio Barba Manuale, 14 Lamette Gillette 42,99€ 3,07 per unità;(3,07€ / unità)',2),(40,'2026-01-12',98.64,0.00,5,4,'Mercatò Big',2),(41,'2026-01-12',0.00,562.50,8,8,'Incasso soldi dai condomini per la Fattura n. 2025/016319/F11 del 14/11/2025 periodo dal 01/10/2025 al 31/10/2025',2),(42,'2026-01-12',545.51,0.00,8,11,'Codice TRN del bonifico: 0306908568230002S94622046220IT Fattura n. 2025/016319/F11 del 14/11/2025 periodo dal 01/10/2025 al 31/10/2025',2),(43,'2026-01-13',0.00,480.00,10,12,'Mese di Gennaio Ricevuta per prestazione occasione ',2),(44,'2026-01-14',26.60,0.00,16,5,'Acquisto dominio CIJB.EU ',2),(45,'2026-01-14',89.01,0.00,23,13,'Egea Luce IREN Fattura n. 38502600435165 * Emessa in data: 09 gennaio 2026 01 dicembre 2025 31 dicembre 2025',2),(46,'2026-01-14',21.58,0.00,27,5,'Deodorante VEO per Cinzia',2),(47,'2026-01-28',66.17,0.00,28,14,'Periodo NOV. 2025 - DIC. 2025 - spesa per l\'ENERGIA ELETTRICA\r\nBolletta sintetica riferita alla fattura elettronica n. 5405659761 del 13/01/2026 valida ai fini fiscali.',2),(48,'2026-01-16',18.67,0.00,5,9,'Materiale per casa per festeggiare Nonno Guido\r\n',2),(49,'2026-01-16',500.00,0.00,29,9,'Rata di 500,00 euro su 1000,00 di debito verso Astegiano Mobili',2),(50,'2026-01-08',0.00,62.00,16,1,'Fipap rimborso spese Palestra e nastri Dicembre 2025',2),(51,'2026-01-17',53.00,0.00,5,4,'Bono Formaggi per festa Compleanno Nonno Guido',2),(52,'2026-01-17',24.20,0.00,5,4,'Food Stories magiano alfieri Polenta e sugo per compleanno Nonno Guido',2),(53,'2026-01-17',13.00,0.00,25,8,'Hamburger per noi , da Damonte',2),(54,'2026-01-17',108.90,0.00,25,2,'Carne per spezzatino e tritata compleanno di Nonno Guido',2),(55,'2026-01-17',6.10,0.00,18,4,'Bramardi caffetteria io e Cinzia',2),(56,'2026-01-17',41.91,0.00,5,4,'Varie e i \"pastis\" di Cinzia per la festa di nonno guido ',2),(57,'2026-01-19',106.00,0.00,8,7,'Pagato teleriscaldamento , assicurazione generali e spese varie per un totale 1504.86',2),(58,'2026-01-19',30.95,0.00,8,7,'Teleriscaldamento Totale di 545,00 per cui a condomino incassato tutti Fattura n. 2025/016319/F11 del 14/11/2025',2),(59,'2026-01-19',148.21,0.00,16,5,'Acquisto Nastri , Coppe / premi e Proiettore portatile',2),(60,'2026-01-21',1309.00,0.00,9,7,'Pagamento rimanenza per passaggio quote , esattamente mezzo pranzo di Paolo',2),(61,'2026-01-20',0.00,45.00,5,8,'Meta importo della torta comprata per Nonno Guido ',2),(62,'2026-01-22',18.00,0.00,28,6,'Pagamento Riviera acqua Fattura n° 020020250000998887 del 23/12/2025 Periodo di fatturazione: dal 01/10/2025 al 30/11/2025 Codice Soggetto: 21276874 Codice Fornitura: 53311301 + 1,00 spesa pagopa',2),(63,'2026-01-15',26.32,0.00,5,4,'Mercatò Local Canale',2),(64,'2026-01-22',2000.00,2000.00,16,7,'Alessandro Vacchetto dato soldi che gli spettano , dei 3500,00€ rimane solo più 1500,00 €',2),(65,'2026-01-24',15.00,0.00,5,4,'Pane e fatto cazzata pizzette e grissini al peperoncino ( pizzette care come il fuoco ) ',2),(66,'2026-01-24',10.00,0.00,25,8,'Carne tritata bella 400 gr per sugo tagliatelle , Bignante - Damonte',2),(67,'2026-01-24',70.00,0.00,22,9,'Rifornimento Gasolio Diesel quasi pieno ',2),(68,'2026-01-24',10.00,0.00,24,4,'Mio Giubottone Grigio ',2),(69,'2026-01-24',12.50,0.00,5,4,'Biologicamente Kwi Cavolo rosso e finocchi',2),(70,'2026-01-26',25.00,0.00,30,4,'QUota Associativa Confartigianato , utlizzata per inviare RED legato alla sua Pensione',2),(71,'2026-01-26',75.81,0.00,16,14,'Tris di Coppe ( due pacchi ) per One Wall Premiazioni',2),(72,'2026-01-27',96.45,0.00,16,10,'Cavo hdmi Lampadine Maglia Juve Matteo',2),(73,'2026-01-28',12.08,0.00,31,10,'Rinnovo PEC Numero Ordine: 183677441 Casella: giorgio.vacchetto@pec.it Tipologia e Dimensione Casella: STANDARD - casella 1 Gb Annualità : 1 Importo: 9,90 Euro + Iva',2),(74,'2026-01-27',19.00,0.00,32,4,'Mi sono tagliato i capelli da Stefania Modè',2),(75,'2026-01-26',71.40,0.00,28,14,'FATTURA: MERCATO: Mercato Libero GAS NUMERO: DEL: 100/MM/344089 26/01/2026 Numero fattura elettronica valida ai fini fiscali SERVIZI DIGITALI SPAZIO CLIENTI | ENGIE APP | Android - iOS 3202041412 SERVIZIO WHATSAPP Invia un messaggio, dal lunedì al sabato, dalle 8:00 alle 20:00, con il tuo Codice Cliente (senza spazi) per richiedere assistenza. COMUNICAZIONI SCRITTE Richieste scritte di informazioni e Reclami: ENGIE Italia SPA, Milano Cordusio, casella postale 242 - 20123 Milano | reclami-ita@engie.com. Da rete fissa al numero gratuito 800.422.422 Da cellulare o per chiamate dall\'estero +39 02395688 (il costo della chiamata varia in base al piano tariffario del tuo operatore telefonico). Servizio attivo dal lunedì al sabato dalle 8:00 alle 20:00 (escluse festività nazionali) engie.it/casa SERVIZIO CLIENTI PROSSIMA BOLLETTA: 30 marzo 2026 La ',2),(76,'2026-01-29',0.00,45.00,30,8,'Vanno per Confartigianato + 13,40 spese luce + 10,00 giubbotto',2),(77,'2026-02-01',148.00,0.00,5,8,'Due latte di olio da 5 litri e una cassa di arance , Giordano, Sicilia , prodotti siciliani',1),(78,'2026-02-02',98.68,0.00,5,9,'Spesa Mercatò Big',1),(79,'2026-02-02',43.00,0.00,17,9,'Ciabatte Giorgio , Calze Ragazzi Montello Calzature',1),(80,'2026-02-02',21.73,0.00,16,9,'Materiale per il OW Nazionale a Canale',2),(81,'2026-02-02',0.00,1242.63,9,14,'Pensione di Febbraio',2),(82,'2026-02-01',3.00,0.00,6,14,'TimFin',2),(83,'2026-02-01',2.00,0.00,6,14,'Tim Fin',2),(84,'2026-02-01',11.00,0.00,6,14,'Tim Fin',2),(85,'2026-02-02',35.32,0.00,5,9,'Mercato Local',1),(86,'2026-02-02',15.71,0.00,5,9,'Mercatò Local',1),(87,'2026-02-02',0.00,38.00,16,14,'Pallapugno torneo ow',1),(88,'2026-02-02',0.00,1487.00,33,13,'Residuo ad oggi ',1),(89,'2026-02-02',19.20,0.00,5,9,'Alfieri 6 passate di pomodoro , 3.2 cadauna',1),(90,'2026-02-03',25.00,0.00,5,8,'Sacchero per Torta Ale e Bugie',2),(91,'2026-02-03',12.00,0.00,16,8,'Manifesti da Appendere',2),(92,'2026-02-03',0.00,300.66,16,14,'Rimborso dei premi per One Wall nazionale e spese palestra tutto Gennaio ',2),(93,'2026-02-02',2.66,0.00,22,14,'Telepass ',2);
/*!40000 ALTER TABLE `prima_nota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `cognome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cellulare` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'Cinzia','Barbero','cinzia@gmail.com','3355652759'),(2,'Giorgio','Vacchetto','giovacto@hotmail.com','3355801156');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipologie_pagamento`
--

DROP TABLE IF EXISTS `tipologie_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipologie_pagamento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `descrizione` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipologie_pagamento`
--

LOCK TABLES `tipologie_pagamento` WRITE;
/*!40000 ALTER TABLE `tipologie_pagamento` DISABLE KEYS */;
INSERT INTO `tipologie_pagamento` VALUES (1,'Bonifico Ingresso'),(2,'Carta di Credito'),(4,'Satispay'),(5,'PayPall'),(6,'Pago PA'),(7,'Bonifico in uscita'),(8,'Contanti'),(9,'Bancomat'),(10,'Carta Ricaricabile'),(11,'Bonifico da Corneliano'),(12,'Assegno'),(13,'Banca d\'Alba conto comune'),(14,'Addebito Diretto Banca Canale Intesa');
/*!40000 ALTER TABLE `tipologie_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utenti`
--

DROP TABLE IF EXISTS `utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `ruolo` enum('admin','user') COLLATE utf8mb4_general_ci DEFAULT 'user',
  `attivo` tinyint(1) DEFAULT '0',
  `data_registrazione` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utenti`
--

LOCK TABLES `utenti` WRITE;
/*!40000 ALTER TABLE `utenti` DISABLE KEYS */;
INSERT INTO `utenti` VALUES (1,'Administrator','admin@test.com','scrypt:32768:8:1$bsqh6NxS2CnfeRLF$00ed73d72c135478ada63e562cb784fee370d3bff5b602c2fa605e54b8d97dc84b7304df5f653d03eff094d8e7a5eb7a49ab671c7791588e9cfbac6a0b315ced','admin',1,'2025-12-14 20:08:19'),(2,'Utente','utente@test.com','scrypt:32768:8:1$XYnuJH62kY2Kr75H$1cbdd91732c856a7e08de9173158d8cf7784e2beb5054449433d7f40f234dfa8e0bca1d4981702a750b9a3852d7cb601fe97cc423f6ab282f7104dde72c090b6','user',1,'2025-12-14 20:14:42');
/*!40000 ALTER TABLE `utenti` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-04 14:53:13

-- sudo mysql -u root -p
-- CREATE database ligne_ferroviaire_normandie;
-- USE ligne_ferroviaire_normandie;



/* Etape non nécessaire (juste au cas où on utilise une base de données déjà remplie et qu'on veut la réinitialiser) */

DROP TABLE IF EXISTS Trajet;
DROP TABLE IF EXISTS Train;
DROP TABLE IF EXISTS Passager;
DROP TABLE IF EXISTS contenir;
DROP TABLE IF EXISTS Ligne;
DROP TABLE IF EXISTS acheter;
DROP TABLE IF EXISTS desservir;
DROP TABLE IF EXISTS Arret;




/* Création des tables utiles */

CREATE TABLE Train(
	id_train SERIAL, 
	type VARCHAR(3) CHECK (type IN ('TGV', 'TER')),
	
	PRIMARY KEY(id_train)
);

CREATE TABLE Passager(
	id_passager SERIAL,
	nom VARCHAR(255) NOT NULL,
	prenom VARCHAR(255) NOT NULL,
	date_naissance DATE NOT NULL,
	situation VARCHAR(255) CHECK(situation IN ('none','Senior', 'Etudiant', 'Militaire')),

	PRIMARY KEY(id_passager)
);
	
CREATE TABLE Arret(
	nom_arret VARCHAR(255),
	ville VARCHAR(255) NOT NULL,
	
	PRIMARY KEY(nom_arret)
);

CREATE TABLE contenir(
	id_contenir SERIAL,
	ville_depart VARCHAR(255),
	ville_arrivee VARCHAR(255),
	nom_arret VARCHAR(255),

	PRIMARY KEY(id_contenir)
);

CREATE TABLE Ligne(
	ville_depart VARCHAR(255),
	ville_arrivee VARCHAR(255),
	
	PRIMARY KEY(ville_depart, ville_arrivee)
);

CREATE TABLE Trajet(
	id_train INT,
	id_trajet SERIAL, 
	ville_depart VARCHAR(255),
	ville_arrivee VARCHAR(255),
	
	-- BUG A SOLUTIONNER - RENVOYER VERS ARRET ET NON VERS LIGNE
	-- FOREIGN KEY (ville_depart, ville_arrivee) REFERENCES ligne(ville_depart, ville_arrivee),
	PRIMARY KEY(id_trajet)
);

CREATE TABLE desservir(
	id_desservir SERIAL, 
	id_trajet INT,
	nom_arret VARCHAR(255), 
	date_heure TIMESTAMP NOT NULL,
	num_quai INT,
	
	PRIMARY KEY(id_desservir)
);

CREATE TABLE acheter(
	id_acheter SERIAL, 
	id_trajet INT, 
	id_passager INT, 
	date_heure TIMESTAMP NOT NULL,
	prix FLOAT,
	num_siege INT,
	
	PRIMARY KEY(id_acheter)
);



/* Visualiser les champs de chaque table */

DESCRIBE Train;
DESCRIBE Passager;
DESCRIBE Arret;
DESCRIBE contenir;
DESCRIBE Ligne;
DESCRIBE Trajet;
DESCRIBE desservir;
DESCRIBE acheter;




/* Ajouter des éléments aux tables */

INSERT INTO Train(type) VALUES ('TER'), ('TGV'), ('TGV'), ('TER');
INSERT INTO Passager(nom, prenom, date_naissance, situation) VALUES ('Leduc', 'Roxane', DATE('2001-07-11'), 'Etudiant'), ('Deponthieux', 'Ariane', DATE('2001-02-24'), 'Etudiant'),('Chaignaud', 'Nathalie', DATE('1980-03-30'), 'none'),('Costaud', 'Monsieur', DATE('1992-04-01'), 'Militaire'),('Andre', 'Anouk', DATE('2001-09-29'),'Etudiant');
INSERT INTO Arret(nom_arret, ville) VALUES ('Le Havre', 'Le Havre'), ('Rouen Rive Droite', 'Rouen'), ('Caen','Caen'),('Breaute-Beuzeville','Breaute'), ('Yvetot','Yvetot'), ('Paris St-Lazare', 'Paris');
INSERT INTO contenir(ville_depart, ville_arrivee, nom_arret) VALUES ('Le Havre','Paris','Paris St-Lazare'), ('Le Havre','Paris','Rouen Rive Droite'), ('Le Havre','Paris','Yvetot'), ('Le Havre','Paris','Breaute-Beuzeville'),('Le Havre','Paris','Le Havre');
INSERT INTO Ligne(ville_depart, ville_arrivee) VALUES ('Le Havre','Paris'), ('Caen','Paris');
INSERT INTO Trajet(id_train, ville_depart, ville_arrivee) VALUES (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (2,'Le Havre','Paris'), (3,'Caen','Paris');
INSERT INTO desservir(id_trajet, nom_arret, date_heure, num_quai) VALUES (1, 'Le Havre', TIMESTAMP('2023-04-26 13:17:00'), 4),  (1, 'Breaute-Beuzeville', TIMESTAMP('2023-04-26 13:37:00'), 2), (2, 'Le Havre', TIMESTAMP('2023-04-26 13:17:00'), 4),  (2, 'Yvetot', TIMESTAMP('2023-04-26 13:47:00'), 6), (3, 'Le Havre', TIMESTAMP('2023-04-26 13:17:00'), 4),  (3, 'Rouen Rive Droite', TIMESTAMP('2023-04-26 14:04:00'), 2), (4, 'Le Havre', TIMESTAMP('2023-04-26 13:17:00'), 4),  (4, 'Paris St-Lazare', TIMESTAMP('2023-04-26 15:19:00'), 18),
(5, 'Breaute-Beuzeville', TIMESTAMP('2023-04-26 13:37:00'), 2),  (5, 'Yvetot', TIMESTAMP('2023-04-26 13:47:00'), 6), (6,  'Breaute-Beuzeville', TIMESTAMP('2023-04-26 13:37:00'), 2),  (6, 'Rouen Rive Droite', TIMESTAMP('2023-04-26 14:04:00'), 2), (7,  'Breaute-Beuzeville', TIMESTAMP('2023-04-26 13:37:00'), 2),  (7, 'Paris St-Lazare', TIMESTAMP('2023-04-26 15:19:00'), 18),
(8,  'Yvetot', TIMESTAMP('2023-04-26 13:47:00'), 6),  (8, 'Rouen Rive Droite', TIMESTAMP('2023-04-26 14:04:00'), 2), (9,  'Yvetot', TIMESTAMP('2023-04-26 13:47:00'), 6),  (9, 'Paris St-Lazare', TIMESTAMP('2023-04-26 15:19:00'), 18),
(10,   'Rouen Rive Droite', TIMESTAMP('2023-04-26 14:04:00'), 2),  (10, 'Paris St-Lazare', TIMESTAMP('2023-04-26 15:19:00'), 18);
INSERT INTO acheter(id_trajet, id_passager, date_heure, prix, num_siege) VALUES (1, 1, TIMESTAMP('2023-04-12 23:00:00'), 5.50, 92), (1, 2, TIMESTAMP('2023-04-16 21:56:00'), 5.50, 93), (2, 3, TIMESTAMP('2023-04-16 21:56:00'), 7.50, 120), (5, 4, TIMESTAMP('2023-04-25 13:14:34'), 3.50, 92);


/* Visualiser éléments de chaque table */

SELECT * FROM Train;
SELECT * FROM Passager;
SELECT * FROM Arret;
SELECT * FROM contenir;
SELECT * FROM Ligne;
SELECT * FROM Trajet;
SELECT * FROM desservir;
SELECT * FROM acheter;



/* REQUETES */

/* Requête n°1 */
-- Afficher les informations du(des) ticket(s) du passager n°1 ?
CREATE VIEW dans_quel_train_voyage_X AS 
	SELECT DISTINCT A.prix, D.*, A.num_siege
	FROM acheter as A, desservir as D
	WHERE  (A.id_passager = 1) AND (A.id_trajet = D.id_trajet);



/* Requête n°2 */
-- Quels sont les trains en circulation le 26/04/2023 ?
SELECT DISTINCT t.id_train 
FROM Train t, desservir d, Trajet tr
WHERE d.date_heure LIKE '2023-04-26%' AND t.id_train=tr.id_train AND d.id_trajet=tr.id_trajet;



/* Requête n°3 */
-- Nombre de trajets réservés par client du réseau normandie, pour les clients ayant réservés plus de 2 tickets enregistrés dans la base des données + leur nom et prénom
SELECT DISTINCT prenom, nom, COUNT(a.id_trajet) AS 'Nombre de trajets réservés'
FROM Passager p, acheter a
WHERE a.id_passager=p.id_passager
GROUP BY a.id_passager
HAVING COUNT(a.id_trajet)>=2;



/* Requête n°4 */
-- Liste des passagers ayant au moins un trajet pour départ de 'Yvetot' ou d'arrivée 'Yvetot' au mois d'Avril 2023
SELECT DISTINCT prenom, nom
FROM Passager p
WHERE EXISTS (SELECT *
				FROM desservir d, acheter a
				WHERE d.nom_arret='Yvetot' AND (d.date_heure LIKE '%04-26%') AND d.id_trajet=a.id_trajet AND a.id_passager=p.id_passager);



/* Requête n°5 */
-- Quelles sont les lignes qui désservent l'arrêt 'Breaute-Beuzeville' OU 'Yvetot' ?
SELECT DISTINCT ville_depart, ville_arrivee
FROM desservir d, Trajet t
WHERE d.id_trajet=t.id_trajet AND d.nom_arret IN ('Breaute-Beuzeville','Yvetot');



/* Requête n°6 */
--"A quelle heure et quel quai arrive le train à Yvetot (celui qui part du et qui est censé arrivé vers 13H45 le 26/04/2023) ?", se demande un proche de NAthalie Chaignaud venu pour la récupérer. Cette information doit être affichée en gare sur un panneau d'affichage
-- Faire afficher toutes les informations utiles pour les panneaux d'affichages des trains qui arrivent entre 13H et 14H le 26/04/23 à Yvetot.

SELECT DISTINCT ville_depart AS 'En provenance de', TIME(d.date_heure) AS 'arrivée prévue à', traj.id_train, type, num_quai
FROM desservir d, Train t, Trajet traj
WHERE traj.id_trajet=d.id_trajet
	AND t.id_train=traj.id_train
	AND d.nom_arret='Yvetot'
	AND d.date_heure BETWEEN TIMESTAMP('2023-04-26 13:00:00') AND TIMESTAMP('2023-04-26 14:00:00');



/* Requête n°7 */
-- Liste des trains prévus pour parcourir au moins un trajet de chaque ligne du réseau Normandie sur la base des trajets enregistrés (la division)
-- Le type du train est précisé pour les statistiques
INSERT INTO Trajet(id_train, ville_depart, ville_arrivee) VALUES (2,'Caen','Paris');


SELECT DISTINCT id_train, type
FROM Train
WHERE id_train NOT IN (
	SELECT DISTINCT id_train
	FROM Train
	WHERE EXISTS (
		SELECT ville_depart, ville_arrivee
		FROM Ligne l
		WHERE NOT EXISTS (
			SELECT id_trajet
			FROM Trajet t1
			WHERE t1.ville_depart=l1.ville_depart
				AND t1.ville_arrivee=l.ville_arrivee
				AND Train.id_train = t1.id_train
			)
	)
);

--On sélectionne tous les trains qui ne font pas partis de la liste des trains (t2) pour lesquels il existe une ligne pour laquelle il n'existe pas de trajet qui est assuré par ce train (t2).



/* Requête n°8 */
-- Liste des passagers assis à la place 92 dans le train n°2 le 26 avril 2023? (ce siège est endommagé, a remarqué un personnel de nettoyage des trains en fin de journée)
SELECT DISTINCT prenom, nom
FROM Passager p, acheter a, Trajet t
WHERE a.num_siege=92 AND t.id_train='2' AND t.id_trajet=a.id_trajet AND p.id_passager=a.id_passager AND EXISTS (SELECT *
										FROM desservir d
										WHERE d.date_heure LIKE '2023-04-26%' AND d.id_trajet=t.id_trajet);

/* Autre façon d'écrire requête n°8 */
SELECT DISTINCT prenom, nom
FROM Passager p, acheter a, Trajet t, desservir d
WHERE a.num_siege=92 AND t.id_train='2' AND t.id_trajet=a.id_trajet AND p.id_passager=a.id_passager AND d.date_heure LIKE '2023-04-26%' AND d.id_trajet=t.id_trajet;




/* Requête n°9 */
-- Nombre de passagers par situation permettant une réduction (nombre de Etudiant, nombre de Militaire, nombre de Senior)
SELECT situation, COUNT(situation) AS 'Nombre de personnes'
FROM Passager
WHERE situation!='none'
GROUP BY(situation);



/* Requête n°10 */
-- Quels sont les trajets possibles Le Havre/Rouen avec un départ entre 10H et 14H le 26/04/2023 ? (demande d'un client pour un achat de ticket sur le site web)
SELECT d_depart.id_trajet, d_depart.date_heure, d_arrivee.date_heure
FROM desservir d_depart, desservir d_arrivee
WHERE d_depart.nom_arret='Le Havre'
	AND d_depart.date_heure BETWEEN TIMESTAMP('2023-04-26 10:00:00') AND TIMESTAMP('2023-04-26 14:00:00')
	AND d_arrivee.nom_arret='Rouen Rive Droite'
	AND d_arrivee.id_trajet=d_depart.id_trajet
	AND d_depart.date_heure<d_arrivee.date_heure;



/* Requête n°11 */
-- Quel est le prix moyen du trajet Le Havre/ Breaute-Beuzeville n°1 payé par les passagers ?
SELECT DISTINCT AVG(prix) AS 'Moyenne du prix payé par les passagers pour le trajet n°1 (€)'
FROM acheter
WHERE id_trajet=1;



/* Requête n°12 */
-- Tous les arrêts desservis par la ligne Le Havre/ Paris départ Le Havre le 04/26/2023 à 13H17 (avec les horaires de chaque arrêt)
--(Trajet général = ensemble des 10 trajets du 04/26/2023 départ Le Havre à 13H17)
SELECT DISTINCT d_arret.nom_arret, d_arret.date_heure
FROM desservir d_depart, desservir d_arret
WHERE d_depart.id_trajet=d_arret.id_trajet
	AND d_depart.nom_arret='Le Havre'
	AND d_depart.date_heure LIKE '2023-04-26 13:17:00';



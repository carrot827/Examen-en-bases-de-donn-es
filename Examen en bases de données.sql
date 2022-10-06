/*Creation BD*/
CREATE DATABASE MouvementAnimaliste;
GO
USE MouvementAnimaliste;

/*Creation tables*/
CREATE TABLE ASSOCIATION
(
Id int PRIMARY KEY,
Nom varchar(100) NOT NULL,
StatutJuridique varchar(30) NOT NULL,
Nentreprise int NOT NULL,
Email varchar(100) NOT NULL,
Tel varchar(20) NOT NULL,
Mission text,
SiteInternet varchar(70),
CONSTRAINT UQ_ASSOCIATION UNIQUE (Nentreprise),
);



CREATE TABLE ADRESSE
(
Id int PRIMARY KEY,
Rue varchar(150) NOT NULL,
NRue int NOT NULL,
CodePostal int NOT NULL,
Localité varchar(60) NOT NULL,
);


/*Ancien nom = A*/  
CREATE TABLE RECENSE
(
Adresse int FOREIGN KEY REFERENCES ADRESSE(Id),
Association int FOREIGN KEY REFERENCES ASSOCIATION(Id),
CONSTRAINT PK_RECENSE PRIMARY KEY (Adresse,Association),
);

CREATE TABLE MEMBRE
(
Id int PRIMARY KEY,
Nom varchar(100) NOT NULL,
Prénom varchar(100) NOT NULL,
Surnom varchar(20),
DateNaiss date NOT NULL,
Tel varchar(20),
Email varchar(100),
Adresse int,
Accompagne int FOREIGN KEY REFERENCES MEMBRE(Id),

CONSTRAINT FK_ADRESSE FOREIGN KEY (Adresse) REFERENCES ADRESSE(Id),
CONSTRAINT UQ_MEMBRE UNIQUE (Nom,Prénom),
/*J'ai été contraint de modifier mon idée de base, en effet je me rends compte que pour appliquer ma première idée, je dois appliquer un trigger.
Aucun mineur ne peu à présent faire d'actions s'ils ne sont pas accompagné

< 18 AND Accompagne IS NOT NULL)*/  
CONSTRAINT CK_MINEUR CHECK(DATEDIFF(YEAR, DateNaiss, GETDATE()) > 18 OR Accompagne IS NOT NULL)



);



CREATE TABLE COMPTE
(
Membre int FOREIGN KEY REFERENCES MEMBRE(Id),
Association int FOREIGN KEY REFERENCES ASSOCIATION(Id),
CONSTRAINT PK_COMPTE PRIMARY KEY (Membre,Association),
);

CREATE TABLE ACTION
(
Id int PRIMARY KEY,
Nom varchar(100) NOT NULL,
Date date NOT NULL,
HeureDébut time NOT NULL,
HeureFin time,
Autorisation text NOT NULL,
ARisque bit NOT NULL,
NbDePersSensib int,
Responsable int NOT NULL,
Adresse int NOT NULL,
CONSTRAINT FKA_MEMBRE FOREIGN KEY (Responsable) REFERENCES MEMBRE(Id),
CONSTRAINT FKA_ADRESSE FOREIGN KEY (Adresse) REFERENCES ADRESSE(Id),
);

CREATE TABLE PARTICIPE
(
Membre int FOREIGN KEY REFERENCES MEMBRE(Id), 
Action int FOREIGN KEY REFERENCES ACTION(Id),
CONSTRAINT PK_PARTICIPE PRIMARY KEY (Membre,Action),
);




GO
/*Insertion*/

INSERT INTO ASSOCIATION
VALUES (1001, 'L214', 'asbl', 33976119, 'presse@l214.com', '0650/35.57.48', 'Rendre compte de la réalité / Démontrer l"inpact négatif / Nourir le ébat', 'www.l214.com'),
       (1002, 'Anonymous for the Voiceless', 'asbl', 49561115, 'anonymousforthevoiceless@animal.com', '0555/12.54.99', 'La sensibilisation de rue', 'anonymousforthevoiceless.org'),
       (1003, 'Gaia', 'asbl', 34964164, 'gaia@mail.be', '0817/64.22.33', 'sensibiliser le grand public', 'www.gaia.be');

INSERT INTO ADRESSE
VALUES (2001, 'Rue de la République', 23, 69002, 'LYON'),
       (2002, 'Place de lange', 13, 5000, 'NAMUR'),
       (2003, 'Rue chez-moi', 50, 5150, 'FLOREFFE'),
       (2004, 'Whallstreet', 600, 1000, 'BRUXELLES'),
       (2005, 'RueGaia', 13, 1000, 'BRUXELLES'),
	   (2006, 'RueAlex', 15, 2000, 'LIEGE');


INSERT RECENSE(Adresse,Association)
VALUES (2001,1001),
       (2004,1002),
	   (2005,1003);

/*
1xxx = membres
2xxx = adresses
3xxx = actions
*/

INSERT MEMBRE(Id, Nom, Prénom, Surnom, DateNaiss, Tel, Email, Adresse)
VALUES (1002, 'Grandgagnage', 'Frédéric', 'Xxxxx', '1995-12-12', '0474/00.00.00', 'xxxxxxxx@hotmail.com', 2003);

INSERT MEMBRE(Id, Nom, Prénom, DateNaiss)
VALUES (1003, 'William', 'Clément', '1990-12-15');

INSERT MEMBRE(Id, Nom, Prénom, Surnom, DateNaiss, Tel, Email, Adresse, Accompagne)
VALUES (1001, 'Yyyyyy', 'Alexandra', 'Yyyy', '2005-12-01', '0474/44.11.55', 'yyyyyyyyyyy@gmail.com', 2006, 1002);





INSERT INTO ACTION
VALUES (3001, 'Cube Of Truth: Namur: July 12th', '2020-07-12', '15:00', '18:00', 'Autorisation de Maxime Prévot', 0, 24, 1003, 2002),
       (3003, 'Cube Of Truth: Namur: July 20th', '2020-07-20', '15:00', '18:00', 'Autorisation de Maxime Prévot', 0, 65, 1003, 2002);

INSERT ACTION(Id, Nom, date, HeureDébut, Autorisation, ARisque, Responsable, Adresse) 
VALUES (3002, 'Sauvetage animaux', '2020-06-14', '03:30', 'Aucune', 1, 1002, 2006);


INSERT PARTICIPE(Membre, Action)
VALUES (1001, 3003),
       (1002, 3002),
       (1002, 3001),
       (1003, 3001),
       (1003, 3002),
       (1003, 3003);

INSERT COMPTE(Membre, Association)
VALUES (1001, 1001),
	   (1002, 1002),
       (1003, 1003);

GO

/* Selections */

select * from ADRESSE;
select * from ASSOCIATION;
select * from MEMBRE;
select * from ACTION;

select * from PARTICIPE;
select * from RECENSE;
select * from COMPTE;

/* Toutes les colonnes memebres et les deux colonnes d'action*/
SELECT * FROM MEMBRE INNER JOIN PARTICIPE ON PARTICIPE.Membre = MEMBRE.Id

/* Trois table*/
SELECT Membre.Nom, Prénom, Action.Nom, Action.ARisque FROM MEMBRE INNER JOIN PARTICIPE ON PARTICIPE.Membre = MEMBRE.Id INNER JOIN ACTION ON ACTION.Id = PARTICIPE.Action 
WHERE ACTION.Nom = 'Sauvetage animaux'

SELECT * FROM MEMBRE INNER JOIN COMPTE ON COMPTE.Membre = MEMBRE.Id INNER JOIN ASSOCIATION ON ASSOCIATION.Id = Compte.Association
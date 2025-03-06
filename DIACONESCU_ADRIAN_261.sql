-- Tabel Roluri Creat
CREATE TABLE Roluri (
    id_rol NUMBER NOT NULL,
    titlu VARCHAR2(80 CHAR) NOT NULL,
    descriere VARCHAR2(100 CHAR) NOT NULL,
    nivel VARCHAR2(10 CHAR) CHECK (nivel IN ('intern', 'junior', 'senior')),
    PRIMARY KEY (id_rol)
);


-- Tabelul Clienti creat

CREATE TABLE Clienti (
    id_client NUMBER NOT NULL,
    nume VARCHAR2(30 CHAR),
    adresa VARCHAR2(80 CHAR),
    persoana_contact VARCHAR2(40 CHAR),
    telefon VARCHAR2(15 CHAR) NOT NULL,
    e_mail VARCHAR2(30 CHAR),
    PRIMARY KEY (id_client),
    CONSTRAINT rest_id_client CHECK (id_client > 0),
    CONSTRAINT rest_email CHECK (e_mail LIKE '%@%.%')
);


-- Tabel Departamente creat

CREATE TABLE Departamente (
    id_departament NUMBER NOT NULL,
    nume VARCHAR2(30 CHAR) NOT NULL,
    locatie VARCHAR2(50 CHAR) NOT NULL,
    nume_sef VARCHAR2(50 CHAR) NOT NULL,
    PRIMARY KEY (id_departament),
    CONSTRAINT rest_id_departament CHECK (id_departament > 0)
);


-- Tabel Angajati creat

CREATE TABLE Angajati (
    id_angajat VARCHAR2(25 CHAR) NOT NULL,
    nume VARCHAR2(50 CHAR) NOT NULL,
    calificare VARCHAR2(30 CHAR) CHECK (calificare IN ('arhitect', 'inginer', 'tehnician', 
                                                 'contabil','desenator')),
    salariu NUMBER NOT NULL,
    data_angajare DATE NOT NULL,
    id_departament NUMBER NOT NULL, -- Definirea coloanei pentru FK
    id_rol NUMBER NOT NULL,         -- Definirea coloanei pentru FK
    CONSTRAINT id_departament_angajat FOREIGN KEY (id_departament) 
        REFERENCES Departamente (id_departament) 
        ON DELETE CASCADE,
    CONSTRAINT id_rol_angajat FOREIGN KEY (id_rol) 
        REFERENCES Roluri (id_rol) 
        ON DELETE CASCADE,
    PRIMARY KEY (id_angajat)
);



-- Tabel Salarii creat

CREATE TABLE Salarii (
    id_salariu NUMBER NOT NULL,
    id_angajat VARCHAR2(25 CHAR) NOT NULL, -- FK catre Angajati
    salariu_de_baza NUMBER NOT NULL,
    bonus NUMBER,
    data_incasare DATE NOT NULL,
    PRIMARY KEY (id_salariu),
    CONSTRAINT id_angajat_salariu FOREIGN KEY (id_angajat) 
        REFERENCES Angajati (id_angajat) 
        ON DELETE CASCADE,
    CONSTRAINT rest_salariu CHECK (salariu_de_baza > 0)
);


-- Tabel Proiecte creat

CREATE TABLE Proiecte (
    id_proiect NUMBER NOT NULL,
    nume VARCHAR2(30 CHAR) NOT NULL,
    buget NUMBER NOT NULL,
    data_incepere DATE NOT NULL,
    data_limita DATE NOT NULL,
    id_client NUMBER NOT NULL, -- FK catre tabelul Clienti
    PRIMARY KEY (id_proiect),
    CONSTRAINT id_proiect_client FOREIGN KEY (id_client) 
        REFERENCES Clienti (id_client) 
        ON DELETE CASCADE,
    CONSTRAINT rest_id_proiect CHECK (id_proiect > 0),
    CONSTRAINT rest_buget CHECK (buget > 0)
);


-- Tabel Atribuiri_roiecte creat

CREATE TABLE Atribuiri_Proiecte (
    id_atribuire NUMBER NOT NULL,
    ore_lucrate NUMBER NOT NULL,
    id_proiect NUMBER NOT NULL, -- FK catre Proiecte
    id_director VARCHAR2(25 CHAR) NOT NULL, -- FK catre Angajati
    PRIMARY KEY (id_atribuire),
    CONSTRAINT id_proiect_atribuit FOREIGN KEY (id_proiect) 
        REFERENCES Proiecte (id_proiect) 
        ON DELETE CASCADE,
    CONSTRAINT id_director_atribuit FOREIGN KEY (id_director) 
        REFERENCES Angajati (id_angajat) 
        ON DELETE CASCADE,
    CONSTRAINT rest_ore_lucrate CHECK (ore_lucrate > 0)
);

CREATE TABLE Facturi(
    id_factura NUMBER NOT NULL,
    valoare NUMBER NOT NULL,
    data_emitere DATE NOT NULL,
    data_scadenta DATE NOT NULL,
    statut VARCHAR2(15) CHECK (statut IN('achitat','neachitat')),
    id_client NUMBER NOT NULL,
    CONSTRAINT id_client_facturat FOREIGN KEY (id_client) 
        REFERENCES Clienti (id_client) 
        ON DELETE CASCADE,
    CONSTRAINT dif_data CHECK (data_emitere < data_scadenta) 
);

ALTER TABLE Atribuiri_Proiecte
ADD predate VARCHAR2(1)  CHECK ( predate IN('0','1'));


-- Roluri inserate

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (1, 'Director General', 'Coordoneaza activitatea companiei', 'senior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (2, 'Director Tehnic', 'Gestioneaza departamentele tehnice', 'senior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (3, 'Director Economic', 'Gestioneaza deparamentele economice', 'senior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (4, 'Devizier', 'Gestioneaza finantele individuale proiectelor', 'junior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (5, 'Contabil', 'Gestioneaza finantele companiei', 'junior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (6, 'Arhitect Sef', 'Gestioneaza conceptia proiectarii', 'senior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (7, 'Arhitect Proiectant', 'Intocmeste partea de arhitectura', 'junior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (8, 'Tehnician', 'Pune in practica conceptia arhitectului/inginerului', 'junior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (9, 'Desenator', 'Redacteaza proiectele', 'intern');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (10, 'Structurist Sef', 'Coordoneaza echipa de structuri', 'senior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (11, 'Inginer Structurist', 'Proiecteaza structura cladirilor', 'junior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (12, 'Inginer Sef Instalatii', 'Asigura coordonarea echipei de instalatii', 'senior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (13, 'Inginer Sanitar', 'Proiecteaza instalatiile sanitare', 'junior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (15, 'Inginer Termist', 'Proiecteaza instalatiile termice si HVAC', 'junior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (17, 'Inginer Electrician', 'Proiecteaza instalatiile electrice', 'junior');

INSERT INTO Roluri (id_rol, titlu, descriere, nivel) 
VALUES (19, 'Inginer Gaze', 'Proiecteaza instalatiile de gaze naturale', 'junior');


-- Clienti inserate

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (1, 'SC Pro Arc SRL', 'Strada Dd. Dimitrie Ernici 4, Piatra Neamt', 'Diaconescu Iulian', '0723049265', 'diuliarh@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (2, 'Dumitrache Ion', 'Drumul Fermei 68, Popesti-Leordeni', 'Dumitrache Ion', '07680465890', 'Dionh@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (3, 'SC Cristal Vision SRL', 'Strada Smirodava 11, Roman', 'Haralamb Stefan', '07510468890', 'HSTa@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (4, 'Ionescu Aurel', 'Strada Alecu Russo 57, Bacau', 'Ionescu Grigore', '07519068010', 'aurel782@gmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (5, 'Georgescu Bogdan', 'Strada George Bacovia 36, Bacau', 'Georgescu Bogdan', '07125547524', 'BoGG65@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (6, 'SC MEGA TRAVEL SRL', 'Strada Costache Negruzzi 2, Sibiu', 'Ionescu Doru', '07123397122', 'MEGA@gmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (7, 'Mihalache Iosif', 'Strada Protopop Iosif Pop 4, Aiud', 'Mihalache Iosif', '07122160110', 'HihaIosif6@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (8, 'Diaconescu Adrian', 'Intrarea Costache Negri 3, Bucuresti', 'Diaconescu Adrian', '07126819434', 'adrian671@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (9, 'Dobrescu Marcel', 'Strada Ramuri Tei 4, Bucuresti', 'Dobrescu Ioana', '07123820819', 'IDBr521@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (10, 'Bursuc Ana', 'Strada Atomistilor 385, Magurele', 'Bursuc Ana', '07121996897', 'Ana_bursuc@gmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (11, 'Ionescu Grigore', 'Strada Movila Pacurea 13, Iasi', 'Ionescu Grigore', '07126635364', 'GrgI0@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (12, 'Stan Ioana', 'Strada Ene Nita 35, Bucuresti', 'Stan Ioana', '07121996897', 'IoanaStan@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (13, 'SC COMIRO SRL', 'Aleea Privighetorilor 85, Bucuresti', 'Bursuc Rodica', '07128895468', 'coS01@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (14, 'Banescu Ilinca', 'Strada Aurel Vlaicu 91, Bucuresti', 'Banescu Ilinca', '07126866108', 'IBanescu@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (15, 'Iftime George', 'Strada Sfantul Constantin 12a, Bucuresti', 'Iftime George', '07129782764', 'GIFT01@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (16, 'Dinu Marius', 'Strada Alexandru Odobescu 10, Brasov', 'Dinu Marius', '07129741904', 'MariusD01@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (17, 'Nastase Ioana', 'Strada Ceaus Radu 1, Bucuresti', 'Nastase Doru', '07125355361', 'IoaNA8@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (18, 'Grigorescu Marcel', 'Strada Canalului 72, Sacele', 'Grigorescu Marcel', '07129459372', 'GrMa7@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (19, 'Stancu Ion', 'Strada Orsova 89, Bucuresti', 'Stancu Ion', '07121500623', 'StanuIon89@gmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (20, 'SC Petrodava SRL', 'Str. Florilor 4, Toplita', 'Urzica Marcel', '07125060684', 'MarcelUrz9@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (21, 'Grecu Andrei', 'Strada Suzana 27, Bucuresti', 'Grecu Andrei', '07126310501', 'Andrei876@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (22, 'Dumitrache George', 'Strada Vladimirescu 2, Bolintin-Deal', 'Dumitrache George', '07123935947', 'Duitrache_George@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (23, 'Sturza Mihaela', 'Strada Macinului 43, Craiova', 'Sturza Mihaela', '07125674124', 'Mihaela_st601@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (24, 'Popescu Vasile', 'Strada Tudor Vladimirescu 119, Targu Mures', 'Popescu Vasile', '07125840765', 'VasPs01@gmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (25, 'Grigoras Geta', 'Strada Laguna Albastra 56, Corbeanca', 'Grigoras Geta', '07126763297', 'GetA99@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (26, 'SC ROBOR SRL', 'Strada Calugareni 29a, Ghermanesti', 'Dima Mihaela', '07121268676', 'roBOR01@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (27, 'SC OLDANCOM SRL', 'Strada 23 August 47, Buftea', 'Haralamb Stefan', '07127660355', 'OLDANco11@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (28, 'Diaconescu Mircea', 'Strada Azuga 19, Ploiesti', 'Diaconescu Mircea', '07124651292', 'MIrceA01@gmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (29, 'Dima Grigore', 'Strada Radna 6, Bucuresti', 'Dima Grigore', '07124116941', 'DiMaGR76@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (30, 'Ilias Iris', 'Strada Privighetorilor a106, Otopeni', 'Ilias Iris', '07122929963', 'Iris324a@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (31, 'Doe James', 'Soseaua Gruiu-Snagov 192, Gruiu', 'Doe James', '07123884542', 'JamiE9@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (32, 'Ionescu Dan', 'Strada Neamului 24, Bragadiru', 'Ionescu Dan', '07125391718', 'IOne@gmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (33, 'Popescu Andreea', 'Strada Ogorului 11, Catelu', 'Popescu Andreea', '07126702624', 'AndrP98@gmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (34, 'Bistriceanu Traian', 'Strada Baciu 48, Giurgiu', 'Bistriceanu Traian', '07127705777', 'TrtB9@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (35, 'Frizoiu Maximilian', 'Strada Ciulini 1, Jilava', 'Frizoiu Maximilian', '07128201918', 'MaxZF2@yahoo.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (36, 'Ionascu Sebastian', 'Strada Sapte Drumuri Nr. 13, Bucuresti', 'Ionascu Sebastian', '07129688833', 'SeB1@hotmail.com');

INSERT INTO Clienti (id_client, nume, adresa, persoana_contact, telefon, e_mail)
VALUES (37, 'Ghorghiu Paul', 'Strada Tudor Vladimirescu 53, Berceni', 'Haralamb Stefan', '07121497964', 'PaGHiul42@gmail.com');




-- Departamente inserate

INSERT INTO Departamente (id_departament, nume, locatie, nume_sef)
VALUES (1, 'Arhitectura', 'Piatra Neamt', 'Diaconescu Adrian');

INSERT INTO Departamente (id_departament, nume, locatie, nume_sef)
VALUES (2, 'Economie', 'Bucuresti', 'Georgescu Marcel');

INSERT INTO Departamente (id_departament, nume, locatie, nume_sef)
VALUES (3, 'Structura', 'Bucuresti', 'Diaconescu Andrei');

INSERT INTO Departamente (id_departament, nume, locatie, nume_sef)
VALUES (4, 'Instalatii', 'Bucuresti', 'Nica Octavian');

INSERT INTO Departamente (id_departament, nume, locatie, nume_sef)
VALUES (5, 'Gaze', 'Bucuresti', 'Dinu Bogdan');

INSERT INTO Departamente (id_departament, nume, locatie, nume_sef)
VALUES (6, 'Conducere', 'Bucuresti', 'Diaconescu Iulian');




-- Angajati inserate

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A001', 'Diaconescu Adrian', 'arhitect', 25500, TO_DATE('2018-01-15', 'YYYY-MM-DD'), 6, 1);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A002', 'Diaconescu Iulian', 'arhitect', 24500, TO_DATE('2018-06-20', 'YYYY-MM-DD'), 6, 2);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A003', 'Georgescu Marcel', 'contabil', 23500, TO_DATE('2020-03-12', 'YYYY-MM-DD'), 6, 3);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A004', 'Elena Sima', 'contabil', 7000, TO_DATE('2019-09-01', 'YYYY-MM-DD'), 2, 5);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A005', 'Alexandru Popa', 'contabil', 6700, TO_DATE('2021-07-15', 'YYYY-MM-DD'), 2, 5);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A006', 'Andrei Ionescu', 'inginer', 6700, TO_DATE('2020-12-01', 'YYYY-MM-DD'), 2, 4);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A007', 'Simona Popa', 'contabil', 6800, TO_DATE('2022-02-20', 'YYYY-MM-DD'), 2, 4);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A008', 'Ionel Georgescu', 'arhitect', 8000, TO_DATE('2019-11-15', 'YYYY-MM-DD'), 1, 6);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A009', 'Roxana Sima', 'arhitect', 5900, TO_DATE('2018-08-10', 'YYYY-MM-DD'), 1, 7);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A010', 'Mihai Popescu', 'tehnician', 5200, TO_DATE('2021-09-25', 'YYYY-MM-DD'), 1, 8);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A011', 'Alina Ionescu', 'tehnician', 5100, TO_DATE('2020-01-18', 'YYYY-MM-DD'), 1, 8);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A012', 'Vlad Georgescu', 'desenator', 2100, TO_DATE('2024-07-09', 'YYYY-MM-DD'), 1, 9);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A013', 'Ana Popa', 'desenator', 2100, TO_DATE('2024-10-23', 'YYYY-MM-DD'), 1, 9);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A014', 'Diaconescu Andrei', 'inginer', 7900, TO_DATE('2018-05-14', 'YYYY-MM-DD'), 3, 10);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A015', 'Ioana Ionescu', 'inginer', 6100, TO_DATE('2022-10-30', 'YYYY-MM-DD'), 3, 11);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A016', 'Victor Georgescu', 'tehnician', 4900, TO_DATE('2021-06-11', 'YYYY-MM-DD'), 3, 8);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A017', 'Mihai Sima', 'desenator', 2100, TO_DATE('2024-12-03', 'YYYY-MM-DD'), 3, 9);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A018', 'Nica Octavian', 'inginer', 8800, TO_DATE('2021-01-15', 'YYYY-MM-DD'), 4, 12);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A019', 'Florin Ionescu', 'inginer', 6300, TO_DATE('2022-07-05', 'YYYY-MM-DD'), 4, 13);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A020', 'Larisa Georgescu', 'tehnician', 5000, TO_DATE('2020-03-19', 'YYYY-MM-DD'), 4, 13);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A021', 'Petre Sima', 'tehnician', 4800, TO_DATE('2019-06-18', 'YYYY-MM-DD'), 4, 13);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A022', 'Dinu Bogdan', 'inginer', 8300, TO_DATE('2021-11-21', 'YYYY-MM-DD'), 5, 19);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A023', 'Marian Ionescu', 'inginer', 6700, TO_DATE('2020-04-30', 'YYYY-MM-DD'), 4, 15);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A024', 'Liliana Georgescu', 'tehnician', 5100, TO_DATE('2020-02-14', 'YYYY-MM-DD'), 4, 15);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A025', 'Gabriela Sima', 'inginer', 8000, TO_DATE('2021-08-09', 'YYYY-MM-DD'), 5, 19);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A026', 'Stefan Popescu', 'desenator', 2100, TO_DATE('2024-02-13', 'YYYY-MM-DD'), 4, 19);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A027', 'Ioan Ionescu', 'desenator', 2100, TO_DATE('2024-06-25', 'YYYY-MM-DD'), 4, 17);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A028', 'Adriana Georgescu', 'desenator', 2100, TO_DATE('2024-09-15', 'YYYY-MM-DD'), 5, 17);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A029', 'Radu Sima', 'inginer', 6300, TO_DATE('2018-07-28', 'YYYY-MM-DD'), 4, 15);

INSERT INTO Angajati (id_angajat, nume, calificare, salariu, data_angajare, id_departament, id_rol)
VALUES ('A030', 'Florin Popescu', 'tehnician', 5300, TO_DATE('2022-03-10', 'YYYY-MM-DD'), 4, 1);




-- Salarii inserate

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (1, 'A001', 24500, 1000, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (2, 'A002', 23500, 1000, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (3, 'A003', 24500, 1000, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (4, 'A004', 22500, 1000, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (5, 'A005', 6300, 400, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (6, 'A006', 6300, 400, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (7, 'A007', 6300, 500, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (8, 'A008', 7500, 500, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (9, 'A009', 5500, 400, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (10, 'A010', 5000, 200, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (11, 'A011', 5000, 100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (12, 'A012', 2000, 100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (13, 'A013', 2100, 100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (14, 'A014', 7500, 400, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (15, 'A015', 5000, 1100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (16, 'A016', 4500, 400, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (17, 'A017', 2000, 100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (18, 'A018', 8500, 300, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (19, 'A019', 6000, 300, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (20, 'A020', 4500, 500, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (21, 'A021', 4500, 300, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (22, 'A022', 8000, 300, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (23, 'A023', 6500, 200, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (24, 'A024', 5000, 100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (25, 'A025', 7600, 400, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (26, 'A026', 2000, 100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (27, 'A027', 2000, 100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (28, 'A028', 2000, 100, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (29, 'A029', 6000, 300, TO_DATE('2025-01-04', 'YYYY-MM-DD'));

INSERT INTO Salarii (id_salariu, id_angajat, salariu_de_baza, bonus, data_incasare)
VALUES (30, 'A030', 5000, 300, TO_DATE('2025-01-04', 'YYYY-MM-DD'));


-- Proiecte inserate


INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (1, 'Reabilitare casa P', 100000, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'), 1);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (2, 'Reabilitare casa P+1', 150000, TO_DATE('2024-12-21', 'YYYY-MM-DD'), TO_DATE('2025-02-04', 'YYYY-MM-DD'), 2);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (3, 'Sediu firma', 200000, TO_DATE('2024-12-11', 'YYYY-MM-DD'), TO_DATE('2025-02-09', 'YYYY-MM-DD'), 3);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (4, 'Gard beton', 250000, TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2025-02-14', 'YYYY-MM-DD'), 4);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (5, 'Casa P+2', 120000, TO_DATE('2024-11-21', 'YYYY-MM-DD'), TO_DATE('2025-02-19', 'YYYY-MM-DD'), 5);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (6, 'Reabilitare sediu', 180000, TO_DATE('2024-11-11', 'YYYY-MM-DD'), TO_DATE('2025-02-24', 'YYYY-MM-DD'), 6);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (7, 'Casa P', 170000, TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2025-02-18', 'YYYY-MM-DD'), 7);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (8, 'Garaj', 140000, TO_DATE('2024-10-22', 'YYYY-MM-DD'), TO_DATE('2025-03-05', 'YYYY-MM-DD'), 8);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (9, 'Bloc P+5', 230000, TO_DATE('2024-10-12', 'YYYY-MM-DD'), TO_DATE('2025-03-10', 'YYYY-MM-DD'), 9);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (10, 'Spalatorie masini', 190000, TO_DATE('2024-10-02', 'YYYY-MM-DD'), TO_DATE('2025-03-15', 'YYYY-MM-DD'), 10);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (11, 'Casa P+2', 160000, TO_DATE('2024-09-22', 'YYYY-MM-DD'), TO_DATE('2025-03-20', 'YYYY-MM-DD'), 11);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (12, 'Garaj', 150000, TO_DATE('2024-09-12', 'YYYY-MM-DD'), TO_DATE('2025-03-25', 'YYYY-MM-DD'), 12);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (13, 'Sediu P+1', 220000, TO_DATE('2024-09-02', 'YYYY-MM-DD'), TO_DATE('2025-03-30', 'YYYY-MM-DD'), 13);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (14, 'Casa P+2', 250000, TO_DATE('2024-08-23', 'YYYY-MM-DD'), TO_DATE('2025-04-04', 'YYYY-MM-DD'), 14);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (15, 'Casa P', 170000, TO_DATE('2024-08-13', 'YYYY-MM-DD'), TO_DATE('2025-04-09', 'YYYY-MM-DD'), 15);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (16, 'Gard BCA', 120000, TO_DATE('2024-08-03', 'YYYY-MM-DD'), TO_DATE('2025-04-14', 'YYYY-MM-DD'), 16);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (17, 'Casa P', 210000, TO_DATE('2024-07-24', 'YYYY-MM-DD'), TO_DATE('2025-04-19', 'YYYY-MM-DD'), 17);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (18, 'Garaj', 230000, TO_DATE('2024-07-14', 'YYYY-MM-DD'), TO_DATE('2025-04-24', 'YYYY-MM-DD'), 18);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (19, 'Spalatorie auto', 190000, TO_DATE('2024-07-04', 'YYYY-MM-DD'), TO_DATE('2025-04-29', 'YYYY-MM-DD'), 19);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (20, 'Bloc P+11', 170000, TO_DATE('2024-06-24', 'YYYY-MM-DD'), TO_DATE('2025-05-04', 'YYYY-MM-DD'), 20);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (21, 'Casa P+1', 140000, TO_DATE('2024-06-14', 'YYYY-MM-DD'), TO_DATE('2025-05-09', 'YYYY-MM-DD'), 21);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (22, 'Reabilitare casa', 160000, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2025-05-14', 'YYYY-MM-DD'), 22);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (23, 'Proiect Psi', 150000, TO_DATE('2024-05-25', 'YYYY-MM-DD'), TO_DATE('2025-05-19', 'YYYY-MM-DD'), 23);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (24, 'Garaj', 250000, TO_DATE('2024-05-15', 'YYYY-MM-DD'), TO_DATE('2025-05-24', 'YYYY-MM-DD'), 24);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (25, 'Casa P', 170000, TO_DATE('2024-05-05', 'YYYY-MM-DD'), TO_DATE('2025-05-29', 'YYYY-MM-DD'), 25);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (26, 'Reabilitare sediu', 220000, TO_DATE('2024-04-25', 'YYYY-MM-DD'), TO_DATE('2025-06-03', 'YYYY-MM-DD'), 26);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (27, 'Bloc P+13', 200000, TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2025-06-08', 'YYYY-MM-DD'), 27);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (28, 'Bloc P+3', 240000, TO_DATE('2024-04-05', 'YYYY-MM-DD'), TO_DATE('2025-06-13', 'YYYY-MM-DD'), 28);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (29, 'Casa P+2', 190000, TO_DATE('2024-03-26', 'YYYY-MM-DD'), TO_DATE('2025-06-18', 'YYYY-MM-DD'), 29);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (30, 'Reabilitare casa', 130000, TO_DATE('2024-03-16', 'YYYY-MM-DD'), TO_DATE('2025-06-23', 'YYYY-MM-DD'), 30);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (31, 'Gard beton', 180000, TO_DATE('2024-03-06', 'YYYY-MM-DD'), TO_DATE('2025-06-28', 'YYYY-MM-DD'), 31);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (32, 'Sopron', 170000, TO_DATE('2024-02-25', 'YYYY-MM-DD'), TO_DATE('2025-07-03', 'YYYY-MM-DD'), 32);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (33, 'Consolidare casa', 160000, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2025-07-08', 'YYYY-MM-DD'), 33);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (34, 'Casa P+1', 250000, TO_DATE('2024-02-05', 'YYYY-MM-DD'), TO_DATE('2025-07-13', 'YYYY-MM-DD'), 34);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (35, 'Casa P', 210000, TO_DATE('2024-01-26', 'YYYY-MM-DD'), TO_DATE('2025-07-18', 'YYYY-MM-DD'), 35);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (36, 'Garaj', 190000, TO_DATE('2024-01-16', 'YYYY-MM-DD'), TO_DATE('2025-07-23', 'YYYY-MM-DD'), 36);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (37, 'Consolidare casa', 240000, TO_DATE('2024-01-06', 'YYYY-MM-DD'), TO_DATE('2025-07-28', 'YYYY-MM-DD'), 37);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (38, 'Consolidare casa', 200000, TO_DATE('2023-12-27', 'YYYY-MM-DD'), TO_DATE('2025-08-02', 'YYYY-MM-DD'), 2);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (39, 'Casa P+1', 180000, TO_DATE('2023-12-17', 'YYYY-MM-DD'), TO_DATE('2025-08-07', 'YYYY-MM-DD'), 3);

INSERT INTO Proiecte (id_proiect, nume, buget, data_incepere, data_limita, id_client) 
VALUES (40, 'Sediu firma', 220000, TO_DATE('2023-12-07', 'YYYY-MM-DD'), TO_DATE('2025-08-12', 'YYYY-MM-DD'), 4);





-- Atribuiri_proiecte inserate

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (1, 120, 1, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (2, 130, 2, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (3, 140, 3, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (4, 110, 4, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (5, 100, 5, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (6, 150, 6, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (7, 120, 7, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (8, 115, 8, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (9, 135, 9, 'A008');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (10, 125, 10, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (11, 110, 11, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (12, 105, 12, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (13, 125, 13, 'A008');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (14, 130, 14, 'A001');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (15, 140, 15, 'A001');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (16, 150, 16, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (17, 135, 17, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (18, 125, 18, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (19, 120, 19, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (20, 110, 20, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (21, 100, 21, 'A001');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (22, 130, 22, 'A008');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (23, 140, 23, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (24, 120, 24, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (25, 115, 25, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (26, 105, 26, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (27, 110, 27, 'A008');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (28, 120, 28, 'A001');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (29, 125, 29, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (30, 130, 30, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (31, 130, 31, 'A001');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (32, 130, 32, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (33, 130, 33, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (34, 130, 34, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (35, 130, 35, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (36, 130, 36, 'A008');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (37, 130, 37, 'A001');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (38, 130, 38, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (39, 130, 39, 'A002');

INSERT INTO Atribuiri_Proiecte (id_atribuire, ore_lucrate, id_proiect, id_director)
VALUES (40, 130, 40, 'A001');


-- Facturi inserate

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (1, 100000, TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'achitat', 1);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (2, 350000, TO_DATE('2024-11-20', 'YYYY-MM-DD'), TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'neachitat', 2);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (3, 380000, TO_DATE('2024-12-10', 'YYYY-MM-DD'), TO_DATE('2024-12-20', 'YYYY-MM-DD'), 'achitat', 3);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (4, 470000, TO_DATE('2024-11-15', 'YYYY-MM-DD'), TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'neachitat', 4);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (5, 120000, TO_DATE('2024-12-05', 'YYYY-MM-DD'), TO_DATE('2024-12-25', 'YYYY-MM-DD'), 'achitat', 5);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (6, 180000, TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2024-12-20', 'YYYY-MM-DD'), 'neachitat', 6);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (7, 170000, TO_DATE('2024-11-30', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD'), 'achitat', 7);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (8, 140000, TO_DATE('2024-11-25', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'neachitat', 8);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (9, 230000, TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2024-12-18', 'YYYY-MM-DD'), 'achitat', 9);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (10, 190000, TO_DATE('2024-11-22', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD'), 'neachitat', 10);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (11, 160000, TO_DATE('2024-11-28', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'achitat', 11);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (12, 150000, TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2024-12-20', 'YYYY-MM-DD'), 'neachitat', 12);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (13, 220000, TO_DATE('2024-12-03', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'achitat', 13);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (14, 250000, TO_DATE('2024-11-18', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD'), 'neachitat', 14);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (15, 170000, TO_DATE('2024-12-02', 'YYYY-MM-DD'), TO_DATE('2024-12-20', 'YYYY-MM-DD'), 'achitat', 15);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (16, 120000, TO_DATE('2025-01-02', 'YYYY-MM-DD'), TO_DATE('2025-01-15', 'YYYY-MM-DD'), 'neachitat', 16);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (17, 210000, TO_DATE('2025-01-03', 'YYYY-MM-DD'), TO_DATE('2025-01-20', 'YYYY-MM-DD'), 'achitat', 17);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (18, 230000, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'neachitat', 18);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (19, 190000, TO_DATE('2025-01-02', 'YYYY-MM-DD'), TO_DATE('2025-01-12', 'YYYY-MM-DD'), 'achitat', 19);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (20, 170000, TO_DATE('2025-01-04', 'YYYY-MM-DD'), TO_DATE('2025-01-30', 'YYYY-MM-DD'), 'neachitat', 20);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (21, 140000, TO_DATE('2025-01-03', 'YYYY-MM-DD'), TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'achitat', 21);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (22, 160000, TO_DATE('2025-01-04', 'YYYY-MM-DD'), TO_DATE('2025-01-28', 'YYYY-MM-DD'), 'neachitat', 22);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (23, 150000, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-20', 'YYYY-MM-DD'), 'achitat', 23);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (24, 250000, TO_DATE('2025-01-02', 'YYYY-MM-DD'), TO_DATE('2025-01-22', 'YYYY-MM-DD'), 'neachitat', 24);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (25, 170000, TO_DATE('2025-01-03', 'YYYY-MM-DD'), TO_DATE('2025-01-15', 'YYYY-MM-DD'), 'achitat', 25);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (26, 220000, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-29', 'YYYY-MM-DD'), 'neachitat', 26);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (27, 200000, TO_DATE('2025-01-02', 'YYYY-MM-DD'), TO_DATE('2025-01-18', 'YYYY-MM-DD'), 'achitat', 27);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (28, 240000, TO_DATE('2025-01-03', 'YYYY-MM-DD'), TO_DATE('2025-01-23', 'YYYY-MM-DD'), 'neachitat', 28);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (29, 190000, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-21', 'YYYY-MM-DD'), 'achitat', 29);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (30, 130000, TO_DATE('2025-01-04', 'YYYY-MM-DD'), TO_DATE('2025-01-26', 'YYYY-MM-DD'), 'neachitat', 30);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (31, 180000, TO_DATE('2025-01-02', 'YYYY-MM-DD'), TO_DATE('2025-01-17', 'YYYY-MM-DD'), 'achitat', 31);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (32, 170000, TO_DATE('2025-01-03', 'YYYY-MM-DD'), TO_DATE('2025-01-19', 'YYYY-MM-DD'), 'neachitat', 32);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (33, 160000, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-28', 'YYYY-MM-DD'), 'achitat', 33);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (34, 250000, TO_DATE('2025-01-02', 'YYYY-MM-DD'), TO_DATE('2025-01-31', 'YYYY-MM-DD'), 'neachitat', 34);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (35, 210000, TO_DATE('2025-01-03', 'YYYY-MM-DD'), TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'achitat', 35);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (36, 190000, TO_DATE('2025-01-04', 'YYYY-MM-DD'), TO_DATE('2025-01-22', 'YYYY-MM-DD'), 'neachitat', 36);

INSERT INTO Facturi (id_factura, valoare, data_emitere, data_scadenta, statut, id_client)
VALUES (37, 240000, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-20', 'YYYY-MM-DD'), 'achitat', 37);




-- Stergere tabele

DROP TABLE Atribuiri_Proiecte;
DROP TABLE Salarii;
DROP TABLE Proiecte;
DROP TABLE Angajati;
DROP TABLE Departamente;
DROP TABLE Facturi;
DROP TABLE Clienti;
DROP TABLE Roluri;





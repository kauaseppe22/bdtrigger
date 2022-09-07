CREATE TABLE IF NOT EXISTS pacientes(
    id_pac          int generated always as identity PRIMARY KEY,
    nome            varchar(40) NOT NULL,
    sexo            varchar(1),
    obito           boolean,
    insertedAt      TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS profissionais(
    id_profiss      int generated always as identity PRIMARY KEY,
    nome            varchar(50),
    insertedAt      TIMESTAMP NOT NULL DEFAULT NOW()
);



CREATE TABLE IF NOT EXISTS especialidades(
    id_especialidades int generated always as identity PRIMARY KEY,
    nome            varchar(50),
    insertedAt      TIMESTAMP NOT NULL DEFAULT NOW()
);



CREATE TABLE IF NOT EXISTS consultas(
    id_consultas    int generated always as identity PRIMARY KEY,
    id_especialidades integer,
    id_pac          integer,
    id_profiss      integer,
    insertedAt      TIMESTAMP NOT NULL DEFAULT NOW()
);



CREATE TABLE IF NOT EXISTS obitos(
        id_obitos   int generated always as identity PRIMARY KEY,
    obs             text
);
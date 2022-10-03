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


ALTER TABLE consultas  
   ADD CONSTRAINT       FkEspecialidadeDaConsulta
      FOREIGN KEY       (id_especialidades) 
      REFERENCES        especialidades (id_especialidades);




ALTER TABLE consultas  
   ADD CONSTRAINT       FkProfissionalDaConsulta
      FOREIGN KEY       (id_profiss) 
      REFERENCES        profissionais (id_profiss);






INSERT INTO especialidades (nome ) VALUES ('urologista');
INSERT INTO especialidades (nome ) VALUES ('ginecologista');
INSERT INTO especialidades (nome ) VALUES ('clinica geral');



INSERT INTO profissionais(nome) VALUES ('DrFeelGoodUro');
INSERT INTO profissionais(nome) VALUES ('DrJekyllGineco');
INSERT INTO profissionais(nome) VALUES ('DrRay');



INSERT INTO pacientes (nome , sexo , obito) VALUES ('Ada Lovelace','f','f');
INSERT INTO pacientes (nome , sexo , obito) VALUES ('Donald Knuth','m','f');
INSERT INTO pacientes (nome , sexo , obito) VALUES ('Grace Hopper','f','f');
INSERT INTO pacientes (nome , sexo , obito) VALUES ('Dennis Ritchie','m','f');



INSERT INTO consultas (id_especialidades , id_pac , id_profiss) VALUES ('1','2','3');
INSERT INTO consultas (id_especialidades , id_pac , id_profiss) VALUES ('3','1','2');
INSERT INTO consultas (id_especialidades , id_pac , id_profiss) VALUES ('2','3','2');
INSERT INTO consultas (id_especialidades , id_pac , id_profiss) VALUES ('1','3','2');



SELECT * FROM  especialidades;
SELECT * FROM  profissionais;
SELECT * FROM  pacientes;
SELECT * FROM  consultas;


create OR REPLACE function trgValidaDadosConsulta()
RETURNS trigger AS $trgValidaDadosConsulta$;


DECLARE 
linhadopacinserido record;
espec_row record;

--counter integer := 1;
BEGIN
SELECT
    INTO linhadopacinserido *
FROM
    pacientes as p
where
    p.id = NEW.pac_id;

SELECT
    INTO espec_row *
FROM
    especialidades as esp
where
    esp.id = NEW.especialidade_id;

IF linhadopacinserido.sexo = 'm'
AND espec_row.nome = 'ginecologista' THEN RAISE EXCEPTION 'Ginecologista apenas para pacientes do sexo feminino';

ELSEIF linhadopacinserido.sexo = 'f'
AND espec_row.nome = 'urologista' THEN RAISE EXCEPTION 'Urologista apenas para pacientes do sexo masculino';

END IF;

RETURN NEW;

END;

$ trgValidaDadosConsulta $ LANGUAGE plpgsql;

CREATE TRIGGER ValidaDadosConsulta AFTER
INSERT
    OR
UPDATE
    ON consultas FOR EACH ROW --FOR EACH STATEMENT
    EXECUTE PROCEDURE trgValidaDadosConsulta();

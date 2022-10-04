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




	
CREATE OR REPLACE FUNCTION ValidaDadosConsulta()
RETURNS TRIGGER AS $$
DECLARE
paciente_row	RECORD;
especialidade_row RECORD;
BEGIN

        SELECT INTO paciente_row
        *  FROM pacientes as p 
		where id_pacientes = NEW.id_pacientes;

        SELECT INTO especialidade_row
        *  FROM especialidades as e
		where id_especialidades = NEW.id_especialidades;

        IF paciente_row.sexo = 'm'
		AND especialidade_row.especialidade = 'ginecologista' THEN
           RAISE EXCEPTION 'Ginecologista apenas para pacientes do sexo feminino';
        ELSEIF paciente_row.sexo = 'f' 
		AND especialidade_row.especialidade = 'urologista' THEN
           RAISE EXCEPTION 'Urologista apenas para pacientes do sexo masculino';
        END IF;
        
        
        --AUDITA MODIFICACAO 
        NEW.last_time_updated := current_timestamp;
        NEW.last_user_updated := paciente_row.nomePaciente;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

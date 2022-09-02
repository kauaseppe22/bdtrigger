create table pacientes(
    id_pacientes int identity(1,1) PRIMARY KEY,
    nome varchar(40),
    sexo varchar (1),
    obito bit,
    );

create table profissionais(
    id_profissionais int identity(1,1) PRIMARY KEY,
    nomeProfissional varchar(50),
	insertdat datetime,
    );

create table especialidades(
    id_especialidades int identity(1,1) PRIMARY KEY,
    nomeEspecialidade varchar(50),
	insertdat datetime,
);

create table consultas (
    id_consultas int identity(1,1) PRIMARY KEY,
    id_especialidades int,
    id_pacientes int,
    id_profissionais int,
	insertdat datetime
)

create table obitos (
     id_obitos int identity(1,1) PRIMARY KEY, 
    obs text);

ALTER TABLE consultas
ADD CONSTRAINT FKEspecialidadeDaConsulta FOREIGN KEY
(id_especialidades)
REFERENCES
especialidades (id_especialidades);

ALTER TABLE consultas
ADD CONSTRAINT FKProfissionalDaConsulta FOREIGN KEY
(id_profissionais)
REFERENCES profissionais(id_profissionais);

insert into pacientes (nome, sexo, obito)
values ('cleito','m',1), ('clebs','m',0), ('bruna','f',1)

insert into profissionais(nomeProfissional, insertdat)
values ('paulo',getdate()), ('wagner',getdate()), ('jorge',getdate())

insert into especialidades (nomeEspecialidade, insertdat)
values ('ginecologista', getdate()), ('urologista',getdate()), ('clinico geral',getdate())

insert into consultas (id_especialidades, id_pacientes, id_profissionais, insertdat)
values (3,1,1,getdate()), (2,1,3,getdate()), (2,3,3,getdate())

CREATE OR REPLACE  FUNCTION trgValidadeDadosConsulta() RETURNS trigger $trgValidadeDadosConsulta;

DECLARE
pac_row record;
espec_row record;
BEGIN
    RAISE NOTICE 'nossa trigger rodou!!!';
RETURN new;

END;
$trgValidadeDadosConsulta LANGUAGE plpgsql;

CREATE TRIGGER ValidadeDadosConsulta
BEFORE INSERT OR UPDATE ON consultas
FOR EACH ROW
EXECUTE PROCEDURE trgValidadeDadosConsulta();

select * from pacientes
select * from profissionais
select * from especialidades
select * from consultas

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

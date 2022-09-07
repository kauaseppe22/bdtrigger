create OR REPLACE function trgValidaDadosConsulta()
RETURNS trigger AS $trgValidaDadosConsulta$;

BEGIN
raise notice 'o trigger rodou!!';
RETURN NEW;
END
$trgValidaDadosConsulta$ LANGUAGE plpgsql;

create TRIGGER validaDadosConsulta
after insert or UPDATE on consultas
FOR each ROW
EXECUTE PROCEDURE trgValidaDadosConsulta();


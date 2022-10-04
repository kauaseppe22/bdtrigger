
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

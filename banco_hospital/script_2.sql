ALTER TABLE consultas  
   ADD CONSTRAINT       FkEspecialidadeDaConsulta
      FOREIGN KEY       (id_especialidades) 
      REFERENCES        especialidades (id_especialidades);




ALTER TABLE consultas  
   ADD CONSTRAINT       FkProfissionalDaConsulta
      FOREIGN KEY       (id_profiss) 
      REFERENCES        profissionais (id_profiss);


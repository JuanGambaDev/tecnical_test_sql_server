USE PermitSystem
GO

INSERT INTO Company
(
    compa_name,                        -- Nombre legal completo de la compañía
    compa_tradename,                   -- Nombre comercial o marca de la compañía
    compa_doctype,                     -- Tipo de documento de identificación de la compañía
    compa_docnum,                      -- Número de identificación fiscal o documento legal de la compañía
    compa_address,                     -- Dirección física de la compañía
    compa_city,                        -- Ciudad donde está ubicada la compañía
    compa_state,                       -- Departamento o estado donde está ubicada la compañía
    compa_country,                     -- País donde está ubicada la compañía
    compa_industry,                    -- Sector industrial al que pertenece la compañía
    compa_phone,                       -- Número de teléfono principal de la compañía
    compa_email,                       -- Dirección de correo electrónico principal de la compañía
    compa_active               
) 
VALUES
(
    'Stone ERP',
    'Stone ERP',
    'NI',
    '800.219.325-2',
    'Calle 98 A # 51- 37',
    'Bogota D.C.',
    'Distrito Capital',
    'Colombia',
    'Software',
    '16180141',
    'ventas@stone.com.co',
    1
);




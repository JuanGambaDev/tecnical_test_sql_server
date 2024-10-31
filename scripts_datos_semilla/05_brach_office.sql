USE PermitSystem
GO

INSERT INTO BranchOffice 
(
    company_id, broff_name, 
    broff_code, broff_address, 
    broff_city, broff_state, 
    broff_country, broff_phone, 
    broff_email, 
    broff_active
)
VALUES
(
    1, 
    'Sucursal Centro', 
    '001', 
    'Carrera 7 #10-20', 
    'Bogotá', 
    'Cundinamarca', 
    'Colombia', 
    '3007654321', 
    'centro@abc.com', 
    1
),
(
    1, 
    'Sucursal Norte', 
    '002', 
    'Calle 50 #80-90', 
    'Medellín', 
    'Antioquia', 
    'Colombia', 
    '3107654321', 
    'norte@xyz.com', 
    1
);


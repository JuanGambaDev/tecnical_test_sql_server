USE PermitSystem
GO

INSERT INTO EntityCatalog 
(
    entit_name, 
    entit_descrip, 
    entit_active, 
    entit_config
) 
VALUES
(
    'Sucursal', 
    'Catálogo de sucursales del sistema', 
    1, 
    NULL
),
(
    'Centro de Costos', 
    'Catálogo de centros de costo del sistema', 
    1, 
    NULL
);
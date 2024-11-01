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
    'BranchOffice', 
    'Catálogo de sucursales del sistema', 
    1, 
    NULL
),
(
    'CostCenter', 
    'Catálogo de centros de costo del sistema', 
    1, 
    NULL
);


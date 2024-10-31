USE PermitSystem
GO

INSERT INTO Permission 
(
    name, 
    description, 
    can_create, 
    can_read, 
    can_update, 
    can_delete, 
    can_import, 
    can_export
) 
VALUES
(
    'Crear Registros',
    'Permite crear nuevos registros',
    1,
    0, 
    0, 
    0, 
    0, 
    0),
(
    'Leer Registros', 
    'Permite leer registros existentes', 
    0, 
    1, 
    0, 
    0, 
    0, 
    0
),
(
    'Actualizar Registros', 
    'Permite modificar registros existentes', 
    0, 
    0, 
    1, 
    0, 
    0, 
    0
),
(
    'Eliminar Registros', 
    'Permite eliminar registros existentes', 
    0, 
    0, 
    0, 
    1, 
    0, 
    0
);

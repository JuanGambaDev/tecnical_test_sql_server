
CREATE TRIGGER trg_check_user_is_admin
ON [User]
AFTER INSERT, UPDATE
AS
BEGIN
    -- Verificar si se inserta o actualiza un usuario con admin
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE user_is_admin = 1 
          AND (user_is_active = 1 )  -- Verificar que el usuario está activo
    )
    BEGIN
       DECLARE @UserId BIGINT,
                @EntityCatalogID BIGINT, -- Aquí asigna el ID de la entidad correspondiente
                @PermissionID BIGINT     -- Aquí asigna el ID de permiso correspondiente
        
    END 
END;


SELECT * FROM Role

select * FROM Permission

SELECT * FROM EntityCatalog
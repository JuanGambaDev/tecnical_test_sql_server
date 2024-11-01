USE PermitSystem
GO

-----------------------------------------
-- Author: Juan Gamba
-- Date: October 31, 2024
-- Description: This storage procedure assigns or revokes permission (for example, read or modify) on an entire entity to a role.
---------------------------------------

CREATE OR ALTER PROCEDURE [sp_assign_entity_permission_user]
--DECLARE
    @RoleId BIGINT,
    @EntityCatalogID BIGINT, -- Id Of entity (e.g BrachOffice o CostCenter)
    @PermissionID BIGINT,
    @Include BIT = 1 -- 1 assign, 0 revoke
AS
BEGIN
    SET NOCOUNT ON; -- Evita el conteo de filas afectadas

    BEGIN TRY
        BEGIN TRANSACTION; -- Iniciar la transacción

        -- Utilizar MERGE para simplificar la lógica de inserción y actualización
        MERGE INTO PermiRole AS target
        USING (SELECT @RoleId AS role_id, @EntityCatalogID AS entitycatalog_id, @PermissionID AS permission_id) AS source
        ON target.role_id = source.role_id 
           AND target.entitycatalog_id = source.entitycatalog_id 
           AND target.permission_id = source.permission_id
        WHEN MATCHED THEN
            UPDATE SET perol_include = @Include
        WHEN NOT MATCHED THEN
            INSERT (role_id, entitycatalog_id, permission_id, perol_include)
            VALUES (source.role_id, source.entitycatalog_id, source.permission_id, @Include);

        COMMIT TRANSACTION; -- Confirmar la transacción
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; -- Deshacer la transacción en caso de error

        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState); -- Propagar el error
    END CATCH;
END;
GO

select * from Permission
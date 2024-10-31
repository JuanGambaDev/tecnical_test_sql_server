USE PermitSystem
GO

-----------------------------------------
-- Author: Juan Gamba
-- Date: October 31, 2024
-- Description: This storage procedure allows you to assign or revoke permissions on a specific record in an entity (for example, a user on a specific branch).
---------------------------------------

CREATE OR ALTER PROCEDURE sp_assign_record_permission_user
    @UserID BIGINT,
    @EntityCatalogID BIGINT,
    @RecordID BIGINT, -- ID específico del registro en la entidad (ej. ID de una sucursal específica)
    @PermissionID BIGINT,
    @Include BIT = 1 -- 1 para asignar, 0 para revocar
AS
BEGIN
    SET NOCOUNT ON; -- Evita el conteo de filas afectadas

    BEGIN TRY
        BEGIN TRANSACTION; -- Iniciar la transacción

        -- Utilizar MERGE para simplificar la lógica de inserción y actualización
        MERGE INTO PermiUserRecord AS target
        USING (SELECT @UserID AS usercompany_id, @EntityCatalogID AS entitycatalog_id, @PermissionID AS permission_id, @RecordID AS peusr_record) AS source
        ON target.usercompany_id = source.usercompany_id 
           AND target.entitycatalog_id = source.entitycatalog_id 
           AND target.permission_id = source.permission_id
           AND target.peusr_record = source.peusr_record
        WHEN MATCHED THEN
            UPDATE SET peusr_include = @Include
        WHEN NOT MATCHED THEN
            INSERT (usercompany_id, entitycatalog_id, permission_id, peusr_record, peusr_include)
            VALUES (source.usercompany_id, source.entitycatalog_id, source.permission_id, source.peusr_record, @Include);

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


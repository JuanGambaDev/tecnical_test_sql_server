USE PermitSystem
GO

-- Asignación de permiso a nivel de entidad completa
DECLARE @UserID BIGINT = 1; -- Usuario de prueba
DECLARE @EntityCatalogID BIGINT = 1; -- ID de entidad Sucursal o Centro de Costos
DECLARE @PermissionID BIGINT = 2; -- Permiso de prueba, por ejemplo "Lectura"
DECLARE @Include BIT = 1;

-- Ejecución del procedimiento de asignación
EXEC sp_assign_entity_permission_user @UserID, @EntityCatalogID, @PermissionID, @Include;

-- Verificar que el permiso se haya asignado
IF EXISTS (
    SELECT 1 FROM PermiUser
    WHERE usercompany_id = @UserID AND entitycatalog_id = @EntityCatalogID AND permission_id = @PermissionID AND peusr_include = 1
)
    PRINT 'Test Pass: Permiso asignado a nivel de entidad correctamente.';
ELSE
    PRINT 'Test Fail: Permiso no asignado a nivel de entidad.';

-- Revocación de permiso
SET @Include = 0;
EXEC sp_assign_entity_permission_user @UserID, @EntityCatalogID, @PermissionID, @Include;

-- Verificar que el permiso se haya revocado
IF NOT EXISTS (
    SELECT 1 FROM PermiUser
    WHERE usercompany_id = @UserID AND entitycatalog_id = @EntityCatalogID AND permission_id = @PermissionID AND peusr_include = 1
)
    PRINT 'Test Pass: Permiso revocado correctamente a nivel de entidad.';
ELSE
    PRINT 'Test Fail: Permiso no revocado a nivel de entidad.';

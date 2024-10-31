USE PermitSystem
GO

-----------------------------------------
-- Author: Juan Gamba
-- Date: October 31, 2024
-- Description: This storage procedure checks whether a user has permission to an entire entity or a specific record within that entity..
---------------------------------------

CREATE OR ALTER PROCEDURE CheckPermissionForUser
    @UserID BIGINT,
    @EntityCatalogID BIGINT,
    @PermissionID BIGINT,
    @RecordID BIGINT = NULL, -- NULL si es a nivel de entidad completa
    @HasPermission BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON; -- Evita el conteo de filas afectadas

    DECLARE @EntityPermission BIT;
    DECLARE @RecordPermission BIT;

    -- Verificar permiso a nivel de entidad completa
    SELECT @EntityPermission = peusr_include 
    FROM PermiUser 
    WHERE usercompany_id = @UserID 
      AND entitycatalog_id = @EntityCatalogID 
      AND permission_id = @PermissionID;

    -- Verificar permiso a nivel de registro individual si @RecordID no es NULL
    IF @RecordID IS NOT NULL
    BEGIN
        SELECT @RecordPermission = peusr_include
        FROM PermiUserRecord
        WHERE usercompany_id = @UserID 
          AND entitycatalog_id = @EntityCatalogID 
          AND permission_id = @PermissionID 
          AND peusr_record = @RecordID;
    END

    -- Determinar si el usuario tiene el permiso
    SET @HasPermission = CASE 
        WHEN @RecordID IS NOT NULL AND @RecordPermission = 1 THEN 1
        WHEN @EntityPermission = 1 THEN 1
        ELSE 0
    END;
END;
GO


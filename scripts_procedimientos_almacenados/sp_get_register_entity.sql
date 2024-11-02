USE PermitSystem;
GO

-- ===================================================
-- Author: Juan Gamba
-- Date: Noviembre 01, 2024
-- Description: Este procedimiento almacenado obtiene de forma dinamica el listado de registros de una entidad a partir del id de la entidad.
--              Ejecutar el procedimiento para probar los resultados: 
--              EXEC sp_GetRegisterEntity @entityId = 2;
-- ===================================================

CREATE OR ALTER PROCEDURE sp_GetRegisterEntity
    @entityId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener registros de una entidad de forma dinámica
    DECLARE @entityName NVARCHAR(255);
    DECLARE @idColumn NVARCHAR(255);
    DECLARE @nameColumn NVARCHAR(255);
    DECLARE @sql NVARCHAR(MAX);

     -- Obtener el nombre de la entidad de EntityCatalog
    SELECT @entityName = entit_name
    FROM EntityCatalog
    WHERE id_entit = @entityId; 

    -- Verificar si el nombre de la entidad no es nulo
    IF @entityName IS NOT NULL
    BEGIN
        SELECT TOP 1 
            @idColumn = c1.name, 
            @nameColumn = c2.name
        FROM sys.columns c1
        JOIN sys.tables t ON c1.object_id = t.object_id
        JOIN sys.columns c2 ON c2.object_id = t.object_id 
            AND c2.name LIKE '%name%'  -- Asumiendo que el nombre de la columna incluye 'name'
        WHERE t.name = @entityName
        AND c1.is_identity = 1;  

        -- Verificar si se encontró la columna ID y Name
        IF @idColumn IS NOT NULL AND @nameColumn IS NOT NULL
        BEGIN
            -- Crear consulta para insertar datos
            SET @sql = N'
            SELECT 
                ' + QUOTENAME(@idColumn) + ', 
                ' + QUOTENAME(@nameColumn) + ' 
            FROM ' + QUOTENAME(@entityName) + ';';

            EXEC sp_executesql @sql;
        END
        ELSE
        BEGIN
            PRINT 'No se encontró una columna ID o Name para la tabla.';
        END
    END
    ELSE
    BEGIN
        PRINT 'El nombre de la entidad es nulo o no existe.';
    END

END
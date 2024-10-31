USE PermitSystem
GO

INSERT INTO PermiRoleRecord 
(
    role_id, 
    permission_id, 
    entitycatalog_id, 
    perrc_record, 
    perrc_include
) 
VALUES
(
    3, 
    1, 
    1, 
    1, 
    1
),
(
    4, 
    2, 
    2, 
    2, 
    1
);


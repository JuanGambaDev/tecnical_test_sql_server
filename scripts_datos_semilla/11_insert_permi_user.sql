USE PermitSystem
GO

INSERT INTO PermiUser 
(
    usercompany_id, 
    permission_id, 
    entitycatalog_id, 
    peusr_include
) 
VALUES
(1, 1, 1, 1),
(1, 2, 1, 1),
(1, 3, 1, 1),
(1, 4, 1, 1),
(1, 5, 1, 1),
(1, 6, 1, 1),
(1, 1, 2, 1),
(1, 2, 2, 1),
(1, 3, 2, 1),
(1, 4, 2, 1),
(1, 5, 2, 1),
(1, 6, 2, 1),
(2, 2, 1, 1),
(2, 3, 1, 1),
(2, 2, 2, 1),
(2, 3, 2, 1),
(2, 4, 2, 1),
(3, 1, 2, 1),
(3, 2, 2, 1);




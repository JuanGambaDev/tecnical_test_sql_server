USE PermitSystem
GO

INSERT INTO CostCenter 
(
    company_id, 
    cosce_parent_id, 
    cosce_code, 
    cosce_name, 
    cosce_description, 
    cosce_budget, 
    cosce_level, 
    cosce_active
) 
VALUES
(
    1, 
    NULL, 
    'CC01', 
    'Centro de Costo A', 
    'Centro de costo para operaciones A', 
    1000000.00, 
    1, 
    1
),
(
    1, 
    NULL, 
    'CC02', 
    'Centro de Costo B', 
    'Centro de costo para operaciones B', 
    2000000.00, 
    1, 
    1
);



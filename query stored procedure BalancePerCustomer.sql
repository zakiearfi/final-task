CREATE PROCEDURE BalancePerCustomer
    @name VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.CustomerName,
        a.AccountType,
        a.Balance,
        (a.Balance + 
            ISNULL(
                SUM(
                    CASE 
                        WHEN ft.TransactionType = 'Deposit' THEN ft.Amount
                        ELSE -ft.Amount
                    END
                ), 0
            )
        ) AS CurrentBalance
    FROM 
        DimCustomer c
    INNER JOIN 
        DimAccount a ON c.CustomerID = a.CustomerID
    LEFT JOIN 
        FactTransaction ft ON a.AccountID = ft.AccountID
    WHERE 
        c.CustomerName LIKE '%' + @name + '%'
        AND a.Status = 'Active'
    GROUP BY 
        c.CustomerName,
        a.AccountType,
        a.Balance,
        a.AccountID
    ORDER BY 
        c.CustomerName,
        a.AccountType;
END;
GO

-- For the execution:
EXEC BalancePerCustomer @name='Shelly'
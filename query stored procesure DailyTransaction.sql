CREATE PROCEDURE DailyTransaction
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        CONVERT(DATE, TransactionDate) AS [Date],
        COUNT(*) AS TotalTransactions,
        SUM(Amount) AS TotalAmount
    FROM 
        FactTransaction
    WHERE 
        TransactionDate BETWEEN @start_date AND @end_date
    GROUP BY 
        CONVERT(DATE, TransactionDate)
    ORDER BY 
        [Date] ASC;
END;
GO

EXEC DailyTransaction @start_date='2024-01-18', @end_date='2024-01-21'
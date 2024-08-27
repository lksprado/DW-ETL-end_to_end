
  create view "postgres"."public_datamart"."dm_commodities__dbt_tmp"
    
    
  as (
    with commodities as ( 
    SELECT
        data,
        ticker_code,
        valor_fechamento
    FROM "postgres"."public_staging"."stg_commodities"
),

movimentacao as (
    SELECT
        data,
        ticker_code,
        action,
        quantidade
    FROM
        "postgres"."public_staging"."stg_commodities_trade"
),

joined as (
    SELECT
        c.data,
        c.ticker_code,
        c.valor_fechamento,
        m.quantidade,
        (m.quantidade*c.valor_fechamento) as valor, 
        CASE 
            WHEN m.action = 'sell' then (m.quantidade * c.valor_fechamento)  
            ELSE -(m.quantidade * c.valor_fechamento)
        END as ganho
    FROM
        commodities c 
    INNER JOIN
        movimentacao m
    ON c.data = m.data 
    AND c.ticker_code = m.ticker_code
),

last_day as ( 
    SELECT 
        max(data) as max_date
    FROM joined
),

latest_day_report as (
    SELECT
        l.max_date,
        j.ticker_code, 
        j.quantidade,
        j.valor,
        j.ganho
    FROM joined j 
    INNER JOIN last_day l 
    ON l.max_date = j.data 
)

SELECT * FROM latest_day_report
  );
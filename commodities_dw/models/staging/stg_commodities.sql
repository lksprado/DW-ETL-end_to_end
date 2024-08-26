-- IMPORT
with source as (
    select 
    "Date",
    "Close",
    "ticker"
    from {{source('postgres','commodities')}} -- NOTACAO JINJA NOME DO SCHEMA E NOME DA TABELA
),

-- RENAMED

renamed as (
    SELECT
        cast("Date" as date) as data,
        "Close" as valor_fechamento,
        ticker as ticker_code
    
    from source
)

select * from renamed
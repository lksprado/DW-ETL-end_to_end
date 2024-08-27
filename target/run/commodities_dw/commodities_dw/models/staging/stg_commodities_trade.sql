
  create view "postgres"."public_staging"."stg_commodities_trade__dbt_tmp"
    
    
  as (
    -- IMPORT
with source as (
    select 
    "data",
    "action",
    "quantity",
    "ticker_code"
    from "postgres"."public"."commodities_trade" -- NOTACAO JINJA NOME DO SCHEMA E NOME DA TABELA
),


-- RENAMED

renamed as (
    SELECT
        cast("data" as date) as data,
        "action",
        quantity as quantidade,
        ticker_code    
    from source
)

select * from renamed
  );
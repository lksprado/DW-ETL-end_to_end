
  create view "postgres"."public_staging"."stg_commodities__dbt_tmp"
    
    
  as (
    -- IMPORT
with source as (
    select 
    "Date",
    "Close",
    "ticker"
    from "postgres"."public"."commodities" -- NOTACAO JINJA NOME DO SCHEMA E NOME DA TABELA
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
  );
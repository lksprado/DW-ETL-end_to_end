# IMPORT
import yfinance as yf 
import pandas as pd 
import os 
from dotenv import load_dotenv
from sqlalchemy import create_engine
from urllib.parse import quote_plus
load_dotenv()

# IMPORT VENV
DB_HOST=os.getenv('DB_HOST_PROD')
DB_PORT=os.getenv('DB_PORT_PROD')
DB_NAME=os.getenv('DB_NAME_PROD')
DB_USER=os.getenv('DB_USER_PROD')
DB_PASS=os.getenv('DB_PASS_PROD')
DB_SCHEMA=os.getenv('DB_SCHEMA_PROD')
#DB_THREADS=os.getenv('DB_THREADS_PROD') 
#DBT_PROFILES_DIR=os.getenv('DBT_PROFILES_DIR')


DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"


def buscar_commodities(ticker,periodo='5y'): 
    dados = yf.Ticker(ticker).history(period=periodo)[['Close']]
    dados['ticker'] = ticker
    return dados

def buscar_todas_commodities(commodities):
    todos_dados = [] 
    for ticker in commodities:
        dados = buscar_commodities(ticker)
        todos_dados.append(dados)
    return pd.concat(todos_dados)

def load_to_pg(df, schema='public'):
    engine = create_engine(DATABASE_URL)
    df.to_sql('commodities',engine, if_exists='replace', index_label='Date', schema=schema)
    

if __name__=="__main__":
    commodities= ['CL=F', 'GC=F', 'ZS=F']
    dados_concatenados = buscar_todas_commodities(commodities)
    load_to_pg(dados_concatenados)
    
    
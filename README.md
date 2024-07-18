# TrabalhoFinalBDD2
##  Grupo: Valt 21
- Matheus Henrique Assunçao de Medeiros
- Caio Victor Silvério Sobral
- Francisco Geibson Saraiva De Oliveira Frutuoso
- Vitor elbert filgueira lima
- Gustavo Medeiros de Oliveira
## Descriçao
Tabalho final da disciplina Banco de Dados 2. Tema: Replicação e Shard com PostgreSQL

## Tarefa: 
Pesquisa sobre o tema proposto e apresentar um seminário.
O seminário deve apresentar um caso prático e elaborar slides que permitam ao leitor compreender replicar o caso prático. Deve ser fornecido um repositório no github com os scripts, programas e documentação do projeto, que deve rodar em container Docker/Podman.

### Passo a passo Replica
1. Subir o Container PostgreSQL
 ```sh
  docker run --name replica -e POSTGRES_PASSWORD=12345 -p 5432:5432 -d postgres
   ```
2. Preparar o Banco de Dados Local (Servidor Principal)

  Editar postgresql.conf:
  ```sh
  Ajuste wal_level para logical, max_replication_slots e max_wal_senders.
  conf
  wal_level = logical
  max_replication_slots = 4
  max_wal_senders = 4
```
  Editar pg_hba.conf:

  Adicione a linha para permitir conexões do container:
   ```sh
  conf
  host replication replica 192.168.56.1/32 trust
  ```
  Reiniciar o Serviço PostgreSQL:
   ```sh
  net stop postgresql-x64-16
  net start postgresql-x64-16
  ``` 
3. Configurar o Banco de Dados Principal
  Criar Banco de Dados e Usuário:
 ```sh
  CREATE DATABASE primary_db;
  CREATE USER replica WITH REPLICATION PASSWORD '12345'; 
 ``` 
  Conceder Permissões na Tabela:
 ```sh
  GRANT SELECT ON TABLE usuarios TO replica;
 ``` 
  Criar a Publicação:
 ```sh
  CREATE PUBLICATION my_publication FOR ALL TABLES;
 ```
  
4. Configurar a Réplica
  Conectar ao Banco de Dados no Container:
 ```sh
  docker exec -it replica psql -U postgres
 ```
  Criar a Assinatura na Réplica:
 ```sh
  CREATE SUBSCRIPTION my_subscription
     CONNECTION 'host=192.168.56.1 dbname=primary_db user=replica password=12345'
     PUBLICATION my_publication;
 ```
  Verificar Tabelas na Réplica:
 ```sh
  \dt
  SELECT * FROM usuarios;
 ```
  Verificação e Solução de Problemas
  Erro de Permissão:
  Certifique-se de que as permissões foram concedidas corretamente no servidor principal e que foram replicadas.
  Sincronizar Permissões:
  Execute no banco de dados da réplica:
 ```sh
  SELECT pg_logical_slot_get_changes('my_subscription', NULL, NULL);
 ```
### Passo a passo Shard

Construir as Imagens Docker:

Para o primeiro contêiner:

 ```sh
Copiar código
docker build -t my_postgres -f Dockerfile .
 ```
Para o segundo contêiner:
 ```sh
Copiar código
docker build -t my_postgres_v2 -f Dockerfile .
 ```
Iniciar os Contêineres:
Primeiro contêiner:

 ```sh
docker run --name my_postgres_container -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydatabase -p 5432:5432 -d my_postgres
 ```
Segundo contêiner:

 ```sh
docker run --name my_postgres_container_v2 -e POSTGRES_USER=newuser -e POSTGRES_PASSWORD=newpassword -e POSTGRES_DB=newdatabase -p 5433:5432 -d my_postgres_v2
 ```
Copiar e Executar os Scripts SQL:

Para o primeiro contêiner:

 ```sh
docker cp init.sql my_postgres_container:/docker-entrypoint-initdb.d/
 ```
Para o segundo contêiner:

 ```sh
docker cp insert_first_10_users.sql my_postgres_container_v2:/docker-entrypoint-initdb.d/
 ```
Os scripts SQL serão executados durante a inicialização dos contêineres.

Configurar o Sharding em Tempo Real:

No primeiro contêiner, configure o acesso ao segundo contêiner usando Foreign Data Wrapper (FDW):

No primeiro contêiner:

 ```sql
-- Criar extensão FDW
CREATE EXTENSION IF NOT EXISTS postgres_fdw;


-- Criar servidor estrangeiro (segundo contêiner)
CREATE SERVER shard2
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', port '5433', dbname 'newdatabase');

-- Criar mapeamento de usuário
CREATE USER MAPPING FOR myuser
SERVER shard2
OPTIONS (user 'newuser', password 'newpassword');

-- Importar a tabela de usuários do segundo contêiner
IMPORT FOREIGN SCHEMA public
FROM SERVER shard2
INTO public;
 ```
Verificação
Verifique os dados no primeiro contêiner:

 ```sh
docker exec -it my_postgres_container psql -U myuser -d mydatabase -c "SELECT * FROM users;"
Verifique os dados no segundo contêiner:
 ```

 ```sh
docker exec -it my_postgres_container_v2 psql -U newuser -d newdatabase -c "SELECT * FROM users;"
 ```






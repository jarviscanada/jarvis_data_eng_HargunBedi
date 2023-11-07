# Introduction
This project aims to streamline and automate the monitoring of hardware specifications and resource usage over time. Designed for system administrators, the tool provides valuable insights into the performance and health of servers. At its core, the project leverages technologies such as Bash for scripting, Docker for containerization, Git for version control, and PostgreSQL for data persistence.

# Quick Start
```bash
# Create a PostgreSQL instance using Docker (if it hasn't been created, otherwise use the start command):
./psql_docker.sh create [db_username] [db_password]

# Create tables using DDL SQL commands (assumes host_agent database is already created):
psql -h localhost -U postgres -d host_agent -f ./sql/ddl.sql

# Insert hardware specifications data into the database:
./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password

# Insert hardware usage data into the database:
./scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password

# Crontab setup to automate the running of scripts:
crontab -e
# Add the following lines to the opened crontab file:
* * * * * bash /path/to/scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
```

# Implemenation
## Architecture
![Architecture diagram of the project](/assets/Linux-Project-Arch.jpg)

## Scripts
- **psql_docker.sh**: Manages the Docker container for PostgreSQL
```
./psql_docker.sh start|stop|create [db_username] [db_password]
```
- **host_info.sh**: Collects hardware specifications and inserts them into the database.
```
./host_info.sh psql_host psql_port db_name psql_user psql_password
```
- **host_usage.sh**: Gathers current hardware usage and sends it to the database.
```
./host_usage.sh psql_host psql_port db_name psql_user psql_password
```
- **crontab**: Automates the execution of host_usage.sh every minute.
```bash
crontab -e
# Add the following to the crontab file
''* * * * * bash /path/to/scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password''
```
- **ddl.sql**: Sets up the required tables in the database
```
psql -h [ip_address] -U [db_username] -d host_agent -f ./ddl.sql
```

## Database Modeling
Describe the schema of each table using markdown table syntax (do not put any sql code)
- `host_info`

  | Column             | Type                    | Constraint            | Description                                 |
  |--------------------|-------------------------|-----------------------|---------------------------------------------|
  | `id`               | Serial Integer          | Not Null, Primary Key | Unique identifier for each host             |
  | `hostname`         | String (Varchar)        | Not Null, Unique      | Name of the host                            |
  | `cpu_number`       | Integer2                | Not Null              | Number of CPUs in the host                  |
  | `cpu_architecture` | String (Varchar)        | Not Null              | Architecture of the host's CPU              |
  | `cpu_model`        | String (Varchar)        | Not Null              | Model of the host's CPU                     |
  | `cpu_mhz`          | Float8                  | Not Null              | Speed of the host's CPU in MHz              |
  | `L2_cache`         | Integer4                | Not Null              | Size of L2 cache in KB                      |
  | `total_mem`        | Integer4                | Not Null              | Total memory in the host in MB              |
  | `timestamp`        | Timestamp | Not Null              | Time when the host information was recorded |

- `host_usage`

| Column            | Type      | Constraints           | Description                              |
|-------------------|-----------|-----------------------|------------------------------------------|
| `timestamp`       | Timestamp | Not Null              | Time when the usage data was recorded                |
| `host_id`         | Integer   | Not Null, Foreign Key | References `id` from `host_info` table               |
| `memory_free`     | Integer4  | Not Null              | Amount of free memory at the time of recording in MB |
| `cpu_idle`        | Integer2  | Not Null              | Percentage of time the CPU was idle            |
| `cpu_kernel`      | Integer2  | Not Null              | Percentage of time the CPU running kernel code |
| `disk_io`         | Integer4  | Not Null              | Number of disk I/O operations |
| `disk_available`  | Integer4  | Not Null              | Available disk space in MB |

# Testing
The bash scripts and DDLs were tested by running them and verifying the insertion of data into the database on a single machine. All scripts were thoroughly tested to validate their usage.

# Deployment
Deployment was achieved through:

- GitHub for hosting the codebase and version control.
- Docker to containerize the PostgreSQL instance.
- Crontab to schedule `host_usage` collection every minute on the agent's machine.

# Improvements
Write at least three things you want to improve
e.g.
- Enhancing the scripts to include error handling and additonal customizability
- Adding SQL queries to analyze usage metrics
- Automating the deployment process for newly added agents

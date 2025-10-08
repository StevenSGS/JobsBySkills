### Al entrar al shell del contenedor

Cuando se abre el contenedor se ejecuta el shell de base `sh`, es acceder al shell de `bash` para simplificar el ingreso de comandos

```sh
bash
```

### Alias recomendado para acceder a SQL Server

Para simplificar el uso de `sqlcmd` dentro del contenedor, se recomienda crear un alias que facilite la conexión al servidor SQL:

```bash
alias sql='/opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -C'
```

Ahora se puede acceder con facilmente con el comando:

```bash
sql
```

Posteriormente mostrara una entrada de contraseña, la contraseña es `YourStrong(!)Password`:

```bash
Password: YourStrong(!)Password
```

Y de esta forma ya se puede acceder facilmente al CLI de SQL-Server para ingresar comandos a la base de datos.

¡¡¡Es necesario repetir el proceso cada vez que se reinicia el contenedor!!!

### Ingresar datos a la base de datos.

Copiar el contenido indicado del archivo `JobsBySkills\database\codigo-database.md` en en la entrada del CLI de la SQL-Server

¡¡De esta forma la base de datos quedaria completamente funcional!!
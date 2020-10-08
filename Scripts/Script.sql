-- utilizar la opción --quick o -q para que MySQL exporte fila a fila en lugar de meter en buffer toda la tabla y agotar la memoria.
mysqldump -u usuario -p -q nombre_bbdd > bbdd.SQL


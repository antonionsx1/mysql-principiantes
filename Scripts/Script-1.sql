update aspdb.aspirante_registrado_ceneval set estatus = 6 where no_de_control is null;

update aspdb.rol_aplicacion set estatus = 1 where estatus = 2;

select * from aspdb.rol_aplicacion;


SELECT arc.*,
       a.folio_ittla,
       concat(a.apellido_paterno, ' ', a.apellido_materno, ' ', a.nombre) AS nombre_completo,
       a.folio_ceneval,
       a.carrera_aspirar AS carrera_aspirar,
       c.carrera_corto,
       ca.campus AS campus,
       e.id_estatus,
       e.estatus,
       u.id_usuario
FROM asdb.aspirante_registrado_ceneval arc
INNER JOIN asdb.aspirante a ON a.curp = arc.curp
INNER JOIN asdb.carrera c ON a.carrera_aspirar = c.id_carrera
INNER JOIN asdb.campus ca ON ca.id_campus = c.campus
INNER JOIN asdb.estatus e ON e.id_estatus = arc.estatus
INNER JOIN asdb.usuarios u ON u.usuario = a.curp
WHERE cast(fecha_registro_ceneval AS DATE) BETWEEN
    (SELECT distinct(fecha_inicio_seleccion)
     FROM asdb.periodos_escolares
     WHERE estatus = 1) AND
    (SELECT distinct(fecha_termino_seleccion)
     FROM asdb.periodos_escolares
     WHERE estatus = 1)
  AND a.folio_ceneval IS NOT NULL
  AND c.id_carrera = :id_carrera
UNION
SELECT 9999999,
       a1.curp,
       NULL,
       a1.fecha_registro,
       e1.id_estatus,
       NULL,
       a1.folio_ittla,
       concat(a1.apellido_paterno, ' ', a1.apellido_materno, ' ', a1.nombre) AS nombre_completo,
       a1.folio_ceneval,
       a1.carrera_aspirar AS carrera_aspirar,
       c1.carrera_corto,
       ca1.campus AS campus,
       e1.id_estatus,
       e1.estatus,
       u1.id_usuario
FROM asdb.aspirante a1
INNER JOIN asdb.carrera c1 ON a1.carrera_aspirar = c1.id_carrera
INNER JOIN asdb.campus ca1 ON ca1.id_campus = c1.campus
INNER JOIN asdb.estatus e1 ON e1.id_estatus = 6
INNER JOIN asdb.usuarios u1 ON u1.usuario = a1.curp
WHERE cast(a1.fecha_registro AS DATE) BETWEEN
    (SELECT distinct(fecha_inicio_seleccion)
     FROM asdb.periodos_escolares
     WHERE estatus = 1) AND
    (SELECT distinct(fecha_termino_seleccion)
     FROM asdb.periodos_escolares
     WHERE estatus = 1)
  AND a1.folio_ceneval IS NOT NULL
  AND a1.curp not in
    (SELECT curp
     FROM asdb.aspirante_registrado_ceneval arc1
     WHERE arc1.curp=a1.curp)
  AND c1.id_carrera = :id_carrera
ORDER BY carrera_aspirar,
         campus,
         CASE id_estatus
             WHEN 6 THEN 1
             WHEN 7 THEN 2
             WHEN 4 THEN 3
         end;
         
select * from asdb.usuarios u ;
select * from asdb.aplicaciones a ;
select * from asdb.aspirante a ;
select CONCAT(pe.fecha_inicio_seleccion, pe.fecha_termino_seleccion), pe.estatus from asdb.periodos_escolares pe order by periodo;



select * FROM asdb.rencuesta_cliente;

select re.pregunta as id_pregunta, re.valor, re.respuesta
from asdb.respuesta_encuesta re
inner join asdb.encuesta_equipo ee on ee.id_pregunta = re.pregunta
where 
	ee.proceso = 1 and 
	ee.estatus = 1 and re.estatus = 1

select * from asdb.encuesta_equipo ee;

SELECT g.genero, c.id_carrera 
               FROM asdb.genero g, asdb.carrera c ;
              
select * from asdb.periodos_escolares pe;

INSERT INTO asdb.periodos_escolares (id_periodo, periodo, decripcion, fecha_inicio_seleccion, fecha_termino_seleccion, fecha_inicio_inscripcion, fecha_termino_inscripcion, estatus) values
(3, '20211', 'ENE-JUN', '2020-10-07', '2020-11-20', '2020-11-21', '2020-12-18', 1);
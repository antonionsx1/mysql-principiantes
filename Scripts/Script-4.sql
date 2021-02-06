    SELECT count(aspi.carrera_aspirar) as total, aspi.carrera_aspirar, aspi.carrera_corto from (
                    SELECT count(DISTINCT requisito) total,
                            asp.carrera_aspirar,
                            c.carrera_corto
                     FROM asdb.doc_proceso doc,
                          asdb.aspirante asp,
                          asdb.carrera c,
                          asdb.genero g
                     WHERE doc.curp=asp.curp
                       AND doc.estatus_doc = 3
                       AND doc.requisito in (SELECT DISTINCT rec.id_requisitos FROM asdb.requisitos rec WHERE rec.proceso=1 AND rec.estatus_requisito=1)
                       AND asp.folio_ceneval is not NULL
                       AND asp.carrera_aspirar = c.id_carrera
                       AND CAST(doc.fecha_subida AS DATE) BETWEEN
                       (select distinct(fecha_inicio_seleccion) from asdb.periodos_escolares where id_periodo = 1) and 
                       (select distinct(fecha_termino_seleccion) from asdb.periodos_escolares where id_periodo = 1)
				    GROUP BY doc.curp,
                      asp.carrera_aspirar,
                      c.carrera_corto
            HAVING total = (SELECT COUNT(id_requisitos) FROM requisitos WHERE proceso=1 AND estatus_requisito=1) ) as aspi
    GROUP by aspi.carrera_aspirar;
    
   
   SELECT count(a.curp) total,
        a.carrera_aspirar,
        c.carrera_corto
    FROM asdb.aspirante_registrado_ceneval arc,
      asdb.aspirante a,
      asdb.carrera c
    WHERE 
        arc.estatus = 7 
        AND arc.estatus is not null
        AND arc.curp = a.curp
        AND a.folio_ceneval is not NULL
       AND a.folio_ceneval LIKE 'ES-%'
        AND CAST(a.fecha_registro AS DATE) BETWEEN
               (select distinct(fecha_inicio_seleccion) from asdb.periodos_escolares where id_periodo = 1) and 
               (select distinct(fecha_termino_seleccion) from asdb.periodos_escolares where id_periodo = 1)
		    AND a.carrera_aspirar = c.id_carrera
        GROUP BY a.carrera_aspirar;
       
s
SELECT * from aspirante a where  
			a.folio_ceneval LIKE 'RE-%' ;
      
SELECT count(a.curp) as total, a.carrera_aspirar from asdb.aspirante a where 
			a.folio_ceneval LIKE 'ES-%' 
or			a.folio_ceneval LIKE 'RE-%'
       GROUP by a.carrera_aspirar ;
        

SELECT count(aspi.carrera_aspirar) AS total,
       aspi.carrera_aspirar,
       aspi.carrera_corto
FROM
  (SELECT count(DISTINCT requisito) total,
          asp.carrera_aspirar,
          c.carrera_corto
   FROM asdb.doc_proceso doc,
        asdb.aspirante asp,
        asdb.aspirante_registrado_ceneval arc,
        asdb.carrera c
   WHERE doc.curp=asp.curp
     AND doc.estatus_doc in (3, 8)
     AND doc.requisito in
       (SELECT DISTINCT rec.id_requisitos FROM asdb.requisitos rec WHERE rec.proceso=2 AND rec.estatus_requisito=1)
     AND arc.curp=doc.curp
     AND asp.carrera_aspirar = c.id_carrera
     AND CAST(arc.fecha_registro_ceneval AS DATE) BETWEEN
       (SELECT distinct(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND
       (SELECT distinct(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1)
   GROUP BY doc.curp,
            arc.no_de_control,
            asp.carrera_aspirar,
            c.carrera_corto
   HAVING total=
     (SELECT COUNT(id_requisitos) FROM requisitos WHERE proceso=2 AND estatus_requisito=1)
   ORDER BY c.carrera_corto) aspi
GROUP BY aspi.carrera_aspirar;

SELECT count(DISTINCT requisito) total,
                    doc.curp,
                    arc.no_de_control,
                    asp.apellido_paterno,
                    asp.apellido_materno,
                    asp.nombre,
                    'XAXX010101000' AS rfc,
                    d.calle,
                    d.numero_int,
                    d.numero_ext,
                    a.asentamiento,
                    m.municipio,
                    e.estado,
                    a.id_cp,
                    c.carrera_corto
             FROM asdb.doc_proceso doc,
                  asdb.aspirante asp,
                  asdb.aspirante_registrado_ceneval arc,
                  asdb.direccion d,
                  asdb.asentamiento a,
                  asdb.municipios m,
                  asdb.estados e,
                  asdb.carrera c
             WHERE doc.curp=asp.curp
               AND arc.curp=doc.curp
               AND asp.curp=d.curp
               AND d.asentamiento = a.id_asentamiento
               AND d.municipio = m.id_municipios
               AND m.id_estado = e.id_estados
               AND asp.carrera_aspirar = c.id_carrera 
               AND CAST(arc.fecha_registro_ceneval AS DATE) BETWEEN
                (SELECT distinct(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND
       			(SELECT distinct(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1)
               AND doc.estatus_doc in (3, 8)
               AND doc.requisito in (SELECT DISTINCT rec.id_requisitos FROM asdb.requisitos rec WHERE rec.proceso=2 AND rec.estatus_requisito=1)
             GROUP BY doc.curp,
                      arc.no_de_control,
                      asp.apellido_paterno,
                      asp.apellido_materno,
                      asp.nombre,
                      d.calle,
                      d.numero_int,
                      d.numero_ext,
                      a.asentamiento,
                      a.id_cp,
                      m.municipio,
                      e.estado,
                      c.carrera_corto
            HAVING total= (SELECT COUNT(id_requisitos) FROM requisitos WHERE proceso=2 AND estatus_requisito=1)
            ORDER BY c.carrera_corto, asp.apellido_paterno
            
 SELECT * from asdb.aspirante a 
 inner join asdb.aspirante_registrado_ceneval arc on a.curp = arc.curp 
 where a.tipo_ingreso in (2,3)
 and a.folio_ceneval is not null
 AND CAST(a.fecha_registro AS DATE) BETWEEN
(SELECT distinct(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND
(SELECT distinct(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1);


SELECT IFNULL(t2.total, 0) AS total, g.id_carrera AS carrera_aspirar, g.genero
FROM
  (SELECT g.genero, c.id_carrera FROM asdb.genero g, asdb.carrera c) g
LEFT JOIN
  (SELECT count(arc.curp) total, a.carrera_aspirar, g.genero
   FROM asdb.aspirante_registrado_ceneval arc, asdb.aspirante a, asdb.carrera c, asdb.genero g
   WHERE arc.estatus = 7
     AND arc.curp = a.curp
     AND CAST(arc.fecha_registro_ceneval AS DATE) BETWEEN
       (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 3) AND 
       (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 3) AND 
       a.carrera_aspirar = c.id_carrera
	     AND a.genero = g.id_genero
	   GROUP BY a.carrera_aspirar, a.genero) AS t2 ON t2.genero = g.genero AND t2.carrera_aspirar = g.id_carrera
	   
	   ;
	  

SELECT IFNULL(t2.total, 0) AS total, g.id_carrera AS carrera_aspirar, g.genero
FROM
  (SELECT g.genero, c.id_carrera FROM asdb.genero g, asdb.carrera c) g
LEFT JOIN
  (SELECT count(arc.curp) total, a.carrera_aspirar, g.genero 
   FROM asdb.aspirante_registrado_ceneval arc, asdb.aspirante a, asdb.carrera c, asdb.genero g
   WHERE arc.estatus = 7
     AND arc.curp = a.curp
     AND CAST(arc.fecha_registro_ceneval AS DATE) BETWEEN
       (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND
       (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND 
       a.carrera_aspirar = c.id_carrera AND 
       a.genero = g.id_genero
   GROUP BY a.carrera_aspirar, a.genero) AS t2 ON t2.genero = g.genero AND t2.carrera_aspirar = g.id_carrera;
  
  
  
SELECT count(DISTINCT requisito) total, asp.folio_ceneval, asp.apellido_paterno, asp.apellido_materno, asp.nombre, asp.correo
FROM asdb.doc_proceso doc, asdb.aspirante asp, asdb.carrera c, asdb.genero g
WHERE doc.curp=asp.curp
  AND doc.requisito in (SELECT DISTINCT rec.id_requisitos FROM asdb.requisitos rec WHERE rec.proceso=1 AND rec.estatus_requisito=1)
  AND asp.folio_ceneval IS NULL
  AND asp.carrera_aspirar = c.id_carrera
  AND CAST(doc.fecha_subida AS DATE) BETWEEN
    (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND
    (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1)
GROUP BY doc.curp, asp.folio_ceneval, asp.apellido_paterno, asp.apellido_materno, asp.nombre, asp.correo
HAVING total < (SELECT COUNT(id_requisitos) FROM requisitos WHERE proceso = 1 AND estatus_requisito=1)
ORDER BY asp.folio_ceneval;

SELECT asp.folio_ceneval, asp.apellido_paterno, asp.apellido_materno, asp.nombre, asp.correo
FROM asdb.aspirante asp
WHERE asp.folio_ceneval IS NULL
  AND CAST(asp.fecha_registro AS DATE) BETWEEN
    (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND
    (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1)
ORDER BY asp.folio_ceneval;

SELECT count(DISTINCT requisito) total, asp.folio_ceneval, asp.apellido_paterno, asp.apellido_materno, asp.nombre, asp.correo
            FROM asdb.doc_proceso doc, asdb.aspirante asp, asdb.carrera c, asdb.genero g
            WHERE doc.curp=asp.curp
              AND doc.requisito in (SELECT DISTINCT rec.id_requisitos FROM asdb.requisitos rec WHERE rec.proceso=1 AND rec.estatus_requisito=1)
              AND asp.folio_ceneval IS NULL
              AND asp.carrera_aspirar = c.id_carrera
              AND CAST(doc.fecha_subida AS DATE) BETWEEN
                (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND
                (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1)
            GROUP BY doc.curp, asp.folio_ceneval, asp.apellido_paterno, asp.apellido_materno, asp.nombre, asp.correo
            HAVING total < (SELECT COUNT(id_requisitos) FROM requisitos WHERE proceso = 1 AND estatus_requisito=1)
            ORDER BY asp.folio_ceneval;
   
   
           
           SELECT asp.folio_ceneval, asp.apellido_paterno, asp.apellido_materno, asp.nombre, asp.correo
            FROM asdb.aspirante asp
            WHERE asp.folio_ceneval IS NULL
              AND CAST(asp.fecha_registro AS DATE) BETWEEN
                (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE estatus = 1) AND
                (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE estatus = 1)
            ORDER BY asp.folio_ceneval;
            
           SELECT * from asdb.periodos_escolares;
           
          SELECT * from asdb.aspirante a ;
          SELECT * FROM asdb.usuarios u ;
          SELECT * from asdb.estatus e ;
         select * from asdb.alumnos_inscritos_periodo aip ;
          
         
SELECT IFNULL(t2.total, 0) AS total, g.id_carrera AS carrera_aspirar, g.genero
FROM
  (SELECT g.genero, c.id_carrera FROM asdb.genero g, asdb.carrera c) g
LEFT JOIN
  (SELECT count(aspi.carrera_aspirar) AS total, aspi.genero, aspi.carrera_aspirar
   FROM
     (SELECT count(DISTINCT requisito) total, asp.carrera_aspirar, g.genero
      FROM asdb.doc_proceso doc, asdb.aspirante asp, asdb.aspirante_registrado_ceneval arc, asdb.genero g
      WHERE doc.curp=asp.curp
        AND doc.estatus_doc in (3, 8)
        AND doc.requisito in
          (SELECT DISTINCT rec.id_requisitos FROM asdb.requisitos rec WHERE rec.proceso=2 AND rec.estatus_requisito=1)
        AND arc.curp=doc.curp
        AND asp.genero = g.id_genero
        AND CAST(arc.fecha_registro_ceneval AS DATE) BETWEEN
          (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2) AND
          (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2)
      GROUP BY doc.curp, arc.no_de_control, asp.carrera_aspirar, g.genero
      HAVING total = (SELECT COUNT(id_requisitos) FROM requisitos WHERE proceso= 2 AND estatus_requisito = 1)) aspi
   GROUP BY aspi.carrera_aspirar, genero) AS t2 ON t2.genero = g.genero
AND t2.carrera_aspirar = g.id_carrera;


SELECT IFNULL(t2.total, 0) AS total, g.id_carrera AS carrera_aspirar, g.genero
FROM
  (SELECT g.genero, c.id_carrera FROM asdb.genero g, asdb.carrera c) g
LEFT JOIN
  (SELECT count(aspi.carrera_aspirar) AS total, aspi.genero, aspi.carrera_aspirar
   FROM
     (SELECT asp.carrera_aspirar, g.genero 
      FROM asdb.alumnos_inscritos_periodo aip,
           asdb.aspirante asp, asdb.aspirante_registrado_ceneval arc, asdb.genero g
      WHERE aip.no_de_control = arc.no_de_control
        AND arc.curp = asp.curp
        AND asp.genero = g.id_genero
        AND aip.periodo = (SELECT periodo FROM asdb.periodos_escolares WHERE id_periodo = 2)
        AND cast(asp.fecha_registro AS DATE) BETWEEN
          (SELECT distinct(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2) AND
          (SELECT distinct(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2)
        AND cast(arc.fecha_registro_ceneval AS DATE) BETWEEN
          (SELECT distinct(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2) AND
          (SELECT distinct(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2)) aspi
   GROUP BY aspi.carrera_aspirar, genero) AS t2 ON t2.genero = g.genero
AND t2.carrera_aspirar = g.id_carrera;
   
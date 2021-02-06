SELECT sum(t1.valor) AS total, 
t1.cliente AS curp, concat(a.apellido_paterno, ' ', a.apellido_materno, ' ', a.nombre) AS nombre_completo, telefono, movil, correo, carrera_corto
FROM
  (SELECT DISTINCT pregunta, valor, cliente FROM aspdb.rencuesta_cliente r3 WHERE r3.cliente in
       (SELECT DISTINCT r1.cliente
        FROM aspdb.rencuesta_cliente r1
        INNER JOIN aspdb.aspirante a2 on a2.curp = r1.cliente
        where 
            (SELECT count(DISTINCT pregunta) FROM aspdb.rencuesta_cliente r2 WHERE r2.cliente=r1.cliente)=11
          AND CAST(r1.fecha_registro AS DATE) BETWEEN
            (SELECT DISTINCT(fecha_inicio_seleccion) FROM aspdb.periodos_escolares WHERE estatus=1) AND
            (SELECT DISTINCT(fecha_termino_seleccion) FROM aspdb.periodos_escolares WHERE estatus=1)
          AND proceso=1
          AND (a2.folio_ceneval NOT LIKE 'ES%' 
          AND a2.folio_ceneval NOT LIKE 'RE%') and a2.curp = 'MEGJ020715HMCLLSA9') ) t1
INNER JOIN aspdb.aspirante a ON t1.cliente=a.curp
INNER JOIN aspdb.carrera c ON a.carrera_aspirar=c.id_carrera
where CAST(a.fecha_registro AS DATE) BETWEEN
            (SELECT DISTINCT(fecha_inicio_seleccion) FROM aspdb.periodos_escolares WHERE estatus=1) AND
            (SELECT DISTINCT(fecha_termino_seleccion) FROM aspdb.periodos_escolares WHERE estatus=1)
GROUP BY t1.cliente, nombre_completo, telefono, movil, correo, carrera_corto
ORDER BY total;

select * from asdb.periodos_escolares pe ;

UPDATE asdb.aspirante SET folio_ceneval='ES-1836', tipo_ingreso = 2 WHERE folio_ittla = 1836;


select * from asdb.aspirante a where a.folio_ittla = '1847';
select * from asdb.aspirante a where a.curp = 'RAEL010616HMCMSSA9';
select * from asdb.usuarios u where u.usuario ='HELR020107HMCRPBA1';
select * from asdb.rol_aplicacion ra where ra.usuario = '2343';

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
                 (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE estatus=1) AND
                 (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE estatus=1)
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
            ORDER BY c.carrera_corto, asp.apellido_paterno;
            
           select * from asdb.periodos_escolares pe ;
           
          select * from asdb.alumnos_inscritos_periodo aip ;

         select * from asdb.aspirante_registrado_ceneval arc  ;
        
        select * from asdb.aspirante a ;
       
       select * from asdb.estatus e ;
         
       
       
SELECT count(DISTINCT requisito) total, asp.carrera_aspirar, c.carrera_corto
  FROM asdb.doc_proceso doc, asdb.aspirante asp, asdb.aspirante_registrado_ceneval arc, asdb.carrera c
  WHERE doc.curp=asp.curp
    AND doc.estatus_doc in (3, 8)
    AND doc.requisito in
      (SELECT DISTINCT rec.id_requisitos
       FROM asdb.requisitos rec
       WHERE rec.proceso=2 AND rec.estatus_requisito=1)
    AND arc.curp=doc.curp
    AND asp.carrera_aspirar = c.id_carrera
    AND CAST(arc.fecha_registro_ceneval AS DATE) BETWEEN
      (SELECT DISTINCT(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1) AND
      (SELECT DISTINCT(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 1)
  GROUP BY doc.curp, arc.no_de_control, asp.carrera_aspirar, c.carrera_corto 
  HAVING total= (SELECT COUNT(id_requisitos) FROM requisitos WHERE proceso = 2 AND estatus_requisito = 1)
  ORDER BY c.carrera_corto;

   
  	
   
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


SELECT IFNULL(t2.total, 0) AS total, carreras.id_carrera AS carrera_aspirar, carreras.carrera_corto
from (SELECT c.id_carrera, c.carrera_corto FROM asdb.carrera c WHERE c.estatus_carrera = 1) carreras
LEFT JOIN
  (SELECT count(aspi.carrera_aspirar) AS total, aspi.carrera_aspirar, aspi.carrera_corto
   FROM
     (SELECT asp.carrera_aspirar, c.carrera_corto
      FROM asdb.alumnos_inscritos_periodo aip,
           asdb.aspirante asp, asdb.aspirante_registrado_ceneval arc, asdb.carrera c
      WHERE aip.no_de_control = arc.no_de_control
        AND arc.curp = asp.curp
        AND asp.carrera_aspirar = c.id_carrera
        AND aip.periodo = (SELECT periodo FROM asdb.periodos_escolares WHERE id_periodo = 2)
        AND cast(asp.fecha_registro AS DATE) BETWEEN
          (SELECT distinct(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2) AND
          (SELECT distinct(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2)
        AND cast(arc.fecha_registro_ceneval AS DATE) BETWEEN
          (SELECT distinct(fecha_inicio_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2) AND
          (SELECT distinct(fecha_termino_seleccion) FROM asdb.periodos_escolares WHERE id_periodo = 2)) aspi
   GROUP BY aspi.carrera_aspirar) t2 ON t2.carrera_aspirar = carreras.id_carrera
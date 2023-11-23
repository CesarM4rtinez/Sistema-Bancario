DELETE FROM DataMart_SisBanca.dbo.HECHOS
GO

INSERT INTO DataMart_SisBanca.dbo.HECHOS (ID_TIPO_TRANSACCION,FECHA,ID_DIM_CLIENTE,ENTRADA,SALIDA)
SELECT 1,F.FECHA,DC.ID_DIM_CLIENTE,0 MONTO_ENTRADA,SUM(T.MONTO_SALIDA)MONTO_SALIDA FROM 
(select ID_CLIENTE,CONVERT(DATE,FECHA_REGISTRO) FECHA_REGISTRO,MONTO_SALIDA from SISTEMA_BANCARIO.DBO.MOVIMIENTO_TARJETA) T INNER JOIN DIMENSION_TIEMPO F ON F.FECHA = T.FECHA_REGISTRO
INNER JOIN SISTEMA_BANCARIO.DBO.CLIENTE C ON T.ID_CLIENTE = C.ID_CLIENTE
INNER JOIN DataMart_SisBanca.DBO.DIM_CLIENTE DC ON DC.ID_CLIENTE = T.ID_CLIENTE
GROUP BY F.FECHA,DC.ID_DIM_CLIENTE

UNION ALL
SELECT 2,F.FECHA,DC.ID_DIM_CLIENTE,SUM(T.MONTO_ENTRADA)MONTO_ENTRADA,SUM(T.MONTO_SALIDA)MONTO_SALIDA 
FROM 
(SELECT ID_CLIENTE,CONVERT(DATE,FECHA_REGISTRO)FECHA_REGISTRO,MONTO_ENTRADA,MONTO_SALIDA FROM SISTEMA_BANCARIO.DBO.MOVIMIENTO_CUENTA) T INNER JOIN DIMENSION_TIEMPO F ON F.FECHA = T.FECHA_REGISTRO
INNER JOIN SISTEMA_BANCARIO.DBO.CLIENTE C ON T.ID_CLIENTE = C.ID_CLIENTE
INNER JOIN DataMart_SisBanca.DBO.DIM_CLIENTE DC ON DC.ID_CLIENTE = T.ID_CLIENTE
GROUP BY F.FECHA,DC.ID_DIM_CLIENTE

UNION ALL
SELECT 3,F.FECHA,DC.ID_DIM_CLIENTE,0 MONTO_ENTRADA,SUM(T.MONTO_SALIDA)MONTO_SALIDA FROM 
(SELECT ID_CLIENTE,CONVERT(DATE,FECHA_REGISTRO)FECHA_REGISTRO,MONTO_SALIDA FROM SISTEMA_BANCARIO.DBO.MOVIMIENTO_ABONO) T INNER JOIN DIMENSION_TIEMPO F ON F.FECHA = T.FECHA_REGISTRO
INNER JOIN SISTEMA_BANCARIO.DBO.CLIENTE C ON T.ID_CLIENTE = C.ID_CLIENTE
INNER JOIN DataMart_SisBanca.DBO.DIM_CLIENTE DC ON DC.ID_CLIENTE = T.ID_CLIENTE
GROUP BY F.FECHA,DC.ID_DIM_CLIENTE
GO
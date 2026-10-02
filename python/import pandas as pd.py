import pandas as pd

# 1. Cargar el CSV
df = pd.read_csv("data/capacitaciones_sence.csv")

# 2. Crear la columna del Costo Neto Empresa (Costo Total - Cobertura SENCE)
df["costo_neto_empresa"] = df["costo_total"] - df["cobertura_sence"]

# 3. Agrupar por 'nombre_curso' y sumar las métricas financieras
resumen_curso = df.groupby("nombre_curso")[["costo_total", "cobertura_sence", "costo_neto_empresa"]].sum().reset_index()

# 4. Ordenar de mayor a menor según el costo neto
resumen_curso = resumen_curso.sort_values(by="costo_neto_empresa", ascending=False)

# 5. Mostrar el resultado
print("=== RESUMEN FINANCIERO POR CURSO ===")
print(resumen_curso.to_string(index=False))
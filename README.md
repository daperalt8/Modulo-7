# Modulo-7
# RESERVAS BANCARIAS DEL ECUADOR
## PERÍODO: 2017-2023 (FRECUENCIA MENSUAL)
> La base datos recoge 78 observaciones de las reservas bancarias del Ecuador en millones de dólares, la data fue obtenida del Banco Central del Ecuador

### LIBRERÍAS
------------
library(openxlsx)

library(highcharter)

library(forecast)

library(urca)

------------


### FUNCIONES
------------
read.xlsx()
> Permite leer la base de datos en formato xlsx

ts()
> Transforma una variable en serie de tiempo

plot(stl())
> Permite hacer gráficos de la serie de tiempo, permite observar señal original, estacional, tendencial y estocástica

diff()
> Permite diferenciar una serie de tiempo

hchart()
> Mejora el gráfico de una serie de tiempo

------------



<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Reservas.png" alt="RESERVAS BANCARIAS DEL ECUADOR">
</p>

> En la imagen se puede observar la señal de las reservas bancarias original, la parte estacional, la tendencial y la estocástica

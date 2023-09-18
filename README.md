# Modulo-7
# RESERVAS BANCARIAS DEL ECUADOR
## PERÍODO: 2017-2023 (FRECUENCIA MENSUAL)
> La base datos recoge 78 observaciones de las reservas bancarias del Ecuador en millones de dólares, la data fue obtenida del Banco Central del Ecuador

### LIBRERÍAS
------------
library(openxlsx), library(highcharter), library(forecast), library(urca)

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

acf() y acp()
> Función de autocoreelación simple y parcial

ur.df(), ur.pp(), ur.kpss y ur.ers
> Permiten contrastar la hipótesis de estacionariedad

Arima(), auto.arima()
> Modelo Arima de orden (p,d,q)

accuracy() y Box.test()
> Evaluar el modelo arima (p,d,q)


------------



<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Reservas.png" alt="RESERVAS BANCARIAS DEL ECUADOR, HCHART">
</p>

> En la imagen se puede observar la señal de las reservas bancarias original, la parte estacional, la tendencial y la estocástica

<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Rplot01.png" alt="RESERVAS BANCARIAS DEL ECUADOR, Visualización con HCHART">
</p>


> Las reservas bancarias del Ecuador no se comporta como una señal estacionaria en sentido débil, claramente se observa que si se divide la gráfica en el año 2019, las medias y las varianzas en los dos períodos será distinto, por lo que podría concluir que no es serie estacionaria en sentido débil.

<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Rplot02.png" alt="RESERVAS BANCARIAS DEL ECUADOR, Visualización con HCHART">
</p>

> Las reservas bancarias no se comporta como una señal estacionaria en sentido débil por lo que podría traer problemas al momento de crear un modelo ARMA, para mitigar el problema  aplicamos la primera diferencia y se observa que al parecer la señal se vuelve estacionaria en sentido débil, lo que indica que al momento de simular mi Modelo Arima (p,d,q) debería usar la primera diferencia.

## CONTRASTES DE RAÍZ UNITARIA PARA EVALUAR LA ESTACIONARIEDAD DE LAS RESERVAS BANCARIAS DEL ECUADOR

------------
### Augmented Dickey-Fuller Test Unit Root Test

>Test regression trend 


>Call:
>lm(formula = z.diff ~ z.lag.1 + 1 + tt + z.diff.lag)

>Residuals:
>    Min      1Q  Median      3Q     Max 
>-1259.9  -295.6   -71.1   266.4  1501.5 

>Coefficients:
>             Estimate Std. Error t value Pr(>|t|)

>(Intercept) 561.34872  301.80114   1.860   0.0670 .

>z.lag.1      -0.13447    0.06867  -1.958   0.0541 .

>tt            5.44766    3.93185   1.386   0.1702

>z.diff.lag   -0.19806    0.11620  -1.705   0.0926 .

>Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

>Residual standard error: 503.2 on 72 degrees of freedom

>Multiple R-squared:  0.1173,	Adjusted R-squared:  0.08047

>F-statistic: 3.188 on 3 and 72 DF,  p-value: 0.02875


>Value of test-statistic is: -1.9582 1.2871 1.9226 

>Critical values for test statistics: 
>      1pct  5pct 10pct

>tau3 -4.04 -3.45 -3.15

>phi2  6.50  4.88  4.16

>phi3  8.73  6.49  5.47


### Phillips-Perron Unit Root Test
>Test regression with intercept and trend 


>Call:
>lm(formula = y ~ y.l1 + trend)

>Residuals:
>     Min       1Q   Median       3Q      Max 
>-1361.13  -269.30   -49.71   257.93  1588.72 

>Coefficients:
>            Estimate Std. Error t value Pr(>|t|)    
>(Intercept) 938.5654   376.6529   2.492   0.0149 *  
>y.l1          0.8364     0.0653  12.808   <2e-16 ***
>trend         6.4201     3.7463   1.714   0.0908 .  

>Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

>Residual standard error: 507.2 on 74 degrees of freedom

>Multiple R-squared:  0.8478,	Adjusted R-squared:  0.8436

>F-statistic:   206 on 2 and 74 DF,  p-value: < 2.2e-16


>Value of test-statistic, type: Z-tau  is: -2.293 

>           aux. Z statistics
>Z-tau-mu              3.1900

>Z-tau-beta            1.5078

>Critical values for Z statistics: 
>                     1pct      5pct     10pct

>critical values -4.080282 -3.468062 -3.160581


### KPSS Unit Root Test
>Test is of type: tau with 3 lags. 

>Value of test-statistic is: 0.2112 

>Critical value for a significance level of: 
>                10pct  5pct 2.5pct  1pct

>critical values 0.119 0.146  0.176 0.216


### Elliot, Rothenberg and Stock Unit Root Test
>Test of type DF-GLS 
>detrending of series with intercept and trend 


>Call:
>lm(formula = dfgls.form, data = data.dfgls)

>Residuals:
>     Min       1Q   Median       3Q      Max 
>-1264.25  -335.27   -82.07   224.19  1445.46 

>Coefficients:
>              Estimate Std. Error t value Pr(>|t|)

>yd.lag       -0.096583   0.065843  -1.467   0.1470

>yd.diff.lag1 -0.231559   0.125007  -1.852   0.0683 .

>yd.diff.lag2 -0.007712   0.126253  -0.061   0.9515

>yd.diff.lag3 -0.040879   0.126118  -0.324   0.7468
 
>yd.diff.lag4 -0.004919   0.119871  -0.041   0.9674  

>Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

>Residual standard error: 508.1 on 68 degrees of freedom

>Multiple R-squared:  0.1157,	Adjusted R-squared:  0.05068

>F-statistic: 1.779 on 5 and 68 DF,  p-value: 0.1288


>Value of test-statistic is: -1.4669 

>Critical values of DF-GLS are:
>                 1pct  5pct 10pct

>critical values -3.58 -3.03 -2.74


------------

#### Todos los test para contrastar el problema de raíz unitaria sugieren que existe un problema de estacionariedad.


<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Rplot03.png" alt="RESERVAS BANCARIAS DEL ECUADOR, Visualización con HCHART">
</p>

> Gráfica de autocorrelación simple y parcial de la primera diferencia que me premitiran contruir mi modelo arima(p,d,q), el modelo debería tener un autorregresivo de orden 12 y solo valores en ar1,ar7 y ar12 y debería tener una media móvil de orden 13, sin embargo el mejor modelo resultó ser un arima de orden (12,1,0)

### Mejor Modelo: Arima(ts_reservas,order = c(12,1,0))

<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Modelo%203.jpeg" alt="Mejor Modelo">
</p>

#### MAPE (error) bajo de 6%, MAE de 341.5442 aceptable, considerando que las reservas bancarias están en millones de dólares, RMSE aceptable de 443.3595, ya que el RMSE expresa la verdadera diferencia entre el valor ajustado y el observado, es bajo considerando que la variable en estudio está en millones de dólares.

#### Residuos independientes

<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Residuos.jpeg" alt="Mejor Modelo">
</p>

> El Box-Ljung test demuestran que los residuos del modelo (12,1,0) son independientes, es decir que son ruído blanco, esto quiere decir que mi modelo es aceptable.

#### ACF y PACF de los Residuos
<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Rplot04.png" alt="Mejor Modelo">
</p>

#### Gráfico del Modelo
<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Rplot05.png" alt="Mejor Modelo">
</p>

> El gráfico del Modelo indican que es bueno, se observan todos los puntos dentro del círculo unitario

### PROYECCIONES DE LA RESERVA BANCARIA (JULIO-AGOSTO-SEPTIEMBRE-OCTUBRE)
<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Rplot06.png" alt="Mejor Modelo">
</p>

#### 4 Proyecciones
<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Proyecciones.jpeg" alt="Mejor Modelo">
</p>

#### AUTOARIMA
<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Autoarima.jpeg" alt="Mejor Modelo">
</p>

> El software sugiere realizar un modelo arima(12,1,1) sin embargo se puede visualizar la funcion de autocorrelación simple y parcial de los residuos del modelo autoarima que no se comportan como ruído blanco, algunas barritas están sobre las cotas

<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Rplot08.png" alt="a">
</p>

#### SERIE ORIGINAL, ARIMA Y AUTO-ARIMA
<p align="center">
  <img src="https://github.com/daperalt8/Modulo-7/blob/main/Rplot07.png" alt="a">
</p>

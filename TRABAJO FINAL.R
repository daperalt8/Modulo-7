#--- Librerías #---
library(openxlsx)


#--- Base de datos #---
Reservas_bancarias <- read.xlsx("C:\\Users\\User\\Desktop\\Cursos, Diplomado, etc\\Experto en ciencia de datos\\Módulo 7\\IEM-111-e.xlsx",
                                sheet = "Hoja1")

#--- Convertimos reservas a una serie de tiempo #---
ts_reservas <- ts(Reservas_bancarias$Reserva,start = c(2017, 1),frequency = 12)

#--- original, estacionaria, tendencia, irregular #---
plot(stl(ts_reservas,s.window = "period"))

#--- Verificando si es estacionaria en sentido débil #---
# Debe cumplirse que la media y la varianza de los 2 primeros momentos sean casi iguales #
plot(ts_reservas)

g1 <- window(ts_reservas, start = c(2017, 1), end = c(2019, 12))
g2 <- window(ts_reservas, start = c(2020, 1), end = c(2023, 6))

mean(g1)
mean(g2)
var(g1)
var(g2)

#--- Aplicando la primera diferencia #---
plot(diff(ts_reservas,1))

'''
Las reservas bancarias no es una señal estacionaria en sentido débil por lo que podría
traer problemas al momento de crear un modelo ARMA, para mitigar el problema  aplicamos la
primera diferencia

'''

#--- Mejorando el gráfico de serie de tiempo #---
library(highcharter)
hchart(ts_reservas)

#--- FAS ----> MA
#--- FAP ----> AR


#--- Ejemplo de modelo ar con coeficiente igual a 0.8 #---
ar1 <- arima.sim(list(order=c(1,0,0),ar=0.8),n=100)
plot(ar1,
     main="Modelo Auto Regresivo de Orden 1")

#--- Función de autocorrelación simple #--
acf(ar1)

#--- Función de autocorrelación Parcial #---
pacf(ar1)

par(mfrow=c(1,2))

'''
Si en el gráfico de la función de autocorrelación parcial el primer rezago es significativo
y en la función de autocorrelación simple va decreciendo hasta 0, estamos hablando de un 
problema AR1
'''

#--- Modelo Arima de orden 1 #---
arima1 <- arima.sim(list(orcer=c(2,1,1),ar=c(0.9,-0.5),ma=1.7),n=100)
plot(arima1)
plot(diff(ts_reservas,1))

# Por inspección las reservas bancarias podrían simularse como un modelos arima de orden
# (2,1,1) con un valor de ar=c(0.9,-0.5) y ma=1.7 y n=100


#--- Contraste de Raíz Unitaria (No estacionariedad) #---
library(forecast)

#--- Contraste de Raíz Unitaria #---


############################################### 
# Augmented Dickey-Fuller Test Unit Root Test #
#         Test regression trend               #
############################################### 
adftest <- ur.df(ts_reservas,type = c("trend"),selectlags = c("BIC"))
summary(adftest)


#--- Metodología Box Jenkins #---
# El modelo es Arima cuando hay que diferenciar la serie, ya que no es estacionaria
# El modelo es Arma cuando la serie ya es estacionaria y no hay que diferenciarla


# Si el primer valor de value of test statistics > a los valores de tau 3 se rechaza Ho
# Ho: Raíz  Unitaria = No estacionariedad
# Hi: No raiz unitaria = Estacionariedad


########################################### 
#      Phillips-Perron Unit Root Test     # 
#Test regression with intercept and trend #
########################################### 
pptest <- ur.pp(ts_reservas,type = c("Z-tau"),model = c("trend"),lags = c("short") )
summary(pptest)
# Si el valor de Z-tau > a los valores críticos 3 se rechaza Ho
# Ho: Raíz  Unitaria = No estacionariedad
# Hi: No raiz unitaria = Estacionariedad

''' 
Los dos contraste sugieren que las reservas bancarias tienen raíz unitaria,
es decir, que tiene problemas de estacionariedad '''

#--- Contraste Kpss #---
kpsstest <- ur.kpss(ts_reservas,type=c("tau"),
                    lag=c("short"))
summary(kpsstest)

# Ho:Estacionariedad
# H1: No estacionariedad

#--- ers test #---
erstest <- ur.ers(ts_reservas,type=c("DF-GLS"),
                  model = c("trend"),
                  lag.max = 4)
summary(erstest)
# Ho: Raíz Unitaria
# H1:No Raíz Unitaria

#-- Otra forma de evaluar #---
ndiffs(ts_reservas,test = c("kpss"))

ndiffs(ts_reservas,test = c("adf"))

#--- Identificado el problema de estacionariedadd, procedemos a construir el modelo #---

# 1.- Dibujamos la serie de tiempo
plot(ts_reservas) #identificamos que tiene tendencia, se sospecha estacionariedad

# 2.- Identificamos los problemas de estacionariedad
# ur.df, ur.ers, ur.kpss, ur.pp

# 3.- Dibujamos la primera diferencia, para mitigar la estacionariedad
plot(diff(ts_reservas,1)) #parece solucionarse el problema de estacionariedad

# 3.- Dibujamos la función de autocorrelación simple y parcial
par(mfrow=c(1,2))
acf(diff(ts_reservas,1),xlim=)
pacf(diff(ts_reservas,1))

# 4. Construyo el modelo
modelo1 <- arima(ts_reservas,order = c(1,1,1))
summary(modelo1) # Verificar que el valor absoluto de los coeficientes sea, menor que 1
# Coeficientes significativos
# Ho: B = 0
# H1 B != 0

# Si t calculado = coef/s.e > 2 rechazo Ho
0.0141/0.4713 # no es mayor 2
-0.2645/0.4613 # no es mayor a 2

modelo2 <- arima(ts_reservas,order = c(12,1,1))
summary(modelo2)
0.9506/0.1817 # Primer coeficiente AR 5.23
0.2327/0.1579 # Coeficiente N°7 AR 1.47
0.1006/0.1545 # Coeficiente N°12 AR 0.65
0.8322/0.1545 # Coeficiente N°1 MA 5.38


modelo3 <- Arima(ts_reservas,order = c(12,1,0))
summary(modelo3)
0.2127/0.1084 # Primer coeficiente AR 1.96
0.2841/0.1102 # Coeficiente N°7 AR 2.57
0.2813/0.1129 # Coeficiente N°12 AR 2.49

# Se escoge el modelo 3 por ser el mejor modelo: ARIMA de orden 12, AR1, Ar 7 y AR 12


# Accuracy del mejor modelo
library(forecast)
accuracy(modelo3) # MAPE=6% de error, MAE aceptable, RMSE aceptable, el MPE bajo

#--- Trabajando los residuos #---
# Se identifica que no hayan patrones y que sean ruído blanco, es decir aleatorios
par(mfrow=c(1,1))
plot(modelo3$residuals)#Se gráfica para observar patrones, si los hay se presume autocorrelación
abline(h=0)

# Ho: Residuos independientes
Box.test(modelo3$residuals,lag = 1,type = "Ljung-Box") #El modelo no presenta problemas
                                                       #de autocorrelación severa

#Grafico de la función de autocorrelación simple y parcial de los residuos
# del mejor modelo
# El objetivo es que todas las barritas de acf y pacf esten dentro de los límites
par(mfrow=c(1,2))
acf(modelo3$residuals,xlim=c(0.2,1.5))
pacf(modelo3$residuals)

#--- Plot del mejor modelo #---
plot(modelo3)#Todos los puntos dentro del círculo unitario, el modelo no es explosivo

# Siguiente paso es la proyección 
f1 <- forecast(modelo3,h=4,level = c(95))
par(mfrow=c(1,1))
plot(f1)


# recuperando las proyecciones
f1
library(highcharter)
hchart(f1)

# Gráfico de variable original y valores ajustados
ts.plot(ts_reservas,f1$fitted,f1$mean,col=c("red","blue","green"))



#--- Modelo automático #---
modelo_auto<-auto.arima(ts_reservas)
accuracy(modelo_auto)
plot(modelo_auto)
Box.test(modelo_auto$residuals,type=c("Ljung-Box")) #Ho: residuos independientes
par(mfrow=c(1,2))
acf(modelo_auto$residuals)
pacf(modelo_auto$residuals)

#proyección
fauto <- forecast(modelo_auto,h = 4,level = c(95))
par(mfrow=c(1,1))
plot(fauto)

fauto

ts.plot(ts_reservas,modelo3$fitted,modelo_auto$fitted,
     col=c("red","blue","green"))

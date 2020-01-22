rm(list = ls())
setwd("E:/FCEA/7° Semestre/Bases de Datos y Paquetes/Trabajo Final/Materiales Stata R")

library(readstata13)
library(foreign)

data = read.dta13 ("base para R.dta")

#5.1 Grafica, utilizando el software R, lo siguiente: 
#La distribución de la población analizada (mujeres con hijos de menos de 4 años) en
#términos de:(a) nivel educativo alcanzado y según ingresos per cápita del hogar (para ello
#genera quintiles de ingresos); (b)horas trabajadas yedad del niño/a en meses.
#Explica brevemente los resultados encontrados a partir del análisis gráfico. 

#A
head(data)
quantile(data$ing_perk, c(0.20, 0.40, 0.60, 0.80, 1), na.rm = TRUE)

data$ing_quintiles=data$ing_perk
data$ing_quintiles[data$ing_perk<= 4141.596]=1
data$ing_quintiles[data$ing_perk>4141.596 & data$ing_perk<=6200.479]=2
data$ing_quintiles[data$ing_perk>6200.479 & data$ing_perk<=8768.683 ]=3
data$ing_quintiles[data$ing_perk>8768.683 & data$ing_perk<=13326.538  ]=4
data$ing_quintiles[data$ing_perk>13326.538 ]=5

table(data$ing_quintiles)

install.packages("ggplot2")
library(ggplot2)
ggplot(data, aes(x = ing_quintiles, group=cat_edu ,fill= cat_edu)) + 
  geom_bar(position='dodge') + xlab("Quintiles") + ylab("Frecuencia") + ggtitle("Nivel educativo alcanzado según ingresos per cápita del hogar") + labs(fill = "Nivel educativo alcanzado")  
ggplot(data,aes(x= ing_quintiles,group=cat_edu, fill=cat_edu))+
  geom_histogram(position='dodge') + xlab("Quintiles") + ylab("Frecuencia") + ggtitle("Nivel educativo alcanzado según ingresos per cápita del hogar") + labs(fill = "Nivel educativo alcanzado")  

#B
data$hs_trab=data$f85
data$hs_trab[data$f85<=300]=0
data$hs_trab[data$f85>30 ]=1
data$hs_trab = factor(data$hs_trab, levels = c(0,1), labels = c('Tiempo Parcial', 'Tiempo Completo'))
table(data$hs_trab)
data = subset(data, !is.na(hs_trab))

ggplot(data = data, aes(x = hs_trab, y = meses)) + 
  geom_jitter(aes(color = hs_trab), size = 1, alpha = 0.7) +
  geom_boxplot(aes(color = hs_trab), alpha = 0.7) + 
  xlab('Jornada Laboral') + 
  ylab('Edad en meses del niño/a') +
  ggtitle('Horas trabajadas según meses del niño/a ') + labs(fill = "Jornada laboral") 

ggplot(data,aes(x= meses,group=hs_trab, fill=hs_trab)) + geom_histogram(position='dodge') + xlab("Edad del niño en meses") + ylab("Frecuencia") + ggtitle("Horas trabajadas segun edad del niño/a en meses") + labs(fill = "Jornada Laboral de la Madre")  


#A partir del analisis grafico se puede observar que la relacion del nivel educativo alcanzado por las madres de niños/as menores a 4 años, y los ingresos per cápita del 
#hogar(dividiendo a la poblacion por quintiles) es positivo; a medida que se escala de quintil la frecuencia del alto nivel educativo alcanzado es mayor (de igual manera que a medida que
#se desciende de quintil la frecuencia del bajo nivel educativo es mayor)

table(data$cat_edu)
table(data$ASQ3_S)

#5.2. Grafica el indicador de desarrollo infantil ASQ según nivel educativo de la madre y según el ingreso per cápita del hogar. 
#ASQ3_S    ASQ3_R      ASQ3_MF        ASQ3_MG       ASQ3_C

quantile(data$bc_edu, c(0.333333, 0.666666), na.rm = TRUE)
data$cat_edu2=data$bc_edu
data$cat_edu2[data$bc_edu<8]=1
data$cat_edu2[data$bc_edu>=8 & data$bc_edu<=10]=2
data$cat_edu2[data$bc_edu>10 ]=3
table(data$cat_edu2)
data$cat_edu2 = factor(data$cat_edu2, levels = c(1,2,3), labels = c('Bajo', 'Medio', 'Alto'))


geom_bar(position='dodge') + xlab("Quintiles") + ylab("Frecuencia") + ggtitle("Resolucion de Problemas segun Ingreso") + labs(fill = "Indicador DI") 
ggplot(data = subset(data, !is.na(ASQ3_R)),aes(x= cat_edu2,group=ASQ3_R, fill=ASQ3_R))+
  geom_bar(position='dodge') + xlab("Nivel educativo alcanzado") + ylab("Frecuencia") + ggtitle("Resolucion de Problemas segun Educ. de la madre") + labs(fill = "Indicador DI")






clear all
set more off

log using "LOG_TrabajoFinal_TobíaDávila", replace 

cd "E:\FCEA\7° Semestre\Bases de Datos y Paquetes\Trabajo Final\Para Entregar" 

*Modificacion de formato de ciertas variables previa a la fusion:
use "Base Externa Informante primera ronda.dta", clear
destring numero, replace force
destring FORMULARIO, replace force
save "Base Externa Informante primera ronda 2 2.dta", replace

use "Base ASQ-3_ola 2.dta", clear
destring numero, replace force
rename nper_informante Nper_Entrev
destring Nper_Entrev, replace force
save "Base ASQ-3_ola 2 2.dta", replace

use "ECH_2012_fusionada.dta", clear
destring numero, replace force
drop _merge
save "ECH_2012_fusionada 2.dta", replace

use "fusionado_2013_terceros.dta", clear
destring numero, replace force
save "fusionado_2013_terceros 2.dta", replace

use "vector_educacion.dta", clear
destring numero, replace force
save "vector_educacion 2.dta", replace

*Comienzo de la fusion:
use "Base Externa Niños primera ronda.dta", clear
destring numero, replace force
merge m:1 IDENTIFICACION using "Base Externa Informante primera ronda 2.dta", keep(match)
drop _merge 

merge m:1 numero FORMULARIO PERSONA using "Base ASQ-3_ola 2 2.dta"
drop if _merge == 2
rename Nper_Entrev nper
drop _merge

merge m:1 numero nper using "ECH_2012_fusionada 2.dta", update
drop if _merge ==2
drop _merge

merge m:1 numero nper using "fusionado_2013_terceros 2.dta", update
drop if _merge == 2
drop _merge

merge m:1 numero nper using "vector_educacion 2.dta"
drop if _merge == 2
drop _merge

*Se pide 1: 

*Dummy Madre con niño/a entre 0 y 4 años
gen madre04 = .
replace madre04 = 1 if RS0 == 1 | RS0 == 2
replace madre04 = 0 if RS0 == 3 | RS0 == 9 

label variable madre04 "Quien contesta es Madre con algun/a niño/a entre 0 y 4 años"
label define madre04 1 "Si" 0 "No", replace
label values madre04 madre04

*Variable categorica Edad:
gen cat_edad = .
replace cat_edad = 1 if e27>0 & e27<=14
replace cat_edad = 2 if e27>14 & e27<=19
replace cat_edad = 3 if e27>19 & e27<=24
replace cat_edad = 4 if e27>24 & e27<35
replace cat_edad = 5 if e27>=35 & e27<100

label variable cat_edad "Tramos de edad"
label define cat_edad 1 "Menor de 14" 2 "Entre 14 y 19" 3 "Entre 20 y 24" 4 "Entre 25 y 34" 5 "Mas de 34", replace
label values cat_edad cat_edad

*Dummy Interior/Montevideo
gen montevideo = .
replace montevideo = 1 if dpto==1 
replace montevideo = 0 if dpto>1 & dpto<=19

label variable montevideo "Residencia"
label define montevideo 1 "Vive en Montevideo" 0 "Vive en el Interior", replace
label values montevideo montevideo

*Variable categorica educacion
gen cat_edu = .
replace cat_edu = 0 if bc_edu<9
replace cat_edu = 1 if bc_edu>=9 & bc_edu<=12
replace cat_edu = 2 if bc_edu>12 & bc_edu<50

label variable cat_edu "Años de Educacion"
label define cat_edu 0 "Menos de 9" 1 "Entre 9 y 12" 2 "Mas de 12", replace
label values cat_edu cat_edu

*Variable categorica Estado Civil:
replace e35 = 7 if e35==1
replace e35 = 8 if e35==2
replace e35 = 9 if e35==3
label define e35 7 "Casamiento Civil" 8 "Union libre con pareja de otro sexo" 9 "Union libre con pareja del mismo sexo", replace
label values e35 e35
gen est_civil = .
replace est_civil = e35 if e36==0
replace est_civil = e36 if e35==0
label variable est_civil "Estado Civil"
label define est_civil 1 "Separado/a de unión libre anterior" 2 "Divorciado/a" 3 "Casado/a (incluye separado/a y aún no se divorció" 4 "Viudo/a de casamiento" 5 "Soltero" 6 "Viudo/a de union libre" 7 "Casamiento Civil" 8 "Union libre con pareja de otro sexo" 9 "Union libre con pareja del mismo sexo", replace
label values est_civil est_civil

tabout cat_edad montevideo cat_edu madre04 using tabla1.txt, c(freq col) replace 
sum e27 if madre04==1
sum bc_edu if madre04==1

*Se pide 2:

 sum CF3A CF3B CF3C CF3D CF3E CF3F CF3G CF3H CF3I CF3J CF3K
 tab IH2
 tab IH3
 
*Se pide 3:

gen madre_ocupada= .
replace madre_ocupada=1 if TE5==1 & madre04==1
replace madre_ocupada=0 if TE5>1 & TE5<=2 & madre04==1
label variable madre_ocupada "Trabajando antes del embarazo"
label define madre_ocupada 0 "No" 1 "Si"
label value madre_ocupada madre_ocupada

gen madre_interru=.
replace madre_interru=1 if TE8==1 & madre04==1
replace madre_interru=0 if TE8==2 & madre04==1
label variable madre_interru "Interrupción del trabajo durante el embarazo/nacimiento del niño/a"
label define madre_interru 0 "No" 1 "Si"
label value madre_interru madre_interru

gen madre_vol=.
replace madre_vol=1 if TE9==1 & madre04==1
replace madre_vol=0 if TE9==2 & madre04==1
label variable madre_vol "Retoma empleo luego de 6 meses de nacimiento del niño/a"
label define madre_vol 0 "No" 1 "Si"
label value madre_vol madre_vol

tabout madre_ocupada madre_interru madre_vol cat_edu using tabla2.txt, c(freq col) replace

*Se pide 4:

*A
gen ocupad=.
replace ocupad=1 if pobpcoac==2
replace ocupad=0 if pobpcoac==3 | pobpcoac==4 | pobpcoac==5 
tabulate ocupad madre04, freq col

*B Tabla IPC para 2018. Fuente:INE
g ipc=.
replace ipc=	177.55	if mes==01
replace ipc=	179.11  if mes==02 
replace ipc=	179.61	if mes==03
replace ipc=	179.73	if mes==04
replace ipc=	181.19	if mes==05
replace ipc=	182.98	if mes==06
replace ipc=	184.07	if mes==07
replace ipc=	185.31	if mes==08
replace ipc=	186.23	if mes==09
replace ipc=	186.66	if mes==10
replace ipc=	187.34	if mes==11
replace ipc=	186.62	if mes==12

gen ing_def_perk = ysvl/TOT /*TOT cantidad de personas en el hogar*/
replace ing_def_perk = (ing_def_perk/ipc)*100
sum ing_def_perk 
hist ing_def_perk if ing_def_perk<40000, xtitle("Ingreso Per Capita del hogar(Deflactado)") bcolor(blue)

*C
gen hs_trab=.
replace hs_trab = TL8 if madre04==1
sum hs_trab 
hist hs_trab, xtitle("Horas trabajadas de la madre") bcolor(blue)

*D
gen ing_madre= (g126_1+ g126_2 +g126_3+ g126_4+ g126_5+ g126_6+ g126_7+ g126_8)
gen ing_def_madre= (ing_madre / ipc) *100
replace ing_def_madre = . if ing_def_madre == 0 & TL5>0 & TL5<10 
sum ing_def_madre if madre04==1

*Se pide 5: se guarda la base generada hasta ahora, para importar en R:

save "base para R", replace

*Se pide 7:

gen int_emp_mat_6 = . /* Variable categorica sobre intensidad del empleo materno*/ 
replace int_emp_mat_6 = 0 if TE9A>0 & TE9A<=20 
replace int_emp_mat_6 = 1 if TE9A>20 & TE9A<100

label variable int_emp_mat_6 "Intensidad del empleo materno en los primeros 6 meses al nacimiento"
label define int_emp_mat_6 0 "Jornada a tiempo parcial" 1 "Jornada a tiempo completo" 
label values int_emp_mat_6 int_emp_mat_6

gen edad_madre = . /*Edad de la madre extraida de la ECH*/ 
replace edad_madre = e27 if madre04 == 1 

replace IH2 = 0 if IH2 == 2/*Modificacion de la variable dicotomica de asistencia a centro educativo*/

*Se generaron variables dicotomicas de los indicadores de desarrollo para poder establecer correlaciones con sentido

gen ASQ3_CO = ./*Creacion de variable dicotomica para indicadores de desarrollo*/
replace ASQ3_CO = 1 if ASQ3_C == 3
replace ASQ3_CO = 0 if ASQ3_C == 2 | ASQ3_C == 1

gen ASQ3_MGR = ./*Creacion de variable dicotomica para indicadores de desarrollo*/
replace ASQ3_MGR = 1 if ASQ3_MG == 3
replace ASQ3_MGR = 0 if ASQ3_MG == 2 | ASQ3_MG == 1

gen ASQ3_MFI = ./*Creacion de variable dicotomica para indicadores de desarrollo*/
replace ASQ3_MFI = 1 if ASQ3_MF == 3
replace ASQ3_MFI = 0 if ASQ3_MF == 2 | ASQ3_MF == 1

gen ASQ3_RE = ./*Creacion de variable dicotomica para indicadores de desarrollo*/
replace ASQ3_RE = 1 if ASQ3_R == 3
replace ASQ3_RE = 0 if ASQ3_R == 2 | ASQ3_R == 1

gen ASQ3_SO = ./*Creacion de variable dicotomica para indicadores de desarrollo*/
replace ASQ3_SO = 1 if ASQ3_S == 3
replace ASQ3_SO = 0 if ASQ3_S == 2 | ASQ3_S == 1

gen calidad_cuid = ./*Creacion de variable dicotomica como indocador de calidad de cuidado*/
replace calidad_cuid = 0 if PC2==2 & PC3==2
replace calidad_cuid = 1 if PC2==1 | PC3==1
label variable calidad_cuid "Calidad del cuidado"
label define calidad_cuid 0 "Baja" 1 "Alta"
label values calidad_cuid calidad_cuid

gen ing_hogar = .
replace ing_hogar = ysvl if madre04==1

*Variables dicotomicas sobre educacion de la madre, para modelar.
gen edu_baja = .
replace edu_baja = 1 if cat_edu == 0
replace edu_baja = 0 if cat_edu==1|cat_edu==2

gen edu_media = .
replace edu_media = 1 if cat_edu == 1
replace edu_media = 0 if cat_edu==0|cat_edu==2

gen edu_alta = .
replace edu_alta = 1 if cat_edu == 2
replace edu_alta = 0 if cat_edu==0|cat_edu==1

pwcorr int_emp_mat_6 edad_madre montevideo TOT ing_hogar calidad_cuid IH2 edu_baja edu_media edu_alta ASQ3_CO ASQ3_MGR ASQ3_MFI ASQ3_RE ASQ3_SO, star(.05)

*Se pide 8:

gen madre_ret_6 = .
replace madre_ret_6 = 1 if TE9==1 & madre04==1
replace madre_ret_6 = 0 if TE9==2 & madre04==1
label variable madre_ret_6 "Madre trabajo dentro de los 6 meses luego del nacimiento del hijo/a"
label define madre_ret_6 1 "Si" 0 "No"
label values madre_ret_6 madre_ret_6

*Modelo para ver efecto del momento en que la madre retorna a la activ. laboral en el desarrollo infantil:
probit ASQ3_RE madre_ret_6 edad_madre montevideo TOT calidad_cuid ing_hogar edu_baja edu_alta IH2, robust
estimates store probit
matrix coef_probit =e(b)
margins, dydx(*)
estimates store margins_probit

*Modelo para ver efecto de la intensidad del empleo materno en el desarrollo infantil.
probit ASQ3_RE int_emp_mat edad_madre montevideo TOT calidad_cuid ing_hogar edu_baja edu_alta IH2, robust
estimates store probit
matrix coef_probit =e(b)
margins, dydx(*)
estimates store margins_probit

;Dudas:
;	- Imprimir por pantalla? No hay que imprimir nada
;	- ¿Hay que introducir por terminal el valor inicial y el tamaño, o se escribe directamente en las variables valor_inicial y tamanho en el script de ensamblador?
;	  Nada, todo por los parametros del fichero, ni imprimir ni leer datos
;	- Realizar direccionamiento con vector (Es vector(r2), si quiero ir al indice 3 del vector (r2=2))? o ¿Es como las matrices, pero de forma lineal?

; Fibonacci: vector[1]=vector[2]=1, vector[n]=vector[n-2]+vector[n-1]
; r10	-> Numero de elementos
; r2	-> contador n
; f4	-> vector[n-2]
; f5	-> vector[n-1]
; f6	-> vector[n]
; f7	-> Para la suma
; f20	-> Para imprimir

		.data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VARIABLES DE ENTRADA: NO MODIFICAR
; valor inicial para la secuencia (de 1.0 a 5.0)
valor_inicial:	.float	5
; Tamanho de la secuencia (multiplo de 5 minimo 10 maximo 30)
tamanho:	.word	30

;;;;; VARIABLES DE SALIDA: NO MODIFICAR ORDEN (TODAS FORMATO FLOAT)
vector:		.space	120
suma: 		.float 	0
; m11=vector[5], m12=vector[6]
; m21=vector[7], m22=vector[8]
M:		.float 0.0, 0.0
		.float 0.0, 0.0
detM: 		.float 0.0
mediaM: 	.float 0.0
; v11=m11/mediaM, v12=m12/mediaM
; v21=m21/mediaM, v22=m22/mediaM
V: 		.float 0.0, 0.0
		.float 0.0, 0.0
detV: 		.float 0.0
mediaV: 	.float 0.0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FORMATO DE IMPRESION
PrintFormat:	.asciiz	"%d\n"
		.align	2
PrintPar:	.word	PrintFormat
PrintValue:	.space	4

;VALORES INICIALES
	f_0:		.float 	0
	f_1:		.float	1
	f_10:		.float	10
	f_4:		.float	4

		.text
		.global main


main:
	lw	r10,tamanho	;Establece el fin de la serie
	addi	r2,r0,0		;Contador a 0
	addi	r3,r0,0		;Contador de vector a 0

	;Valores float utiles para operaciones
	lf	f0,f_0		;Float 0
	lf	f1,f_1		;Float 1
	lf	f2,f_10		;Float 10
	lf	f3,f_4		;Float 4

	;Carga de los registros iniciales
	lf	f4,f_0
	lf	f5,valor_inicial
	lf	f6,valor_inicial
	lf	f7,suma

loop:
	sub	r7,r10,r2	;r7=tamanho-r2
	addi	r2,r2,#1	;r2++
	beqz	r7,matrixM	;si r7=0 final
	subi	r8,r2,2		;Mira si es vector[1] o vector[2] si n-3<0
	slti	r11,r8,0
	bnez	r11,a1a2	;si lo es salta caso contrario continua

	addf	f6,f4,f5	;vector[n] = vector[n-2] + vector[n-1]
	addf	f5,f0,f4	;vector[n-2] = vector[n-1]
	addf	f4,f0,f6	;vector[n-1] = vector[n]
	addf	f7,f7,f6	;realizar suma de todos los elementos
	sf	vector(r3),f6
	addi	r3,r3,#4	;r3++
	j 	loop		;vuelve al principio

a1a2:
	addf	f6,f0,f0	;vector[1] = 1, vector[2] = 1S
	sf	vector(r3),f8
	addi	r3,r3,#4	;r3++
	j	loop

matrixM:
	lf	f8,vector+16
	lf	f9,vector+20
	lf	f10,vector+24
	lf	f11,vector+28
	
	sf	suma,f7
	sf	M,f8
	sf	M+4,f9
	sf	M+8,f10
	sf	M+12,f11

;determinanteM
	multf	f12,f8,f11
	multf	f13,f9,f10
	subf	f14,f12,f13
	sf	detM,f14

	;Comprobacion division entre 0 (Si el determinante es 0, salirse, de lo contrario, se realizarian divisiones entre 0, las otras 2 divisiones del programa (las medias), DEBEN dividirse entre 4)
	;addi	r20,r0,#0	
	movfp2i	r20,f14
	beqz	r20,finish

;mediaM
	addf	f15,f8,f9
	addf	f16,f10,f11
	addf	f17,f15,f16
	divf	f18,f17,f3
	sf	mediaM,f18

;matrizV
	divf	f19,f8,f14
	divf	f20,f9,f14
	divf	f21,f10,f14
	divf	f22,f11,f14
	
	sf	V,f19
	sf	V+4,f20
	sf	V+8,f21
	sf	V+12,f22
	
;determinanteV
	multf	f23,f19,f22
	multf	f24,f20,f21
	subf	f25,f23,f24
	sf	detV,f25

;mediaV
	addf	f26,f19,f20
	addf	f27,f21,f22
	addf	f28,f26,f27
	divf	f29,f28,f3
	sf	mediaV,f29

	j	finish

	
	
finish:
	trap 0	
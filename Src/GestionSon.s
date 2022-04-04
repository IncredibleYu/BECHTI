	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
	import Son
	import LongueurSon 
	import PeriodeSonMicroSec 
	export CallbackSon
	export SortieSon
	export Index
	
	
; ===============================================================================================
	
SortieSon	dcd 0
Index	dcd 0

;*****ldrsh
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		
CallbackSon proc

;   sortir Rx vers la pwm
; 	indice ++
	push {lr,r4-r7}
	
	ldr r4, =LongueurSon ;r4=&LongueurSon
	ldr r1, [r4]         ;r1=*LongueurSon	
	ldr r4, =Index 		 ;r4=&Index
	ldr r2, [r4]         ;r2=*Index	
	
	cmp r2, r1           ;comparer la LongueurSon et Index			 	 
	bge Finsi;  	     ;si Index >= LongueurSon, on passes à after
	
	;	recup l'échantillon
	ldr r1, =Son
	ldrsh r0, [r1,r2, lsl #1]

	;   mise à l'échelle de Rx
	ldr r5, =SortieSon
	ldr r7, [r5]
	add r0, #32768       		; [-32768, 32768] -> [0, 65536]
	mov r6, #719
	mul r0, r0, r6	 		; [0, 65536]->[0,65536*719]
	
	lsr r0, r0, #16				; [0,65536*719]->[0,719]
	
	str r0, [r5]	; SortieSon = r0
	ldr r7, [r5]
	
	

	add r2, r2, #1				; i++
	str r2, [r4] 				; Index = r2

Finsi
	pop {lr,r4-r7}
	
	bx lr
	ENDP
	END
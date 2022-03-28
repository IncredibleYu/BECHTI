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
	
	
; ===============================================================================================
	
SortieSon	dcw [0,719]
Index	dcd 0

;*****ldrsh
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		
CallbackSon proc

;   sortir Rx vers la pwm
; 	indice ++
	push {lr,r4,r5}
	
	ldr r4, =LongueurSon ;r4=&LongueurSon
	ldr r1, [r4]         ;r1=*LongueurSon	
	ldr r4, =Index 		 ;r4=&Index
	ldr r2, [r4]         ;r2=*Index	
	
	cmp r2, r1           ;comparer la LongueurSon et Index			 	 
	bge after;  	     ;si Index < LongueurSon, on passes next
	
	;	recup l'échantillon
	lrd r1, =Son
	ldrsh r0, [r1,r2, lsl #1]

	;   mise à l'échelle de Rx
	ldr r5, =SortieSon
	add r0, #32768       ;16bits, 2^15=32768
	
	
	

after
	pop {lr,r4,r5}
	bx lr 

; fin si
	endp
	END
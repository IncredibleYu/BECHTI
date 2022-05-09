	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
VarTime	dcd 0

	
; ===============================================================================================
	
;constantes (équivalent du #define en C)
TimeValue	equ 900000


	EXPORT Delay_100ms ; la fonction Delay_100ms est rendue publique donc utilisable par d'autres modules.
	export VarTime
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		


; REMARQUE IMPORTANTE 
; Cette manière de créer une temporisation n'est clairement pas la bonne manière de procéder :
; - elle est peu précise
; - la fonction prend tout le temps CPU pour... ne rien faire...
;
; Pour autant, la fonction montre :
; - les boucles en ASM
; - l'accés écr/lec de variable en RAM
; - le mécanisme d'appel / retour sous programme
;
; et donc possède un intérêt pour débuter en ASM pur

Delay_100ms proc
	
	    ldr r0,=VarTime  ; r0 = VarTime		  
						  
		ldr r1,=TimeValue  ; r1 = TimeValue
		str r1,[r0] ; *r0 = r1 donc  r0 = TimeValue   VarTime=900000 passer en mémoire
		
BoucleTempo	
		ldr r1,[r0] ; r1 = *r0 donc r1 = 900000	récupérer la mémoire dans registre			
						
		subs r1,#1 ; r1 = r1 - 1 = 900000-1
		str  r1,[r0] ; *r0 = r1 donc r0 = 899999 passer en mémoire dans l'adresse de r0
		bne	 BoucleTempo ; Si flag z = 0 boucle, sinon on continue 
			
		bx lr ;return et sortie programme
		endp
		
		
	END	
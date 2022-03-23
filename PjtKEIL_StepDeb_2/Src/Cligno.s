	PRESERVE8
	THUMB   
		

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		

	
; ===============================================================================================
	

	

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; �crire le code ici		

timer_callback
	push {lr,r4,r5}
	ldr r4, =FlagCligno
	ldr r5, [r4]
	cmp r5, #1
	bne else
	
	bl GPIOB_Set

	mov r5, #0
	str r5, [r4]
	b after 

else
	bl GPIOB_Clear
	mov r5, #1
	str r5, [r4]

after
	pop {lr,r4,r5}
	bx lr 



		
		
	END	
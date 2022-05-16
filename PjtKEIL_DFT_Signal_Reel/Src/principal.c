

#include "DriverJeuLaser.h"


extern int DFT(short int * Signal64ech, char k);

extern short int LeSignal[64];

int result[64];

short int dma_buf[64];

void Callback_Systick(void)
{
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	for (char k=0; k<64; k++) {
		result[k] = DFT(dma_buf, k);
	}
}

int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();

Systick_Period_ff(360000); /*T=Tck*n donc n=T/Tck=5ms/(1/72MHz)=360000*/
Systick_Prio_IT( 10, Callback_Systick );
SysTick_On ;
SysTick_Enable_IT ;

	
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
Init_ADC1_DMA1( 0, dma_buf );

//============================================================================	

	
while	(1)
	{
	}
}




#include "DriverJeuLaser.h"

#include "GestionSon.h"


extern int DFT(short int * Signal64ech, char k);

extern short int LeSignal[64];

int result[64];

short int dma_buf[64];

int score[4] = {0,0,0,0};

int compteur[4] = {0,0,0,0};


void Callback_Systick(void)
{
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	for (char k=0; k<64; k++) {
		result[k] = DFT(dma_buf, k);
	}
										
	if (result[17] >= 0x9999A) {
		compteur[0]++;
		if (compteur[0] == 20) {
			score[0]++;
			compteur[0] = 0;
			StartSon();
			}
	}
	if (result[18] >= 0x9999A) {
		compteur[1]++;
		if (compteur[1] == 20) {
				score[1]++;
				compteur[1] = 0;
				StartSon();
		}
	}
	if (result[19] >= 0x9999A) {
		compteur[2]++;
		if (compteur[2] == 20) {
				score[2]++;
				compteur[2] = 0;
				StartSon();
		}
	}
	if (result[20] >= 0x9999A) {
		compteur[3]++;
		if (compteur[3] == 20) {
				score[3]++;
				compteur[3] = 0;
				StartSon();
		}
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

// Configuration ADC
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
Init_ADC1_DMA1( 0, dma_buf );

SysTick_Enable_IT ;
	
// Initialisation périphériques
// configuration CallbackSon
Timer_1234_Init_ff(TIM4, 6552); 												// période = 91 µs
Active_IT_Debordement_Timer( TIM4, 2, CallbackSon);

// configuration PWM
PWM_Init_ff(TIM3, 3, 720);
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);	
//============================================================================	

	
while	(1)
	{
	}
}


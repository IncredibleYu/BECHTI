

#include "DriverJeuLaser.h"


extern int DFT_ModuleAuCarre(short int * Signal64ech, char k);

extern short int LeSignal[64];

int result[64];

int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();


	
	

//============================================================================	
for (char k=0; k<64; k++) {
	result[k] = DFT_ModuleAuCarre(LeSignal, k);
}
	
while	(1)
	{
	}
}


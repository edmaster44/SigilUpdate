/*
	Handles all custom grenades.
*/

#include "gl_grenades_inc"

void main()
{
	int nSpell = GetSpellId();
	
	switch (nSpell) {
		case 1230: DoLowFireBomb();        break;
		case 1231: DoMediumAcidBomb();     break;
		case 1232: DoStrongShrapnelBomb(); break;
		case 1233: DoSmokeBomb();          break;
		case 1234: DoChokingBomb();        break;
		case 1235: DoSleepBomb();          break;
		case 1236: DoCaltropsBomb();       break;
		
		default: break;
	}
}
/*	Alersia  03/15/2016
	Script for changing dragon size
	
	Parameters (iParam):	
	0 = large			
	1 = huge		
	2 = medium				

*/

#include "ps_inc_functions"
#include "aaa_dragon_size"
	
void main(int iParam)
{
	object oPC		= OBJECT_SELF;
	
	switch(iParam)
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~LARGE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */	
	{	case 0:
			PS_Dragon_Large(oPC);
			SendMessageToPC(oPC, "You have chosen to be of large size.");
			DelayCommand(1.0f, AssignCommand(oPC, ActionRest()));
		break;	
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~HUGE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */		
		case 1:
			PS_Dragon_Huge(oPC);
			SendMessageToPC(oPC, "You have chosen to be of huge size.");
		    DelayCommand(1.0f, AssignCommand(oPC, ActionRest()));
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MEDIUM~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 2:
			PS_Dragon_Medium(oPC);
			SendMessageToPC(oPC, "You have chosen to be medium size.");
			DelayCommand(1.0f, AssignCommand(oPC, ActionRest()));
		break;	
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */	
	}
}		
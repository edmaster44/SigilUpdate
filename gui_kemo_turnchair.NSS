#include "ff_safevar"

void main()
{
	//object oPC = GetPCSpeaker();
	object oPC = OBJECT_SELF;
	object oChair = PS_GetLocalObject(oPC,"SittingChair");
	float fFacing = GetFacing(oChair);
	
	fFacing = fFacing + 20.0f;
	
	AssignCommand(oChair,SetFacing(fFacing));
}
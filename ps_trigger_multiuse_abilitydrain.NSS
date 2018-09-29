//Script by Dedic8ed
//This script is designed to be used by a placed trigger.

void main()
{
	object oPC = GetEnteringObject();;
	
	if (!GetIsPC(oPC)) return;
	
	int iAbility = GetLocalInt(OBJECT_SELF,"ability");
/*
	Where 	
		Strength =		0
		Dexterity =		1
		Constitution =	2
		Intelligence = 	3
		Wisdom = 		4
		Charisma =		5
*/
	int iDrain = GetLocalInt(OBJECT_SELF,"drainamount");
	string sVFX = GetLocalString(OBJECT_SELF,"vfx");
//Setting the visual effect that will apply; must have the .sef extension
	effect eDrain = EffectAbilityDecrease(iAbility, iDrain);
//Pulls together the previous integers and strings to define the effect
	string sFloaty = GetLocalString(OBJECT_SELF,"floaty");
//the "floaty" variable will be generated as floaty text over the head of the character pulling the lever
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFX), oPC);
	FloatingTextStringOnCreature(sFloaty,oPC);
	DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDrain, oPC));
	
}
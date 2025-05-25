

//Script by Dedic8ed
//This script is designed to be used by a placed trigger.

void main()
{
	object oPC = GetEnteringObject();;
	
	if (!GetIsPC(oPC)) return;
	
	int iType = GetLocalInt(OBJECT_SELF,"damagetype");
/*
	Where 	
		Bludgeoning =	1
		Piercing =		2
		Slashing = 		4
		Magical = 		8
		Acid 	= 		16
		Cold = 			32
		Divine = 		64
		Electrical = 	128
		Fire = 			256
		Negative = 		512
		Positive = 		1024
		Sonic 	= 		2048
*/
	
	int iAmount = GetLocalInt(OBJECT_SELF,"damageamount");
//Where the damage in hit points is preset
	int iIgnore = GetLocalInt(OBJECT_SELF,"ignore");
//Where 1 = TRUE and 0 = FALSE, for ignoring immunity, DR, and resistances
	string sVFX = GetLocalString(OBJECT_SELF,"vfx");
//Setting the visual effect that will apply; must have the .sef extension
	effect eDamage = EffectDamage(iAmount,iType, DAMAGE_POWER_NORMAL, iIgnore);
//Pulls together the previous integers and strings to define the effect
	effect eAgony = EffectKnockdown();
//To knock down the character; ow, that hurts!
	string sFloaty = GetLocalString(OBJECT_SELF,"floaty");
//the "floaty" variable will be generated as floaty text over the head of the character pulling the lever
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFX), oPC, 15.0f);
	FloatingTextStringOnCreature(sFloaty,oPC);
	DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAgony, oPC, 6.0f);
	

}
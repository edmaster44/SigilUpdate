//Script by Dedic8ed
//This script is designed to be used by a placed trigger.

void main()
{
	object oPC = GetEnteringObject();;
	
	if (!GetIsPC(oPC)) return;
	
	string sCaster = GetLocalString(OBJECT_SELF,"caster");
	object oCaster = GetObjectByTag(sCaster);
//These designate the placeable object from which the spell will originate. The placeable must be set to "hostile".

	int iSpell = GetLocalInt(OBJECT_SELF,"spell");
	int iLevel = GetLocalInt(OBJECT_SELF,"level");
//Designates what spell will be cast and the caster level used. Use spell IDs from spells.2da
	
AssignCommand(oCaster, ActionCastSpellAtObject(iSpell, oPC, METAMAGIC_ANY, TRUE, iLevel, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));	

}
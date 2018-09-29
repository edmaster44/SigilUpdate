// i_ps_polymorph_ac

/* Created by Dedic8ed 5/24/2010
	Any singular polymorphing item can be used for this script, and can polymorph into any creature contained
	within the polymorph.2da file. The item's tag must be "ps_it_polymorph". Use unique resrefs to differentiate
	the items within toolset. Items should also be required to be "active only when equipped" for game balance
	purposes.

	Set the item's variable "polymorph" to match the integer of the 2da line item of the form to be polymorphed 
	into; i.e. 27 for cow, or 32 for succubus.
	
	Set the item's variable "duration" to the number of turns (60 seconds each) for the effect to last,
	i.e., 1 hour = 60 turns, while a full day = 1440 turns.
*/

void main()
{
object oPC = GetItemActivator();
int iACBoost = GetAbilityModifier(ABILITY_CHARISMA, oPC);
effect eACIncrease = EffectACIncrease(iACBoost, AC_DEFLECTION_BONUS,AC_VS_DAMAGE_TYPE_ALL, FALSE);
effect eSuperACInc = SupernaturalEffect(eACIncrease);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSuperACInc, oPC);
}
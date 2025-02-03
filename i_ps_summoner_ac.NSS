// i_ps_summoner_ac
/*	Script created by Dedic8ed for use in the Sigil: City of Doors PW
	   
This script is designed to allow items which allow the user to summon a creature, which will remain with the
character until rest. Variables will allow for multiple summoned creatures to be serviced by a single script,
as well as expandability as new monsters are created.

"summon" is the template of the creature being summonned. After summoning, the creature is added as a henchman 
to the summoner. If the summoner already has a henchman, it will be destroyed in the act of summoning and
replaced by the newly summoned creature. An "unsummon" widget will be placed in the PC's inventory.

*/  

// Modification by Agony_Aunt to store repawning of hench in event of server crash within time specified in function
// AllowRespawnHench in ps_inc_faction
#include "ps_inc_faction"

void main()
{
	object oPC		= GetItemActivator();
	object oItem	= GetItemActivated();
//	Collect variable from the calling item to determine what will be summonned
	string sCritter	= GetLocalString(oItem, "summon");
	location oLoc 	= GetItemActivatedTargetLocation();
	object oBad		= GetFirstItemInInventory(oPC);
	
	SendMessageToPC(oPC, "spawning "+sCritter);

/* 	Destroy any old unsummoner items the character may have in their inventory. This will only
	be relevant in the event that a summonned henchman already exists when another is summonned; otherwise
	additional copies of the unsummoner will remain in the character's inventory.
*/
while (GetIsObjectValid(oBad))
   {
   if (GetTag(oBad)=="ps_unsummoner") DestroyObject(oBad);

   oBad = GetNextItemInInventory(oPC);
   }

/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman.
*/
	object oOldHench= GetHenchman(oPC);
	DestroyObject(oOldHench);
	
//	Create the new henchman as an object
	object oHench	= CreateObject(OBJECT_TYPE_CREATURE, sCritter, oLoc);
	ChangeToStandardFaction(oHench, STANDARD_FACTION_DEFENDER);
	AssignCommand(oHench, ClearAllActions());
	
	SetLocalObject(oHench, "SUMMONER", oPC);
		
//	Add the created creature as a henchman and apply the "henchman" script set
	object oFeather = CreateItemOnObject("ps_unsummoner", oPC);
	DelayCommand(0.20, StoreHenchInfo(oFeather, oHench));
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"A cohort has joined you. To release from service, use the Unsummon Cohort tool which has been placed in your inventory.");
	
}
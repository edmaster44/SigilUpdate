#include "ff_safevar"

// i_ps_multisummon_ac
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
	SetMaxHenchmen(4);
	
	object oPC		= GetItemActivator();
	object oItem	= GetItemActivated();
//	Collect variable from the calling item to determine what will be summonned
	string sCritter	= PS_GetLocalString(oItem, "summon");
	location oLoc 	= GetItemActivatedTargetLocation();
	object oBad		= GetFirstItemInInventory(oPC);
	int oLVL		= GetHitDice(oPC);

		SendMessageToPC(oPC,"This is the normal sCritter value: " + sCritter);
	
/* 	Destroy any old unsummoner items the character may have in their inventory. This will only
	be relevant in the event that a summonned henchman already exists when another is summonned; otherwise
	additional copies of the unsummoner will remain in the character's inventory.
*/

/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman.
*/

	int i;

	int iNumHenchmen = GetMaxHenchmen(); 
 	for (i = iNumHenchmen; i>=4; i--) 
		 { 
		 object oHenchman = GetHenchman(oPC, i); 
		//PrettyDebug ("Removing " + GetName(oHenchman)); 
		//RemoveHenchman(oMaster, oHenchman); 
 	    //SetPlotFlag(oHenchman, FALSE); 
 		DelayCommand(0.5f, DestroyObject(oHenchman)); 
		DelayCommand(1.0f, RemoveHenchman(oPC,oHenchman));
		// delay destructions so we have time to iterate through party properly 
 		 
		 
//	Create the new henchman as an object

if (oLVL >= 15 && oLVL <= 26) {
	PS_SetLocalString(oItem, sCritter, (sCritter+"2"));
	SendMessageToPC(oPC,"It should now be stage two summon. sCritter value: " + sCritter);
	}
	
else if (oLVL >= 27) {
	PS_SetLocalString(oItem, sCritter, (sCritter+"3"));
	SendMessageToPC(oPC,"It is now a stage three summon. sCritter value: " + sCritter);
	}
	
		SendMessageToPC(oPC,"sCritter value: " + sCritter);
		
//	Add the created creature as a henchman and apply the "henchman" script set
	object oHench	= CreateObject(OBJECT_TYPE_CREATURE, sCritter, oLoc);
		
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"A cohort has joined you. To release from service, talk them and tell them to bugger off.");

	}
}
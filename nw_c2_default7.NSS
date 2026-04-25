

//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death. 
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
// chazm 5/6/05 added DeathScript
// ChazM 7/28/05 removed call to user defined event for onDeath
// ChazM - 1/26/07 - EvenFlw modifications
// ChazM -5/17/07 - Spirits don't drop crafting items, removed re-equip weapon code

#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "ps_inc_scriptcall"

void SpawnSpecificItem(object oKiller){
	object oPC = oKiller;
	object oItem;
	if (!GetIsPC(oPC)) oPC = GetMaster(oPC);
	if (!GetIsPC(oPC)) oPC = GetFirstFactionMember(oPC);
	if (!GetIsPC(oPC)) return;
	location lLoc = GetLocation(OBJECT_SELF);
	string sRef = "";
	int nRace = GetSubRace(OBJECT_SELF);
	if (FindSubString(GetTag(OBJECT_SELF), "ps_creature_ascended") != -1){//niflheim boss The Ascended
		sRef = "ps_key_mystery"; //always drops key to antechamber
	} else if (nRace == 40){ // incorporeal
		switch (d6()){
			case 1: sRef = "n2_crft_dist028"; break;//ghostly essence 
			case 2: sRef = "n2_crft_dist017"; break;//ghost residue
			case 3: sRef = "n2_crft_dist027"; break;//shadow residue
			default: return;
		}
	} else if (nRace == 137){ //ghoul
		int nRandom = d12();
		if (nRandom <= 3) sRef = "n2_crft_dist015";//ghoul claws
		else if (nRandom <= 6) sRef = "n2_crft_dist016";//ghast claws
		else return;
	} else if (nRace == 159){ //vampire
		if (d20() <= 10) sRef = "n2_crft_dist035"; //vamp tooth
		else return;
	}
	oItem = CreateObject(OBJECT_TYPE_ITEM, sRef, lLoc);
	FloatingTextStringOnCreature("The slain has dropped something!", oPC); 
	//try dropping on ground
	/*
		string sTag = GetTag(OBJECT_SELF);
	if (FindSubString(sTag, "ps_creature_ascended") != -1){//niflheim boss The Ascended
		SpawnSpecificItem("ps_key_mystery", oKiller, GetLocation(OBJECT_SELF), 
			"A key drops to the ground!", "You found a key!");//drops key to antechamber
	if (!GetIsPC(oPC)){
		oItem = CreateObject(OBJECT_TYPE_ITEM, sRes, lCrimeScene);
		AssignCommand(oItem, SpeakString(sDrop));
	} else {
		oItem = CreateItemOnObject(sRes, oPC);
		SendMessageToPC(oPC, sFind);
	}*/
}

void main()
{
	object oKiller = GetLastKiller();
	SpawnSpecificItem(oKiller);
	ExecuteScript("ps_xp_script",OBJECT_SELF);

	string sDeathScript = GetLocalString(OBJECT_SELF, "DeathScript");
	if (sDeathScript != "")
		ExecuteScript(sDeathScript, OBJECT_SELF);

	
    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
	

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }
	
	//PS_WP_DeathDealer(oKiller);

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
	
	//Old Craft Drop - remove later?
	//if (!GetIsSpirit(OBJECT_SELF))
    //	craft_drop_items(oKiller);
	
}
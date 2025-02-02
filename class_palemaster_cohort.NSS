#include "x2_inc_spellhook"




void main(object oPC)
{
	if (!X2PreSpellCastCode())
    {	return;	}

    object oPC 			= OBJECT_SELF;
	object oTarget		= GetSpellTargetObject();
	location lTarget	= GetSpellTargetLocation();
	int iLevel;
    
	int nLevel 			= GetTotalLevels(oPC, FALSE);
	object 	oItem		= GetItemPossessedBy(oPC,"ps_essence");
	string sLA 			= PS_GetLocalString(oItem, "ECL");
	int nLA 			= StringToInt(sLA);
		nLevel = nLevel + nLA;
	
/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman. */
	object oOldHench= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster = GetLocation(oPC);	
	
 	if (nLevel >= 24)
    {	sCritter = "ps_summon_pale2";	}
	else
	{	sCritter = "ps_summon_pale1";	}

    object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName = GetName(oHench);
	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"A " + sName + " has answered your Call. Use the Unsummon Undead feat to return him to his coffin.");

}
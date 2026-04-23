#include "x2_inc_craft"


int PS_GetIsSequencerPot(object oSequencer){
	string sRef = GetResRef(oSequencer);
	//check to make sure this is a sequencer pot
	if (sRef == "ps_potion_lessersequencer" || sRef == "ps_potion_sequencer" ||
		sRef == "ps_potion_greatersequncer")
			return TRUE;
	return FALSE;
}

string GetSpellName(int nId){
	string sNameRef = Get2DAString("spells", "Name", nId);
	return GetStringByStrRef(StringToInt(sNameRef));
}

void PS_RenameSequencerPot(object oSequencer, object oCaster){
	
	int nSpell1 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1"); 
	int nSpell2 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2"); 
	int nSpell3 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3");
	// if no spells stored something has gone wrong
	if (nSpell1 + nSpell2 + nSpell3 < 1) return;
	int nNumberOfTriggers = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
	int nStack = GetItemStackSize(oSequencer);
	string sSpell1 = GetSpellName(nSpell1 - 1);
	string sSpell2, sSpell3;
	if (nSpell2 > 0) sSpell2 = GetSpellName(nSpell2 - 1);
	if (nSpell3 > 0) sSpell3 = GetSpellName(nSpell3 - 1);
	
	string sName = "<c=cyan>";
	string sRef = GetResRef(oSequencer);
	if (sRef == "ps_potion_lessersequencer") sName += "Lesser ";
	else if (sRef == "ps_potion_greatersequencer") sName += "Greater ";
	sName += "Sequencer: ";
	
	if (nSpell2 == 0 && nSpell3 == 0){
		sName += sSpell1;
	} else if (nSpell3 == 0){
		sName += sSpell1 + " and " + sSpell2;
	} else {
		sName += sSpell1 + ", " + sSpell2 + ", and " + sSpell3;
	}
	sName += "</c>";
	SetItemStackSize(oSequencer, 1);
	SetFirstName(oSequencer, sName);
	SetItemStackSize(oSequencer, nStack);
	SetLocalInt(oSequencer, "X2_L_NUMTRIGGERS", nNumberOfTriggers);
	SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1", nSpell1); 
	if (nSpell2 > 0)
		SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2", nSpell2); 
	if (nSpell3 > 0)
		SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3", nSpell3);
	string sMessage = "Your Sequencer Potion has been renamed.\nThe new name will become visible ";
	sMessage += "after an area transition.";
	SendMessageToPC(oCaster, sMessage);
}

int PS_PayForSequencerPot(object oSequencer, object oCaster){
	
	int nId = GetSpellId();
	int nLevel = CIGetSpellInnateLevel(nId, FALSE);
	int nGold = CIGetCraftGPCost(oCaster, nLevel, X2_CI_BREWPOTION_COSTMODIFIER);
	nGold *= GetItemStackSize(oSequencer);

	if (GetGold(oCaster) < nGold){
		FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // not enough gold!
        return FALSE;
	}
	PS_TakeGoldFromCreature(nGold, oCaster);
	return TRUE;
}
// there is a bug in the default sequencer potions we've been using. The sequencer item property
// relies on local integers stored on the item that has the property. If you have a stack of such items
// then if you split them what really happens is part of your stack is destroyed and a new copy is
// made for the split-off stack. When this happens, the local integers are NOT copied, so the new
// "child" stack cannot cast spells and reads as empty. Just as bad, if you have one of the original
// sequencer pots with a spell stored you can drop 9 empty ones on top of it (assuming they're all the
// same resource reference and name) and the ones you dropped on will inherit the local integers of the
// original. Infinite spell reuse as many times as your pockets are deep. Forever.

// So, I've done 3 things:
// 1, to prevent the exploit, I've made sequencer pots get automatically renamed to the spells upon them
// and made the dmfi and item editor unable to be used on potions. You can't drop a stack of empties on
// one full because their names won't be the same.
// 2, I've created new sequencer pots that store the relevant spell data as a string in the item tag.
// Tags ARE copied during a stack split. The new pots use unique power, self only, single use and code 
// in x2_mod_def_act gets the spell id(s) from the tag and casts them from functions here.
// 3, I've given the old style sequencer potions the same kind of tag and put a function in ps_rest
// that calls upon code here to restore lost local ints on seq pots from their tags.
// -FlattedFifth, june 25, 2026

#include "x2_inc_craft"
#include "ff_sequencer_inc"


int FF_GetIsSeqAndStoreSpell(object oPC, object oSequencer){
	// if it's not a sequncer at all, return false and let them carry on
	if (IPGetItemSequencerProperty(oSequencer) < 1 && 
		FF_GetIsNewSequencerPot(oSequencer) == FALSE) 
			return FALSE;
	
	struct dSequencerData data = FF_GetSeqData(oSequencer);
	// a return value of true means only that this was an attempt
	// to store a spell on a sequencer, not that the attempt succeeded
	if (!FF_GetQualifiesForSequencer(oPC, oSequencer, data)) return TRUE;
	
	int nId = GetSpellId() + 1;
	if (data.nSpell1 == 0) data.nSpell1 = nId;
	else if (data.nSpell2 == 0) data.nSpell2 = nId;
	else if (data.nSpell3 == 0) data.nSpell3 = nId;
	else SendMessageToPC(oPC, "All spell slots full!");
	
	// this is only necessary on the item property style sequencers but it doesn't hurt
	// to put the local ints on the new seq pots too
	FF_ApplySeqVars(oSequencer, data);
	
	effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC);
    FloatingTextStrRefOnCreature(83884, oPC);
	if (FF_GetIsSeqPot(oSequencer)){
		FF_RenameSeqPotAndSetTag(oSequencer, data);
		string sMessage = "<c=cyan>Your Sequencer Potion has been renamed.\nThe new name will ";
		sMessage += "become visible after an area transition or after you move the potion from ";
		sMessage += "one square to another in your inventory.</c>";
		SendMessageToPC(oPC, sMessage);
	}
	return TRUE;
}

void FF_CastSpellFromNewSequencer(object oCaster, object oSequencer){
	if (!FF_GetIsNewSequencerPot(oSequencer)) return;
	struct dSequencerData data = FF_GetSeqData(oSequencer);
	// if the tag was set up correctly it should contain ONLY numbers and whatever
	// we're currently using as a delimiter in ff_arrays. Therefore there shouldn't
	// be any letters.
	if (data.nNumSpells == 0 || !FF_GetIsSeqTag(GetTag(oSequencer))){
		FloatingTextStringOnCreature("No spells stored!", oCaster);
		return;
	}
	if (data.nSpell1 != 0) FF_DoSpellCastCheatMode(oCaster, data.nSpell1 -1, oCaster);
	if (data.nSpell2 != 0) FF_DoSpellCastCheatMode(oCaster, data.nSpell2 -1, oCaster);
	if (data.nSpell3 != 0) FF_DoSpellCastCheatMode(oCaster, data.nSpell3 -1, oCaster);
}

void FF_RepairAllOldSeq(object oPC){
	int i = 0;
	object oSequencer = GetFirstItemInInventory(oPC);
	//27072 = num of items a pc could have if inv full of full bags, including the bags
    while (GetIsObjectValid(oSequencer) && i <= 27072){
		i++;
		FF_RecoverOldSequencer(oSequencer);
        oSequencer = GetNextItemInInventory(oPC);
    }
}


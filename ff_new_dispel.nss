/*
	ff_new_dispel.nss by FlattedFifth WIP
	Home-brew rule for dispelling that, instead of being a DC of 10 + the spell level,
	now is an opposed roll that takes more into account. roll is
	1d20 + dispeller's caster level + the spell level of the dispel
	vs
	1d20 + spell caster's level + the spell level of the spell being dispelled

*/

#include "ps_inc_functions"
#include "x0_i0_spells"

// checks if we can dispell the target and, if we cannot, returns an error message as to why not
string GetDispelErrorMessage(object oTarget, object oDispeller, int bIsEnemy, int nId);

// if we're only removing a limited number of effects, then this function will give user
// the highest spell level effect that we haven't already tried to dispel. If we're dispelling
// everything then the main body uses the standard GetFirstEffect() ... GetNextEffect() loop
effect GetEffectToDispel(object oTarget, string sIdList);

// checks if we can dispel effect based on type of effect and relationship to target
// so that we do not dispell buffs on allies or debuffs on enemies
int GetCanDispel(effect eFX, int nTargetSpellId, int bIsEnemy);

//makes the opposed roll to dispel
int GetIsDispelRollSuccess(object oTarget, effect eFX, int nDispellerMod);

// gives feedback to dispeller and target about result of dispel
void GiveDispelFeedback(object oTarget, object oDispeller, string sList, int nDispelId);


//main function
// oTarget = the target being dispelled
// oDispeller == the one casting the dispell
// nMax = the maximum number of spells to be dispelled
// nId = the spell id of the dispel
// returns the number of spells dispelled. This is important for voracious dispelling and 
// devour magic
int PS_NewDispel(object oTarget, object oDispeller = OBJECT_SELF, int nMax = 500, int nId = -1){
	if (nId == -1) nId = GetSpellId();
	int bIsEnemy = spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oDispeller);
	// check eligibility of target for dispelling
	string sError = GetDispelErrorMessage(oTarget, oDispeller, bIsEnemy, nId);
	if (sError != ""){ // if we got anything back ,then ineligible
		SendMessageToPC(oDispeller, sError);
		return 0;
	}
	
	//get the modifier to the dispeller's roll. modifier = CL + dispel spell level
	// we get this here instead of inside GetIsDispelRollSuccess() so that we're 
	// not fetching the same info over and over.
	int nDispellerMod = PS_GetCasterLevel();
	if (nDispellerMod > 30) nDispellerMod = 30; // some npcs have impossible cl, cap at 30
	nDispellerMod += StringToInt(Get2DAString("spells", "Innate", nId)); // the spell level of the dispel
	
	SignalEvent(oTarget, EventSpellCastAt(oDispeller, nId, bIsEnemy));
	
	int nTargetSpellId;
	int nNumDispelled = 0;
	string sIdList = "";
	int bLimitedDispel = nMax < 500;
	effect eFX = (bLimitedDispel) ? GetEffectToDispel(oTarget, sIdList) : GetFirstEffect(oTarget);
	while (GetIsEffectValid(eFX)){
		nTargetSpellId = GetEffectSpellId(eFX);
		if (!GetCanDispel(eFX, nTargetSpellId, bIsEnemy)){
			if (bLimitedDispel){
				sIdList += "|" + IntToString(nTargetSpellId) + "|";
				eFX = GetEffectToDispel(oTarget, sIdList);
			} else eFX = GetNextEffect(oTarget);
		} else if (GetIsDispelRollSuccess(oTarget, eFX, nTargetSpellId, nDispellerMod)){
			RemoveEffectsFromSpell(oTarget, nTargetSpellId);
			nNumDispelled++;
			sList += "Removed ";
			sList += GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nTargetSpellId)));
			sList += " from " + sTargetName;
			if (nNumDispelled >= nMax){
				GiveDispelFeedback(oTarget, oDispeller, sList, nId);
				return nNumDispelled;
			}
			if (bLimitedDispel){
				sIdList += "|" + IntToString(nTargetSpellId) + "|";
				eFX = GetEffectToDispel(oTarget, sIdList);
			} else eFX = GetFirstEffect(oTarget);
		} else {
			if (bLimitedDispel){
				sIdList += "|" + IntToString(nTargetSpellId) + "|";
				eFX = GetEffectToDispel(oTarget, sIdList);
			} else eFX = GetNextEffect(oTarget);
		}	
	} //end while
	
	
	if (nNumDispelled < 1){
		sList = "No effects removed";
	} else {
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ABJURATION), oTarget);
	}
	GiveDispelFeedback(oTarget, oDispeller, sList, nId);
	return nNumDispelled;
}

// if we're only dispelling a limited number of effects, then we want to try for the highest level effects
// so we're not using the standard GetFirstEffect... GetNextEffect
// instead we pass the target to a function that will find the highest level effect along with
// a list of ones we've already tried so we don't infinite loop
effect GetEffectToDispel(object oTarget, string sIdList){
	int nHighestSL = 0;
	effect eHighest;
	int nId;
	int nSL;
	effect eFX = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eFX)){
		nId = GetEffectSpellId(eFX);
		if (FindSubString(sIdList, "|" + IntToString(nId) + "|") == -1){ // if we haven't already looked at this id
			nSL = StringToInt(Get2DAString("spells", "Innate", nId));
			if (nSL > nHighestSL){
				nHighestSL = nSL;
				eHighest = eFX;
			}
		}
		eFX = GetNextEffect(oTarget);
	}
	return eHighest;
}


//helper functions
string GetDispelErrorMessage(object oTarget, object oDispeller, int bIsEnemy, int nId){

	if (GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) || 
		GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") == 10){
		return "Petrified targets cannot be dispelled";
    }
	int bCanTargetAllies = TRUE;
	if (nId == FT_BEHOLDER_DISP || nId == SP_MORDS || nId == SP_LS_BREACH ||
		nId == SP_GR_BREACH || nId == SP_TOTEM_BREACH)
			bCanTargetAllies = FALSE;
			
	if (!bIsEnemy && !bCanTargetAllies)
		return "You cannot target non-hostile targets with this ability";
		
	return "";
}

int GetIsDispelRollSuccess(object oTarget, effect eFX, int nTargetSpellId, int nDispellerMod){
	int nSL = StringToInt(Get2DAString("spells", "Innate", nTargetSpellId));
	int nCL = GetLocalInt(oTarget, SPELLCL + IntToString(nTargetSpellId));
	if (nCL == 0){ //if we dont find a CL stored on target
		object oCreator = GetEffectCreator(eFX);
		int nClass = PS_GetHighestSpellCastingBaseClass(oCreator);
		if (nClass == CLASS_TYPE_INVALID) nCL = 1;
		else nCL = PS_GetCasterLevel(oCreator, nClass);
	}
	int nDispellerRoll = d20() + nDispellerMod;
	int nTargetRoll = d20() + nSL + nCL;
	return (nDispellerRoll > nTargetRoll);
}

int GetCanDispel(effect eFX, int nTargetSpellId, int bIsEnemy){

	int nSub = GetEffectSubType(eFX);
	// dispel cannot affect supernatural, extraordinary, or permanent effects
	if (nSub == SUBTYPE_SUPERNATURAL || nSub == SUBTYPE_EXTRAORDINARY ||
			GetEffectDurationType(eFX) == DURATION_TYPE_PERMANENT){
				return FALSE;
	}
	// is this a debuff?
	int bIsNegFX = GetIsNegEffect(eFX); // is this a debuff?	 
	if (bIsNegFX){ // if so, then check if it's a spell that has some neg effects but is still mostly beneficial
	// If it is, then it's not a debuff
		bIsNegFX = !GetIsPrimarilyBeneficial(nTargetSpellId); 
	}
	// dont dispell debuffs from enemies or buffs from friends
	return ((!bIsNegFX && bIsEnemy) || (bIsNegFX && !bIsEnemy));
}

void GiveDispelFeedback(object oTarget, object oDispeller, string sList, int nDispelId){

	// get user feedback
	string sFeedback = GetName(oDispeller) + " cast ";
	sFeedback += GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nDispelId))); 
	sFeedback += " at " + GetName(oTarget) + "\n";
	sFeedback += sList;
	
	SendMessageToPC(oDispeller, sFeedback);
	SendMessageToPC(oTarget, sFeedback);
}
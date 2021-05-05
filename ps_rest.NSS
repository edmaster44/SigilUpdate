#include "ps_inc_functions"
#include "ps_rage_func"
#include "ps_inc_ecl"
#include "ps_inc_wingtail"

const int cSaveWait = 300;

void DismissSpellHenchmen(object oPC) {
	if (GetIsObjectValid(GetLocalObject(oPC, "simulacrum"))) {
	
		object oSim = GetLocalObject(oPC, "simulacrum");
		RemoveHenchman(oPC, oSim);
		DestroyObject(oSim, 0.1f);
		
	} if (GetIsObjectValid(GetLocalObject(oPC, "rainbow_dweomer"))) {
	
		object oRain = GetLocalObject(oPC, "rainbow_dweomer");
		RemoveHenchman(oPC, oRain);
		DestroyObject(oRain, 0.1f);
		
	}
}

int HasToWipeAbilities(object oPC, object oEssence)
{
	int nORDER = GetAlignmentLawChaos(oPC);
	int nMORAL = GetAlignmentGoodEvil(oPC);
	
	if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0)
	{
		DeleteLocalInt(oEssence, "WildWis");
		DeleteLocalInt(oEssence, "WildInt");
		DeleteLocalInt(oEssence, "WildCha");	
		if ((nORDER != ALIGNMENT_NEUTRAL) && (nMORAL != ALIGNMENT_NEUTRAL))
   		{	
			SendMessageToPC(oPC, "You have taken a side in the natural order of things.");
   			SendMessageToPC(oPC, "You must find balance or leave your ways behind.");
   			return TRUE;
		}
	}

	if (nORDER == ALIGNMENT_LAWFUL)
	{
		if (GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) > 0)
		{
			SendMessageToPC(oPC, "Your rigid ways have stifled you and made you weak.");
   			SendMessageToPC(oPC, "You must regain your freedom or leave your ways behind.");
  			return TRUE;
		}
		if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0)
	  	{	
			SendMessageToPC(oPC, "Your rigid way has crushed the song in your heart.");
	    	SendMessageToPC(oPC, "You must regain your freedom or leave your ways behind.");
	   		return TRUE;
		}
	}
	else
	{		
		if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
	   	{	
			SendMessageToPC(oPC, "You can not concentrate and maintain your ki.");
	   		SendMessageToPC(oPC, "You must relearn the discipline necessary or leave your ways behind.");
			return TRUE;
		}
		
	}
	
	if (nMORAL != ALIGNMENT_EVIL)
	{
			
		if (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 0)
	   	{	
			SendMessageToPC(oPC, "You have changed your evil ways.");
	   		SendMessageToPC(oPC, "You must rid yourself of weakness or leave your ways behind.");
			return TRUE;	
		}
	}
	
	return FALSE;
}

void WipeSpecialAbilities(object oCreature)
{
	int nLevel;
	int nFeat;
	for (nFeat = 0; nFeat < 1071; nFeat++)
	{
		//if(Get2DAString("feat", "USESPERDAY", nFeat) != "")
	 	if (GetHasFeat(nFeat, oCreature))
	    {	
	    	for (nLevel = 0; nLevel < GetHitDice(oCreature); nLevel++)
	      	{
				DecrementRemainingFeatUses(oCreature, nFeat);
			}
		}
	}

	int nSpellTotal;
	int nSpell;
	for (nSpell = 0; nSpell < 804; nSpell++)
	{			
		nSpellTotal = GetHasSpell(nSpell, oCreature);
 		while (nSpellTotal > 0)
		{
			DecrementRemainingSpellUses(oCreature, nSpell);
			nSpellTotal = nSpellTotal - 1;
		}
	}
}

//Removes Temporary Positive Effects
void RemoveBuffs(object oPC)
{
	int nTYPE;
	effect eFX = GetFirstEffect(oPC);
	while(GetIsEffectValid(eFX))
	{
		if (GetEffectDurationType(eFX) == DURATION_TYPE_PERMANENT) eFX = GetNextEffect(oPC);
		else
		{
			nTYPE = GetEffectType(eFX);
			switch (nTYPE)
			{
				case EFFECT_TYPE_ABILITY_DECREASE:
				case EFFECT_TYPE_AC_DECREASE:
				case EFFECT_TYPE_ATTACK_DECREASE:
				case EFFECT_TYPE_DAMAGE_DECREASE:
				case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
				case EFFECT_TYPE_SAVING_THROW_DECREASE:
				case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
				case EFFECT_TYPE_SKILL_DECREASE:
				case EFFECT_TYPE_BLINDNESS:
				case EFFECT_TYPE_DEAF:
				case EFFECT_TYPE_PARALYZE:
				case EFFECT_TYPE_NEGATIVELEVEL:
					eFX = GetNextEffect(oPC);
				default:
					RemoveEffect(oPC, eFX);
					eFX = GetFirstEffect(oPC);
					//First Effect to properly remove linked effects
			}	
		}
	}
}

void GiveDruidMonkPenaltyFeat (object oPC)
{
	if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0 &&
       GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 &&
       GetHasFeat(4727, oPC, TRUE) == FALSE) {	   
	   FeatAdd (oPC, 4727, FALSE, FALSE, FALSE );
	}

}

void FinesseRestFix(object oPC, object oWEAPON)
{
	if (GetLocalInt(oWEAPON , "S_Finesse") == 0) return;
	PS_RemoveSpecialWeaponFinesse(oPC, oWEAPON);
	//DelayCommand(0.0f, PS_ApplySpecialWeaponFinesse(oPC, oWEAPON));
}

void RestStart(object oPC)
{
	RemoveBuffs(oPC);
	object oRIGHT = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);	
	if (GetTag(oRIGHT) == "barbancestoraxe") DestroyAncestralWeapon(oRIGHT);
	if (GetHasFeat(FEAT_WEAPON_FINESSE, oPC, TRUE) == TRUE)
	{
		object oLEFT = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		FinesseRestFix(oPC, oRIGHT);
		FinesseRestFix(oPC, oLEFT);
	}
	
	DismissSpellHenchmen(oPC);
}

void RestFinish(object oPC)
{
	object oESSENCE	= GetItemPossessedBy(oPC, "ps_essence");
	if (HasToWipeAbilities(oPC, oESSENCE) == TRUE) WipeSpecialAbilities(oPC);
	
	
	if (PS_NeedsTemplateClassAbilityFix(oPC) == TRUE) TemplateRacialAdjust(oPC, oESSENCE, FALSE);
	else TemplateRacialAdjust(oPC, oESSENCE, TRUE);
	
	if (GetLocalInt(oESSENCE, "TempChange") != 1)
	{	
		PS_WingTailSetup(oPC);
		PS_ApplyPCTail(oPC);
		PS_ApplyPCWings(oPC);
	}
	
	PS_CalculateECL(oPC);
	
	GiveDruidMonkPenaltyFeat(oPC); //giving out the druid/monk feat
	//DelayCommand(1.0f,ExecuteScript("ed_mode_includes",oPC));
	
	if (CheckTimeStamp(oPC, "REST") > cSaveWait)
	{	
		TimeStamp(oPC, "REST");
		SendMessageToPC(oPC, "Character saved.");
		DelayCommand(0.0f, ExportSingleCharacter(oPC));	
	}
}	

//Allows you to designate spaces in a "non-rest" area as safe to rest
int IsInSafeRestZone(object oPC) {  

	//Check if we're in a limited rest zone
	object oArea = GetArea(oPC);
	int nLimitedRest = GetLocalInt(oArea, "LIMITED_REST");
	if (!nLimitedRest)
		return TRUE;

	//If so, check to see if we're in a designated safe area
    object oSafeTrigger = GetNearestObjectByTag("X0_SAFEREST", oPC);
    int bPCInTrigger = FALSE;

    if (GetIsObjectValid(oSafeTrigger)) {
	
        if (GetObjectType(oSafeTrigger) == OBJECT_TYPE_TRIGGER) {
		
            // * cycle through trigger looking for oPC
            object oInTrig = GetFirstInPersistentObject(oSafeTrigger, OBJECT_TYPE_ALL);
            while (GetIsObjectValid(oInTrig) == TRUE) {
                // * rester is in trigger!
                if (oPC == oInTrig) {
                    bPCInTrigger = TRUE;
					break;
                }
                oInTrig = GetNextInPersistentObject(oSafeTrigger, OBJECT_TYPE_ALL);
            }
        }
		
    }
	
    return bPCInTrigger;
}

void main()
{
	object oPC = GetLastPCRested();
	int nREST = GetLastRestEventType();
	
	//Raise if DM rests you???
	if (GetIsDead(oPC) == TRUE) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
	
	//If this is a limited rest area and you're not in a safe trigger. . don't let you rest
	if (!IsInSafeRestZone(oPC)) {
		AssignCommand(oPC, ClearAllActions());
		
		//Only show floating text once
		if (nREST == REST_EVENTTYPE_REST_STARTED)
			FloatingTextStrRefOnCreature(40156, oPC);
	}
	
	//Rest Events

	if (nREST == REST_EVENTTYPE_REST_STARTED) DelayCommand(0.0f, RestStart(oPC));
	else if (nREST == REST_EVENTTYPE_REST_FINISHED) DelayCommand(0.0f, RestFinish(oPC));
	
		
}
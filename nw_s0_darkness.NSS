//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S2_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////


#include "nw_s0_darkness_inc"

void main(){
	if (!X2PreSpellCastCode()) return;


	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nTargetType = GetObjectType(oTarget);
	
	int nId = GetSpellId();
	int bAbyssalDark = FALSE;
	int nRace = GetSubRace(oCaster);
	int nRounds = PS_GetCasterLevel(oCaster);
	
	if (nId == SPELL_RACIAL_DARKNESS){
		nRounds = GetTotalLevels(oCaster, TRUE);
		if (nRace == 14 || nRace == 194)
			bAbyssalDark = TRUE;
	
	} else if (nId == SPELLABILITY_AS_DARKNESS){
		nRounds = GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
		nRounds += (GetTotalLevels(oCaster, TRUE) - nRounds) / 2;
	}
	
    if (nRounds < 5) nRounds = 5;

    if (GetMetaMagicFeat() == METAMAGIC_EXTEND || bAbyssalDark) nRounds *= 2;
	float fDur = RoundsToSeconds(nRounds);
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
	
	//debug
	//if (bAbyssalDark) SendMessageToPC(oCaster, "Abyssal");
	//if (oCaster == oTarget) SendMessageToPC(oCaster, "Cast on self");

	if (nTargetType == OBJECT_TYPE_CREATURE || nTargetType == OBJECT_TYPE_DOOR ||
		nTargetType == OBJECT_TYPE_PLACEABLE || nTargetType == OBJECT_TYPE_ITEM){
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDur);
		ApplyDarkness(oCaster, oTarget, nId, fDur, bAbyssalDark);
		
	} else {
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetSpellTargetLocation(), fDur);
	}   
}

// original Code
/*


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 
void main()
{



    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    location lTarget = GetSpellTargetLocation();
    int nRounds = GetTotalLevels(OBJECT_SELF, 1); //PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nRounds < 1)
    {
        nRounds = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nRounds = nRounds *2;	//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nRounds));
}
*/
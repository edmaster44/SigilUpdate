//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S2_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"

void main(){

	if (!X2PreSpellCastCode()) return;

	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nTargetType = GetObjectType(oTarget);

	int nLevel;
	int nId = GetSpellId();
	int bAbyssalDark = FALSE;
	if (nId == SPELL_RACIAL_DARKNESS){
		nLevel = GetHitDice(oCaster);
		int nRace = GetSubRace(oCaster);
		if (nRace == 14 || nRace == 194)
		bAbyssalDark = TRUE;
	} else if (nId == SPELLABILITY_AS_DARKNESS){
		nLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
	} else nLevel = PS_GetCasterLevel(oCaster);
	int nMeta = GetMetaMagicFeat();
	if (nMeta == METAMAGIC_EXTEND || bAbyssalDark) nLevel *= 2;
	float fDur = HoursToSeconds(nLevel);
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
	SetEffectSpellId(eAOE, nId); 
	
	SetLocalInt(oCaster, "DarknessSpellId", nId);
	SetLocalInt(oCaster, "DarknessCasterLevel", nLevel);
	SetLocalInt(oCaster, "DarknessIsAbyssal", bAbyssalDark);
	SetLocalInt(oCaster, "DarknessMetaMagic", nMeta);
	
	if (nTargetType == OBJECT_TYPE_CREATURE || nTargetType == OBJECT_TYPE_DOOR ||
		nTargetType == OBJECT_TYPE_PLACEABLE || nTargetType == OBJECT_TYPE_ITEM){
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDur);
	} else {
		location lLocation = GetSpellTargetLocation();
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLocation, fDur);
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
    int nLevel = GetTotalLevels(OBJECT_SELF, 1); //PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nLevel < 1)
    {
        nLevel = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nLevel = nLevel *2;	//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nLevel));
}
*/
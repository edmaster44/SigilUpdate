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

	int nRounds;
	int nId = GetSpellId();
	if (nId == SPELL_RACIAL_DARKNESS){
		nRounds = GetTotalLevels(oCaster, TRUE);
	} else if (nId == SPELLABILITY_AS_DARKNESS){
		nRounds = GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
	} else nRounds = PS_GetCasterLevel(oCaster);
	int nMeta = GetMetaMagicFeat();
	if (nMeta == METAMAGIC_EXTEND) nRounds *= 2;
	float fDur = HoursToSeconds(nRounds);
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
	SetEffectSpellId(eAOE, nId); 
	
	SetLocalInt(oCaster, "DarknessSpellId", nId);
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
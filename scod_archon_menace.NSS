//::///////////////////////////////////////////////
//:: Aura of Menace On Enter
//:: NW_S1_AuraMencA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura all those that fail
    a will save are stricken with Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "aaa_constants"

void main()
{
    //Declare major variables
    object oTarget 	= GetEnteringObject();
	object oCaster 	= GetAreaOfEffectCreator();
	int iLevel;
	int nDC;
	if (GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC, oCaster) >= 1)
	{	
		iLevel		= GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC, oCaster);
		nDC = 20 + (2 * iLevel);
	}
	if (GetSubRace(oCaster) == RACIAL_SUBTYPE_ARCHON)
	{	
		iLevel		= (GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oCaster) + GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oCaster));
		nDC = 18 + (2 * iLevel);
	}
    int nDuration = 1 + iLevel;
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);

    effect eLink;
	if (GetSubRace(oCaster) == RACIAL_SUBTYPE_ARCHON)
	{	eLink = CreateLesserDoomEffectsLink();	}
	else
	{	eLink = CreateDoomEffectsLink();	}
	if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
	{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_AURA_MENACE));
        if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(nDuration));
        }
    }
}
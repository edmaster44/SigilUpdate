//::///////////////////////////////////////////////
//:: Magic Vestment
//:: X2_S0_MagcVest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 AC bonus to armor touched per 4 caster
  levels (maximum of +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller

// Updated (JLR - OEI) 07/12/05 NWN2 3.5

// Nov 29, 2024, FlattedFifth - Changed AC to 1 + 1/3 caster levels, max 6.


#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"

void AddACBonusToArmor(object oMyArmor, float fDuration, int nAmount)
{
    IPSafeAddItemProperty(oMyArmor,ItemPropertyACBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
   	return;
}

void main()
{



    if (!X2PreSpellCastCode()) return;
    

    effect eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_VESTMENT );
	int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
	int nDuration = nCasterLvl;
	if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2;

    int nAmount = (nCasterLvl / 3) + 1;	
    if (nAmount < 1) nAmount = 1;
    else if (nAmount > 5) nAmount = 5;
	nAmount += 1;
    
    object oArmor = IPGetTargetedOrEquippedArmor(TRUE);

    if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2; 
    
    if(GetIsObjectValid(oArmor)){
		
	
	
        SignalEvent(GetItemPossessor(oArmor ), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {

            location lLoc = GetLocation(GetSpellTargetObject());
            //DelayCommand(1.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyArmor)));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oArmor), HoursToSeconds(nDuration));
            AddACBonusToArmor(oArmor, HoursToSeconds(nDuration),nAmount);
    }
        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83826, OBJECT_SELF);
           return;
    }
}

/*  Original Code Below

void  AddACBonusToArmor(object oMyArmor, float fDuration, int nAmount)
{
    IPSafeAddItemProperty(oMyArmor,ItemPropertyACBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
   	return;
}

void main()
{



    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    //Declare major variables
    //effect eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_VESTMENT );

    int nDuration  = PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nAmount = PS_GetCasterLevel(OBJECT_SELF)/4;	// JLR - OEI 07/12/05 NWN2 3.5
    if (nAmount <0)
    {
        nAmount =1;
    }
    else if (nAmount>5)
    {
        nAmount =5;
    }

    object oMyArmor   =  IPGetTargetedOrEquippedArmor(TRUE);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }


    if(GetIsObjectValid(oMyArmor) )
    {
        SignalEvent(GetItemPossessor(oMyArmor ), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {

            location lLoc = GetLocation(GetSpellTargetObject());
            //DelayCommand(1.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyArmor)));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyArmor), HoursToSeconds(nDuration));
            AddACBonusToArmor(oMyArmor, HoursToSeconds(nDuration),nAmount);
    }
        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83826, OBJECT_SELF);
           return;
    }
}
*/
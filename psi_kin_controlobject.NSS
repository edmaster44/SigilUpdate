//::///////////////////////////////////////////////
//:: Shelgarn's Persistent Blade
//:: X2_S0_PersBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dagger to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, Aug 2003

#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned(object oCaster, float fDuration)
{
    //Declare major variables
    int nStat = GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster) / 2;
	if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
	{
		nStat = nStat + 2;
	}
    // GZ: Just in case...
    if (nStat >20)
    {
        nStat =20;
    }
    else if (nStat <1)
    {
        nStat = 1;
    }
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    object oWeapon;
    if (GetIsObjectValid(oSummon))
    {
        //Create item on the creature, epuip it and add properties.
		int nRandom = d8(1);
		switch (nRandom)
		{
			case 1:
			{
				oWeapon = CreateItemOnObject("psi_conobject_wrench", oSummon);
				break;
			}
			case 2:
			{
				oWeapon = CreateItemOnObject("psi_conobject_pin", oSummon);
				break;
			}
			case 3:
			{
				oWeapon = CreateItemOnObject("psi_conobject_broom", oSummon);
				break;
			}
			case 4:
			{
				oWeapon = CreateItemOnObject("psi_conobject_bone", oSummon);
				break;
			}
			case 5:
			{
				oWeapon = CreateItemOnObject("psi_conobject_pan", oSummon);
				break;
			}
			case 6:
			{
				oWeapon = CreateItemOnObject("psi_conobject_arm", oSummon);
				break;
			}
			case 7:
			{
				oWeapon = CreateItemOnObject("psi_conobject_bottle", oSummon);
				break;
			}
			case 8:
			{
				oWeapon = CreateItemOnObject("psi_conobject_board", oSummon);
				break;
			}
		}
        
        // GZ: Fix for weapon being dropped when killed
        SetDroppableFlag(oWeapon,FALSE);
        AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
        // GZ: Check to prevent invalid item properties from being applies
        if (nStat>0)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nStat), oWeapon,fDuration);
        }
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageReduction(5,IP_CONST_DAMAGEREDUCTION_1),oWeapon,fDuration);
    }
}


void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

   if (!PsiPrePowerCastCode())
   {
   // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
       return;
   }
	
    // End of Spell Cast Hook
		object oManifester = OBJECT_SELF;
	   	object oTarget     = GetSpellTargetObject();
	   	struct manifestation manif =
	       EvaluateManifestationNew(oManifester, oTarget,
	                             GetSpellId(),
	                             METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND); //sending metapsionic options
	if(manif.bCanManifest)
	{
	    //Declare major variables
	    int nMetaMagic = GetMetaMagicFeat();
	    int nDuration = manif.nManifesterLevel /2;
	    if (nDuration <1)
	    {
	        nDuration = 1;
	    }
	    effect eSummon = EffectSummonCreature("scod_x_psiconobject");
	    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
	    //Make metamagic check for extend
	    if (GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
		{
			nDuration = nDuration * 2;
		}
	    //Apply the VFX impact and summon effect
	    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
	    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
	
	    object oSelf = OBJECT_SELF;
	    DelayCommand(0.5, spellsCreateItemForSummoned(oSelf,TurnsToSeconds(nDuration)));
	}
}
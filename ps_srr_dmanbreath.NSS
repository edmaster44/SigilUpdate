#include "ff_safevar"

// Dragonman breath weapon

#include "NW_I0_SPELLS"

void main()
{

    //--------------------------------------------------------------------------
    // Set up variables
    //--------------------------------------------------------------------------
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nSpell;
    int nDice;
	int nBreath;
	
	object oPC = OBJECT_SELF;
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	
	if(GetIsObjectValid(oItem))
	{
		nType = PS_GetLocalInt(oItem, "DRAGONTYPE");
	}
	else
	{
		SendMessageToPC(oPC, "You appear to be missing your Essence. Unable to get Dragon breath type. Contact a member of staff.");
	}

	if (nType < 1)
	{
		SendMessageToPC(oPC, "Dragon breath type not set, starting convo to fix...");
		ActionStartConversation(oPC, "ps_srr_conv_dbreath", TRUE, FALSE, TRUE, TRUE);
	}
	else
	{
	    switch (nType)
	    {
			case 2: // silver
	        case 10: //white
	            nDamageType = DAMAGE_TYPE_COLD;
	            nVfx        = VFX_IMP_FROST_S;
				nBreath		= VFX_DUR_CONE_ICE;
	            nSave       = SAVING_THROW_TYPE_COLD;
	            break;
	
			case 3: //copper
	        case 7: //black
			case 9: //green
	            nDamageType = DAMAGE_TYPE_ACID;
	            nVfx        = VFX_IMP_ACID_S;
				if (nType ==9)	nBreath = VFX_DUR_CONE_POISON;
				else			nBreath	= VFX_DUR_CONE_ACID;
	            nSave       = SAVING_THROW_TYPE_ACID;
	            break;
	
	        case 1: //gold
			case 4: //brass
			case 6: //red
	            nDamageType = DAMAGE_TYPE_FIRE;
	            nVfx        = VFX_IMP_FLAME_M;
				nBreath		= VFX_DUR_CONE_FIRE;
	            nSave       = SAVING_THROW_TYPE_FIRE;
	            break;
	
	        case 5: // bronze
			case 8: //blue
	            nDamageType = DAMAGE_TYPE_ELECTRICAL;
	            nVfx        = VFX_IMP_LIGHTNING_S;
				nBreath		= VFX_DUR_CONE_LIGHTNING;
	            nSave       = SAVING_THROW_TYPE_ELECTRICITY;
	            break;
	    }
		
		nDice = GetTotalLevels(oPC, TRUE);
	    int  nDC  = nDice/2 + 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC);

		effect eVis = EffectVisualEffect(nVfx);
   		effect eBreath = EffectVisualEffect(nBreath);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0); 

	    int nDamage;
	    int nDamStrike;
	    float fDelay;
	    object oTarget;
		effect eDamage;
	    nSpell = GetSpellId();

	    //--------------------------------------------------------------------------
	    //Loop through all targets and do damage
	    //--------------------------------------------------------------------------
	    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
	    while(GetIsObjectValid(oTarget))
	    {
	        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	        {
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
	            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				nDamage = d6(nDice);
	            nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
	            if (nDamStrike > 0)
	            {
	                eDamage = EffectDamage(nDamStrike, nDamageType);
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
	             }
	        }
	        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
	    }
	}
}
// Winter Wolf breath weapon

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
	
	nDamageType = DAMAGE_TYPE_COLD;
	nVfx        = VFX_IMP_FROST_S;
	nBreath		= VFX_DUR_CONE_ICE;
	nSave       = SAVING_THROW_TYPE_COLD;
		
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
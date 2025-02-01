#include "ff_safevar"

#include "nw_i0_generic"
#include "x0_i0_spells"
#include "x2_inc_switches"
#include "x2_inc_toollib"

int CheckHasEffect(object oTarget, effect EffectToCheck)
{
	int nValue = 0;
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		if (eEffect == EffectToCheck)
		{
			nValue = 1;
			return nValue;
		}
		eEffect = GetNextEffect(oTarget);
	}
	return nValue;
   
}

int GetTargetHasBuff(object oTarget, int nSpellEffect)
{
   if (GetHasSpellEffect(nSpellEffect, oTarget) == TRUE)
        return 1;
		
	else return 0;
}

int GetBuffedMyself()
{
	return PS_GetLocalInt(OBJECT_SELF, "Buffed");
}

void CastSpells(object oTarget, object oEnemy)
{
int nSpell = 0;
	if (GetIsObjectValid(oTarget) == TRUE && GetHPPercentage(oTarget) > 0)
	{
	if (GetTargetHasBuff(OBJECT_SELF, SPELL_ETHEREALNESS) == 0)
		{ ActionCastSpellAtObject(SPELL_ETHEREALNESS, oTarget, METAMAGIC_ANY, TRUE); return; }
	
	if (GetHPPercentage(oTarget) < 25 && PS_GetLocalInt(oTarget, "Restorated") != 1)
		{ 
			ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, oTarget, METAMAGIC_ANY, TRUE); 
			PS_SetLocalInt(oTarget, "Restorated", 1);
			return; 
		}
			
	if (GetHPPercentage(oTarget) < 75)
		{ ActionCastSpellAtObject(SPELL_INFLICT_CRITICAL_WOUNDS, oTarget, METAMAGIC_ANY, TRUE); return; }
			
 	if (GetTargetHasBuff(oTarget, SPELL_REGENERATE) == 0)
		{ ActionCastSpellAtObject(SPELL_REGENERATE, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	if (GetTargetHasBuff(oTarget, SPELL_VIGOROUS_CYCLE) == 0)
		{ ActionCastSpellAtObject(SPELL_VIGOROUS_CYCLE, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	if (GetTargetHasBuff(oTarget, SPELL_BLESS) == 0)
		{ ActionCastSpellAtObject(SPELL_BLESS, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	if (GetTargetHasBuff(oTarget, SPELL_SUPERIOR_RESISTANCE) == 0)
		{ ActionCastSpellAtObject(SPELL_SUPERIOR_RESISTANCE, oTarget, METAMAGIC_ANY, TRUE); return; }
	
	if (GetTargetHasBuff(oTarget, SPELL_AID) == 0)
		{ ActionCastSpellAtObject(SPELL_AID, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	if (GetTargetHasBuff(oTarget, SPELL_BULLS_STRENGTH) == 0)
		{ ActionCastSpellAtObject(SPELL_BULLS_STRENGTH, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	if (GetTargetHasBuff(oTarget, SPELL_PRAYER) == 0)
		{ ActionCastSpellAtObject(SPELL_PRAYER, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	if (GetTargetHasBuff(oTarget, 1054) == 0) //Recitation
		{ ActionCastSpellAtObject(1054, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	if (GetTargetHasBuff(oTarget, SPELL_SHIELD_OF_FAITH) == 0)
		{ ActionCastSpellAtObject(SPELL_SHIELD_OF_FAITH, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	//if (GetTargetHasBuff(oTarget, SPELL_SHIELD_OTHER) == 0)
	//	{ ActionCastSpellAtObject(SPELL_SHIELD_OTHER, oTarget, METAMAGIC_ANY, TRUE); return; }
		
	if (GetTargetHasBuff(oTarget, SPELL_UNHOLY_AURA) == 0)
		{ ActionCastSpellAtObject(SPELL_UNHOLY_AURA, oTarget, METAMAGIC_ANY, TRUE); return; }
	}
		
	else //KNIGHT DEAD
	{
		if (GetHPPercentage(oEnemy) > 75 && CheckHasEffect(oEnemy, EffectSpellImmunity(SPELL_AVASCULATE)) == 0 && GetRacialType(oEnemy) != RACIAL_TYPE_UNDEAD)
			{ ActionCastSpellAtObject(SPELL_AVASCULATE, oEnemy, METAMAGIC_EMPOWER, TRUE); return; }
		
		
		if (GetRacialType(oEnemy) == RACIAL_TYPE_UNDEAD)
		{
			nSpell = Random(1);
			switch (nSpell)
			{	
				case 0:
				if (CheckHasEffect(oEnemy, EffectSpellImmunity(SPELL_CURE_CRITICAL_WOUNDS)) == 0)
					{ ActionCastSpellAtObject(SPELL_CURE_CRITICAL_WOUNDS, oEnemy, METAMAGIC_EMPOWER, TRUE); break; return; }
				
				case 1:
				if (CheckHasEffect(oEnemy, EffectSpellImmunity(SPELL_SUNBEAM)) == 0)
					{ ActionCastSpellAtObject(SPELL_SUNBEAM, oEnemy, METAMAGIC_EMPOWER, TRUE); break; return; }
				{ ActionCastSpellAtObject(SPELL_HEAL, oEnemy, METAMAGIC_EMPOWER, TRUE); break; return; }
			}	
		}
		else
		{
			if (CheckHasEffect(oEnemy, EffectSpellImmunity(SPELL_HARM)) == 0 && GetHasSpellEffect(SPELL_SHADOW_SHIELD, oEnemy) == FALSE)
				{ ActionCastSpellAtObject(SPELL_HARM, oEnemy, METAMAGIC_EMPOWER, TRUE); return; }
			{ ActionCastSpellAtObject(SPELL_INFLICT_CRITICAL_WOUNDS, oEnemy, METAMAGIC_EMPOWER, TRUE); return; }
			
		}
	}		
}

void main()
{
    //The following two lines should not be touched
    object oIntruder = GetCreatureOverrideAIScriptTarget();
    ClearCreatureOverrideAIScriptTarget();
	object oKnight;
	if (OBJECT_SELF == GetObjectByTag("ps_carceri_depths_sp_fadp"))
		oKnight = GetObjectByTag("ps_carceri_depths_sp_fadk");
	else if (OBJECT_SELF == GetObjectByTag("ps_carceri_depths_sp_fadp2"))
		oKnight = GetObjectByTag("ps_carceri_depths_sp_fadk2");
	else if (OBJECT_SELF == GetObjectByTag("ps_carceri_depths_sp_fadp3"))
		oKnight = GetObjectByTag("ps_carceri_depths_sp_fadk3");	
    // ********************* Start of custom AI script ****************************


    // Here you can write your own AI to run in place of DetermineCombatRound.
    // The minimalistic approach would be something like
    //
    // TalentFlee(oTarget); // flee on any combat activity

    if(GetAssociateState(NW_ASC_IS_BUSY))
    {
        return;
    }

    if (GetIsObjectValid(oIntruder) == FALSE)
        oIntruder = bkAcquireTarget();

    if(BashDoorCheck(oIntruder)) {return;}
    // * BK: stop fighting if something bizarre that shouldn't happen, happens
    if (bkEvaluationSanityCheck(oIntruder, GetFollowDistance()) == TRUE)
    {
        return;
    }

    if (GetIsObjectValid(oIntruder) == FALSE || GetIsDead(oIntruder))
    {
        return; // fall back to default AI because SetCreatureOverrideAIScriptFinished(); wasnt called        t cal
    }
	else
	{
        __TurnCombatRoundOn(TRUE);
        CastSpells(oKnight, oIntruder);
        __TurnCombatRoundOn(FALSE);
        SetCreatureOverrideAIScriptFinished();
	}

}
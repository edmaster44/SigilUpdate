

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

int GetTargetBigbyRes(object oTarget)
{
   if (GetHasSpellEffect(SPELL_STORM_AVATAR, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_FOUNDATION_OF_STONE, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oTarget) == TRUE)
   {
        return 1;
   }
   
   else if (GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_LEAST_SPELL_MANTLE, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_MIND_BLANK, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_LESSER_MIND_BLANK, oTarget) == TRUE
   || GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget) == TRUE)
   {
        return 2;
   }  
   
	else if ((CheckHasEffect(oTarget, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS)) == 1
	&& CheckHasEffect(oTarget, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN)) == 1) ||
	GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTarget) == 1)
	{
		return 3;
	}
	
	else return 0;
}

int GetBuffedMyself()
{
	return GetLocalInt(OBJECT_SELF, "Buffed");
}

void CastSpells(object oTarget)
{
int nSpell = 0;
    /*if (  GetDistanceBetween( OBJECT_SELF, oTarget ) < 1.5f)
    {
        ActionMoveAwayFromObject(oTarget, FALSE, 1.5f);
    }
    ActionMoveToObject( oTarget, FALSE, 1.5f);
    ActionDoCommand(SetFacingPoint( GetPositionFromLocation(GetLocation(oTarget))));
    ActionWait(0.5f);
	*/
 	if (GetTargetBigbyRes(oTarget) == 0)
    {
		ActionCastSpellAtObject(SPELL_BIGBYS_FORCEFUL_HAND, oTarget, METAMAGIC_QUICKEN, TRUE);
		return;
    }
    else if (GetTargetBigbyRes(oTarget) == 1) //Avatar or Foundation
    {
        ActionCastSpellAtObject(SPELL_MORDENKAINENS_DISJUNCTION, oTarget, METAMAGIC_NONE, TRUE);
		return;
    }
	else if (GetTargetBigbyRes(oTarget) == 2) //Spell Mantle
	{
		ActionCastSpellAtObject(SPELL_LESSER_SPELL_BREACH, oTarget, METAMAGIC_QUICKEN, TRUE);
		return;
	}	
	else if (GetTargetBigbyRes(oTarget) == 3) //Immune or under spell
	{	
		if (GetHPPercentage(oTarget) > 75 && CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_AVASCULATE)) == 0 && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
		{	
			ActionCastSpellAtObject(SPELL_AVASCULATE, oTarget, METAMAGIC_EMPOWER, TRUE);
			return;
		}
		
		nSpell = Random(6);		
		switch (nSpell)
		{
			case 0:
			if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_POLAR_RAY)) == 0)
			{
				ActionCastSpellAtObject(SPELL_POLAR_RAY, oTarget, METAMAGIC_EMPOWER, TRUE);
				return;
			}
			
			case 1:
			if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_ISAACS_GREATER_MISSILE_STORM)) == 0)
			{
				ActionCastSpellAtObject(SPELL_ISAACS_GREATER_MISSILE_STORM, oTarget, METAMAGIC_EMPOWER, TRUE);
				return;
			}
			
			case 2:
			if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_ENERGY_DRAIN)) == 0 && CheckHasEffect(oTarget, EffectImmunity(EFFECT_TYPE_NEGATIVELEVEL)) == 0)
			{
				ActionCastSpellAtObject(SPELL_ENERGY_DRAIN, oTarget, METAMAGIC_EMPOWER, TRUE);
				return;
			}
			
			case 3:
			if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_METEOR_SWARM)) == 0)
			{
				ActionCastSpellAtObject(SPELL_METEOR_SWARM_TARGET_CREATURE, oTarget, METAMAGIC_EMPOWER, TRUE);
				return;
			}
			
			case 4:
			if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_VITRIOLIC_SPHERE)) == 0)
			{
				ActionCastSpellAtObject(SPELL_VITRIOLIC_SPHERE, oTarget, METAMAGIC_EMPOWER, TRUE);
				return;
			}
			
			case 5:
			if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_VITRIOLIC_SPHERE)) == 0)
			{
				ActionCastSpellAtObject(SPELL_VITRIOLIC_SPHERE, oTarget, METAMAGIC_EMPOWER, TRUE);
				return;
			}
			
			case 6:
			{
				nSpell = Random(5);		
				switch (nSpell)
				{
					case 0:
					if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_ORB_OF_ACID)) == 0)
					{
						ActionCastSpellAtObject(SPELL_ORB_OF_ACID, oTarget, METAMAGIC_EMPOWER, TRUE);
						return;
					}
					case 1:
					if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_ORB_OF_COLD)) == 0)
					{
						ActionCastSpellAtObject(SPELL_ORB_OF_COLD, oTarget, METAMAGIC_EMPOWER, TRUE);
						return;
					}
					
					case 2:
					if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_ORB_OF_ELECTRICITY)) == 0)
					{
						ActionCastSpellAtObject(SPELL_ORB_OF_ELECTRICITY, oTarget, METAMAGIC_EMPOWER, TRUE);
						return;
					}
					
					case 3:
					if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_ORB_OF_FIRE)) == 0)
					{
						ActionCastSpellAtObject(SPELL_ORB_OF_FIRE, oTarget, METAMAGIC_EMPOWER, TRUE);
						return;
					}
					
					case 4:
					if (CheckHasEffect(oTarget, EffectSpellImmunity(SPELL_ORB_OF_SOUND)) == 0)
					{
						ActionCastSpellAtObject(SPELL_ORB_OF_SOUND, oTarget, METAMAGIC_EMPOWER, TRUE);
						return;
					}
				}
			}		
			
		} //SWITCH END
		ActionCastSpellAtObject(SPELL_METEOR_SWARM_TARGET_CREATURE, oTarget, METAMAGIC_EMPOWER, TRUE);			
	}
}

void BuffSequence(object oTarget)
{
	ActionCastSpellAtObject(SPELL_ETHEREALNESS, oTarget, METAMAGIC_ANY, TRUE);
	//ActionCastSpellAtObject(SPELL_REDUCE_PERSON, oTarget, METAMAGIC_QUICKEN);
	//ActionCastSpellAtObject(SPELL_ENLARGE_PERSON, oTarget, METAMAGIC_QUICKEN);
	ActionCastSpellAtObject(SPELL_IMPROVED_MAGE_ARMOR, oTarget, METAMAGIC_QUICKEN);
	ActionCastSpellAtObject(SPELL_SHADOW_SHIELD, oTarget, METAMAGIC_ANY);
	//ActionCastSpellAtObject(SPELL_DISPLACEMENT, oTarget, METAMAGIC_QUICKEN);
	ActionCastSpellAtObject(SPELL_MIRROR_IMAGE, oTarget, METAMAGIC_QUICKEN);
	ActionCastSpellAtObject(SPELL_GREATER_HEROISM, oTarget, METAMAGIC_QUICKEN);
	ActionCastSpellAtObject(SPELL_TRUE_SEEING, oTarget, METAMAGIC_QUICKEN, TRUE);
	ActionCastSpellAtObject(SPELL_SUPERIOR_RESISTANCE, oTarget, METAMAGIC_QUICKEN);
	ActionCastSpellAtObject(SPELL_PROTECTION_FROM_GOOD, oTarget, METAMAGIC_QUICKEN);
	SetLocalInt(oTarget, "Buffed", 1);
}

void main()
{
    //The following two lines should not be touched
    object oIntruder = GetCreatureOverrideAIScriptTarget();
    ClearCreatureOverrideAIScriptTarget();

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
		if (GetBuffedMyself() == 0) BuffSequence(OBJECT_SELF);
        CastSpells(oIntruder);
        __TurnCombatRoundOn(FALSE);
        SetCreatureOverrideAIScriptFinished();
	}
}
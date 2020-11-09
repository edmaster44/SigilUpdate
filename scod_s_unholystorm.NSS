/*


(Planar Handbook)

Conjuration (Creation) [Evil, Water]
Level:Blackguard 4,
Components: V, S, M, DF,
Casting Time: 1 standard action
Area: 20-ft. radius centered on you
Duration: 1 round/level (D)
Saving Throw: None
Spell Resistance: No

A driving rain falls around you.
It falls in a fixed area once created.
The storm reduces hearing and visibility, resulting in a -4 penalty on Listen, Spot, and Search checks.
It also applies a -4 penalty on all ranged attacks made into, out of, or through the storm.
The rain damages good creatures, dealing 2d6 points of damage per round (good outsiders take double damage).
In addition, each round, a blast of fire strikes a randomly selected good outsider within the spell's area, dealing 5d6 points of magic damage.
After the spell's duration expires, the water disappears.
*/

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "aaa_constants"
#include "ps_inc_functions"

void main()
{
	int eDice;
    //Declare major variables
	float fDelay;
	float fDuration = RoundsToSeconds(PS_GetCasterLevel(OBJECT_SELF));
    effect eListen = EffectSkillDecrease(SKILL_LISTEN,4);
    effect eSpot = EffectSkillDecrease(SKILL_SPOT,4);
    effect eSearch = EffectSkillDecrease(SKILL_SEARCH,4);
    effect eAttack = EffectAttackDecrease(4);
    effect eVisElec = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
	effect eDamage = EffectDamage(eDice,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_NORMAL,FALSE);
	effect	eLinks;
	int eEnemyOutSider;
	eLinks = EffectLinkEffects(eListen,eSpot);
	eLinks = EffectLinkEffects(eLinks,eAttack);
	eLinks = EffectLinkEffects(eLinks,eSearch);


	location lTarget = GetSpellTargetLocation();
	  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	 while (GetIsObjectValid(oTarget))
   
	{

	 	if (spellsIsTarget(oTarget,SPELL_TARGET_SELECTIVEHOSTILE,GetAreaOfEffectCreator()));
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_UNHOLY_STORM));
		
			if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
			{
				eDice = eDice * 2; // outsiders take double damage
			}
		eDice = d6(2);
		
		fDelay = GetRandomDelay(0.5, 2.0);
			//This fires a cast spell event for the specified target
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinks, oTarget,fDuration));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget,fDuration));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget,fDuration);
			

	
	}

	//Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	   
	}
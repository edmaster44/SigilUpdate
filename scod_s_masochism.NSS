/*
Masochism
(Book of Vile Darkness)

Enchantment [Evil]
Level: Sorcerer 2, Wizard 2, Assassin 3, Blackguard 3, Cleric 3,
Components: V, S, M,
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 1 round/level


For every 10 points of damage the caster takes in a given round, he gains a +1 luck bonus on attack rolls, saving throws, and skill checks made in the following round.
The more damage the caster takes, the greater the luck bonus. (Maximum + 3)


*/
#include "nwn2_inc_spells"
#include "ps_inc_functions"
#include "aaa_constants"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
// End of Spell Cast Hook




	if (!GetHasFeat(FEAT_BLACKGUARD,OBJECT_SELF))
	{ SendMessageToPC(OBJECT_SELF,"You do not walk the path of the Wicked for you to cast such a spell");
	return;
	}
	

    object oPC = OBJECT_SELF;
	int nCasterLevel = PS_GetCasterLevel(oPC);
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DOOM);
    float fDuration = TurnsToSeconds(nCasterLevel); 
    int nScale = (PS_GetCasterLevel(OBJECT_SELF) /10);
	 if (nScale < 1)
        nScale = 1;
		
	effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, nScale);
	effect eSkills = EffectSkillIncrease(SKILL_ALL_SKILLS, nScale);
	effect eAttack = EffectAttackIncrease(nScale);	
	effect	eDamage = EffectDamageIncrease(nScale);
	effect eHarm = EffectDamage(nScale * 10 ,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_NORMAL,TRUE);
	effect eLink = 	EffectLinkEffects(eSkills,eSaves);
	eLink = EffectLinkEffects(eLink,eAttack);
	eLink = EffectLinkEffects(eLink,eDamage);
	eLink = EffectLinkEffects(eLink,eHarm);
	
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
	
	}
		
		
		
		
		
		
		
		
		
			
		
		
		
		
		
		
		
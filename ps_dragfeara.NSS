

//::///////////////////////////////////////////////
//:: Dragon Fear OnEnter
//:: based on NW_S1_DragFear
//:: created by Alersia.
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "aaa_constants"

void main()
{
	
	object oTarget 	= GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();
	object oItem	= GetItemPossessedBy(oCreator, "ps_essence");
	int iAffected 	= GetLocalInt(oTarget, "DRAGONFEAR");

    effect eDur  = EffectVisualEffect( VFX_DUR_SPELL_FEAR );
    effect eFear = EffectFrightened();
    effect eLink = EffectLinkEffects(eFear, eDur);

	effect eAttackPen = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
	effect eSavePen = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	effect eSkillPen = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	effect eShakenLink1 = EffectLinkEffects(eAttackPen, eSavePen);
	effect eShakenLink2 = EffectLinkEffects(eSkillPen, eDur);
	effect eLink2 = EffectLinkEffects(eShakenLink1, eShakenLink2);

	
	effect eImm = EffectImmunity(IMMUNITY_TYPE_FEAR);
		eImm = ExtraordinaryEffect(eImm);
	
    int nHD = GetTotalLevels(oCreator, TRUE);
	int nCHRBonus = GetAbilityModifier(ABILITY_CHARISMA, oCreator);
	int nDC = 10 + (nHD / 2) + nCHRBonus; 	
    int nDuration = d6(4);
	int nDuraImm = 24;
	
		
	if (GetLocalInt(oItem, "TempChange") != 1)
	{	
 		if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
  		{	
			if (GetRacialType(oTarget) !=11) 
			{
				if (iAffected != 1)
     	  		{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 2647, TRUE));
      		  		if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
	  				{
						if (
   							GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) ||
			    			GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, GetAreaOfEffectCreator())
			    			)
						{
							// Shaken
		    				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
						}
						else 
						{
							// Fear
							ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
						}
					}
					SetLocalInt(oTarget, "DRAGONFEAR", 1);
				}
   			}
			else
			{
				SendMessageToPC(oCreator, "<c=yellow>Other Dragons are immune to your frightful presence.");
				SetLocalInt(oTarget, "DRAGONFEAR", 1);
			}
		}
	}	
}
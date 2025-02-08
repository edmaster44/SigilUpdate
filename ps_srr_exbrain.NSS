/* Mindflayer extract brain ability - created by Agony_Aunt for SCoD */
/* Edited by Xndar 1/19/2016 */

#include "nw_i0_spells"
#include "x2_inc_spellhook" 

const string EXBRAIN = "EXBRAIN";

void AttachTentacle(object oPC, object oTarget)
{
	
	// do you succeed on a touch attack?
	int iTentacles = PS_GetLocalInt(oTarget, EXBRAIN);
	int iHit = TouchAttackMelee(oTarget, FALSE, iTentacles*2); // 2 points bonus for every tentacle attached and +2 base.
	//Auto-success if stunned.
	int nEffectType;
	effect eIsStunned = GetFirstEffect(oTarget);
	if(iTentacles == 0)
	{
		while(GetIsEffectValid(eIsStunned))
	    {
	        nEffectType = GetEffectType(eIsStunned);
	        if(nEffectType == EFFECT_TYPE_STUNNED && (GetEffectSpellId(eIsStunned) != GetSpellId()))
	        {
	            	SendMessageToPC(oPC, "Automatic hit! All 4 tentacles attached, time to feed!");
					//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 6.0); // cant have the flayer walking away while munching on brains
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oPC, 6.0); // cant have the flayer casting spells or fighting either!
					int iIntel = GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
					if (iIntel > 0)
					{
						int currentPP = PS_GetLocalInt(oPC, "PSI_PP");
						int finalPP = currentPP + (2 * iIntel);
	                    
	                       PS_SetLocalInt(oPC, "PSI_PP", currentPP+(2 * iIntel));
						   SetGUIObjectText(oPC, "powerpointscreen", "PPRatioTXT", -1, IntToString(finalPP));
	                    
					}
					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE, TRUE, TRUE, TRUE), oTarget);
					return;
					
	        }
	
	        eIsStunned = GetNextEffect(oTarget);
			
	    }
	}
	
	
	
	
	if (iHit > 0 && !GetIsDead(oTarget))
	{
		// finally allow will save
		int nDC = 10 + GetTotalLevels(oPC, TRUE)/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC) + iTentacles*2;
				
		if (WillSave(oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC) == 0)
		{
			// we got a tentacle attached!
			if (iHit == 2) // critical
			{
				iTentacles = iTentacles + 2;
			}
			else
			{
				iTentacles++;
			}
				
			if (iTentacles > 3) // extract brainsssss
			{
				SendMessageToPC(oPC, "HIT! All 4 tentacles attached, time to feed!");
				//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 6.0); // cant have the flayer walking away while munching on brains
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oPC, 6.0); // cant have the flayer casting spells or fighting either!
				int iIntel = GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
				if (iIntel > 0)
				{
					int currentPP = PS_GetLocalInt(oPC, "PSI_PP");
					int finalPP = currentPP + (2 * iIntel);
	                    
	                PS_SetLocalInt(oPC, "PSI_PP", currentPP+(2 * iIntel));
					SetGUIObjectText(oPC, "powerpointscreen", "PPRatioTXT", -1, IntToString(finalPP));
				}
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE, TRUE, TRUE, TRUE), oTarget);
				
				
			}
			else
			{
				if (iHit == 2) SendMessageToPC(oPC, "CRITCAL HIT! You attached two tentacles!!");
				else SendMessageToPC(oPC, "HIT! You attached a tentacle!");
				
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_STUN), oTarget, 6.0);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oPC, 6.0); // cant have the flayer walking away while extracting brainssssss
				//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oPC, 6.0); // cant have the flayer casting spells or fighting either!
				
				PS_SetLocalInt(oTarget, EXBRAIN, iTentacles);
				DelayCommand(6.0, AttachTentacle(oPC, oTarget));
			}
		}
		else
		{
			SendMessageToPC(oPC, "Target's will is stronger than your own! Your tentacles recoil!");
			// its all failed, try again.
			PS_SetLocalInt(oTarget, EXBRAIN, 0);
		}		
	}
	else
	{
		SendMessageToPC(oPC, "You failed to attach a tentacle, the target recovers!!!");
		// its all failed, try again.
		PS_SetLocalInt(oTarget, EXBRAIN, 0);
	}
}

void main()
{
	if (!X2PreSpellCastCode())
    {
        return;
    }
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	
	// is it a valid target?
	if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// is it too big? 
		if (GetCreatureSize(oTarget) > GetCreatureSize(oPC))
		{
			SendMessageToPC(oPC, "Creature is too large for you to get to its head");
		}
		// is it immune to mind spells?
		else if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC))
		{
			SendMessageToPC(oPC, "Target is immune to your mind attack");
		}
		else
		{
			AttachTentacle(oPC, oTarget);
		}
	}
	else
	{
		SendMessageToPC(oPC, "Target is immune to your mind attack");
	}
}
// nw_c2_gorgon_trample
//
// Trample script for gorgons
// Reflex save for half bludgeoning damage
// Evasion feats reduce/avoid damage
// If all damage resisted, dodge instead of knockdown

#include "NW_I0_SPELLS"
#include "x0_i0_position"
#include "nw_i0_generic"

void PlayAnimationWrapper(object oTarget, string sAnim, int nLoop)
{
PlayCustomAnimation(oTarget, sAnim, nLoop);
}

int TargetIsFacingWithin(float fDegrees, object oSelf, object oObject)
{
int iRet;
float fDirectionOfFacing = GetFacing(oSelf);
float fDirectionOfObject = GetAngleBetweenObjects(oSelf, oObject);

iRet = IsDirectionWithinTolerance(fDirectionOfObject, fDirectionOfFacing, fDegrees);
return (iRet);
}

void main()
{
object oTarget = GetEnteringObject();
object oSelf = GetAreaOfEffectCreator(OBJECT_SELF);

if (oTarget == oSelf//Don't trample yourself 
	|| GetIsFriend(oTarget, oSelf)//Don't trample friends
	|| !TargetIsFacingWithin(45.0, oSelf, oTarget))//Not within 45 degree cone ahead
		return;

AssignCommand(oTarget, ClearAllActions(TRUE));

if (oTarget == GetLocalObject(oSelf, "Charge"))
	{
	SetCollision(oSelf, 1);
	DelayCommand(0.35, SetAILevel(oSelf, AI_LEVEL_DEFAULT));
	DelayCommand(0.4, RemoveEffectsFromSpell(oSelf, 100));
	}

int nDmg = d8(1)+7;//Full damage
int nDC = 10+GetHitDice(oSelf);
effect eKnock = EffectKnockdown();
effect eVis = EffectNWN2SpecialEffectFile("sp_sonic_hit.sef");
effect eBludgeon = EffectDamage(nDmg, DAMAGE_TYPE_BLUDGEONING);

if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
	{//Saving throw success, half damage
	nDmg = nDmg/2;
	if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
		{//Evasion feats avoid damage
		nDmg = 0;
		}
	}
else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
	{//Saving throw failure & Improved Evasion feat
	nDmg = nDmg/2;//Half damage
	}
if (nDmg > 0)//Knock down & damage target
	{
	DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0));
	DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0));
	DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBludgeon, oTarget));
	}
else//Dodge if uninjured
	{
	DelayCommand(0.3, PlayAnimationWrapper(oTarget, "*dodge01", 0));	
	}

}
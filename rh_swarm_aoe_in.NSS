/*Created by Shaughn
for the Risen Hero Campaign
http://neverwinter.nexusmods.com/mods/10
3/3/2013
*/
#include "aaa_constants"

void main()
{
	
	object oCaster 	= 	GetAreaOfEffectCreator();
	object oTarget 	= 	GetEnteringObject();
	string sIgnore	=	GetLocalString(oCaster, "swarm_ignore");
	string sSummon	=	GetLocalString(oTarget, "swarm_summoner"); //if swarm is created by a spell
	object oSummoner = GetLocalObject(oCaster, "SUMMONER");
	
		if (GetIsObjectValid(oSummoner) && oTarget == oSummoner) {
			//do nothing : Don't kill summoner!
		} else if (GetTag(oTarget) == GetTag(oCaster))
		{
			//do nothing : Don't kill self or similiar swarms
		}
		else if(sIgnore != "" && (GetTag(oTarget) == sIgnore || GetTag(oTarget) == sIgnore+"2" || GetTag(oTarget) == sIgnore+"3"))
		{
			//do nothing : Ignore creature in swarm
		}
		else if(sSummon != "")
		{
			//do nothing : Ignore swarm summoner
		}
		else
		{
			string	sEffect	=	GetLocalString(oCaster,"swarm_enter");
			effect	eEffect = 	SupernaturalEffect(EffectNWN2SpecialEffectFile(sEffect));
			
			ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);
			
			int nHD	=	GetHitDice(oCaster);
			int nCN	=	GetAbilityModifier(ABILITY_CONSTITUTION,oCaster);	
			int nDC	=	10 + (nHD/2) + nCN;
			
			int nSave	=	FortitudeSave(oTarget,nDC,SAVING_THROW_TYPE_NONE,oCaster);
			
			if(nSave == SAVING_THROW_CHECK_FAILED)
			{
				effect eStink = EffectDazed();
		    	effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
		    	effect eLink = EffectLinkEffects(eMind, eStink);	
				
				FloatingTextStringOnCreature(""+GetName(oTarget)+" is DISTRACTED by the swarm",oTarget);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(1));
			}
		}	
}
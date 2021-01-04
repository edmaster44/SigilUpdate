/*Created by Shaughn
for the Risen Hero Campaign
http://neverwinter.nexusmods.com/mods/10
3/3/2013
*/

void RunDistraction(object oCaster,object oTarget);

void main()
{
	object oTarget = GetFirstInPersistentObject();
	object oCaster = GetAreaOfEffectCreator();
	object oSummoner = GetLocalObject(oCaster, "SUMMONER");
	
	//debug
	//FloatingTextStringOnCreature("object: oCaster",oCaster);
	//FloatingTextStringOnCreature("object: oTarget",oCaster);
	
	
	int nHD			=	GetHitDice(oCaster);
	int nDisease	=	GetLocalInt(oCaster,"swarm_disease");
	int nPoison		=	GetLocalInt(oCaster,"swarm_poison");
	int nDC			=	GetLocalInt(oCaster,"swarm_dc");
	int nWound		=	GetLocalInt(oCaster,"swarm_wound");
	int nBonus		=	GetLocalInt(oCaster,"swarm_bonus");
	string sIgnore	=	GetLocalString(oCaster,"swarm_ignore");
	
	effect eDamage;
	
	if(nHD > 20)eDamage		=	EffectDamage(d6(5),DAMAGE_TYPE_PIERCING);
	else if(nHD >15)eDamage	=	EffectDamage(d6(4),DAMAGE_TYPE_PIERCING);
	else if(nHD >10)eDamage	=	EffectDamage(d6(3),DAMAGE_TYPE_PIERCING);
	else if(nHD >5)eDamage	=	EffectDamage(d6(2),DAMAGE_TYPE_PIERCING);
	else eDamage			=	EffectDamage(d6(1),DAMAGE_TYPE_PIERCING);
	
	eDamage	=	EffectLinkEffects(EffectVisualEffect(VFX_COM_BLOOD_REG_RED),eDamage);
	
	while(GetIsObjectValid(oTarget))
	{
		if (GetIsObjectValid(oSummoner) && oTarget == oSummoner) {
			//do nothing : Don't kill summoner!
		} else if (GetTag(oTarget) == GetTag(oCaster)) {
			//do nothing : Don't kill self or similiar swarms
		}
		else if(sIgnore != "" && (GetTag(oTarget) == sIgnore || GetTag(oTarget) == sIgnore+"2" || GetTag(oTarget) == sIgnore+"3"))
		{
			//do nothing : Ignore creature in swarm
		}
		else
		{
			//Fortitude save DC 10 + 1/2HD + Con modifier. Failed dazed x1 round
			RunDistraction(oCaster,oTarget);
		
			ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
		
			if(nPoison != 0)
			{
				effect ePoison = EffectPoison(nPoison);
				effect eVisPos = EffectVisualEffect(VFX_IMP_POISON_S);
				ePoison = EffectLinkEffects(eVisPos,ePoison);
				
				if(FortitudeSave(oTarget,nDC,SAVING_THROW_TYPE_NONE,oCaster) == SAVING_THROW_CHECK_FAILED)
				{
					ApplyEffectToObject(DURATION_TYPE_PERMANENT,ePoison,oTarget);
				}
			}
			
			if(nDisease != 0)
			{
				effect eDisease = EffectDisease(nDisease);
				effect eVisDis = EffectVisualEffect(VFX_IMP_DISEASE_S);
				eDisease = EffectLinkEffects(eVisDis,eDisease);
				 
				if(FortitudeSave(oTarget,nDC,SAVING_THROW_TYPE_NONE,oCaster) == SAVING_THROW_CHECK_FAILED)
				{
					ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDisease,oTarget);
				}
			}
			
			if(nWound != 0)
			{
				effect eWound;
				int nDone = FALSE;
				
				if(GetLocalInt(oCaster,""+GetFirstName(oTarget)+""+GetLastName(oTarget)+"") != 0)nDone == TRUE;
				
				if(nWound == 1 && nDone == FALSE)//Wounding
				{
					eWound == EffectDamageOverTime(1,RoundsToSeconds(1),DAMAGE_TYPE_PIERCING,TRUE);
				}
				
				else if(nWound == 2 && nDone == FALSE)//level drain
				{
					eWound = EffectNegativeLevel(1);
				}
				
				if(FortitudeSave(oTarget,nDC,SAVING_THROW_TYPE_NONE,oCaster) == SAVING_THROW_CHECK_FAILED)
				{
					SetLocalInt(oCaster,""+GetFirstName(oTarget)+""+GetLastName(oTarget)+"",1);
					ApplyEffectToObject(DURATION_TYPE_PERMANENT,eWound,oTarget);
				}
					
			}
			
			if(nBonus != 0)
			{
				effect eBonus = EffectDamage(d8(nHD/2),nBonus);
				
				ApplyEffectToObject(DURATION_TYPE_INSTANT,eBonus,oTarget);
			}
		}
		
		oTarget = GetNextInPersistentObject();
    }
	
}

void RunDistraction(object oCaster,object oTarget)
{
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
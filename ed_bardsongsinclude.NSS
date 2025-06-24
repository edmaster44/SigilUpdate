#include "x0_i0_spells"
#include "nwn2_inc_spells"
#include "nwnx_sql"
#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "ps_inc_functions"

void ED_ApplyFriendlySongEffectsToParty( object oCaster, int nSpellId, effect eLink );


effect InspireCourage(object oCaster)
{
	int nLevel      = GetBardicClassLevelForUses(oCaster);
	
//	SendMessageToPC(oCaster,"Applying caster level to Inspire Courage of: "+IntToString(nLevel));
		
	int nBonus = 1; 
       if (nLevel >= 8)
       {   nBonus = nBonus + ((nLevel - 2) / 6);	}
		
        
       int nDamage = IPGetDamageBonusConstantFromNumber(nBonus);   // Map raw bonus to a DAMAGE_BONUS_* constant.

	    effect eAttack = ExtraordinaryEffect( EffectAttackIncrease(nBonus) );
        effect eDamage = ExtraordinaryEffect( EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eAttack, eDamage) );
		effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_COURAGE) );
        eLink          = ExtraordinaryEffect( EffectLinkEffects(eLink, eDur) );

		return eLink;		
}

effect InspireCompetence(object oCaster)
{
	int nLevel      = GetBardicClassLevelForUses(oCaster);
		
    int nSkill = 2;
        
    if (nLevel >= 11)
     {	nSkill = nSkill + (2 * ((nLevel - 3) / 8));		}
		
	
    effect eSkill  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_ALL_SKILLS, nSkill) );
    effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_COMPETENCE) );
    effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eSkill, eDur) );
    eLink          = ExtraordinaryEffect( EffectLinkEffects(eLink, eDur) );

	return eLink;		
}


effect InspireDefense(object oCaster)
{
		int nLevel      = GetBardicClassLevelForUses(oCaster);

//		SendMessageToPC(oCaster,"Applying caster level to Inspire Defense of: "+IntToString(nLevel));	
				
        int nAC = 2; 
        
        if (nLevel >= 10)
        {	nAC = nAC + ((nLevel - 5) / 5);		}
		

        effect eAC     = ExtraordinaryEffect( EffectACIncrease(nAC, AC_DODGE_BONUS) );
        effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_DEFENSE) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eAC, eDur) );

		return eLink;		
}

effect InspireRegen(object oCaster)
{
		int nLevel      = GetBardicClassLevelForUses(oCaster);
		
        float fDuration = 4.0;
        int nRegen = Ceil(nLevel / 5.0);
		if(nRegen < 1) nRegen = 1;
       
		

        effect eRegen  = EffectRegenerate(nRegen, RoundsToSeconds(1));
        effect eDur    = EffectVisualEffect(VFX_HIT_BARD_INS_REGENERATION);
        effect eLink   = EffectLinkEffects(eRegen, eDur);

		//In addition this inspiration gives a 10% hitpoints bonus for all allies. 
		//This bonus increases by an additional 1% for 1/2 your Bardic levels up to a maximum of +20% (total including base bonus). 
		//The bonus hitpoints granted is capped at your perform * 1.5.	
	
		int iPerform = GetSkillRank(SKILL_PERFORM,oCaster);	
		
		float iBase = 0.1 + ((nLevel / 2.0) * 0.01);
		if(iBase > 0.2) iBase = 0.2;
		
		int iHP = Ceil(GetMaxHitPoints(oCaster) * iBase);
		if(iHP > Ceil(iPerform * 1.5)) iHP = Ceil(iPerform * 1.5);

		eLink   = EffectLinkEffects(EffectBonusHitpoints(iHP), eLink);
		eLink = ExtraordinaryEffect( EffectLinkEffects(EffectHeal(iHP),eLink));	
				
		return eLink;		
}

effect InspireDamageReduction(int DRBonus)
{
	effect eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING,DRBonus),EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,DRBonus));
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,DRBonus),eLink);
		
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,DRBonus),eLink);
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,DRBonus),eLink);		
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,DRBonus),eLink);
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,DRBonus),eLink);
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,DRBonus),eLink);
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,DRBonus),eLink);
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,DRBonus),eLink);
	eLink = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,DRBonus),eLink);
	return eLink;
}

effect InspireToughness(object oCaster)
{
	int nLevel      = GetBardicClassLevelForUses(oCaster);
		
       int nSave = Ceil(nLevel / 5.0);
			


		effect eSave   = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSave);
		effect eDur    = EffectVisualEffect(VFX_HIT_BARD_INS_TOUGHNESS);
		effect eLink   = EffectLinkEffects(eSave, eDur);

		float iBase = 0.1 + ((nLevel / 2.0) * 0.01);
		if(iBase > 0.2) iBase = 0.2;
				
		effect eDR = ExtraordinaryEffect( EffectLinkEffects(InspireDamageReduction(FloatToInt(iBase * 100)),eLink));
		
		return eLink;
}


effect BardSongChoice(object oCaster, int nSpell)
{
	effect eEffect;

	switch (nSpell)
	{
		case 905 :		//Inspire Courage
		return InspireCourage(oCaster);
		break;
		case 906 :		//Inspire Competence
		return InspireCompetence(oCaster);
		break;
		case 907 :		//Inspire Defense
		return InspireDefense(oCaster);
		break;
		case 908 :		//Inspire Regen
		return InspireRegen(oCaster);
		break;
		case 909 :		//Inspire Toughness
		return InspireToughness(oCaster);
		break;
	}
	return eEffect;	
}

int HasBardSpell( int nSpellId, object oTarget )
{
	effect eCheck = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eCheck))
	{
		if (GetEffectSpellId(eCheck) == nSpellId &&
			GetEffectType(eCheck) != EFFECT_TYPE_BARDSONG_SINGING)
		{
		return TRUE;
		}
		eCheck = GetNextEffect(oTarget);
	}
	return FALSE;
}


void ED_ApplyFriendlySongEffectsToParty( object oCaster, int nSpellId, effect eLink )
{
    object oTarget = GetFirstFactionMember( oCaster ); object oAnimal;
	eLink = SetEffectSpellId( eLink, nSpellId );
	
	while ( GetIsObjectValid( oTarget ) )
    {
	if(GetArea(oTarget) == GetArea(oCaster))
	{
		if ( GetIsObjectValidSongTarget(oTarget) && !GetIsDead(oTarget) && GetRacialType(oTarget))
		{
	  		if(!HasBardSpell(nSpellId, oTarget)) ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, 35.0 );
	   		else RefreshSpellEffectDurations(oTarget, nSpellId, 35.0);
		}
		
		oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oTarget);
		if(GetIsObjectValidSongTarget(oAnimal) && !GetIsDead(oAnimal) && GetRacialType(oAnimal) != RACIAL_TYPE_DRAGON)
		{
		    if(!HasBardSpell(nSpellId, oAnimal)) ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oAnimal, 35.0 );
	   		else RefreshSpellEffectDurations(oAnimal, nSpellId, 35.0);
		}
		
		oAnimal = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oTarget);
		if(GetIsObjectValidSongTarget(oAnimal) && !GetIsDead(oAnimal) && GetRacialType(oAnimal) != RACIAL_TYPE_DRAGON)
		{
		    if(!HasBardSpell(nSpellId, oAnimal)) ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oAnimal, 35.0 );
	   		else RefreshSpellEffectDurations(oAnimal, nSpellId, 35.0);
		}
		
		oAnimal = GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oTarget);
		if(GetIsObjectValidSongTarget(oAnimal) && !GetIsDead(oAnimal) && GetRacialType(oAnimal) != RACIAL_TYPE_DRAGON)
		{
		    if(!HasBardSpell(nSpellId, oAnimal)) ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oAnimal, 35.0 );
	   		else RefreshSpellEffectDurations(oAnimal, nSpellId, 35.0);
		}
	}

		oTarget = GetNextFactionMember( oCaster );		
 	}
}

int CountFactionMembers(object oCaster)
{
	object oFaction = GetFirstFactionMember(oCaster); int iCount;
	while(GetIsObjectValid(oFaction))
	{
		if(GetArea(oFaction) == GetArea(oCaster) && !GetIsDead(oFaction)) iCount++;
		if(iCount >= 2) return 2;
			
		oFaction = GetNextFactionMember(oCaster);
	}
		
	return iCount;
}

void RunPersistentSong(object oCaster, int nSpellId)
{
	if ( GetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(	
	}
	
	if(GetLocalInt(oCaster,"CombinedSongsOn") == 1)
	{
		FloatingTextStringOnCreature("*Deactivate Combined Inspirations to use this song!*", oCaster, TRUE, 3.0f);
		return;
	}
	
	int	nPerform	= GetSkillRank(SKILL_PERFORM, oCaster);
	 
	if (nPerform < 3 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, oCaster );
		return;
	}
	

	int nWillSave = 13 + (GetBardicClassLevelForUses(oCaster) / 2) + GetAbilityModifier(ABILITY_CHARISMA,oCaster);
	
    // Verify that we are still singing the same song...
    int nSingingSpellId = FindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
    if(nSingingSpellId == nSpellId)
    {
		 ED_ApplyFriendlySongEffectsToParty(oCaster, nSpellId, BardSongChoice(oCaster, nSpellId));
		
        DelayCommand(30.0f, RunPersistentSong(oCaster, nSpellId));
    }
}



effect GetSongEffect(object oCaster, int selection)
{
	
	if(selection == 1) return SetEffectSpellId(InspireCourage(oCaster),905);
	else if(selection == 2) return SetEffectSpellId(InspireCompetence(oCaster),906);
	else if(selection == 3) return SetEffectSpellId(InspireDefense(oCaster),907);
	else if(selection == 4) return SetEffectSpellId(InspireRegen(oCaster),908);
	else if(selection == 5) return SetEffectSpellId(InspireToughness(oCaster),909);
	else return EffectHeal(1);	
}

void RunPersistentCombinedSong(object oCaster, int song1, int song2, int uniqueid)
{
	if ( GetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(	
	}
	
	int	nPerform	= GetSkillRank(SKILL_PERFORM, oCaster);
	 
	if (nPerform < 15 )
	{
		FloatingTextStrRefOnCreature ( 182800, oCaster );
		return;
	}
	
	if(song1 == 5 && CountFactionMembers(oCaster) < 2 || song2 == 5 && CountFactionMembers(oCaster) < 2)
	{
		FloatingTextStringOnCreature("Inspire Recklessness requires you to be in a party!", oCaster, TRUE, 3.0f);
		return;
	}
		
	int id = GetLocalInt(oCaster,"CSONGID");
	
    if(id == uniqueid)
    {
		if(song1 == 1 || song2 == 1)
		{
			
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 905, InspireCourage(oCaster));
		}
		if(song1 == 2 || song2 == 2)
		{
			
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 906, InspireCompetence(oCaster));;		
		}
		if(song1 == 3 || song2 == 3)
		{
			
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 907, InspireDefense(oCaster));
		}
		if(song1 == 4 || song2 == 4)
		{
		
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 908, InspireToughness(oCaster));
		}
		if(song1 == 5 || song2 == 5)
		{
		
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 909, InspireRegen(oCaster));						
		}

										
        DelayCommand(30.0f, RunPersistentCombinedSong(oCaster, song1, song2, uniqueid));
    }
}

void StartSong(object oCaster, int nSpellId)
{
	if ( GetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(	
	}
		
	if(GetLocalInt(oCaster,"CombinedSongsOn") == 1)
	{
		int song1 = GetLocalInt(oCaster,"CSONG1");
		int song2 = GetLocalInt(oCaster,"CSONG2");
		
		if(song1 == 1 || song2 == 1) RemoveAnySpellEffects(905,oCaster);
		if(song1 == 2 || song2 == 2) RemoveAnySpellEffects(906,oCaster);
		if(song1 == 3 || song2 == 3) RemoveAnySpellEffects(907,oCaster);
		if(song1 == 4 || song2 == 4) RemoveAnySpellEffects(908,oCaster);
		if(song1 == 5 || song2 == 5) RemoveAnySpellEffects(909,oCaster);				
		
		FloatingTextStringOnCreature("*Disabling Combined Inspirations!*", oCaster, TRUE, 3.0f);
		ClearBardVariables(oCaster,0); DeleteLocalInt(oCaster,"InspireAweID");	
		return;
	}
	
	ClearBardVariables(oCaster,0); DeleteLocalInt(oCaster,"InspireAweID");

	if(AttemptNewSong(oCaster, TRUE))
    {
		DeleteLocalInt(oCaster,"CSONGID");
		effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );
	    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oCaster));
		FloatingTextStringOnCreature("*"+GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpellId)))+"*", oCaster, TRUE, 3.0f);
		
		DelayCommand(0.1f, RunPersistentSong(oCaster, nSpellId));
    }
}

void PlayCombinedSongs(object oCaster, int nSpellID)
{
	ClearBardVariables(oCaster,5); DeleteLocalInt(oCaster,"InspireAweID");
	
	if ( GetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(	
	}

	int song1; int song2;
	
	if(GetLocalInt(oCaster,"CombinedSongsOn") == 0)
	{
		string name = SQLEncodeSpecialChars(GetName(oCaster));
		string act = SQLEncodeSpecialChars(GetPCPlayerName(oCaster));
	
		SQLExecDirect("SELECT `song_1`,`song_2` FROM `bard_combinesongs` WHERE `name`='"+name+"' AND `act`='"+act+"';");
		SQLFetch();
	
		song1 = StringToInt(SQLGetData(1));	song2 = StringToInt(SQLGetData(2));
	
		if(song1 <= 0 || song2 <= 0)
		{
			FloatingTextStringOnCreature("*You need to pick two songs for song selection feat!*", oCaster, TRUE, 3.0f);
			return;
		}	
	
		int uniqueID = Random(50000);
		SetLocalInt(oCaster,"CombinedSongsOn",1);
		SetLocalInt(oCaster,"CSONGID",uniqueID);
		SetLocalInt(oCaster,"CSONG1",song1);
		SetLocalInt(oCaster,"CSONG2",song2);
	
		effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oCaster));
		FloatingTextStringOnCreature("*Playing Combined Inspirations!*", oCaster, TRUE, 3.0f);
		
		DelayCommand(0.1f, RunPersistentCombinedSong(oCaster,song1,song2,uniqueID));
		}
		else 
		{
			DeleteLocalInt(oCaster,"CombinedSongsOn");
			DeleteLocalInt(oCaster,"CSONGID");
		
			song1 = GetLocalInt(oCaster,"CSONG1");
			song2 = GetLocalInt(oCaster,"CSONG2");
		
			if(song1 == 1 || song2 == 1) RemoveAnySpellEffects(905,oCaster);
			if(song1 == 2 || song2 == 2) RemoveAnySpellEffects(906,oCaster);
			if(song1 == 3 || song2 == 3) RemoveAnySpellEffects(907,oCaster);
			if(song1 == 4 || song2 == 4) RemoveAnySpellEffects(908,oCaster);
			if(song1 == 5 || song2 == 5) RemoveAnySpellEffects(909,oCaster);				

		
			FloatingTextStringOnCreature("*Disabling Combined Inspirations!*", oCaster, TRUE, 3.0f);
		}
}
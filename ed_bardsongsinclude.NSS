#include "x0_i0_spells"
#include "nwn2_inc_spells"
#include "nwnx_sql"
#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "ps_inc_functions"

void ED_ApplyFriendlySongEffectsToParty( object oCaster, int nSpellId, effect eLink );


effect BardSongChoice(object oCaster, int nSpell)
{
	effect eEffect;

	switch (nSpell)
	{
		case 905 :		//Inspire Courage
		return InspireCourage(oCaster,0);
		break;
		case 906 :		//Inspire Competence
		return InspireCompetence(oCaster,0);
		break;
		case 907 :		//Inspire Defense
		return InspireDefense(oCaster,0);
		break;
		case 908 :		//Inspire Regen
		return InspireRegen(oCaster,0);
		break;
		case 909 :		//Inspire Toughness
		return InspireToughness(oCaster,0);
		break;


	return eEffect;	
}
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
	

	int nWillSave = 13 + (GetBardTRUECasterlevel(oCaster) / 2) + GetAbilityModifier(ABILITY_CHARISMA,oCaster);
	
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
	eFX = ExtraordinaryEffect(eFX);
	if(selection == 1) return SetEffectSpellId(eFX,905);
	else if(selection == 2) return SetEffectSpellId(eFX,906);
	else if(selection == 3) return SetEffectSpellId(eFX,907);
	else if(selection == 4) return SetEffectSpellId(eFX,908);
	else if(selection == 5) return SetEffectSpellId(eFX,909);
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
			
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 905, SPELLABILITY_SONG_INSPIRE_COURAGE(oCaster,1));
		}
		if(song1 == 2 || song2 == 2)
		{
			
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 906, SPELLABILITY_SONG_INSPIRE_COMPETENCE(oCaster,1));		
		}
		if(song1 == 3 || song2 == 3)
		{
			
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 907, SPELLABILITY_SONG_INSPIRE_DEFENSE(oCaster,1));
		}
		if(song1 == 4 || song2 == 4)
		{
		
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 908, SPELLABILITY_SONG_INSPIRE_REGENERATION(oCaster,1));
		}
		if(song1 == 5 || song2 == 5)
		{
		
			 ED_ApplyFriendlySongEffectsToParty(oCaster, 909, SPELLABILITY_SONG_INSPIRE_TOUGHNESS(oCaster,1));						
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

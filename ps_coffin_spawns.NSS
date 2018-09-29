///////////////////////////////////////////////////////////////
// ps_coffin_spawns (or sarcophagi, whatever)
//
// Spawns either monsters, treasure, both, or neither when a
// PC opens a container (coffin, etc) - OnOpen hook. 
//
//
// Author:  			Rust
// Date Created:    	26FEB2012 for SCOD (Sigil, City of Doors)
// Last Modified By:	Rust
// Date Last Modified:	26FEB2012
///////////////////////////////////////////////////////////////
/*
						
History of Changes

	26FEB2012 - Rust
	
	Note:  This script relies on the ps_chest script for any treasure generation.

*/



const int IS_TREASURE = 30;
const int IS_MONSTER = 30;


object SpawnUndeadMonster(object oArea, location loc_spawn_location)
{
	object oSummon = OBJECT_INVALID;
	
	int nMonsterType = d10();
		
	int i;
	
	switch(nMonsterType)
	{
		case 1: /// a hoard of rats!
		// This might have to change, as I don't know if multiple spawns
		// will lag folks. There's no way to create an encounter trigger
		// under their feet that I know of. 
		for (i=0; i < 12; ++i)
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_rat", loc_spawn_location);
			
		break;
		
		case 2: //// Skeleton
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_skeleton", loc_spawn_location);
			AssignCommand(oSummon, SpeakString(d4() < 3 ? "<i>clack-rattle" : "Sssssss!"));
		break;
		
		case 3: //// zombie
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_zombie", loc_spawn_location);
			AssignCommand(oSummon, SpeakString(d4() < 3 ? "<i> . . brainssssssss!" : "Garkchtsss!"));
		break;
		
		case 4: //// Ghoul
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_ghoul", loc_spawn_location);
			AssignCommand(oSummon, SpeakString(d4() < 3 ? "<i>Lovely flesssssssh." : "<i> . . gnaw your bones I will."));
		break;	
		
		case 5: //// Shadow
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_shadow", loc_spawn_location);
			AssignCommand(oSummon, SpeakString(d4() < 3 ? "<i> . . JOIN USssss . . ." : "<i>I smell your blood!"));
		break;
		
		case 6: //// Mummy! Just to make it serious every once in awhile

			if (GetLocalInt(oArea, "MUMMY_SPAWNED") != TRUE)
			{
				oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_mummy", loc_spawn_location);
				
				/// Mummy's are tough for this area, so only allow once in awhile. 
				SetLocalInt(oArea, "MUMMY_SPAWNED", TRUE);
				AssignCommand(oArea, DelayCommand(1800.5f, DeleteLocalInt(oArea, "MUMMY_SPAWNED")));	
			}
			else
				oSummon =  CreateObject(OBJECT_TYPE_CREATURE, "c_skeletonwarrior", loc_spawn_location);
				
			AssignCommand(oSummon, SpeakString(d4() < 3 ? "<i> . . you dare disturb me . . ." : "<i>Grave robbersssss!"));
		break;
		
		case 7: //// Ghast
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_ghast", loc_spawn_location);
			AssignCommand(oSummon, SpeakString("<i> . . fresssssssh meat!"));
		break;
		
		case 8: /// Dire Rats (2)
			CreateObject(OBJECT_TYPE_CREATURE, "c_ratdire", loc_spawn_location);
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_ratdire", loc_spawn_location);
		break;
		
		case 9: /// Skeleton Warrior
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_skeletonwarrior", loc_spawn_location);
			AssignCommand(oSummon, SpeakString(d4() < 3 ? "<i>Death!" : "<i>FOOLISH MORTALS!"));
		break;
		
		case 10: /// Fire beetles
			CreateObject(OBJECT_TYPE_CREATURE, "c_beetlefire", loc_spawn_location);
			oSummon = CreateObject(OBJECT_TYPE_CREATURE, "c_beetlefire", loc_spawn_location);
		break;	
	
	
	}
	
	return(oSummon);

}

void main()
{
	// Player has opened a sarcophagus or coffin
	// Determine if there's treasure, monster, both, or neither. 
	
	if (GetLocalInt(OBJECT_SELF, "COFFIN_SPAWN_DONE") == TRUE)
		return;
		
	SetLocalInt(OBJECT_SELF, "COFFIN_SPAWN_DONE", TRUE);
	DelayCommand(900.0f, DeleteLocalInt(OBJECT_SELF, "COFFIN_SPAWN_DONE"));
	
	/////////////////////////////////////////
	//////////// TREASURE? /////////////////
	////////////////////////////////////////

	if (d100() < IS_TREASURE)
	{
		// This requires variables that ps_chest expects
		SetLocalInt(OBJECT_SELF, "GOLDDICE", d6());
		SetLocalInt(OBJECT_SELF, "GOLDNR", d4());
		SetLocalInt(OBJECT_SELF, "GOLDCONS", 15);
		if (d100() > 90 || d100() < 15)
		{
			int nRandomItem = d10();
			string sTreasure = "JUNK";
			switch(nRandomItem)
			{
				case 1: sTreasure = "BOOK"; break;
				case 2: sTreasure = "GEM"; break;
				case 3: sTreasure = "ARCANE"; break;
				case 4: sTreasure = "AMMO"; break;
				case 5: sTreasure = "KIT"; break;				
				case 6: sTreasure = "POTION"; break;
				default: break;		// defaults to junk 4 times out of ten	
			
			
			}

			SetLocalString(OBJECT_SELF, "TREASURE1", sTreasure);
			if (d100() > 90)
				SetLocalInt(OBJECT_SELF, "TREASURE1N", 2); // for a lucky 2 objects
			

		} // determines treasure type		
	
		ExecuteScript("ps_chest", OBJECT_SELF);
		
		DelayCommand(10.0f, DeleteLocalInt(OBJECT_SELF, "GOLDDICE"));
		DelayCommand(10.0f, DeleteLocalInt(OBJECT_SELF, "GOLDNR"));		
		DelayCommand(10.0f, DeleteLocalInt(OBJECT_SELF, "GOLDCONS"));	
		DelayCommand(10.0f, DeleteLocalInt(OBJECT_SELF, "TREASURE1"));
		DelayCommand(10.0f, DeleteLocalInt(OBJECT_SELF, "TREASURE1N"));
		DeleteLocalInt(OBJECT_SELF, GetTag(OBJECT_SELF)+"_s");
			
	} // is treasure
	
	
	/////////////////////////////////////////////
	////////////// Monster? ////////////////////
	////////////////////////////////////////////
	if (d100() < IS_MONSTER)
	{
		object oPC = GetLastOpenedBy();
		
		if (GetIsObjectValid(oPC) != TRUE)
			return;		
					
		location loc_PC = GetLocation(oPC);
		
		/// Spawn some grave opening funk on the opening PC
		/// Dunno if this will work properly, so keep an eye on it
		string sImpactScript=Get2DAString("traps","TrapScript", TRAP_BASE_TYPE_MINOR_GAS);
		ExecuteScript(sImpactScript,OBJECT_SELF);
						
		
		SpawnUndeadMonster(GetArea(OBJECT_SELF), loc_PC);
		
	} // if monster
		
	


}
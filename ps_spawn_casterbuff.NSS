#include "ff_safevar"

// ps_spawn_casterbuff by Ceremorph 3/1/2012
/*
Custom creature spawn script.
This will allow the spawned creature to cast seveal buffing spells upon itself, or perform summons. The creature will need to
be a caster, with the specified spells known or memorized, depending on class spellcasting method.
*/
// 

#include "NW_I0_GENERIC"
#include "ginc_event_handlers"
#include "ginc_math"

void main()
{
	// These will specify which spells are cast. 
	int iSpell1 = PS_GetLocalInt(OBJECT_SELF,"Sp1");
	int iSpell2 = PS_GetLocalInt(OBJECT_SELF,"Sp2");
	int iSpell3 = PS_GetLocalInt(OBJECT_SELF,"Sp3");
	/* This determines if the spell is cast with metamagic. If Cheat is set to 0, be very careful to ensure the NPC has the
	   necessary feats, as well as having the metamagic version of the spell memorized if applicable. Blank if none.
	   Metamagic values:
	   Empower = 1, Extend = 2, Maximuze = 4, Quicken = 8, Silent = 16, Still = 32, Persistent = 64, Permanent = 128 */
	int iMeta = PS_GetLocalInt(OBJECT_SELF,"Meta");
	// This determines whether or not the monster actually has to know the spell to use it. Default is
	// 0, which requires the spell to be known and castable. 1 allows the spawn to "cheat".
	int iCheat = PS_GetLocalInt(OBJECT_SELF,"Cheat");
	// This determines whether spells are cast normally (0) or instantly (1). Default is 0.
	int iInstant = PS_GetLocalInt(OBJECT_SELF,"Instant");

	// **** OPTIONAL BEHAVIORS (Comment In or Out to Activate ) ****
	//SetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION);
	//SetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION);
	            // * This causes the creature to say a special greeting in their conversation file
	            // * upon Perceiving the player. Attach the [NW_D2_GenCheck.nss] script to the desired
	            // * greeting in order to designate it. As the creature is actually saying this to
	            // * himself, don't attach any player responses to the greeting.
	
	//SetSpawnInCondition(NW_FLAG_SHOUT_ATTACK_MY_TARGET); // This will set the listening pattern on the NPC to attack when allies call
	//SetSpawnInCondition(NW_FLAG_STEALTH);				// If the NPC has stealth and they are a rogue go into stealth mode
	//SetSpawnInCondition(NW_FLAG_SEARCH);				// If the NPC has Search go into Search Mode
	//SetSpawnInCondition(NW_FLAG_SET_WARNINGS);		// This will set the NPC to give a warning to non-enemies before attacking
	//SetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING);	// Separate the NPC's waypoints into day & night.
	//SetSpawnInCondition(NW_FLAG_APPEAR_SPAWN_IN_ANIMATION); // NPC will appear using "EffectAppear" instead of fading in (IF SetListeningPatterns() called)
	//SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS); //This will play Ambient Animations until the NPC sees an enemy or is cleared.
	SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);	// as above + will wander around the area.
	            
	// ===================================================================
	// * NOTE: AT MOST ONLY ONE OF THE FOLLOWING ESCAPE COMMANDS SHOULD EVER BE ACTIVATED AT ANY ONE TIME.
	//SetSpawnInCondition(NW_FLAG_ESCAPE_RETURN);    // Flee to a way point and return a short time later.
	//SetSpawnInCondition(NW_FLAG_ESCAPE_LEAVE);     // Flee to a way point and do not return.
	//SetSpawnInCondition(NW_FLAG_TELEPORT_LEAVE);   // Teleport to safety and do not return.
	//SetSpawnInCondition(NW_FLAG_TELEPORT_RETURN);  // Teleport to safety and return a short time later.
	
	
	// ===================================================================
	// *** CUSTOM USER DEFINED EVENTS ***
	// *   The following settings will allow the user to fire one of the blank user defined events in the NW_D2_DefaultD.  Like the
	// *   On Spawn In script this script is meant to be customized by the end user to allow for unique behaviors.  The user defined
	// *   events user 1000 - 1010
	//SetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT);        // Fire User Defined Event 1001
	//SetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT);         // Fire User Defined Event 1002
	//SetSpawnInCondition(NW_FLAG_ATTACK_EVENT);           // Fire User Defined Event 1005
	//SetSpawnInCondition(NW_FLAG_DAMAGED_EVENT);          // Fire User Defined Event 1006
	//SetSpawnInCondition(NW_FLAG_DISTURBED_EVENT);        // Fire User Defined Event 1008
	//SetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT); // Fire User Defined Event 1003
	//SetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT);      // Fire User Defined Event 1004
	//SetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT);    // Fire User Defined Event 1011
	
	
	// ===================================================================
	// **** Animation Conditions **** //
	// * These are extra conditions you can put on creatures with ambient animations.
	
	// * Civilized creatures interact with placeables in their area that have the 
	// * tag "NW_INTERACTIVE" and "talk" to each other.
	// * Humanoid races are civilized by default, so only set this flag for monster 
	// * races that you want to behave the same way.
	SetAnimationCondition(NW_ANIM_FLAG_IS_CIVILIZED);
	
	// * If this flag is set, this creature will constantly be acting. Otherwise, 
	// * creatures will only start performing their ambient animations when they
	// * first perceive a player, and they will stop when the player moves away.
	SetAnimationCondition(NW_ANIM_FLAG_CONSTANT);
	
	// * Civilized creatures with this flag set will randomly use a few 
	// * voicechats. It's a good idea to avoid putting this on multiple
	// * creatures using the same voiceset.
	// SetAnimationCondition(NW_ANIM_FLAG_CHATTER);
	
	// * Creatures with _immobile_ ambient animations can have this flag set
	// * to make them mobile in close range. They will never leave their immediate
	// * area, but will move around in it, frequently returning to their starting point.
	// * Note that creatures spawned inside interior areas that contain a waypoint
	// * with one of the tags "NW_HOME", "NW_TAVERN", "NW_SHOP" will automatically
	// * have this condition set.
	// SetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE);
	
	
	// ===================================================================
	// **** Special Combat Tactics *****//
	// * These are special flags that can be set on creatures to
	// * make them follow certain specialized combat tactics.
	// * NOTE: ONLY ONE OF THESE SHOULD BE SET ON A SINGLE CREATURE.
	
	// SetCombatCondition(X0_COMBAT_FLAG_RANGED);	// Ranged attacker will attempt to stay at ranged distance from their target.
	// SetCombatCondition(X0_COMBAT_FLAG_DEFENSIVE);// Defensive attacker will use defensive combat feats and parry
	// SetCombatCondition(X0_COMBAT_FLAG_AMBUSHER); // Ambusher will go stealthy/invisible and attack, then run away and do it again.
	// SetCombatCondition(X0_COMBAT_FLAG_COWARDLY);	// Cowardly creatures will attempt to flee attackers.
	
	// * Exclude use of items, abilities, and/or spells
	// PS_SetLocalIntState(OBJECT_SELF, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ITEM); 	
	// PS_SetLocalIntState(OBJECT_SELF, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ABILITY); 	
	// PS_SetLocalIntState(OBJECT_SELF, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_SPELL); 	
	
	// ===================================================================
	// Now run the standard spawn.  This may run other scripts, create treasure, and set various flags
	ExecuteScript(SCRIPT_DEFAULT_SPAWN, OBJECT_SELF);
	// NPC will immediately cast spells on themselves at spawn. Select spell IDs from spells.2da. 
	// Use defensive/buffing spells only. Up to three can be cast at this point.
	ActionCastSpellAtObject(iSpell1,OBJECT_SELF,iMeta,iCheat,0,0,iInstant);
	if(iSpell2>0)
		ActionCastSpellAtObject(iSpell2,OBJECT_SELF,iMeta,iCheat,0,0,iInstant);
	if(iSpell3>0)
		ActionCastSpellAtObject(iSpell3,OBJECT_SELF,iMeta,iCheat,0,0,iInstant);
}
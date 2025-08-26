/*
	Constants and help functions for custom grenades
*/

#include "x2_I0_SPELLS"
#include "NW_I0_SPELLS"

// Low fire grenade constants.
// After initial hit, has chance to combust effect on targets.
const int   LOW_FIRE_DIE      	      = 20; // Damage die
const int   LOW_FIRE_DICE_NUM 	      = 1;  // Number of dice
const float LOW_FIRE_COMBUST_CHANCE   = 0.5; // In percentage, for example 0.5 is 50% to catch on fire
const int   LOW_FIRE_COMBUST_DIE      = 6; // Combust damage die
const int   LOW_FIRE_COMBUST_DICE_NUM = 1; // Combust number of dice
const int   LOW_FIRE_COMBUST_ROUNDS   = 3; // How many rounds targets on fire?
const float LOW_FIRE_RADIUS           = RADIUS_SIZE_HUGE; // Explosion radius
const int   LOW_FIRE_REFLEX_SAVE_DC   = 20;

// Medium Acid grenade constants.
// After initial hit, has chance for blindness,
// and chance to sticky acid to cause more damage for a few round.
const int   MED_ACID_DIE                     = 20;
const int   MED_ACID_DICE_NUM                = 3;
const float MED_ACID_BLIND_CHANCE            = 0.1; // In percentage
const int   MED_ACID_BLIND_DURATION          = 5; // In rounds
const float MED_ACID_STICK_CHANCE            = 0.5; // Percent for sticky acid
const int   MED_ACID_STICK_DAMAGE_DIE        = 6;
const int   MED_ACID_STICK_DAMAGE_DICE_NUM   = 2;
const int   MED_ACID_STICK_DURATION_DIE      = 4;
const int   MED_ACID_STICK_DURATION_DICE_NUM = 2;
const float MED_ACID_RADIUS                  = RADIUS_SIZE_HUGE; // Explosion radius
const int   MED_ACID_REFLEX_SAVE_DC          = 26;

// Strong Shrapnel grenade constants.
// Deals slashing/blud./piercing damage on hit.
const int   STRONG_SHRAPNEL_SLASH_DIE       = 20;
const int   STRONG_SHRAPNEL_SLASH_DICE_NUM  = 2;
const int   STRONG_SHRAPNEL_BLUDGE_DIE      = 20;
const int   STRONG_SHRAPNEL_BLUDGE_DICE_NUM = 2;
const int   STRONG_SHRAPNEL_PIERCE_DIE      = 20;
const int   STRONG_SHRAPNEL_PIERCE_DICE_NUM = 2;
const int   STRONG_SHRAPNEL_REFLEX_SAVE_DC  = 30;
const float STRONG_SHRAPNEL_RADIUS          = RADIUS_SIZE_HUGE;

// Smoke grenade constants.
// Darkness effect, that's all.
const int SMOKE_GRENADE_DURATION = 5; // In rounds

// Choking bomb constants.
// Daze effect if fail the save.
const int CHOKING_BOMB_SAVE_DC          = 20;
const int CHOKING_BOMB_EFFECT_DURATION  = 5; // How many rounds of daze?
const int CHOKING_BOMB_BASE_DURATION    = 1; // AoE base duration   
const int CHOKING_BOMB_EXT_DUR_DIE      = 4; // Some randomness to AoE duration
const int CHOKING_BOMB_EXT_DUR_DICE_NUM = 1; // Some randomness to AoE duration

// Sleep bomb constants.
// Sleep effect on failed save.
const int SLEEP_BOMB_SAVE_DC          = 20;
const int SLEEP_BOMB_EFFECT_DURATION  = 5; // How many rounds target will sleep?
const int SLEEP_BOMB_BASE_DURATION    = 1; // AoE base duration
const int SLEEP_BOMB_EXT_DUR_DIE      = 4; // Some randomness to AoE duration
const int SLEEP_BOMB_EXT_DUR_DICE_NUM = 1; // Some randomness to AoE duration

// Bag of caltrops constants.
// Slow effect plus some damage from caltrops.
const int CALTROPS_SAVE_DC          = 20;
const int CALTROPS_SLOW_DURATION    = 5; // In rounds!
const int CALTROPS_SLOW_DECREASE    = 50; // How much to slow the target, in percentage (default: 50%)
const int CALTROPS_BASE_DURATION    = 1; // AoE base duration (in rounds)
const int CALTROPS_EXT_DUR_DIE      = 4; // Some randomness to AoE duration
const int CALTROPS_EXT_DUR_DICE_NUM = 2; // Some randomness to AoE duration
const int CALTROPS_DAMAGE_DIE       = 2; // Damage dealt by each caltrop
const int CALTROPS_DAMAGE_DICE_NUM  = 1; // Damage dealt by each caltrop
const int CALTROPS_MIN              = 0; // Minimum caltrops stepped on each time.
const int CALTROPS_MAX              = 3; // Maximum caltrops stepped on each time.

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// Gets the die and number of dice to roll.
// Returns the result.
int RollDice(int nDie, int nDiceNum)
{
	int nResult = 0;
	int i;
	for (i = 0; i < nDiceNum; i++)
		nResult += Random(nDie) + 1;
		
	return nResult;
}

// Combust effect for low fire bomb
void DoCombustEffect(object oTarget)
{
	// Random damage
	int nDamage = RollDice(LOW_FIRE_COMBUST_DIE, LOW_FIRE_COMBUST_DICE_NUM);
	
	// Reflex save
	nDamage = GetReflexAdjustedDamage(nDamage, oTarget, LOW_FIRE_REFLEX_SAVE_DC, SAVING_THROW_TYPE_FIRE);
		
	if (nDamage > 0) {
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	}
}

// Do low fire bomb effects
void DoLowFireBomb()
{		                  
    location lTarget = GetSpellTargetLocation();
	effect eVis      = EffectVisualEffect(VFX_HIT_AOE_FIRE);
	effect eHit      = EffectVisualEffect(VFX_IMP_FLAME_M);
	effect eCombust  = EffectVisualEffect(VFX_DUR_FIRE);
	int nDamage;
	effect eDam;
	float fDelay;
	float fCatchOnFire;
	int i;
	
	// Explosion visual
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, LOW_FIRE_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);    
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			
            //Roll damage for each target
            nDamage = RollDice(LOW_FIRE_DIE, LOW_FIRE_DICE_NUM);
			
			//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, LOW_FIRE_REFLEX_SAVE_DC, SAVING_THROW_TYPE_FIRE);
			
			//Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
			
            if(nDamage > 0)
            {
	            // Apply effects to the currently selected target.
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				
				// Damage effect
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				
				// Hit visual
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));				
             }  
			 
			 // Chance to catch on fire
			 fCatchOnFire = IntToFloat(Random(100) + 1);
			 if (fCatchOnFire <= LOW_FIRE_COMBUST_CHANCE * 100) {			 	
			 	// Visual - catch on fire
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCombust, oTarget, RoundsToSeconds(LOW_FIRE_COMBUST_ROUNDS) + 1.0);
				
				// Damage each round
				for (i = 1; i <= LOW_FIRE_COMBUST_ROUNDS; i++) {
					DelayCommand(RoundsToSeconds(i), DoCombustEffect(oTarget));
				}
			}			 
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, LOW_FIRE_RADIUS, lTarget, TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}

// Sticky acid effect
void DoStickyAcidEffect(object oTarget)
{
	// Random damage
	int nDamage = RollDice(MED_ACID_STICK_DAMAGE_DIE, MED_ACID_STICK_DAMAGE_DICE_NUM);
	
	// Reflex save
	nDamage = GetReflexAdjustedDamage(nDamage, oTarget, MED_ACID_REFLEX_SAVE_DC, SAVING_THROW_TYPE_ACID);
		
	if (nDamage > 0) {
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
		effect eHit = EffectVisualEffect(VFX_IMP_ACID_L);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	}
}

// Do medium acid bomb effects
void DoMediumAcidBomb()
{		                  
    location lTarget = GetSpellTargetLocation();
	effect eVis      = EffectVisualEffect(VFX_HIT_AOE_ACID);
	effect eHit      = EffectVisualEffect(VFX_IMP_ACID_L);
	int nDamage;
	effect eDam;
	float fDelay;
	float fAcidSticks;
	int i;
	int nRounds;
	
	// Explosion visual
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, MED_ACID_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);    
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			
            //Roll damage for each target
            nDamage = RollDice(MED_ACID_DIE, MED_ACID_DICE_NUM);
			
			//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, MED_ACID_REFLEX_SAVE_DC, SAVING_THROW_TYPE_ACID);
			
			//Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
			
            if(nDamage > 0)
            {
	            // Apply effects to the currently selected target.
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				
				// Damage effect
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				
				// Hit visual
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));				
             }  
			 
			 // Chance for acid to stick
			 fAcidSticks = IntToFloat(Random(100) + 1);
			 if (fAcidSticks <= MED_ACID_STICK_CHANCE * 100) {
			 	// Random rounds to stick
				nRounds = RollDice(MED_ACID_STICK_DURATION_DIE, MED_ACID_STICK_DURATION_DICE_NUM);
			 			 				 								
				// Damage each round
				for (i = 1; i <= nRounds; i++) {
					DelayCommand(RoundsToSeconds(i), DoStickyAcidEffect(oTarget));
				}
			}
			
			// Blindness chance
			if (IntToFloat(Random(100) + 1) <= MED_ACID_BLIND_CHANCE * 100) {
				if (!GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS, OBJECT_SELF))
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNewBlindness(), oTarget, RoundsToSeconds(MED_ACID_BLIND_DURATION));
			}		 
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, MED_ACID_RADIUS, lTarget, TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}

// Do strong shrapnel bomb effects
void DoStrongShrapnelBomb()
{		                  
    location lTarget = GetSpellTargetLocation();
	effect eVis      = EffectNWN2SpecialEffectFile("fx_air_elemental_death");
	effect eVis2     = EffectNWN2SpecialEffectFile("fx_wooden_explosion_big");
	effect eVis3     = EffectVisualEffect(VFX_HIT_AOE_FIRE);
	effect eHit      = EffectNWN2SpecialEffectFile("fx_spike_trap");
	int nDamage1;
	int nDamage2;
	int nDamage3;	
	effect eDam1;
	effect eDam2;
	effect eDam3;
	effect eLinkDamage;
	float fDelay;
	int i;
	int nSave;
	
	// Explosion visual
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis3, lTarget);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, STRONG_SHRAPNEL_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);    
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			
            //Roll damage for each target
            nDamage1 = RollDice(STRONG_SHRAPNEL_SLASH_DIE, STRONG_SHRAPNEL_SLASH_DICE_NUM);
			nDamage2 = RollDice(STRONG_SHRAPNEL_BLUDGE_DIE, STRONG_SHRAPNEL_BLUDGE_DICE_NUM);
			nDamage3 = RollDice(STRONG_SHRAPNEL_PIERCE_DIE, STRONG_SHRAPNEL_PIERCE_DICE_NUM);					
			
			// Reflex save for half/no damage
			nSave = ReflexSave(oTarget, STRONG_SHRAPNEL_REFLEX_SAVE_DC);
			switch (nSave) {
				case SAVING_THROW_CHECK_SUCCEEDED:
					// Half damage
					nDamage1 /= 2;
					nDamage2 /= 2;
					nDamage3 /= 2;
					break;
					
				case SAVING_THROW_CHECK_IMMUNE:
					// No damage (evasion and such)
					nDamage1 = 0;
					nDamage2 = 0;
					nDamage3 = 0;
					break;
					
				default:
					break;
			}
			
			//Set the damage effect
            eDam1 = EffectDamage(nDamage1, DAMAGE_TYPE_SLASHING);
			eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_BLUDGEONING);
			eDam3 = EffectDamage(nDamage3, DAMAGE_TYPE_PIERCING);
			eLinkDamage = EffectLinkEffects(eDam1, eDam2);
			eLinkDamage = EffectLinkEffects(eLinkDamage, eDam3);
			
            if(nDamage1 + nDamage2 + nDamage3 > 0)
            {
	            // Apply effects to the currently selected target.
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				
				// Damage effect
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkDamage, oTarget));
				
				// Hit visual
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));				
             }  			 
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, STRONG_SHRAPNEL_RADIUS, lTarget, TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}

// Smoke grenade
void DoSmokeBomb()
{
	float fDuration = RoundsToSeconds(SMOKE_GRENADE_DURATION);
	location lTarget = GetSpellTargetLocation();
	effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}

// Choking bomb
void DoChokingBomb()
{
	float fDuration = RoundsToSeconds(CHOKING_BOMB_BASE_DURATION);
	fDuration += RoundsToSeconds(RollDice(CHOKING_BOMB_EXT_DUR_DIE,CHOKING_BOMB_EXT_DUR_DICE_NUM));
	location lTarget = GetSpellTargetLocation();
	effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
	effect eAOE = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT, "gl_grenades_choke_ent", "", "");
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}

// Sleep bomb
void DoSleepBomb()
{
	float fDuration = RoundsToSeconds(SLEEP_BOMB_BASE_DURATION);
	fDuration += RoundsToSeconds(RollDice(SLEEP_BOMB_EXT_DUR_DIE, SLEEP_BOMB_EXT_DUR_DICE_NUM));
	location lTarget = GetSpellTargetLocation();
	effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
	effect eAOE = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT, "gl_grenades_sleep_ent", "", "");
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}

// Bag of caltrops - handle damage/slow effect
void DoCaltropsEffects(object oTarget)
{
	effect eSlow = EffectMovementSpeedDecrease(CALTROPS_SLOW_DECREASE);
    effect eMind = EffectVisualEffect(	VFX_DUR_SPELL_SLOW );    
    effect eLink = EffectLinkEffects(eMind, eSlow);    

    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
		SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId()));			
		
		// Apply slow effect if not already applied
		if (!GetHasSpellEffect(1236, oTarget))
			DelayCommand(GetRandomDelay(0.2, 0.8), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(CALTROPS_SLOW_DURATION)));
		
		// How many caltrops did we step on?
		int nCaltrops = Random(CALTROPS_MAX + 1) + CALTROPS_MIN;
		
		// Reflex save to evade some caltrops
		int nSave = ReflexSave(oTarget, CALTROPS_SAVE_DC, SAVING_THROW_TYPE_NONE, GetAreaOfEffectCreator());
		switch (nSave) {
			// Evasion and such
			case SAVING_THROW_CHECK_IMMUNE:
				nCaltrops -= 2;
				break;
				
			case SAVING_THROW_CHECK_SUCCEEDED:
				nCaltrops -= 1;
				break;
				
			default:
				break;
		}
		
		if (nCaltrops <= 0) return;
		
		// Damage effect
		int i;
		int nDamage;
		effect eDam;
		for (i = 0; i < nCaltrops; i++) {
			nDamage = RollDice(CALTROPS_DAMAGE_DIE, CALTROPS_DAMAGE_DICE_NUM);			
			eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
		
			if (nDamage > 0) DelayCommand(GetRandomDelay(0.5, 1.0), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		}
	}
}

// Bag of caltrops - create AoE
void DoCaltropsBomb()
{
	float fDuration = RoundsToSeconds(CALTROPS_BASE_DURATION);
	fDuration += RoundsToSeconds(RollDice(CALTROPS_EXT_DUR_DIE, CALTROPS_EXT_DUR_DICE_NUM));
	location lTarget = GetSpellTargetLocation();
	effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
	effect eAOE = EffectAreaOfEffect(AOE_PER_SPIKE_GROWTH, "gl_grenades_caltrops_ent", "gl_grenades_caltrops_hb", "");
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}
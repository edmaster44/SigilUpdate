/*
-------------------------------------------------------------------------------
SpellFactory
-------------------------------------------------------------------------------
This attempts to consolidate frequently used spell logic in one place.
There is a lot of common behavior among damage inflicting spells and this 
attempts to capture it in a generalized way.
 
General usage:
    Create a CombatSpellData object with GetCombatSpellData and then customize
    the properties of it for your needs.

Notes:
    Most of the features are agnostic about how they are called, with these exceptions:
    SpellResistance checks still works off of the internal spell data
    TouchAttacks still assume that the caster is OBJECT_SELF

#include "ps_spellfactory_includes"

void main()
{
    struct CombatSpellData spell = GetCombatSpellData(OBJECT_SELF);
    spell.DiceType = 6; // D6
    spell.DiceNumber = Limit(GetCasterLevel(OBJECT_SELF), 1, 10); // 1d6 per level, up to 10
    spell.DamageType = DAMAGE_TYPE_FIRE;
    spell.TargetType = SPELL_TARGET_TYPE_SHAPE;
    spell.Shape = SHAPE_SPHERE;
    spell.Radius = RADIUS_SIZE_HUGE;
    spell.SavingThrow = SAVING_THROW_REFLEX;
    spell.SavingThrowType = SAVING_THROW_TYPE_FIRE;
    spell.ImpactEffect = EffectVisualEffect(VFX_IMP_FLAME_M);
    spell.LineOfSight = TRUE;
    spell.DistanceDelay = TRUE;
    HandleSpell(spell);
}
*/
#include "ps_spellfactory_other"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"
#include "psi_spellhook"



void HandleSpell(struct CombatSpellData spell);
void HandleSpellImpact(struct CombatSpellData spell, struct CombatSpellData impactSpell);

const int SPELL_TARGET_TYPE_SINGLE = 0;
const int SPELL_TARGET_TYPE_SHAPE = 1;
const int SPELL_TARGET_TYPE_MISSILE = 2;

// Missiles all go to a single target
const int MISSILE_BEHAVIOR_SINGLE_TARGET = 0;
// Missiles are evenly distributed among targets in the aoe
const int MISSILE_BEHAVIOR_SPREAD = 1;
// Missiles are fired at a single target until it is killed or MissilesPerTarget is reached, 
// then a new target target in shape/range is selected
const int MISSILE_BEHAVIOR_SPILLOVER = 2;

const float SPELL_SNEAK_ATTACK_RANGE = 10.668f; // 35ft

struct CombatSpellData
{
    // A flag to determine if this struct has been configured and is ready
    // if this is FALSE then the struct will be considered to null
    // Currently only used to see if an ImpactEffect is valid or empty
    int Ready;
    //-------------------------------------------------------------------------
    // Standard Spell Properties
    //-------------------------------------------------------------------------
    object Caster;
    int SpellID;
    int DC;
    int Metamagic;
    object TargetObject;
    location TargetLocation;

    // The caster level of the spell. Not used internally.
    int CasterLevel;
    // SPELL_SCHOOL_* constants
    // unused atm
    int SpellSchool;
    // A comma separated list of tags for this spell
    // like "FIRE,EVIL"
    // unused atm
    string Tags;

    //-------------------------------------------------------------------------
    // Generic behaviors / properties
    //-------------------------------------------------------------------------
    // Should the X2PreSpellCastCode be called?
    int PreSpellCastHook;
    // used by Psionic casting
    int PsiPrePowerCastHook;
    // Should this create a SpellNode creature?
    // ImpactEffects & Beams will be fired at this creature and it will be destroyed in 2 seconds
    int CreateSpellNode;
    
    // Weird bespoke behaviors
    // Should this heal certain racial types (for negative damage vs undead)
    int HealRacialType;
    effect HealVisEffect;

    //-------------------------------------------------------------------------
    // Target / Shape properties
    //-------------------------------------------------------------------------
    // Target Type, 0 = single target, 1 = shape
    int TargetType;
    // Shape type to use if TargetType is SPELL_TARGET_TYPE_SHAPE
    int Shape;
    float Radius;
    // What rules should we use for determining if something is a target for this spell?
    // SPELL_TARGET_STANDARDHOSTILE, etc
    int TargetFilter;
    // For aoe/cone type spells, filters object types
    // OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE
    int ObjectTypeFilter;
    // should we introduce a distance based delay for the effects?
    int DistanceDelay;
    // should we process the targets nearest to furthest? Very inefficient, but some effects such as lightning bolt need this
    int DistanceSort;
    // should LoS checks be performed on the target?
    int LineOfSight;
    // Any delay between targets/projectiles?
    float DelayBetweenTargets;


    //-------------------------------------------------------------------------
    // Damage properties
    //-------------------------------------------------------------------------
    // How many dice to roll
    int DiceNumber;
    // What type of die to roll
    int DiceType;
    // Is there a flat amount of damage that should be added per die? the +1 part in 1d4+1
    int AdditionalDamagePerDice;
    // Is there a flat amount of damage that should be added to the spell?
    int AdditionalDamage;
    // What damage type does this spell deal?
    // We could treat DamageType as bitfields and work out what damage types to deal...
    // That's a bit complicated for our needs though, we'll probably never need more than 2.
    int DamageType;
    // If DamageType2 is specified then the spell will do half of its damage as the first type, half as the second
    int DamageType2;
    // if DamageType3 is specified then the spell will do 1/3 of its damage as the first/second/third
    int DamageType3;
    
    // Missile related properties
    // How many missiles/attacks to make?
    int MissileNumber;
    // Is there a maximum number of missiles per target?
    int MissilesPerTarget;
    int MissileBehavior;
    
    //-------------------------------------------------------------------------
    // Primary effect save/checks
    //-------------------------------------------------------------------------
    // Should SpellResistance checks be made?
    int SpellResistance;
    // Should something happen if the spell is resisted?
    int SpellResistedHalfDamage;
    effect SpellResistedEffect;
    float SpellResistedEffectDuration;

    // Should a Touch Attack be made?
    int TouchAttackMelee;
    int TouchAttackRanged;
    int SneakAttack;

    // What type of saving throw should be rolled? 0 specifies none (default)
    int SavingThrow;
    int SavingThrowType;
    // What type of ability score tests should be made? -1 specifies none (default)
    int AbilityScoreCheck;
    // DC of the ability score check. The dc is the caster's score in that ability.
    // -1 indicates an opposed check vs the caster's stat
    int AbilityScoreDC;

    // Additional Primary Effect (skipped if the saving throw is made)
    effect AdditionalEffect;
    float AdditionalEffectDuration;
    
    //-------------------------------------------------------------------------
    // Secondary effect save/checks
    //-------------------------------------------------------------------------
    // SecondaryEffects are not dependant on the saves of the Primary effect
    // These are applied if the target fails the save / ability check
    // SecondaryEffects must have a save or ability check.
    effect SecondaryEffect;
    float SecondaryEffectDuration;
    // What type of saving throw should be rolled? 0 specifies none (default)
    // It uses the spell's regular DC
    int SecondarySavingThrow;
    int SecondarySavingThrowType;
    // What type of ability score tests should be made? -1 specifies none (default)
    int SecondaryAbilityScoreCheck;
    // DC of the ability score check. The dc is the caster's score in that ability.
    // -1 indicates an opposed check vs the caster's stat
    int SecondaryAbilityScoreDC;

    //-------------------------------------------------------------------------
    // Visual Effects
    //-------------------------------------------------------------------------
    // Effects that are played on the caster
    effect CasterEffect;
    effect CasterEffect2;
    effect CasterEffect3;
    float CasterEffectDuration;

    // Vis that is played at the target location (not on the object!)
    effect TargetLocationEffect;
    float TargetLocationEffectDuration;
    
    // Vis that is played on each target. These are played even if the target fails their saves or takes no damage.
    // If you want effects that are only played if the target fails their saving throw use AdditonalEffect
    effect ImpactEffect;
    effect ImpactEffect2;
    effect ImpactEffect3;
    float ImpactEffectDuration;
    // Additional impact effects that can play on hit
    // Delay between additional effects
    float ImpactEffectDelay;

    //-------------------------------------------------------------------------
    // Missile/Projectile related things
    //-------------------------------------------------------------------------
    // Should this call SpawnSpellProjectile for each missile or target?
    int SpellProjectile; // TRUE/FALSE
    int SpellProjectileSpellId; // The spell to use for the projectile. ProjSEF from spells.2da
    int SpellProjectilePathType;
    // Should the missile bounce from target to target?
    // Its a little complicated and I'm not sure if the logic for this is correct
    int SpellProjectileBounce;
    // Set by the handler - the object that the next missile should appear to come 'from' instead of the caster
    object SpellProjectileBounceSource;
    // Should we use GetProjectileTravelTime for the projectile effects?
    // Todo: Is this ever FALSE when SpellProjectile is TRUE? if not, we can remove it
    int SpellProjectileTravelTime;

    //-------------------------------------------------------------------------
    // Beam related things
    //-------------------------------------------------------------------------
    int Beam;
    // The beam visual type to be used when creating EffectBeam
    // We don't pass the effect itself to this like the other properties
    // because we may need to recreate the beam (if BeamChain is True)
    int BeamVis;
    // How long should the beam effect be visible for?
    float BeamDuration;
    // What Node does the beam originate from on the caster?
    int BeamOriginBodyPart;
    // Should this beam chain from one target to the next?
    // If this is FALSE then all beams will originate from the caster
    // If this is TRUE then the beam will chain from one target to the next
    // (use DistanceSort=TRUE to make it chain from closest to furthest)
    int BeamChain;
    // What node does the beam originate from on the chain targets?
    int BeamChainBodyPart;
};

// Populates a CombatSpellData struct with values from GetSpell* functions
// and some sensible defaults
struct CombatSpellData GetCombatSpellData(object oCaster)
{
    struct CombatSpellData spell;
    spell.Ready = TRUE;
    spell.Caster = oCaster;
    spell.CasterLevel = PS_GetCasterLevel(oCaster);
    spell.SpellID = GetSpellId();
    // disabled until we need it. not sure what the perfromance impact of 2da lookups is.
    // spell.SpellSchool = GetSpellSchoolFromID(spell.SpellID);
    spell.DC = GetSpellSaveDC();
    spell.Metamagic = GetMetaMagicFeat();
    spell.TargetObject = GetSpellTargetObject();
    spell.TargetLocation = GetSpellTargetLocation();
    spell.TargetFilter = SPELL_TARGET_STANDARDHOSTILE;
    spell.ObjectTypeFilter = OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE;
    spell.SpellResistance = TRUE;
    spell.PreSpellCastHook = TRUE;
    spell.PsiPrePowerCastHook = TRUE;
    spell.SavingThrow = SAVING_THROW_NONE;
    spell.AbilityScoreCheck = -1;
    spell.SecondarySavingThrow = 0;
    spell.SecondaryAbilityScoreCheck = -1;
    spell.BeamOriginBodyPart = BODY_NODE_HAND;
    spell.BeamDuration = 1.7f;
    spell.HealRacialType = -1;
    spell.MissileNumber = 1;
    spell.SpellProjectileSpellId = spell.SpellID;
    spell.SpellProjectilePathType = PROJECTILE_PATH_TYPE_DEFAULT;
    spell.DistanceDelay = FALSE;
    spell.LineOfSight = TRUE;

    return spell;
}

// This is inefficient, we shouldn't call it unless we need to (lightning bolt)
// Find the count for the nearest object after oPreviousObject that is in the SpellShape
// Then we can grab that object using GetNearestObject()
int GetNextObjectCountInShapeByDistance(struct CombatSpellData spell, int nCnt, int nExcludeCaster=TRUE)
{
    object oTarget = GetNearestObject(spell.ObjectTypeFilter, spell.Caster, nCnt);
    object oTarget2;
    vector vOrigin;
    if(spell.Shape == SHAPE_SPELLCYLINDER || spell.Shape == SHAPE_CONE)
        vOrigin = GetPosition(spell.Caster);

    // nCnt now points to Previous Object. Let's find the next object by distance
    nCnt++;
    oTarget = GetNearestObject(spell.ObjectTypeFilter, spell.Caster, nCnt);
    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= spell.Radius)
    {
        // See if this object is in the SpellShape
        oTarget2 = GetFirstObjectInShape(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
        while(GetIsObjectValid(oTarget2))
        {
            if(nExcludeCaster && oTarget2 != spell.Caster)
            {
                if(oTarget2 == oTarget)
                {
                    return nCnt;
                }
            }
            oTarget2 = GetNextObjectInShape(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
        }
        nCnt++;
        oTarget = GetNearestObject(spell.ObjectTypeFilter, spell.Caster, nCnt);
    }
    // nothing in range & shape
    return 0;
}

//-----------------------------------------------------------------------------
// CombatSpellData Processing Functions
//-----------------------------------------------------------------------------
void ProcessSpellImpactVis(struct CombatSpellData spell, object oTarget, float fDelay)
{
    // Apply Impact effects
    if(!GetIsEffectNull(spell.ImpactEffect))
        ApplyTempOrInstantEffect(oTarget, spell.ImpactEffect, fDelay, spell.ImpactEffectDuration);
    if(!GetIsEffectNull(spell.ImpactEffect2))
        ApplyTempOrInstantEffect(oTarget, spell.ImpactEffect2, fDelay + spell.ImpactEffectDelay, spell.ImpactEffectDuration);
    if(!GetIsEffectNull(spell.ImpactEffect3))
        ApplyTempOrInstantEffect(oTarget, spell.ImpactEffect3, fDelay + (spell.ImpactEffectDelay * 2), spell.ImpactEffectDuration);
}

// Handle common vis elements (CasterVis, TargetVis) & SpellNodes
// returns the SpellNode object if one was created, OBJECT_INVALD otherwise
object ProcessSpellCommonVis(struct CombatSpellData spell, float fDelay=0.0f)
{
    object oSpellNode = OBJECT_INVALID;

    // Caster Effects
    if(!GetIsEffectNull(spell.CasterEffect))
        ApplyTempOrInstantEffect(spell.Caster, spell.CasterEffect, 0.0f, spell.CasterEffectDuration);
    if(!GetIsEffectNull(spell.CasterEffect2))
        ApplyTempOrInstantEffect(spell.Caster, spell.CasterEffect2, 0.0f, spell.CasterEffectDuration);
    if(!GetIsEffectNull(spell.CasterEffect3))
        ApplyTempOrInstantEffect(spell.Caster, spell.CasterEffect3, 0.0f, spell.CasterEffectDuration);
    
    // Target Effects
    if(!GetIsEffectNull(spell.TargetLocationEffect))
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, spell.TargetLocationEffect, spell.TargetLocation);

    // Lightning bolt needs this to draw some vfx when targeting locations...
    // Will need to genericize this when we get to other spells that use SpellNodes
    if(spell.CreateSpellNode)
    {
        oSpellNode = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode", spell.TargetLocation);
        SetScriptHidden(oSpellNode, TRUE);
        ProcessSpellImpactVis(spell, oSpellNode, 0.0f);
        if(spell.Beam)
	        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(spell.BeamVis, spell.Caster, spell.BeamOriginBodyPart), oSpellNode, spell.BeamDuration);
        DestroyObject(oSpellNode, 2.0);
    }
    return oSpellNode;
}

//-----------------------------------------------------------------------------
// Processes the spell for a single target
// oTarget is used so that this can be called from HandleSpellArea/Missile
// Returns nDamage (how much was rolled or applied)
// In the case where DamageType2  & 3 are provided then the return value will 
// be the total damage before it is split up among the damage types
//-----------------------------------------------------------------------------
int ProcessSpellTarget(struct CombatSpellData spell, struct CombatSpellData impactSpell, object oTarget, float fDelay=0.0f, int nDoBeams=TRUE)
{
    int nResistSpell;
    int nDamage;
    effect eDamage;
    effect eBeam;
    int nHit = TRUE;
    int nCrit = FALSE;
    int nHalf = FALSE;
    int nHostile = TRUE;
    int nHeal = FALSE;
    if(!GetIsObjectValid(oTarget))
        oTarget = spell.TargetObject;
    float fDist = GetDistanceBetweenLocations(spell.TargetLocation, GetLocation(oTarget));

    object oProjSource = spell.Caster;
    if(GetIsObjectValid(spell.SpellProjectileBounceSource))
        oProjSource = spell.SpellProjectileBounceSource;

    if(spell.HealRacialType > -1 && GetRacialType(oTarget) == spell.HealRacialType)
    {
        // not a hostile spell for this type
        nHostile = FALSE;
        nHeal = TRUE;
    }

    if(nDoBeams)
    {
        if(spell.Beam)
            eBeam = EffectBeam(spell.BeamVis, spell.Caster, spell.BeamOriginBodyPart);
    }

    if(spell.DistanceDelay)
        fDelay += fDist / 20;

    float fTravelTime = 0.0f;
    if(spell.SpellProjectileTravelTime)
        fTravelTime += GetProjectileTravelTime(GetLocation(oProjSource), GetLocation(oTarget), spell.SpellProjectilePathType);

    // Keep fTravelTime as a separate var, we'll need to subtract it from fDelay later (for drawing projectiles)
    fDelay += fTravelTime;

    // Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(spell.Caster, spell.SpellID));

    if(spell.TouchAttackMelee || spell.TouchAttackRanged)
    {
        int nTouch = 0;
        if(spell.TouchAttackMelee)
        {
            nTouch = TouchAttackMelee(oTarget, TRUE);
        }
        else if(spell.TouchAttackRanged)
        {
            nTouch = TouchAttackRanged(oTarget, TRUE);
        }
        if(nTouch == TOUCH_ATTACK_RESULT_MISS)
            nHit = FALSE;
        if(nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
                nCrit = TRUE;
    }

    if(nHit)
    {
        nResistSpell = FALSE;
        if(spell.SpellResistance)
            nResistSpell = MyResistSpell(spell.Caster, oTarget, fDelay);
        
        if(nResistSpell && !GetIsEffectNull(spell.SpellResistedEffect))
        {
            // Apply resisted effect 
            ApplyTempOrInstantEffect(oTarget, spell.SpellResistedEffect, fDelay, spell.SpellResistedEffectDuration);
            ProcessSpellImpactVis(spell, oTarget, fDelay);
        }

        if(nResistSpell && spell.SpellResistedHalfDamage)
        {
            nResistSpell = FALSE;
            nHalf = TRUE;
        }

        if(nResistSpell == FALSE)
        {
            nDamage = RollDamage(spell.DiceNumber, spell.DiceType, spell.AdditionalDamagePerDice, spell.AdditionalDamage, spell.Metamagic);
            int nSavingThrowRequired = FALSE;
            int nSaved = TRUE;

            if(nCrit)
                nDamage = nDamage * 2;
            if(nHalf)
                nDamage = nDamage / 2;

            // Sneak attack damage isn't critted, so we handle it after that multiplier
            if(spell.SneakAttack && fDist <= SPELL_SNEAK_ATTACK_RANGE)
                nDamage += PS_AddSneakDmgToSpell(spell.Caster,oTarget,nDamage);

            if(nHostile)
            {
                // Handle saving throws / ability score tests
                // If the target succeeds on these then the damage will be reduced by 1/2
                if(spell.SavingThrow == SAVING_THROW_REFLEX)
                {
                    nSavingThrowRequired = TRUE;
                    // Reflex saves are slightly more complicated since they use a helper function 
                    // that modifies the damage instead of returning a success/fail
                    if(nDamage > 0)
                    {
                        int nNewDmg = GetReflexAdjustedDamage(nDamage, oTarget, spell.DC, spell.SavingThrowType);
                        if(nNewDmg < nDamage)
                        {
                            nDamage = nNewDmg;
                            nSaved = FALSE;
                        }
                    }
                    else
                    {
                        if(ReflexSave(oTarget, spell.DC, spell.SavingThrowType, spell.Caster) == SAVING_THROW_CHECK_FAILED)
                        {
                            nSaved = FALSE;
                        }
                    }
                }
                else if(spell.SavingThrow == SAVING_THROW_FORT)
                {
                    nSavingThrowRequired = TRUE;
                    if(FortitudeSave(oTarget, spell.DC, spell.SavingThrowType, spell.Caster) == SAVING_THROW_CHECK_FAILED)
                    {
                        nDamage = nDamage / 2;
                        nSaved = FALSE;
                    }
                }
                else if(spell.SavingThrow == SAVING_THROW_WILL)
                {
                    nSavingThrowRequired = TRUE;
                    if(WillSave(oTarget, spell.DC, spell.SavingThrowType, spell.Caster) == SAVING_THROW_CHECK_FAILED)
                    {    
                        nDamage = nDamage / 2;
                        nSaved = FALSE;
                    }
                }
                // Do we have any ability score checks to make?
                // I'm not aware of any spells that allow you to make an ability score check for half damage
                // but it's here for completeness's sake
                if(spell.AbilityScoreCheck != -1)
                {
                    nSavingThrowRequired = TRUE;
                    if(AbilityScoreCheck(spell.Caster, oTarget, spell.AbilityScoreCheck, spell.AbilityScoreDC) == 0)
                    {
                        nDamage = nDamage / 2;
                        nSaved = FALSE;
                    }
                }

                // Do we need to split the damage among 2 types?
                if(spell.DamageType2 == 0) // 1 damage type
                {
                    eDamage = GetDamageEffect(spell.Caster, spell.DamageType, nDamage);
                }
                else if(spell.DamageType3 == 0) // 2 damage types
                {
                    int nDamage1 = nDamage / 2;
                    int nDamage2 = nDamage - nDamage1;
                    eDamage = GetDamageEffect(spell.Caster, spell.DamageType, nDamage1);
                    effect eDamage2 = GetDamageEffect(spell.Caster, spell.DamageType2, nDamage2);
                    eDamage = EffectLinkEffects(eDamage, eDamage2);
                }
                else // 3 damage types
                {
                    int nDamage1 = nDamage / 3;
                    int nDamage2 = nDamage1;
                    int nDamage3 = nDamage - (nDamage1 + nDamage2);
                    eDamage = GetDamageEffect(spell.Caster, spell.DamageType, nDamage1);
                    effect eDamage2 = GetDamageEffect(spell.Caster, spell.DamageType2, nDamage2);
                    effect eDamage3 = GetDamageEffect(spell.Caster, spell.DamageType3, nDamage2);
                    eDamage = EffectLinkEffects(eDamage, eDamage2);
                    eDamage = EffectLinkEffects(eDamage, eDamage3);
                }

                // Apply Damage
                if(nDamage > 0)
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget)); 
                }

                // Additional Effects (if saving throw was failed or no saving throw was required)
                if(nSavingThrowRequired == FALSE || nSaved == FALSE)
                {
                    if(!GetIsEffectNull(spell.AdditionalEffect))
                    {
                        ApplyTempOrInstantEffect(oTarget, spell.AdditionalEffect, fDelay, spell.AdditionalEffectDuration);
                    }
                }

                // Apply Impact effects
                ProcessSpellImpactVis(spell, oTarget, fDelay);

                // If we have an ImpactSpell we'll fire that off
                if(impactSpell.Ready)
                {
                    impactSpell.TargetObject = oTarget;
                    impactSpell.TargetLocation = GetLocation(oTarget);
                    impactSpell.PreSpellCastHook = FALSE;
					impactSpell.PsiPrePowerCastHook = FALSE;
                    DelayCommand(fDelay, HandleSpell(impactSpell));
                }

                // Spells can have secondary effects
                // These can usually be blocked by a Saving Throw or ability score check
                if(!GetIsEffectNull(spell.SecondaryEffect))
                {
                    int nSecondaryEffectSaved = TRUE;
                    if(spell.SecondarySavingThrow == SAVING_THROW_REFLEX)
                    {
                        if(ReflexSave(oTarget, spell.DC, spell.SecondarySavingThrowType, spell.Caster) == SAVING_THROW_CHECK_FAILED)
                            nSecondaryEffectSaved = FALSE;
                    }
                    else if(spell.SecondarySavingThrow == SAVING_THROW_FORT)
                    {
                        if(FortitudeSave(oTarget, spell.DC, spell.SecondarySavingThrowType, spell.Caster) == SAVING_THROW_CHECK_FAILED)
                            nSecondaryEffectSaved = FALSE;
                    }
                    else if(spell.SecondarySavingThrow == SAVING_THROW_WILL)
                    {
                        if(WillSave(oTarget, spell.DC, spell.SecondarySavingThrowType, spell.Caster) == SAVING_THROW_CHECK_FAILED)
                            nSecondaryEffectSaved = FALSE;
                    }
                    // Do we have any ability score checks to make?
                    if(spell.SecondaryAbilityScoreCheck != -1)
                    {
                        if(AbilityScoreCheck(spell.Caster, oTarget, spell.SecondaryAbilityScoreCheck, spell.SecondaryAbilityScoreDC) == 0)
                            nSecondaryEffectSaved = FALSE;
                    }
                    if(!nSecondaryEffectSaved)
                    {
                        ApplyTempOrInstantEffect(oTarget, spell.SecondaryEffect, fDelay, spell.SecondaryEffectDuration);
                    }
                }
            }

            if(nHeal)
            {
                // used for things like Negative Energy Ray that heals the target instead of damaging them
                nDamage = RollDamage(spell.DiceNumber, spell.DiceType, spell.AdditionalDamagePerDice, spell.AdditionalDamage, spell.Metamagic);
                if(nCrit)
                    nDamage = nDamage * 2;
                if(nHalf)
                    nDamage = nDamage / 2;
                effect eHeal = EffectHeal(nDamage);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, spell.HealVisEffect, oTarget));
            }

            /*if(spell.InfiniteSpell)
                DoInfiniteSpell(spell.Caster, oTarget);*/
        }
    }
    // Draw the beams & projectiles even if the target resists/misses
    // Todo: hit/miss if touch attacks were required?
    if(spell.SpellProjectile)
    {
        // Draw a spell projectile
        DelayCommand(fDelay - fTravelTime, SpawnSpellProjectile(oProjSource, oTarget, GetLocation(oProjSource), GetLocation(oTarget), spell.SpellProjectileSpellId, spell.SpellProjectilePathType));
    }
    if(nDoBeams)
    {
        if(spell.Beam)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, spell.BeamDuration);
            if(spell.BeamChain)
                eBeam = EffectBeam(spell.BeamVis, oTarget, spell.BeamChainBodyPart);
        }
    }
    return nDamage;
}

// Handle a single target spell
void ProcessSpellSingle(struct CombatSpellData spell, struct CombatSpellData impactSpell)
{
    ProcessSpellCommonVis(spell);
    ProcessSpellTarget(spell, impactSpell, spell.TargetObject);
}

// Handles AOE spells (Spheres, Cones, Cylinders)
// Currently doesn't support MissileNumber/MissilesPerTarget or SpellProjectile vfx
void ProcessSpellArea(struct CombatSpellData spell, struct CombatSpellData impactSpell)
{
    object oTarget;
    vector vOrigin;
    float fDelay;
    if(spell.Shape == SHAPE_SPELLCYLINDER || spell.Shape == SHAPE_CONE)
        vOrigin = GetPosition(spell.Caster);
    effect eBeam;

    // Beam drawing is done here instead of in ProcessSpellTarget so that chaining can work
    if(spell.Beam)
        eBeam = EffectBeam(spell.BeamVis, spell.Caster, spell.BeamOriginBodyPart);

    ProcessSpellCommonVis(spell);

    int nCount = 0;
    if(spell.DistanceSort)
    {
        nCount = GetNextObjectCountInShapeByDistance(spell, 0);
        oTarget = (nCount > 0) ? GetNearestObject(spell.ObjectTypeFilter, spell.Caster, nCount) : OBJECT_INVALID;
    }
    else
        oTarget = GetFirstObjectInShape(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, spell.TargetFilter, spell.Caster))
    	{
            fDelay += spell.DelayBetweenTargets;
            ProcessSpellTarget(spell, impactSpell, oTarget, fDelay, FALSE);
            // Beam drawing is done here instead of in ProcessSpellTarget so that chaining can work
            if(spell.Beam)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, spell.BeamDuration));
                if(spell.BeamChain)
                    eBeam = EffectBeam(spell.BeamVis, oTarget, spell.BeamChainBodyPart);
            }

        }
        if(spell.DistanceSort)
        {
            nCount = GetNextObjectCountInShapeByDistance(spell, nCount);
            oTarget = (nCount > 0) ? GetNearestObject(spell.ObjectTypeFilter, spell.Caster, nCount) : OBJECT_INVALID;
        }
        else
            oTarget = GetNextObjectInShape(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
    }
}

// Used when spell mantles should absorb the missiles
// We still want to draw all the missiles and beams
void ProcessFakeMissiles(struct CombatSpellData spell, struct CombatSpellData impactSpell, object oTarget, int nMissilesForThisTarget)
{
    int i;
    effect eBeam;
    if(spell.Beam)
        eBeam = EffectBeam(spell.BeamVis, spell.Caster, spell.BeamOriginBodyPart, TRUE);

    // Fire a bunch of proxy projectiles at the target
    for(i=0; i < nMissilesForThisTarget; i++)
    {
        float fDelay = (spell.DelayBetweenTargets * IntToFloat(i));
        ProcessSpellImpactVis(spell, oTarget, fDelay);
        if(spell.SpellProjectile)
            DelayCommand(fDelay, SpawnSpellProjectile(spell.Caster, oTarget, GetLocation(spell.Caster), GetLocation(oTarget), spell.SpellProjectileSpellId, spell.SpellProjectilePathType));
        if(spell.Beam)
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, spell.BeamDuration));
    }
}

// Missiles all go to a single target
// Returns the number of missiles remaining
int ProcessSpellMissileSingle(struct CombatSpellData spell, struct CombatSpellData impactSpell)
{
    ProcessSpellCommonVis(spell);

    int i;
    int nTotalMissilesRemaining = spell.MissileNumber;
    object oTarget = spell.TargetObject;
    location lTarget = GetLocation(oTarget);
    
    int nMissilesForThisTarget = Limit(spell.MissilesPerTarget, 0, nTotalMissilesRemaining);

    // If the target has a mantle we only want to call ResistSpell once
    // and draw a bunch of fake missiles/beams/vfx
    // Otherwise magic missiles and such would strip mantles very fast, as each
    // call to MyResistSpell would reduce the spell mantle's spells remaining
    // note that this has the side effect that a mantle that can absorb a single spell level will block a lvl 9 missile spell
    if(TargetHasMantle(spell.TargetObject))
    {
        // Target has a mantle
        float fTravelTime = 0.0f;
        if(spell.SpellProjectileTravelTime)
            fTravelTime = GetProjectileTravelTime(GetLocation(spell.Caster), lTarget, spell.SpellProjectilePathType);
        MyResistSpell(spell.Caster, oTarget, fTravelTime);
        // Fire a bunch of proxy projectiles at the target
        ProcessFakeMissiles(spell, impactSpell, oTarget, nMissilesForThisTarget);
        nTotalMissilesRemaining -= nMissilesForThisTarget;
    }
    else
    {
        // Target has no mantle
        for(i=0; i < nMissilesForThisTarget; i++)
        {
            float fDelay = (spell.DelayBetweenTargets * IntToFloat(i));
            ProcessSpellTarget(spell, impactSpell, oTarget, fDelay);
        }
        nTotalMissilesRemaining -= nMissilesForThisTarget;
    }
    
    // Nothing to do with the extra missiles...
    return nTotalMissilesRemaining;
}

// Missiles are distributed among targets in the shape
// Note: this doesn't support Distance sorting yet
void ProcessSpellMissileSpread(struct CombatSpellData spell, struct CombatSpellData impactSpell)
{
    ProcessSpellCommonVis(spell);

    vector vOrigin;
    if(spell.Shape == SHAPE_SPELLCYLINDER || spell.Shape == SHAPE_CONE)
        vOrigin = GetPosition(spell.Caster);

    int nTargetCount = GetSpellTargetCountInArea(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.Caster, spell.ObjectTypeFilter, spell.TargetFilter);
    // If we have more targets than missiles we'll cap the target count 
    // at the number of missiles
    if(nTargetCount > spell.MissileNumber)
        nTargetCount = spell.MissileNumber;

    // Todo: Should we do anything if target count is 0?
    // We might want to fire projectile vfx at a SpellNode?
    if(nTargetCount == 0)
        return;

    // figure out how many missiles we will be firing at target
    // capped by the spell.MissilesPerTarget property
    int nMissilesPerTarget = Limit(spell.MissileNumber / nTargetCount, 0, spell.MissilesPerTarget);
    // how many 'leftover' missiles do we have?
    int nLeftoverMissiles = spell.MissileNumber - (nTargetCount * nMissilesPerTarget);
    int nTotalMissilesRemaining = spell.MissileNumber;

    // We'll start with the primary target
    object oTarget = spell.TargetObject;
    int nFirst = TRUE;
    // We may be targetting an area instead of a creature
    if(!GetIsObjectValid(oTarget))
    {
        oTarget = GetFirstObjectInShape(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
        nFirst = FALSE;
    }

    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, spell.TargetFilter, spell.Caster))
    	{
            int i;
            int nMissilesForThisTarget = nMissilesPerTarget;
            if(nMissilesForThisTarget < spell.MissilesPerTarget && nLeftoverMissiles > 0)
            {
                // Steal a missile from LeftoverMissiles
                nMissilesForThisTarget++;
                nLeftoverMissiles--;
            }

            // If the target has a mantle we only want to call ResistSpell once
            // and draw a bunch of fake missiles/beams/vfx
            // Otherwise magic missiles and such would strip mantles very fast, as each
            // call to MyResistSpell would reduce the spell mantle's spells remaining
            // note that this has the side effect that a mantle that can absorb a single spell level will block a lvl 9 missile spell
            if(TargetHasMantle(oTarget))
            {
                // Target has a mantle
                float fTravelTime = 0.0f;
                if(spell.SpellProjectileTravelTime)
                    fTravelTime = GetProjectileTravelTime(GetLocation(spell.Caster), GetLocation(oTarget), spell.SpellProjectilePathType);
                MyResistSpell(spell.Caster, oTarget, fTravelTime);
                // Fire a bunch of proxy projectiles at the target
                ProcessFakeMissiles(spell, impactSpell, oTarget, nMissilesForThisTarget);
                nTotalMissilesRemaining -= nMissilesForThisTarget;
            }
            else
            {
                // Target has no mantle
                for(i=0; i < nMissilesForThisTarget && nTotalMissilesRemaining > 0; i++)
                {
                    float fDelay = (spell.DelayBetweenTargets * IntToFloat(i));
                    ProcessSpellTarget(spell, impactSpell, oTarget, fDelay);
                    nTotalMissilesRemaining--;
                }
            }
            spell.SpellProjectileBounceSource = oTarget;
        }

        if(nFirst)
        {
            oTarget = GetFirstObjectInShape(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
            nFirst = FALSE;
        }
        else
            oTarget = GetNextObjectInShape(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
        // skip the primary target if we encounter it again...
        if(GetIsObjectValid(spell.TargetObject) && oTarget == spell.TargetObject)
            oTarget = GetNextObjectInShape(spell.Shape, spell.Radius, spell.TargetLocation, spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
    }
}

// Missiles are fired at a single target until it is killed or MissilesPerTarget is reached, 
// then a new target target in shape/range is selected
// It attempts to use the target's resistances/immunities to determine if the target should be dead or not
void ProcessSpellMissileSpillover(struct CombatSpellData spell, struct CombatSpellData impactSpell)
{
    ProcessSpellCommonVis(spell);
    float fDelay;
    object oTarget = spell.TargetObject;
    vector vOrigin;
    if(spell.Shape == SHAPE_SPELLCYLINDER || spell.Shape == SHAPE_CONE)
        vOrigin = GetPosition(spell.Caster);
    int nFirst = TRUE;
    int nTotalMissilesRemaining = spell.MissileNumber;

    while(nTotalMissilesRemaining > 0 && GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, spell.TargetFilter, spell.Caster))
    	{
            int nTargetResist = GetDamageResistance(oTarget, spell.DamageType);
            int nTargetImmunity = GetDamageImmunity(oTarget, spell.DamageType);
            int nTargetHP = GetCurrentHitPoints(oTarget);
            int nTotalDamageDealt = 0;

            // If the target has a mantle we only want to call ResistSpell once
            // and draw a bunch of fake missiles/beams/vfx
            // Otherwise magic missiles and such would strip mantles very fast, as each
            // call to MyResistSpell would reduce the spell mantle's spells remaining
            // note that this has the side effect that a mantle that can absorb a single spell level will block a lvl 9 missile spell
            if(TargetHasMantle(oTarget))
            {
                // Target has a mantle
                float fTravelTime = 0.0f;
                if(spell.SpellProjectileTravelTime)
                    fTravelTime = GetProjectileTravelTime(GetLocation(spell.Caster), GetLocation(oTarget), spell.SpellProjectilePathType);
                MyResistSpell(spell.Caster, oTarget, fTravelTime);
                // Fire a single proxy projectile at the target
                // then we'll select a new target.
                ProcessFakeMissiles(spell, impactSpell, oTarget, 1);
                fDelay += spell.DelayBetweenTargets;
                nTotalMissilesRemaining -= 1;
            }
            else
            {
                // Target has no mantle
                int i;
                for(i=0; i < spell.MissilesPerTarget && nTotalMissilesRemaining > 0; i++)
                {
                    fDelay += spell.DelayBetweenTargets;
                    int nDmg = ProcessSpellTarget(spell, impactSpell, oTarget, fDelay);
                    int nRealDmg = FloatToInt((nDmg - nTargetResist) * (1.0f - (IntToFloat(nTargetImmunity) / 100.0f)));
                    nTotalDamageDealt += nRealDmg;
                    if(nTotalDamageDealt > nTargetHP)
                    {
                        // We *probably* did enough damage to kill the target, time to switch targets
                        i = spell.MissilesPerTarget;
                    }
                    nTotalMissilesRemaining--;
                }
            }
            spell.SpellProjectileBounceSource = oTarget;
        }

        // Grab the next target (we may not use it however)
        // The area is centered on the caster as they should be able to aim the missiles at any target in range of the spell
        if(nFirst)
        {
            oTarget = GetFirstObjectInShape(spell.Shape, spell.Radius, GetLocation(spell.Caster), spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
            nFirst = FALSE;
        }
        else
            oTarget = GetNextObjectInShape(spell.Shape, spell.Radius, GetLocation(spell.Caster), spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
        // skip the primary target if we encounter it again...
        if(GetIsObjectValid(spell.TargetObject) && oTarget == spell.TargetObject)
            oTarget = GetNextObjectInShape(spell.Shape, spell.Radius, GetLocation(spell.Caster), spell.LineOfSight, spell.ObjectTypeFilter, vOrigin);
    }
}       

//-----------------------------------------------------------------------------
// General purpose spell handler
// Dispatches the spell to the apporpriate processor function
// We can do some spell processing here too, such as updating AdditionalDamagePerDice
// based on the damage type and feats
//-----------------------------------------------------------------------------
void HandleSpell(struct CombatSpellData spell)
{
    struct CombatSpellData impactSpell;
    impactSpell.Ready = FALSE;
    HandleSpellImpact(spell, impactSpell);
}

// A version of HandleSpell that also processes impactSpell on each impact
void HandleSpellImpact(struct CombatSpellData spell, struct CombatSpellData impactSpell)
{
    if(spell.PreSpellCastHook)
    {
        if (!X2PreSpellCastCode())
        {
            // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }
    }

if(spell.PsiPrePowerCastHook)
{
    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
}
    // Add in any bonuses from reserve feats and other sources
    /*spell = AddReserveFeatBonuses(spell);
    if(impactSpell.Ready)
        impactSpell = AddReserveFeatBonuses(impactSpell);*/

    switch(spell.TargetType)
    {
        case SPELL_TARGET_TYPE_SINGLE:
            ProcessSpellSingle(spell, impactSpell);
            break;
        case SPELL_TARGET_TYPE_SHAPE:
            ProcessSpellArea(spell, impactSpell);
            break;
        case SPELL_TARGET_TYPE_MISSILE:
            switch(spell.MissileBehavior)
            {
                case MISSILE_BEHAVIOR_SINGLE_TARGET:
                    ProcessSpellMissileSingle(spell, impactSpell);
                    break;
                case MISSILE_BEHAVIOR_SPREAD:
                    ProcessSpellMissileSpread(spell, impactSpell);
                    break;
                case MISSILE_BEHAVIOR_SPILLOVER:
                    ProcessSpellMissileSpillover(spell, impactSpell);
                    break;
            }
            break;
    }
}


//-----------------------------------------------------------------------------
// Spell Heartbeats
//-----------------------------------------------------------------------------

// General purpose heartbeat for things like Combust and Melfs Acid Arrow
// This only works on TargetObject - another version will need to be made for locations
// nSavingThrow is checked on rounds after the first round for the target to resist the effects
// On the first round this will perform touch attacks and spell resistance and remove them from the spell struct
// If the touch attacks miss or the target makes the SR check then the spell won't be processed
void SpellHeartbeat(struct CombatSpellData spell, int nRoundsRemaining, int nSavingThrow=FALSE, int nSavingThrowType=SAVING_THROW_TYPE_NONE, int nSavingThrowDC=0, int nFirstRound=TRUE, int nSavingThrowsOnFirstRound=FALSE)
{
    int nContinue = TRUE;
    if(nRoundsRemaining <= 0 || GetIsDead(spell.TargetObject))
    {
        return;
    }

    if(nFirstRound)
    {
        // things that happen on the first round that determine if the effect 'sticks'
        // If the spell has a touch attack we make it (and remove it from the spell)

        if(spell.PreSpellCastHook)
        {
            if (!X2PreSpellCastCode())
            {
                // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
                return;
            }
        }

        if(spell.TouchAttackMelee || spell.TouchAttackRanged)
        {
            int nTouch = 0;
            if(spell.TouchAttackMelee)
                nTouch = TouchAttackMelee(spell.TargetObject, TRUE);
            else if(spell.TouchAttackRanged)
                nTouch = TouchAttackRanged(spell.TargetObject, TRUE);

            if(nTouch == TOUCH_ATTACK_RESULT_MISS)
                nContinue = FALSE;

            spell.TouchAttackMelee = FALSE;
            spell.TouchAttackRanged = FALSE;
        }

        // if the target has SR we make the SR check on the first round
        if(spell.SpellResistance)
        {
            int nResistSpell = MyResistSpell(spell.Caster, spell.TargetObject);
            if(nResistSpell)
            {
                if(!GetIsEffectNull(spell.SpellResistedEffect))
                {
                    // Apply resisted effect 
                    ApplyTempOrInstantEffect(spell.TargetObject, spell.SpellResistedEffect, 0.0f, spell.SpellResistedEffectDuration);
                }                    
                nContinue = FALSE;
                ProcessSpellImpactVis(spell, spell.TargetObject, 0.0f);
            }
            spell.SpellResistance = FALSE;
        }
    }
    
    if(nSavingThrowsOnFirstRound || !nFirstRound)
    {
        // do we have a saving throw to continue heartbeating?
        if(nSavingThrow > 0)
        {
            if(nSavingThrow == SAVING_THROW_REFLEX)
            {
                if(ReflexSave(spell.TargetObject, nSavingThrowDC, nSavingThrowType, spell.Caster) != SAVING_THROW_CHECK_FAILED)
                    nContinue = FALSE;
            }
            else if(nSavingThrow == SAVING_THROW_FORT)
            {
                if(FortitudeSave(spell.TargetObject, nSavingThrowDC, nSavingThrowType, spell.Caster) != SAVING_THROW_CHECK_FAILED)
                    nContinue = FALSE;
            }
            else if(nSavingThrow == SAVING_THROW_WILL)
            {
                if(WillSave(spell.TargetObject, nSavingThrowDC, nSavingThrowType, spell.Caster) != SAVING_THROW_CHECK_FAILED)
                    nContinue = FALSE;
            }
        }
    }

    if(nContinue)
    {
        HandleSpell(spell);
        nRoundsRemaining--;
        DelayCommand(6.0f, SpellHeartbeat(spell, nRoundsRemaining, nSavingThrow, nSavingThrowType, nSavingThrowDC, FALSE));
    }
}

// A heartbeat for "sphere" type spells - Flaming Sphere
// Every round we either damage our current target or move to a new target
// if there are no targets left we'll "move" to the caster and continue searching
void SphereHeartbeat(struct CombatSpellData spell, int nRoundsRemaining, string sSphereName, int nFirstRound=TRUE)
{
    if(nFirstRound)
    {
        // things that happen only on the first round of the spell
        if(spell.PreSpellCastHook)
        {
            if (!X2PreSpellCastCode())
            {
                // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
                return;
            }
        }
    }


	int nNewTarget = FALSE;
	if(GetIsDead(spell.Caster) || nRoundsRemaining <= 0)
	{
		SendMessageToPC(spell.Caster, "Your " + sSphereName + " fades away.");
		return;
	}
	else if(GetIsObjectValid(spell.TargetObject) && spell.TargetObject != spell.Caster && !GetIsDead(spell.TargetObject))
	{
		// Continue to damage our current target
		// TODO: We should probably perform an area/distance check here...
		// Or maybe seek a new target from the player every round?
		// Lets have a 25% chance of having it seek a new target/return to caster
		if(d4() == 1)
		{
			nNewTarget = TRUE;
		}
		else
		{
			spell.TargetLocation = GetLocation(spell.TargetObject);
			HandleSpell(spell);
		}
	}
	else
	{
		// We should seek a new target
		nNewTarget = TRUE;
	}

	if(nNewTarget)
	{
		// The sphere wants to "move"
		object oNewTarget;
		// OldTarget is where the projectile vfx should be drawn 'from'
		// We'll try to use our last target but fall back to the caster if that's no longer valid
		object oOldTarget = spell.TargetObject;
		location lOldLocation = spell.TargetLocation;

		if(!GetIsObjectValid(oOldTarget))
		{
			oOldTarget = spell.Caster;
			//lOldLocation = GetLocation(spell.Caster);
		}

		// See if there are any targets in range of the caster
		// Use the caster's current location, not the spell's TargetLocation
		location lCaster = GetLocation(spell.Caster);
		object oTarget = GetFirstObjectInShape(spell.Shape, spell.Radius, lCaster, spell.LineOfSight, spell.ObjectTypeFilter);
        while(GetIsObjectValid(oTarget) && !GetIsObjectValid(oNewTarget))
        {
			if (spellsIsTarget(oTarget, spell.TargetFilter, spell.Caster))
			{
				oNewTarget = oTarget;
			}
			oTarget = GetNextObjectInShape(spell.Shape, spell.Radius, lCaster, spell.LineOfSight, spell.ObjectTypeFilter);
		}

		if(GetIsObjectValid(oNewTarget))
		{
			// we have a new target
			// fire the projectile & do damage
			if(oOldTarget == oNewTarget)
			{
				// We switched targets but picked the same target
				// don't draw the projectile moving
				spell.TargetLocation = GetLocation(spell.TargetObject);
				HandleSpell(spell);
			}
			else
			{
				spell.TargetObject = oNewTarget;
				spell.TargetLocation = GetLocation(oNewTarget);
				float fTravelTime = 0.0f;
				if(spell.SpellProjectileTravelTime)
					fTravelTime = GetProjectileTravelTime(lOldLocation, spell.TargetLocation, spell.SpellProjectilePathType);
				SpawnSpellProjectile(oOldTarget, spell.TargetObject, lOldLocation, spell.TargetLocation, spell.SpellProjectileSpellId, spell.SpellProjectilePathType);
				DelayCommand(fTravelTime, HandleSpell(spell));
			}
		}
		else
		{
			// No new targets. The sphere will try to return to the caster if it is not already there
			if(spell.TargetObject != spell.Caster)
			{
				spell.TargetObject = spell.Caster;
				spell.TargetLocation = GetLocation(spell.Caster);
				SpawnSpellProjectile(oOldTarget, spell.TargetObject, lOldLocation, GetLocation(spell.TargetObject), spell.SpellProjectileSpellId, spell.SpellProjectilePathType);
			}
		}
	}
	nRoundsRemaining -= 1;
	DelayCommand(6.0f, SphereHeartbeat(spell, nRoundsRemaining, sSphereName, FALSE));
}
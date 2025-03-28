//::///////////////////////////////////////////////
//:: Extract Water Elemental
//:: [nx_s0_extractwaterelemental.nss]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
/*
	Extract Water Elemental
	Transmutation [Water]
	Level: Druid 6, sorceror/wizard 6
	Components: V, S
	Range: Close 
	Target: One living creature
	Saving Throw: Fortitude half
	Spell Resistance: Yes
	 
	This brutal spell causes the targeted creature to
	dehydrate horriby as the moisture in its body is
	forcibly extracted through its eyes, nostile, mouth,
	and pores.  This deals 1d6 points of damage per
	caster level (maximum 20d6), or half damage on a
	successful Fortitude save.  If the targeted creature
	is slain by this spell, the extracted moisture is
	transformed into a water elemental of a size equal
	to the slain creature (up to Huge).  The water
	elemental is under your control, as though you had
	summoned it, and disappears after 1 minute.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008: Made only non-living immune to it (Construct, Undead)

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_functions"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
	object oCaster = OBJECT_SELF;
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
	int PML = GetPureMageLevels(OBJECT_SELF);

	// Things that are not alive are immune to this spell.	
	//if (GetIsImmune(oTarget,IMMUNITY_TYPE_DEATH))
	if(GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
	{
		FloatingTextStrRefOnCreature(184683, oCaster, FALSE);	// "Target is immune to that effect."
		return;
	}
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {		
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
 
		//Make SR check
		if(PS_GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") == 3)
		{
			SendMessageToPC(OBJECT_SELF, "You find that it is impossible to cast water-based spells on this plane!");
			SetModuleOverrideSpellScriptFinished();
			return;
		}
       	else if (!MyResistSpell(OBJECT_SELF, oTarget))
       	{	
			int nNumRolls = nCasterLvl;

			int nDamage = d6(nNumRolls) + d6(PML/3);
			if (nCasterLvl < 20 && !GetIsObjectValid(GetSpellCastItem()) && GetIsPC(OBJECT_SELF)){
			nDamage = d6(20) + d6(PML/3);
			} 
			float fSummonTime = RoundsToSeconds(10);
						
			//Enter Metamagic conditions
   			int nMetaMagic = GetMetaMagicFeat();
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDamage = nDamage + ((3*nDamage)/4);
            }
            if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                 nDamage = nDamage + (nDamage/2);
            }
			if (nMetaMagic == METAMAGIC_EXTEND)
			{
				fSummonTime *= 2;
			}
			
           	if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
			{	// Fort save for 1/2 damage.
				nDamage = nDamage / 2;
			}
			
			// Inflict damage.
            effect eDamage = EffectDamage(nDamage);
 			//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);	// replace with dehydration effect
            //effect eLink = EffectLinkEffects(eDamage, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);		// deal some damage
			
			// If target was killed, summon an appropriately-sized water elemental
			if (GetIsDead(oTarget))
			{
				int nCreatureSize = GetCreatureSize(oTarget);
				effect eSummon;
			
				if (nCreatureSize >= CREATURE_SIZE_HUGE)
				{	// Huge is as big as the elemental gets
					eSummon = EffectSummonCreature("c_elmwaterhuge");
				}
				else if (nCreatureSize == CREATURE_SIZE_LARGE)
				{
					eSummon = EffectSummonCreature("c_elmwaterlarge");
				}
				else if (nCreatureSize == CREATURE_SIZE_MEDIUM)
				{
					eSummon = EffectSummonCreature("c_elmwater");
				}
				else if (nCreatureSize <= CREATURE_SIZE_SMALL)
				{	// Small is as small as the elemental gets
					eSummon = EffectSummonCreature("c_elmwatersmall");
				}

				ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetLocation(oTarget), fSummonTime);
			}
		}
	}
}
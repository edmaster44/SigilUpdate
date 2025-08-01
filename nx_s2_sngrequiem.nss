//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Song/Hymn of Requiem
//:: nx_s2_sngrequiem
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/23/2007
//:: Copyright (c) 2007 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    Song of Requiem:
    This song damages all enemies within 20 feet for 5 rounds.
    The total sonic damage caused is equal to 2*Perform skill; the minimum damage
    caused per target is Perform/3. For example, with Perform 30, a total of
    60 points of damage is inflicted each round. If six (or more) enemies are
    affected, they would each take 10 sonic damage per round. This ability has a
    cooldown of 20 rounds.
    
    Hymn of Requiem:
    The character's Song of Requiem now also heals all party members. The amount
    healed is the same as the damage caused by the Hymn and is divided among all
    party members; the minimum amount healed per ally is Perform/3. For example,
    if the total damage dealt is 60 and four characters are in the party, each is
    healed 15 hit points per round.
*/
// ChazM 5/31/07 renamed DoHealing() to DoPartyHealing() (DoHealing() is declared in nw_i0_spells)
// AFW-OEI 07/20/2007: NX1 VFX.
// Ariella - Fixed invisibility exploit and allowed songs to continue with requiem.
// FlattedFifth, July 8, 2025: Returned to OC functionality except for invisibility exploit fix

#include "x0_i0_spells"
#include "nwn2_inc_spells"

void DoDamage(object oCaster, int nSpellId)
{
    //SpeakString("nx_s2_SngRequiem: Entering Do Damage");

	location locCaster	= GetLocation(oCaster);
    int nNumEnemies   = 0;
   
    /* Fix current exploit with stealth and invisibility */
    effect eBad = GetFirstEffect(oCaster);
    while (GetIsEffectValid(eBad))
    {
    	int iType = GetEffectType(eBad);
        if (iType == EFFECT_TYPE_SANCTUARY 
		|| iType == EFFECT_TYPE_INVISIBILITY
		|| iType == EFFECT_TYPE_ETHEREAL)
        {
        	RemoveEffect(oCaster, eBad);
        }
        eBad = GetNextEffect(oCaster);
		nNumEnemies++; // this use of nNumEnemies is just to prevent stack overflow
		if(nNumEnemies>75)  
			break;
    }
    SetActionMode(oCaster, ACTION_MODE_STEALTH, FALSE);
    nNumEnemies=0;
	
   
    // Count up enemy targets so we can divide up damage evenly.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
    while(GetIsObjectValid(oTarget))
    {
        if ( GetIsObjectValidSongTarget( oTarget ) &&  GetIsEnemy( oTarget ) )
        {
            nNumEnemies += 1;
        }
		if (nNumEnemies > 75) break;

    	oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
    }
    //SpeakString("nx_s2_SngRequiem: DoDamage: nNumEnemies = " + IntToString(nNumEnemies));
    
    if (nNumEnemies <= 0)
    {
        return;
    }
    
    int nPerformSkill = GetSkillRank(SKILL_PERFORM, oCaster);
	 // Damage per target is (2*Perform)/Number of Enemies, min (Perform / 3)
	int nMinDamage = nPerformSkill / 3;
    int nDamage = (nPerformSkill * 2) / nNumEnemies;  
	if (nDamage < nMinDamage) nDamage = nMinDamage;
    
    // Inflict Sonic damage.  No save.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
    while(GetIsObjectValid(oTarget))
    {
        //SpeakString("nx_s2_SngRequiem: DoDamage: iterating through damage while loop");
        if ( GetIsObjectValidSongTarget( oTarget ) &&  GetIsEnemy( oTarget ) )
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
            
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
            effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
            float fDelay = 0.15 * GetDistanceToObject( oTarget );

            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget ) );
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget ) ); 
        }

    	oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
    }
    //SpeakString("nx_s2_SngRequiem: DoDamage: exiting function"); 
}

void DoPartyHealing(object oCaster, int nSpellId)
{
    //SpeakString("nx_s2_SngRequiem: Entering DoHealing");

    // Count up party members so we can divide up healing evenly.
    int nNumPartyMembers = 0;
    int bPCOnly    = FALSE;
    object oLeader = GetFactionLeader( oCaster );
    object oTarget = GetFirstFactionMember( oLeader, bPCOnly );
    while ( GetIsObjectValid( oTarget ) )
    {
		if ( GetIsObjectValidSongTarget(oTarget) )
		{
            nNumPartyMembers += 1;
        }
		
		if (nNumPartyMembers > 75) break;
        
        oTarget = GetNextFactionMember( oLeader, bPCOnly );
    }
    
    if (nNumPartyMembers <= 0)
    {
        return;
    }
    
    int nPerformSkill = GetSkillRank(SKILL_PERFORM, oCaster);
	int nMinHeal = nPerformSkill / 3;
    int nHeal = (nPerformSkill * 2) / nNumPartyMembers;
	if (nHeal < nMinHeal) nHeal = nMinHeal;
    
    // Apply healing to party members
    oTarget = GetFirstFactionMember( oLeader, bPCOnly );
    while ( GetIsObjectValid( oTarget ) )
    {
        if ( GetIsObjectValidSongTarget(oTarget) )
        {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
        
        effect eHeal = EffectHeal(nHeal);
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
        float fDelay = 0.15 * GetDistanceToObject( oTarget );

        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oTarget ) );
        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget ) ); 
        }
        
        oTarget = GetNextFactionMember( oLeader, bPCOnly );
    }
}  
  
            
void RunSongEffects(int nCallCount, object oCaster, int nSpellId)
{
    //SpeakString("nx_s2_SngRequiem: Entering RunSongEffects");
//SendMessageToPC(oCaster, "[DEBUG] REQUIEM CALL COUNT="+IntToString(nCallCount));

    // See if you are still allowed to sing.
	if ( GetCanBardSing( oCaster ) == FALSE )
	{
		return;	
	}

    // Make sure you have enough perform ranks.
	int	nPerformRanks = GetSkillRank(SKILL_PERFORM, oCaster, TRUE);
	if (nPerformRanks < 24 )
	{
		FloatingTextStrRefOnCreature ( 182800, oCaster );
		return;
	}

    // Verify that we are still singing the same song...
    //int nSingingSpellId = FindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
    //if(nSingingSpellId == nSpellId)
    //{
		effect ePulse = EffectVisualEffect(VFX_HIT_BARD_REQUIEM);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, ePulse, oCaster);

			
		DoDamage(oCaster, nSpellId);
        
        // If you have Hymn of Requiem, heal your party, too
        if (GetHasFeat(FEAT_EPIC_HYMN_OF_REQUIEM, oCaster))
        {
            DoPartyHealing(oCaster, nSpellId);
        }
		
		
            
        // Schedule the next ping
        nCallCount += 1;
        if (nCallCount > ApplySongDurationFeatMods(5, oCaster)) 
        {
			RemoveBardSongSingingEffect(oCaster, GetSpellId());	// AFW-OEI 07/19/2007: Terminate song.
            return;
        }
        else
        {   // Run once per round
            DelayCommand(6.0f, RunSongEffects(nCallCount, oCaster, nSpellId));
        }
    //}
}


void main()
{
	object oCaster = OBJECT_SELF;
    if ( !GetCanBardSing( oCaster ) )
    {
	return;	
    }
    
    if (!GetHasFeat(FEAT_BARD_SONGS, oCaster))
    {
        FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,oCaster); // no more bardsong uses left
        return;
    }

    effect eFNF = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oCaster));

    DelayCommand(0.1f, RunSongEffects(1, oCaster, GetSpellId()));
    
    DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
}
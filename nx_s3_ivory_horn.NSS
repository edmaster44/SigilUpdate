//	nx_s3_ivory_horn
/*
	Summons an ivory shieldmaiden to fight for the party.
*/
//	JSH-OEI 8/15/08

void main()
{
    object oCaster = OBJECT_SELF;
    string sResRef = "nx2_c_shieldmaiden";
    float fDuration = 600.0; // Ten minutes
    
    // 0.5 sec delay between VFX and creature creation
    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_3, 0.5);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
}
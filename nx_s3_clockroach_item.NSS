//	nx_s3_clockroach_item
/*
	Summons a collapsible clockroach to fight for the party.
*/
//	acarlson 7/1/08 (from JSH-OEI 4/11/08)

void main()
{
    object oCaster = OBJECT_SELF;
    string sResRef = "nx2_c_clockroachpet";
    float fDuration = 600.0; // Ten minutes
    
    // 0.5 sec delay between VFX and creature creation
    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_3, 0.5);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
}
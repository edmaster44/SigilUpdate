void main()
{
object oPC = GetEnteringObject();
object oStatue = GetNearestObjectByTag("BeamStatue1");
effect eBeam = EffectBeam(VFX_BEAM_COLD,oStatue,BODY_NODE_HAND,FALSE);
effect eDMG = EffectDamage( d6(5) ,DAMAGE_TYPE_COLD);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oPC,1.0);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eDMG,oPC,0.0);
}
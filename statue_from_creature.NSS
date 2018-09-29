// statue_from_creature
/*
This script should be placed in the 'On Spawn In' script of a creature. When
the creature is spawned into the game, animation is permanently turned off,
a stoneskin visual effect is applied, and a death effect is used to make the
creature non-living. Finally, a collision ball is placed in the location of
the creature to prevent player movement through the object.
*/
// RJH 11sep10
const string COLLISION_BALL_TAG = "plc_collbox";
void main()
{
// Stop the creature animating
effect eFreeze = EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION );
ApplyEffectToObject( DURATION_TYPE_PERMANENT,
SupernaturalEffect( eFreeze ), OBJECT_SELF );

}
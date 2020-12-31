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
const int FREEZE_SPELL_ID = -2999;
void main()
{
	float fDelay = GetLocalFloat(OBJECT_SELF, "ANIMATION_DELAY");
	if (fDelay <= 0.0)
		fDelay = 0.75;
		
	effect eFreeze = SupernaturalEffect(EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION ));
	SetEffectSpellId(eFreeze, FREEZE_SPELL_ID);
	
	DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eFreeze, OBJECT_SELF ));
	DelayCommand(fDelay, SetLocalInt(OBJECT_SELF, "STOP_ANIMATION", 1));

}
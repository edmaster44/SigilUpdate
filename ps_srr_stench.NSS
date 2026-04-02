#include "ff_applyeffect" 
void main()
{
    //Declare and apply the AOE
	float fDur = RoundsToSeconds(GetTotalLevels(OBJECT_SELF, TRUE));
	
    effect eAOE = ExtraordinaryEffect(EffectAreaOfEffect( 72 ));
    PS_ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, fDur );
}
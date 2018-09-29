// bdoor_oopen
/*
	Description: This pretty much heals then closes the door after x amount 
	of time set at default of 120.0 seconds or 2 minutes. This goes on the
	On Open section of a bashable door.
	
*/
// Sean Claypool aka "Publilius_Syrus" 10/08/09

void main()
	{
    object oDoor = OBJECT_SELF;
    ClearAllActions();
	effect eHeal = EffectHeal(GetMaxHitPoints()-GetCurrentHitPoints());
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oDoor);
    ActionWait(120.0);
    ActionCloseDoor(OBJECT_SELF);

    }

const string COLLISION_BALL_TAG = "plc_collbox";

void main()
{
	object oPC = GetEnteringObject();
	// if (!GetIsPC(oPC) && !GetIsDM(oPC))
	//  return;
	  
	int iLock = GetGlobalInt

("player_house_neerephaEnterLock");
	if ( iLock == 0 )
 	{
	  SetGlobalInt("player_house_neerephaEnterLock", 1); 
	  
	  // Only allows one clean up at a time.
	 


 if(GetObjectByTag("NW_STATUE") == OBJECT_INVALID)
	  {
		   object oWP = GetWaypointByTag

("wp_statue");
		   location lSpawnpoint = GetLocation

(oWP);  
		   object oSpawn = CreateObject

		   		   
(OBJECT_TYPE_CREATURE, "NW_STATUE", lSpawnpoint);    
	   
   ActionEquipItem(GetObjectByTag("ps_scythe_blessedofnerull"), 1);

	   // Stop the creature animating
  effect eFreeze = EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION );
  ApplyEffectToObject( DURATION_TYPE_PERMANENT,
  SupernaturalEffect( eFreeze ), oSpawn );

  // Avoid fadeout on death and make it generally inert
  SetIsDestroyable( FALSE, FALSE, FALSE );
  SetBumpState( oSpawn, BUMPSTATE_UNBUMPABLE );
  SetCommandable( FALSE, oSpawn );
  SetOrientOnDialog( oSpawn, FALSE );


  // Create collision ball around the statue
  location loc = GetLocation( oSpawn );
  object oCollBall = CreateObject( OBJECT_TYPE_PLACEABLE, COLLISION_BALL_TAG, loc );

  // Scale the box to fit the statue size
  float fSS = 0.5f;
  SetScale( oCollBall, fSS, fSS, fSS );
  	}

	 
SetGlobalInt("player_house_neerephaEnterLock", 0);
 }
}
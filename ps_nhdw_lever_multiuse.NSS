//Script by Dedic8ed
//This script is designed to be used by the "usable lever" placeable. However, it should be compatible
//with any other usable placeable in the game; however, the animation will not occur unless it is a placeable that
//has both an "activated" and "deactivated" state.

//Place in the object's OnUsed

void main()
{

	object oPC = GetLastUsedBy();
	
	if (!GetIsPC(oPC)) return;
	
//the "open" variable will open a door with this tag 
	string sOpen = GetLocalString(OBJECT_SELF,"open");
//the "open2" variable will open a door with this tag
	string sOpen2 = GetLocalString(OBJECT_SELF, "open2");
//the "close" variable will close a door with this tag
	string sClose = GetLocalString(OBJECT_SELF,"close");
// the "close2" variable will close a door with this tag
	string sClose2 = GetLocalString(OBJECT_SELF, "close2");
//the "sound" variable will play the sound with this name
	string sSound = GetLocalString(OBJECT_SELF,"sound");
//the "soundremote" variable will cause the sound object with this tag to play
	string sSoundRemote = GetLocalString(OBJECT_SELF,"soundremote");
//the "vfx" variable will apply this visual effect to the lever's puller; ; the full filename (xxxx.sef) must be used
	string sVFX = GetLocalString(OBJECT_SELF,"vfx");
//the "vfxremote variable will apply this visual effect to a remote waypoint; ; the full filename (xxxx.sef) must be used
	string sVFXRemote = GetLocalString(OBJECT_SELF,"vfxremote");
//the "destroy" variable will destroy a placeable with this tag; the placeable must NOT be set to static
	string sDestroy = GetLocalString(OBJECT_SELF,"destroy");
//the "waypoint" variable will set the default waypoint for functions
	string sWaypoint = GetLocalString(OBJECT_SELF,"waypoint");
//the "teleport" variable is an integer. 1=teleport is activated, 0=no teleport
	int iTeleport = GetLocalInt(OBJECT_SELF,"teleport");
//the "floaty" variable will be generated as floaty text over the head of the character pulling the lever
	string sFloaty = GetLocalString(OBJECT_SELF,"floaty");
	
//Definition
	object oDoorOpen;
	object oDoorOpen2;
	object oDoorClose;
	object oDoorClose2;
	object oWaypoint;
	object oSoundRemote;
	object oDestroy;
	location lWaypoint;
	oDoorOpen = GetObjectByTag(sOpen);
	oDoorOpen2 = GetObjectByTag(sOpen2);
	oDoorClose = GetObjectByTag(sClose);
	oDoorClose2 = GetObjectByTag(sClose2);
	oWaypoint = GetObjectByTag(sWaypoint);
	oSoundRemote = GetObjectByTag(sSoundRemote);
	oDestroy = GetObjectByTag(sDestroy);
	lWaypoint= GetLocation(oWaypoint);
	
//Lever animation-runs regardless of variables
  if (!GetLocalInt ( OBJECT_SELF, "m_bActivated" )==TRUE)
   {
    SetLocalInt (OBJECT_SELF,"m_bActivated",FALSE);
    ActionPlayAnimation ( ANIMATION_PLACEABLE_ACTIVATE);
	ActionPlayAnimation ( ANIMATION_PLACEABLE_DEACTIVATE);
   }
   else if ( GetLocalInt (OBJECT_SELF,"m_bActivated") ==FALSE)
   {
    SetLocalInt (OBJECT_SELF,"m_bActivated",TRUE);
    ActionPlayAnimation (ANIMATION_PLACEABLE_DEACTIVATE);
   }
//End lever animation	

//Sound play section
	PlaySound(sSound);
	SoundObjectPlay(oSoundRemote);
//Door unlock & open section
	SetLocked(oDoorOpen, FALSE);
	AssignCommand(oDoorOpen, ActionOpenDoor(oDoorOpen));
	SetLocked(oDoorOpen2, FALSE);
	AssignCommand(oDoorOpen2, ActionOpenDoor(oDoorOpen2));
//Door lock & close section	
	AssignCommand(oDoorClose, ActionCloseDoor(oDoorClose));
	SetLocked(oDoorClose, TRUE);
	AssignCommand(oDoorClose2, ActionCloseDoor(oDoorClose2));
	SetLocked(oDoorClose2, TRUE);
//Visual effect section
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sVFX), oPC);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sVFXRemote), oWaypoint);
//Destroy section
	DestroyObject(oDestroy,1.0);
//Floaty Text section
	FloatingTextStringOnCreature(sFloaty,oPC);
//Teleport section
	if (!iTeleport ==1) return;
	{
	if (GetAreaFromLocation(lWaypoint)==OBJECT_INVALID) return;
	
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, ActionJumpToLocation(lWaypoint));
	}

}
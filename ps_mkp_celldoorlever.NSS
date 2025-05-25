
void main()
{
  object oDoor ;
  int nDoorLocked;
  int nDoorOpen; //Is the door opened already?
  string sDoorTag; //testing variable
  oDoor=GetNearestObjectByTag ("CELL_DOOR",OBJECT_SELF,1);
  if ( GetIsObjectValid (oDoor) == TRUE )
  {
    sDoorTag = GetTag(oDoor);
    nDoorLocked = GetLocked(oDoor);
    nDoorOpen = GetIsOpen(oDoor);
//This part simply switches the graphics on the lever from activate to
//deactivate or vice versa.
  if (GetLocalInt(OBJECT_SELF, "m_bActivated" )==TRUE)
   {
    SetLocalInt (OBJECT_SELF,"m_bActivated",FALSE);
    ActionPlayAnimation ( ANIMATION_PLACEABLE_ACTIVATE);
   }
   else if (GetLocalInt (OBJECT_SELF,"m_bActivated") ==FALSE)
   {
    SetLocalInt (OBJECT_SELF,"m_bActivated",TRUE);
    ActionPlayAnimation (ANIMATION_PLACEABLE_DEACTIVATE);
   }
/* this part checks if the door is locked and close if it is it unlocks and opens.
If it is open and unlocked then it closes and locks it.
The door should have the tag LEVER_DOOR and its initial state should be
locked and closed.*/
  if ( nDoorLocked && nDoorOpen==FALSE)
   {
    SetLocked ( oDoor,FALSE );
    ActionOpenDoor ( oDoor );
   }
   else if ( nDoorOpen && nDoorLocked==FALSE)
   {
    ActionCloseDoor (oDoor);
    SetLocked (oDoor,TRUE);
   }
   else if ( nDoorOpen==FALSE && nDoorLocked==FALSE)
   {
    ActionOpenDoor (oDoor);
   }
}
}
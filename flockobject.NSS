///////////////////////////////////////////////////////////////
// flockobject
//
// 
//
//
// Author:  			Rust
// Date Created:    	26FEB2012 for SCOD (Sigil, City of Doors)
// Date Last Modified:	26FEB2012 for SCOD (Sigil, City of Doors)
// Last Modified By:	Rust
///////////////////////////////////////////////////////////////
/*
						
History of Changes

*/




/////////////////////////////////////////////////////////
// Auto-lock object (chests, other containers, etc)
// Only if they are tagged lockable
//
// Should use this only in OnClose events
/////////////////////////////////////////////////////////
void main()
{
	if (GetLockLockable(OBJECT_SELF))
		DelayCommand(180.5f,SetLocked(OBJECT_SELF,TRUE));
}
// End
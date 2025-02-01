#include "ff_safevar"

void main()
{
  
 int iLock = PS_GetGlobalInt("MusicShopLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("MusicShopLock", 1); // Only allows one clean up at a time.
  if(GetObjectByTag("ps_tc_tatya") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_tc_tatya", GetLocation(GetWaypointByTag("wp_tc_tatya")));  
  }
  if(GetObjectByTag("ps_tc_musicplayer") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_tc_musicplayer", GetLocation(GetWaypointByTag("wp_tc_musicplayer")));  
  }
  
  PS_SetGlobalInt("MusicShopLock", 0);
 }
}
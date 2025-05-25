

void main()
{
  
 int iLock = GetGlobalInt("MusicShopLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("MusicShopLock", 1); // Only allows one clean up at a time.
  if(GetObjectByTag("ps_tc_tatya") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_tc_tatya", GetLocation(GetWaypointByTag("wp_tc_tatya")));  
  }
  if(GetObjectByTag("ps_tc_musicplayer") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_tc_musicplayer", GetLocation(GetWaypointByTag("wp_tc_musicplayer")));  
  }
  
  SetGlobalInt("MusicShopLock", 0);
 }
}

void main()
{
 object oPC = GetEnteringObject();
  
 int iLock = GetGlobalInt("Temple_of_Hermes");
 if ( iLock == 0 )
 {
  SetGlobalInt("Temple_of_Hermes", 1); // Only allows one clean up at a time.
  
  if(GetObjectByTag("ps_npc_hermespriest") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hermespriest", GetLocation(GetWaypointByTag("wp_ps_npc_hermespriest1"))); 
	CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hermespriest2", GetLocation(GetWaypointByTag("wp_ps_npc_hermespriest2")));  
  }
  if(GetObjectByTag("ps_npc_hermesguard") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hermesguard", GetLocation(GetWaypointByTag("wp_ps_npc_hermesguard1"))); 
	CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hermesguard", GetLocation(GetWaypointByTag("wp_ps_npc_hermesguard2")));  
  }
  if(GetObjectByTag("ps_npc_hermespriestess") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hermespriestess", GetLocation(GetWaypointByTag("wp_ps_npc_hermespriestess1"))); 
	CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hermespriestess2", GetLocation(GetWaypointByTag("wp_ps_npc_hermespriestess2")));  
	CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_hermespriestess3", GetLocation(GetWaypointByTag("wp_ps_npc_hermespriestess3")));  
  }
  if(GetObjectByTag("ps_npc_madmoll") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_madmoll", GetLocation(GetWaypointByTag("wp_ps_npc_madmoll"))); 
  }
  
  SetGlobalInt("Temple_of_Hermes", 0);
 }
}
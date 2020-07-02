
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("CivicEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("CivicEnterLock", 1); // Only allows one clean up at a time.

  //Item Cloner Guy
  if(GetObjectByTag("festhallnpc_itemcloner") == OBJECT_INVALID) {
	object oWP = GetWaypointByTag("wp_festhallnpc_itemcloner");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_itemcloner", lSpawnpoint);    
  }
  
  //Cionell
  if(GetObjectByTag("festhallnpc_civicmerchant") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_civicmerchant");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_civicmerchant", lSpawnpoint);    
  }
    
  //Spice Rack barkeep - Tasha
  if(GetObjectByTag("festhallnpc_tasha") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_tasha");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_tasha", lSpawnpoint);    
  } 
  
  //Spice Rack barkeep - Mishka
  if(GetObjectByTag("festhallnpc_mishka") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_mishka");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_mishka", lSpawnpoint);    
  } 
  
  //festhallnpc_annaliwebspinner
  if(GetObjectByTag("festhallnpc_annaliwebspinner") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_annaliwebspinner");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_annaliwebspinner", lSpawnpoint);    
  } 
  
  //Dananin
  if(GetObjectByTag("festhallnpc_dananin") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_dananin");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_dananin", lSpawnpoint);    
  } 
  
  //Guards
  if(GetObjectByTag("festhallnpc_harlequinguard") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_harlequinguard_1");
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_harlequinguard", GetLocation(oWP)); 
   	oWP = GetWaypointByTag("wp_festhallnpc_harlequinguard_2");
   	oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_harlequinguard", GetLocation(oWP)); 
   	oWP = GetWaypointByTag("wp_festhallnpc_harlequinguard_3");
   	oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_harlequinguard", GetLocation(oWP)); 
  }
  
  //Public Sensorium
  if(GetObjectByTag("festhallnpc_sheelasadrang") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_sheelasadrang");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_sheelasadrang", lSpawnpoint);    
  } 
  
  //Library
  if(GetObjectByTag("festhallnpc_greggory") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_greggory");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_greggory", lSpawnpoint);    
  } 
  if(GetObjectByTag("festhallnpc_mia") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_mia");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_mia", lSpawnpoint);    
  } 
  
  //Classroom
  if(GetObjectByTag("festhallnpc_lecturer") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_lecturer");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_lecturer", lSpawnpoint);    
  } 
  
  //Opera
  if(GetObjectByTag("festhallnpc_ticketer") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_ticketer");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_ticketer", lSpawnpoint);    
  } 
  
  //Runway
  if(GetObjectByTag("festhallnpc_model_female") == OBJECT_INVALID) {
   	object oWP = GetWaypointByTag("wp_festhallnpc_model_female");
   	location lSpawnpoint = GetLocation(oWP);  
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_model_female", lSpawnpoint);    
  } 
  
  SetGlobalInt("CivicEnterLock", 0);
 }
}
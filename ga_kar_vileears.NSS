#include "nw_i0_plot"

void main () 
{ object oPC = GetPCSpeaker(); 
int nTotalItem = GetNumItems( oPC, "ps_kar_vileear" ); 
 TakeNumItems(oPC, "ps_kar_vileear", nTotalItem);

int gold_reward = 75; 

int nGold = gold_reward*nTotalItem; 
GiveGoldToCreature(oPC, nGold); }
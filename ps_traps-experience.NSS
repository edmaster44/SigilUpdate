// Traps & XP 
//
// Rewards player with XP if trap was disarmed 
// 
// by Incanus - big THX to Benn  
// enjoy or destroy
//
// www.versuchungdermacht.de 
object oPC; //player who disarmed trap 
int nXP; //XP player gets 
int nDC; //DC 
int nlevel; 
void main() 
{ 
//Get PC who disarmed the trap 
oPC = GetLastDisarmed(); 
//Get level of PC 
nlevel = GetHitDice(oPC); 
//Get DC for disarming trap (needed for calculation of XP) 
nDC = GetTrapDisarmDC(OBJECT_SELF); 
//Check, if trap was set by another PC. Otherwise give XP 
if (GetTrapCreator(OBJECT_SELF)==OBJECT_INVALID) 
{ 
nXP = (nDC-(15+nlevel))*2*nlevel; 
GiveXPToCreature(oPC,nXP); 
} 
}
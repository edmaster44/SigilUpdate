


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("outlanddragon1EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("outlanddragon1EnterLock", 1); // Only allows one clean up at a time.

//  DelayCommand(300.0, ExecuteScript("ps_chest_treasure",oPC));
   
  SetGlobalInt("outlanddragon1EnterLock", 0);
 }
}
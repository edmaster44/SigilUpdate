


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("abyss4EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("abyss4EnterLock", 1); // Only allows one clean up at a time.

  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  SetGlobalInt("abyss4EnterLock", 0);
 }
}
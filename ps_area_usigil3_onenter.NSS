
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("usigil3EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("usigil3EnterLock", 1); // Only allows one clean up at a time.

//  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  SetGlobalInt("usigil3EnterLock", 0);
 }
}
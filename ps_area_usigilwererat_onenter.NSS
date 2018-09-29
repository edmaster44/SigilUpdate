
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("usigilwereratEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("usigilwereratEnterLock", 1); // Only allows one clean up at a time.

  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  SetGlobalInt("usigilwereratEnterLock", 0);
 }
}
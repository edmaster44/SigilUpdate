//================================================================================
//===========> by Crom
//=====================> crom29@hotmail.fr
//================================================================================


#include "nwnx_sql"
#include "library_inc"


string MakeBookDescription(string sText, string sAuthor, string sSource);



//--------------------------------------------------------------------------------
void main(string sAction, string sTag, string arg0)
{
	object oPC = OBJECT_SELF;
	
	SQLExecDirect("SET NAMES utf8");

	arg0 = SQLEncodeSpecialChars(arg0);

	if(sAction == "Init")
	{
		//Disable buttons until a book is selected
		SetGUIObjectText(oPC, GUI_SCREEN, "TextBuy", -1, TEXT_BUY);
		SetGUIObjectDisabled(oPC, GUI_SCREEN, "BoutonBuy", TRUE);
		SetGUIObjectDisabled(oPC, GUI_SCREEN, "BoutonRead", TRUE);
	
		//Update Category ListBox
		
		ClearListBox(oPC, GUI_SCREEN, "ListBoxCats");
		//- Add 'All' row
		AddListBoxRow(oPC, GUI_SCREEN, "ListBoxCats", "", "TextRowCat="+TEXT_ALL, "", "", "");
		//- Add the other rows
		SQLExecDirect("SELECT `cat` FROM `library` WHERE (`libtag`='*' OR FIND_IN_SET('"+sTag+"',`libtag`)) GROUP BY `cat` ORDER BY `cat` ASC");
		while(SQLFetch())
		{
			AddListBoxRow(oPC, GUI_SCREEN, "ListBoxCats", "", "TextRowCat="+SQLGetData(1), "", "", "");
		}

		
		//Clear book list
		ClearListBox(oPC, GUI_SCREEN, "ListBoxBooks");
		
		
		
	
	}
	else if(sAction == "UpdateBooks")
	{
		string sCat = arg0;
		
		ClearListBox(oPC, GUI_SCREEN, "ListBoxBooks");
		
		string sWhere;
		if(sCat == TEXT_ALL)
			sWhere = "1";
		else
			sWhere = "`cat`='"+sCat+"'";
			
		
		sWhere += " AND (`libtag`='*' OR FIND_IN_SET('"+sTag+"',`libtag`))";
		
		SQLExecDirect("SELECT `code`,`title`,`icon`,ADDTIME(`date`, '"+STR_NEW_FLAG_DURATION+" 0:0:0')>=NOW() FROM `library` WHERE "+sWhere+" ORDER BY `title` ASC");
		
		while(SQLFetch())
		{
			string sTextures = "IconRowBook="+Get2DAString("nwn2_icons", "ICON", StringToInt(SQLGetData(3)))+".tga";
			if(StringToInt(SQLGetData(4)))
				sTextures+=";IconRowBookNew=b_map.tga";
			
			AddListBoxRow(oPC, GUI_SCREEN, "ListBoxBooks", "", "TextRowBookCode="+SQLGetData(1)+";TextRowBookTitle="+SQLGetData(2), sTextures, "", "");
		}
	}
	else if(sAction == "Buy")
	{
		if(arg0 == "")
		{
			SendMessageToPC(oPC, TEXT_MUST_SELECT_BOOK);
		}
		else
		{
			SQLExecDirect("SELECT `icon`,`title`,`text`,`author`,`source`,`price` FROM `library` WHERE `code`='"+arg0+"'");
			if(SQLFetch())
			{
				int nPrice = StringToInt(SQLGetData(6));
				if(GetGold(oPC)>=nPrice)
				{
				TakeGoldFromCreature(nPrice, oPC, TRUE);
				
				
					SendMessageToPC(oPC, TEXT_YOU_HAVE_BOUGHT+" '"+SQLGetData(2)+"'");
					object oBook = CreateItemOnObject("nw_it_book001", oPC, 1, "lby_bk_"+arg0, FALSE);
					
					SetFirstName(oBook, SQLGetData(2));
					SetLastName(oBook, SQLGetData(2));
					SetItemIcon(oBook, StringToInt(SQLGetData(1)));
					SetDescription(oBook, MakeBookDescription(SQLGetData(3), SQLGetData(4), SQLGetData(5)));
				}
				else
					SendMessageToPC(oPC, TEXT_NOT_ENOUGH_GOLD);
			}
			else
				FloatingTextStringOnCreature("SQL ERROR "+sAction, oPC);
		}
	}
	else if(sAction == "Read")
	{
		if(arg0 == "")
		{
			SendMessageToPC(oPC, TEXT_MUST_SELECT_BOOK);
		}
		else
		{
			SQLExecDirect("SELECT `title`,`text`,`author`,`source` FROM `library` WHERE `code`='"+arg0+"'");
			if(SQLFetch())
			{
				DisplayMessageBox(oPC, 0, MakeBookDescription(SQLGetData(2), SQLGetData(3), SQLGetData(4)), "", "", FALSE, "SCREEN_MESSAGEBOX_DEFAULT", 0, TEXT_CLOSE);
			}
			else
				FloatingTextStringOnCreature("SQL ERROR "+sAction, oPC);
		}
	}
	else if(sAction == "SelectBook")
	{
		SQLExecDirect("SELECT `price` FROM `library` WHERE `code`='"+arg0+"'");
		if(SQLFetch())
		{
			SetGUIObjectText(oPC, GUI_SCREEN, "TextBuy", -1, TEXT_BUY+" ("+SQLGetData(1)+TEXT_GP+")");
			SetGUIObjectDisabled(oPC, GUI_SCREEN, "BoutonBuy", FALSE);
			SetGUIObjectDisabled(oPC, GUI_SCREEN, "BoutonRead", FALSE);
		}
		else
			FloatingTextStringOnCreature("SQL ERROR "+sAction, oPC);
	}
	
	SQLExecDirect("SET NAMES latin1");


}



//--------------------------------------------------------------------------------
string MakeBookDescription(string sText, string sAuthor, string sSource)
{
	string sReturn = "";
	
	if(sAuthor!="")
	{
		sReturn+=TEXT_BOOK_BY+" "+sAuthor+"\n\n";
	}
	sReturn+=sText;
	sReturn+="\n";
	
	if(sAuthor!="")
		sReturn+="\n"+TEXT_BOOK_AUTHOR+": "+sAuthor;
	
	if(sSource!="")
		sReturn+="\n("+TEXT_BOOK_SOURCE+": "+sSource+")";
	
	return sReturn;
}
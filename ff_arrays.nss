/* 
Functions to mimic the functionality of lists using strings. Uses specific, rarely-used characters as 
delimeters. It is VITALLY important NOT to use the designated delimiter characters inside ANY values.
I don't know if strings in nwn2 can support extended ascii or unicode characters, so sticking to the 
regular 128 character ascii set, but as long as we don't use the chosen delimeter characters, we should
be able to do anything with these string-pretending-to-be-lists as we can with real lists.

Example: If we want a list of "bilbo", "frodo", "sam", "merry", "pippin", and "smeagol" then we would do this
string listHobbits = NewListOf("bilbo", "frodo", "sam");
listHobbits = AddToList(listHobbits, "merry", "pippin");
listHobbits = AddToList(listHobbits, "smeagol");

Internally, that would just give us a string of 
"bilbo`frodo`sam`merry`pippin`smeagol"

But (again, if we're not using the backtick character at all in any values) we can perform all normal list
operations with the other functions in this file.

 -FlattedFifth, August 13, 2024
*/

// backtick used to separate values in a list or separate key-value pairs in a map
const string sDelimiter = "`";

// the tilde character used to separate key from value in a map element
const string sMap = "~";

// nwscript has no "null" value for integers or strings, so while we can use an empty string ("")
// for a string "null", an empty string converted to an integer by StringToInt() = 0, which
// might be a valid entry. Instead, we will select a very unlikely number to serve as an integer "null"
// This is different from the NULL already defined in aaa_constants. We may be removing that because I'm not
// sure it's needed. We only created it on the word of TauSoldier, who proved rather unreliable.
const int LIST_NULL = -999999999;

// default boolean value for case sensitivity when checking for duplicate values in collections. 
const int B_CASE = FALSE;

// default boolean value for allowing whitespace in strings.
const int B_ALLOW_WHITESPACE = TRUE;

// control integers for the operation to be performed by IterateList()
const int GET_NUM_INDICES = 0; // causes IterateList() to return the number of indices
const int GET_VALUE_AT_INDEX = 1; // returns the value at a provided index
const int GET_INDEX_OF_VALUE = 2; // returns the index of the first instance of a value
const int REMOVE_VALUE_AT_INDEX = 3; // remove the value at a given index
const int REMOVE_INSTANCE_OF_VALUE = 4; // remove the first instance of a given value
const int INSERT_VALUE_AT_INDEX = 5; // insert a given value at a given index
const int REPLACE_VALUE_AT_INDEX = 6; // replace the value at a given index with the given value
const int COUNT_VALUE = 7; // count the instances of a given value

// function declarations


/* ----------------------------------------------------------------------------------
			LIST FUNCTIONS, THESE DO NOT CHECK FOR DUPLICATES 
------------------------------------------------------------------------------------*/

// join 1 to 3 string values into a delimeter separated string pretending to be a list
// and return that pseudo-list
string NewListOf(string sValue, string sValue1 = "", string sValue2 = "");

// add 0 to 2 items to an existing list and then return it.
string AddToList(string sList, string sValue1 = "", string sValue2 = "");

// insert a value to a list at a specific index, returns updated list (or "" on error)
string AddToListAtIndex(string sList, int nIndex, string sValue);

// accepts a list that may or may not have duplicates and returns a set without duplicates
string ConvertListToSet(string sList, int bCaseSensitive = B_CASE);

// add a value to a list at a specific index, replacing the existing value at that index (or "" on error)
string ReplaceInListAtIndex(string sList, int nIndex, string sValue);


/*-------------------------------------------------------------------------------------
			SET FUNCTIONS, AS ABOVE BUT WITHOUT DUPLICATES
---------------------------------------------------------------------------------------*/

string NewSetOf(string sValue, string sValue1 = "", string sValue2 = "", int bCaseSensitive = B_CASE);

string AddToSet(string sSet, string sValue1 = "", string sValue2 = "", int bCaseSensitive = B_CASE);

string AddToSetAtIndex(string sSet, int nIndex, string sValue, int bCaseSensitive = B_CASE);


/*------------------------------------------------------------------------------------------
			GENERAL FUNCTIONS, THESE WORK THE SAME ON LISTS AND SETS
-----------------------------------------------------------------------------------------*/

// Return number of indices of collection. Returns 0 if collection is empty.
// (but use GetIsEmptyCollection() if you only want to know if it's empty)
int GetNumberIndices(string sCol);

// Returns true if value is in collection, false otherwise. Can only search for one value
// with each function call, so doing something like GetInCollection(listHobbits, "bilbo`frodo")
// will return false
int GetIsInCollection(string sCol, string sValue, int bCaseSensitive = B_CASE);

// Return the index of the 1st instance of value. Returns -1 if the value is not present.
// Use GetInCollection() if you only want to know if it's there. It's more efficient).
int GetIndexOfValue(string sCol, string sValue, int bCaseSensitive = B_CASE);

// Returns true if the collection is empty or has nothing but delimeter and key-value separator.
// The latter case *shouldn't* be possible, but just in case.
int GetIsEmptyCollection(string sCol);

// Get the value at the given index. Returns "" if the index is out of bounds.
string GetValueAtIndex(string sCol, int nIndex);

// Remove the value at the given index from the collectionand return remainder.
string RemoveIndex(string sCol, int nIndex);

// Remove the first instance of the given value from the collection and return remainder.
string RemoveValue(string sCol, string sValue, int bCaseSensitive = B_CASE);

// reverse the order of the elements in a collection
string ReverseCollection(string sCol);

// sort the collection in alphabetical order, with no regard to case, using quicksort algorithm
string SortCollection(string sCol, int bCaseSensitive = B_CASE);


// These are helper functions for above and should not be called directly.
string IterateList(int nTask, string sCol, int nIndex = LIST_NULL, string sValue = "", int bCaseSensitive = B_CASE);
string ListSurgery(string sPrevious, string sInsert, string sRemainder);
string Quicksort(string sCol, int bCaseSensitive = B_CASE, int nIteration = 1);
string TrimForList(string sInput, int bAllowWhitespace = B_ALLOW_WHITESPACE);
string TrimInput(string sString, int bForKeyOrValue = FALSE, int bAllowWhitespace = B_ALLOW_WHITESPACE);
string TrimKeyValue(string sInput, int bAllowWhitespace = B_ALLOW_WHITESPACE);
int CheckIsSorted(string sCol, int nSize = LIST_NULL, int bCaseSensitive = B_CASE);
int GetMedianOfThree(string sFirst, string sMiddle, string sLast, int bCaseSensitive);
int GetNumIndices(string sCol);


/*------------------------------------------------------------------------------------
						Implementations
-------------------------------------------------------------------------------------*/

string NewListOf(string sValue, string sValue1 = "", string sValue2 = ""){
	return AddToList(TrimForList(sValue), sValue1, sValue2);
}

string AddToList(string sList, string sValue1 = "", string sValue2 = ""){
	sValue1 = TrimForList(sValue1);
	sValue2 = TrimForList(sValue2);
	if (sValue1 == "" && sValue2 == "") return sList;
    if (sList == ""){
		if (sValue1 == "") return sValue2;
		else if (sValue2 == "") return sValue1;
		else return sValue1 + sDelimiter + sValue2;
	} else {
		if (sValue1 != "") sList += sDelimiter + sValue1;
		if (sValue2 != "") sList += sDelimiter + sValue2;
	}
	return sList;
}

string AddToListAtIndex(string sList, int nIndex, string sValue){
	return IterateList(INSERT_VALUE_AT_INDEX, sList, nIndex, TrimForList(sValue));
}

string ReplaceInListAtIndex(string sList, int nIndex, string sValue){
	return IterateList(REPLACE_VALUE_AT_INDEX, sList, nIndex, TrimForList(sValue));
}

string ConvertListToSet(string sList, int bCaseSensitive = B_CASE){
	int nIndices = GetNumberIndices(sList);
	if (nIndices <= 1) return sList;

	string sNewList = "";
	string sValue = "";
	nIndices -= 1;
	int i;
	for (i = 0; i <= nIndices; i++){
		sValue = GetValueAtIndex(sList, i);
		if (sNewList == "") sNewList = sValue;
		else if (sValue != ""){
			if (!GetIsInCollection(sNewList, sValue, bCaseSensitive))
				sNewList += sDelimiter + sValue;
		}
	}
	return sNewList;
}

string NewSetOf(string sValue, string sValue1 = "", string sValue2 = "", int bCaseSensitive = B_CASE){
	return AddToSet(TrimForList(sValue), sValue1, sValue2, bCaseSensitive);
}

string AddToSet(string sSet, string sValue1 = "", string sValue2 = "", int bCaseSensitive = B_CASE){
	sValue1 = TrimForList(sValue1);
	sValue2 = TrimForList(sValue2);
	if (sValue1 == "" && sValue2 == "") return sSet;
	if (sSet == ""){
		if (sValue1 == "") return sValue2;
		else if (sValue2 == "") return sValue1;
		else return sValue1 + sDelimiter + sValue2;
	} else {
		if (sValue1 != "" && !GetIsInCollection(sSet, sValue1, bCaseSensitive))
			 sSet += sDelimiter + sValue1;
		if (sValue2 != "" && !GetIsInCollection(sSet, sValue2, bCaseSensitive))
			 sSet += sDelimiter + sValue2;
	}
	return sSet;
}

string AddToSetAtIndex(string sSet, int nIndex, string sValue, int bCaseSensitive = B_CASE){
	sValue = TrimForList(sValue);
	if (!GetIsInCollection(sSet, sValue, bCaseSensitive))
		return AddToListAtIndex(sSet, nIndex, sValue);
	else return sSet;
}

string ReplaceInSetAtIndex(string sSet, int nIndex, string sValue, int bCaseSensitive = B_CASE){
	sValue = TrimForList(sValue);
	if (!GetIsInCollection(sSet, sValue, bCaseSensitive))
		return ReplaceInListAtIndex(sSet, nIndex, sValue);
	else return sSet;
}

int GetNumberIndices(string sCol){
	string sIndices = IterateList(GET_NUM_INDICES, sCol);
	if (sIndices == "") return 0;
	else return StringToInt(sIndices);
}

int GetIsInCollection(string sCol, string sValue, int bCaseSensitive = B_CASE){
	sValue = TrimForList(sValue);
	if (!bCaseSensitive){
		sCol = GetStringLowerCase(sCol);
		sValue = GetStringLowerCase(sValue);
	}
	if (sCol == "" || sValue == "") return FALSE;

	string sEncasedList = sDelimiter + sCol + sDelimiter;
	string sEncasedValue = sDelimiter + sValue + sDelimiter;
	if (FindSubString(sEncasedList, sEncasedValue) == -1) return FALSE;
	else return TRUE;
}

int GetIndexOfValue(string sCol, string sValue, int bCaseSensitive = B_CASE){
	string sIndex = IterateList(GET_INDEX_OF_VALUE, sCol, -1, TrimForList(sValue), bCaseSensitive);
	if (sIndex == "") return -1;
	else return StringToInt(sIndex);
}

int GetIsEmptyCollection(string sCol){
	if (TrimInput(sCol, TRUE) == "") return TRUE;
	else return FALSE;
}

string GetValueAtIndex(string sCol, int nIndex){
	return IterateList(GET_VALUE_AT_INDEX, sCol, nIndex);
}

string RemoveIndex(string sCol, int nIndex){
	return IterateList(REMOVE_VALUE_AT_INDEX, sCol, nIndex);
}

string RemoveValue(string sCol, string sValue, int bCaseSensitive = B_CASE){
	return IterateList(REMOVE_INSTANCE_OF_VALUE, sCol, -1, TrimForList(sValue), bCaseSensitive);
}

string ReverseCollection(string sCol){
	int nIndices = GetNumberIndices(sCol);
	if (nIndices <= 1) return sCol;
	
	string sReversedList = "";
	string sValue = "";
	nIndices -= 1;
	int i;
	for (i = nIndices; i >= 0; i--){
		sValue = GetValueAtIndex(sCol, i);
		if (sReversedList == "") sReversedList = sValue;
		else if (sValue != "") sReversedList += sDelimiter + sValue;
	}
	return sReversedList;
}

string SortCollection(string sCol, int bCaseSensitive = B_CASE){
    return Quicksort(sCol, bCaseSensitive);
}


/*-------------------------------------------------------------------------------
	Helper functions for above. Should be considered private within this file
	and not called outside of it.
--------------------------------------------------------------------------------*/

// the heavy lifter of list manipulation. Can perform any of 8 operations
// defined in the control constants at the top of file.
string IterateList(int nTask, string sCol, int nIndex = LIST_NULL, string sValue = "", int bCaseSensitive = B_CASE){

	int nSize = GetNumIndices(sCol);
	if (nTask == GET_NUM_INDICES) return IntToString(nSize);
	// error catching
	if (sCol == ""){
		if (nTask == COUNT_VALUE) return "0";
		else if (nTask == GET_INDEX_OF_VALUE) return IntToString(LIST_NULL);
		else if ((nTask == REPLACE_VALUE_AT_INDEX || nTask == INSERT_VALUE_AT_INDEX) && nIndex == 0)
			return sValue;
		else return "";
	}
	// all of the cases in which sCol is empty are handled with returns above so we can now assume
	// that it's not empty. Now we have to be careful because not every operation depends upon there
	// being anything set for value or index.
	if (sValue == ""){
		// these two operations don't care if there's a value set.
		if (nTask != GET_VALUE_AT_INDEX && nTask != REMOVE_VALUE_AT_INDEX){
			// these do
			if (nTask == GET_INDEX_OF_VALUE) return IntToString(LIST_NULL);
			else if (nTask == COUNT_VALUE) return "0";
			else return sCol; // REMOVE_INSTANCE_OF_VALUE, INSERT_VALUE_AT_INDEX, REPLACE_VALUE_AT_INDEX	
		}	
	}
	// now we've handled every case of an empty value as well, so we can assume that both the sCol and the
	// value are set to valid entries. So now we'll handle indexes that are not set or out of bounds
	if (nIndex < 0 || nIndex > nSize - 1){
		// these three operations don't care if there's a valid index set
		if (nTask != GET_INDEX_OF_VALUE && nTask != REMOVE_INSTANCE_OF_VALUE && nTask != COUNT_VALUE){
			// the rest do
			if (nTask == GET_VALUE_AT_INDEX) return "";
				else return sCol;
		}
	}
	
    int nDelimPos = FindSubString(sCol, sDelimiter);
	
    if (nDelimPos == -1) {
        if (nTask == GET_VALUE_AT_INDEX) {
            if (nIndex == 0) return sCol;
            else return "";
        } else if (nTask == GET_INDEX_OF_VALUE) {
            if (sCol == sValue) return "0";
            else return "";
		} else if (nTask == REMOVE_VALUE_AT_INDEX){
			if (nIndex == 0) return "";
			else return sCol;
		} else if (nTask == REMOVE_INSTANCE_OF_VALUE){
			if (sCol == sValue) return "";
			else return sCol;
		} else if (nTask == INSERT_VALUE_AT_INDEX){
			if (nIndex == 0) return sValue + sDelimiter + sCol;
			else return sCol + sDelimiter + sValue;
		} else if (nTask == REPLACE_VALUE_AT_INDEX){
			if (nIndex == 0) return sValue;
			else return sCol;
		} else if (nTask == COUNT_VALUE){
			if (sCol == sValue) return "1";
			else return "0";
		}
    } else {
		
		int nCount = 0;
        string sRemainder = sCol;
		int nLength = GetStringLength(sRemainder);
        string sCurrentValue = "";

		// but first handle if the index is last, because we don't need the loop if it is. If it's first
		// then the loop will exit early enough not to need optimization here.
		if (nIndex == nSize - 1){
			// again, index is irrelevant to these three operations.
			if (nTask != GET_INDEX_OF_VALUE && nTask != REMOVE_INSTANCE_OF_VALUE && nTask != COUNT_VALUE){
					sRemainder = "";
					// reverse the order of all the characters so we can more easily get the last
					// instance of sDelimiter, temporarily using sRemainder to store the backwards
					// string so we don't waste memory creating a new string variable just for this.
					for (nCount = nLength; nCount >= 1; nCount--){
						sRemainder += GetSubString(sCol, nCount, 1);
					}
					// set the delim position to the first of the reversed string, which ofc will 
					// give us the length of the last index value
					nDelimPos = FindSubString(sRemainder, sDelimiter);
					// not set sRemainder to everything but the last index value and the last delimeter
					sRemainder = GetStringLeft(sCol, nLength - nDelimPos - 1);
					// and set sCurrentValue to the last index value
					sCurrentValue = GetStringRight(sCol, nDelimPos);
					// now we have all the info we need to perform these operations without 
					// having to get every value for every index
					if (nTask == GET_VALUE_AT_INDEX) return sCurrentValue;
					else if (nTask == REMOVE_VALUE_AT_INDEX) return sRemainder;
					else if (nTask == INSERT_VALUE_AT_INDEX) 
						return sRemainder + sDelimiter + sValue + sDelimiter + sCurrentValue;
					else if (nTask == REPLACE_VALUE_AT_INDEX)
						return sRemainder + sDelimiter + sValue;
			}
		}
		// finally, we handle cases where index is not last, and cases where the index is irrelevant.
		// We need a couple more variables for this but we don't have to reset the previous ones because
		// the script would have either returned out or not changed them in the above conditional.
		// What we do here is iterate through the list, separating it into three parts as we go: 
		// sPrevious, sCurrentValue, and sRemainder. 
		int nCurrentIndex = -1;
		string sPrevious = "";
		while (nCurrentIndex <= nSize - 1) {  
			nCurrentIndex += 1;
			nDelimPos = FindSubString(sRemainder, sDelimiter);
			if (nDelimPos != -1){
				sCurrentValue = GetStringLeft(sRemainder, nDelimPos);
				nLength = GetStringLength(sRemainder);
				sRemainder = GetStringRight(sRemainder, nLength - nDelimPos - 1);
			} else {
				sCurrentValue = sRemainder;
				sRemainder = "";
			}
			
			if (nCurrentIndex == nIndex) {
				if (nTask == GET_VALUE_AT_INDEX) return sCurrentValue;
				else if (nTask == REMOVE_VALUE_AT_INDEX){
					return ListSurgery(sPrevious, "", sRemainder);
				} else if (nTask == INSERT_VALUE_AT_INDEX){
					return ListSurgery(sPrevious, sValue + sDelimiter + sCurrentValue, sRemainder);
				} else if (nTask == REPLACE_VALUE_AT_INDEX){
					return ListSurgery(sPrevious, sValue, sRemainder);
				}
			}
			if ((bCaseSensitive && sCurrentValue == sValue) || 
				(!bCaseSensitive && GetStringLowerCase(sCurrentValue) == GetStringLowerCase(sValue))){
				if (nTask == GET_INDEX_OF_VALUE) return IntToString(nCurrentIndex);
				else if (nTask == REMOVE_INSTANCE_OF_VALUE)
					return ListSurgery(sPrevious, "", sRemainder);  
				else if (nTask == COUNT_VALUE) nCount += 1;
			}
			if (sPrevious == "") sPrevious = sCurrentValue;
			else sPrevious += sDelimiter + sCurrentValue;
		}
		// end of while loop, end of list
		if (nTask == COUNT_VALUE) return IntToString(nCount);	
    }
    return ""; 
}

// Strictly a helper for above, used for either removing or inserting values
string ListSurgery(string sPrevious, string sInsert, string sRemainder){
	if (sPrevious == ""){
		if (sInsert == "" && sRemainder == "") return ""; // if this happens something's gone wrong
		else if (sInsert == "") return sRemainder;
		else if (sRemainder == "") return sInsert;
		else return sInsert + sDelimiter + sRemainder;
	}
	if (sInsert == ""){
		if (sRemainder == "") return sPrevious;
		else return sPrevious + sDelimiter + sRemainder;
	}
	if (sRemainder == "") return sPrevious + sDelimiter + sInsert;
	else return sPrevious + sDelimiter + sInsert + sDelimiter + sRemainder;
}

// quicksort algorithm to sort the list, based on info from
//   https://www.geeksforgeeks.org/quick-sort-algorithm/
string Quicksort(string sCol, int bCaseSensitive = B_CASE, int nIteration = 1) {

    int nSize = GetNumberIndices(sCol);
    if (nSize <= 1) return sCol;
	
	if (nSize == 2){ 
		int nDelim = FindSubString(sCol, sDelimiter); 
		int nLength = GetStringLength(sCol); 
		string sLeft = GetStringLeft(sCol, nDelim);
		string sRight = GetStringRight(sCol, nLength - nDelim - 1);
		if (StringCompare(sLeft, sRight, bCaseSensitive) > 0)
			return sRight + sDelimiter + sLeft;
		else return sCol;
	}
	
	if (CheckIsSorted(sCol, nSize, bCaseSensitive)) return sCol;
	
	int nPivot;
    string sPivot;
	if (nSize == 3 || nIteration <= 2 || (nSize >= 10 && nIteration <= 3)){
		int nDelim1 = FindSubString(sCol, sDelimiter);
		string sFirst = GetStringLeft(sCol, nDelim1);
		int nMiddle;
		string sMiddle;
		string sLast;
		if (nSize == 3){
			int nLength = GetStringLength(sCol); 
			int nDelim2 = FindSubString(sCol, sDelimiter, nDelim1 + 1);
			sLast = GetStringRight(sCol, nLength - nDelim2 - 1);
			int nMidLength = nLength - GetStringLength(sFirst) - GetStringLength(sLast) - 2;
			sMiddle = GetSubString(sCol, nDelim1 + 1, nMidLength);
			nMiddle = 1;
		} else {
			nMiddle = nSize / 2;
			sMiddle = GetValueAtIndex(sCol, nMiddle);
			sLast = GetValueAtIndex(sCol, nSize - 1);
		}
		
		int nSelectedPivot = GetMedianOfThree(sFirst, sMiddle, sLast, bCaseSensitive);
		if (nSelectedPivot == 1){
			sPivot = sFirst;
			nPivot = 0;
		} else if (nSelectedPivot == 2) {
			sPivot = sMiddle;
			nPivot = nMiddle;
		} else {
			sPivot = sLast;
			nPivot = nSize - 1;
		}
	} else {
		nPivot = nSize / 2;
		sPivot = GetValueAtIndex(sCol, nPivot);
	}

    string sLess = "";
	string sGreater = "";
    string sValue;
    int i;
    for (i = 0; i < nSize; i++) {
		if (i != nPivot){
			sValue = GetValueAtIndex(sCol, i);
			if (StringCompare(sValue, sPivot, bCaseSensitive) < 0) {
				if (sLess == "") sLess = sValue;
				else sLess += sDelimiter + sValue;
			} else {
				if (sGreater == "") sGreater = sValue;
				else sGreater += sDelimiter + sValue;
			}
		}
    }

	// sort the sublists, eventually this will result in lists small enough to return immediately without
	// further recursion.
    sLess = Quicksort(sLess, bCaseSensitive, nIteration + 1);
    sGreater = Quicksort(sGreater, bCaseSensitive, nIteration + 1);

    // merge sublists
    if (sLess != "") sLess += sDelimiter;
    if (sGreater != "") sGreater = sDelimiter + sGreater;
    return sLess + sPivot + sGreater;
}

int GetMedianOfThree(string sFirst, string sMiddle, string sLast, int bCaseSensitive){
	if ((StringCompare(sFirst, sMiddle, bCaseSensitive) > 0) == (StringCompare(sFirst, sLast, bCaseSensitive) < 0)) {
		return 1;
	} else if ((StringCompare(sMiddle, sFirst, bCaseSensitive) > 0) == (StringCompare(sMiddle, sLast, bCaseSensitive) < 0)) {
		return 2;
	} else {
		return 3;
	}
}

int CheckIsSorted(string sCol, int nSize = LIST_NULL, int bCaseSensitive = B_CASE){
	if (nSize == LIST_NULL) nSize = GetNumberIndices(sCol);
	if (nSize <= 1) return TRUE;
	int i;
	int bSorted = TRUE;
	string sValue1;
	string sValue2;
	for (i = 0; i <= nSize - 2; i++){
		sValue1 = GetValueAtIndex(sCol, i);
		sValue2 = GetValueAtIndex(sCol, i + 1);
		if (StringCompare(sValue1, sValue2, bCaseSensitive) > 0){
			bSorted = FALSE;
			break;
		}
	}
	return bSorted;
}

int GetNumIndices(string sCol){
	if (sCol == "") return 0;
	
	int nDelim = FindSubString(sCol, sDelimiter);
	if (nDelim == -1) return 1; // if it's not empty but we don't have a delimeter we have 1 index
	
	nDelim = 0;
	int nLength = GetStringLength(sCol);
	int i;
	string c;
	for (i = 1; i <= nLength; i++){
		c = GetSubString(sCol, i, 1);
		if (c == sDelimiter) nDelim += 1;
	}
	return nDelim + 1;
}

// trim the value added to a list, or a key-value pair added to a map, of all list
// delimiters to make sure we don't have double delimiters or false delimiters.
string TrimForList(string sInput, int bAllowWhitespace = B_ALLOW_WHITESPACE){
	return TrimInput(sInput, FALSE, bAllowWhitespace);
}

//trim a key or a value to be added to a map of both list delimiters and key-value
//separators so that we don't have double or false delimiters or separators.
//In other words, when creating a map we will call this on both the key and then
//the value before joining them into a pair.
string TrimKeyValue(string sInput, int bAllowWhitespace = B_ALLOW_WHITESPACE){
	return TrimInput(sInput, TRUE, bAllowWhitespace);
}

// trim the special characters that we are using for key-value pairs and for 
// lists. If we're trimming for a list, we do NOT remove the key-value
// separators because we're re-using the list functions to create map-lists, 
// so adding a key-value pair to a list of key-value pairs WILL include
// the map separators.
string TrimInput(string sString, int bForKeyOrValue, int bAllowWhitespace = B_ALLOW_WHITESPACE){
    int nLength = GetStringLength(sString);
    if (nLength == 0) return sString;
    
    // check for list delimiters and map separators
    int bHasDelim = (FindSubString(sString, sDelimiter) != -1);
    int bHasMap = (FindSubString(sString, sMap) != -1);
	int bHasWhitespace = ((FindSubString(sString, " ") != -1) || (FindSubString(sString, "\t") != -1) ||
		(FindSubString(sString, "\n") != -1) || (FindSubString(sString, "\r") != -1));
    
    // if there's no unwanted special characters just return the string
	if ((!bHasDelim) && (bAllowWhitespace || !bHasWhitespace)){
		if ((bForKeyOrValue && !bHasMap) || !bForKeyOrValue){
			return sString;
		}
	}
  
    string sNonSpecial = "";
    
	int i;
	string sChar;
	int bPassCheck = TRUE;
    for (i = 0; i < nLength; i++) {
        sChar = GetSubString(sString, i, 1);
		
		if (sChar == sDelimiter) bPassCheck = FALSE;
        if (bForKeyOrValue && bPassCheck) {
            if (sChar == sMap) bPassCheck = FALSE;
        }
		if (!bAllowWhitespace && bPassCheck){
			if (sChar == " " || sChar == "\t" || sChar == "\n" || sChar == "\r")
				bPassCheck = FALSE;
		}
		if (bPassCheck) sNonSpecial += sChar;
    }
    return sNonSpecial;
}

/*
I did have a separate function for trimming whitespace but I decided to include it in the 
above so that I don't have to iterate through the string more than once. Might need a 
dedicated function for this at some point so leaving it here. -FlattedFifth
string TrimWhiteSpace(string sInput){
    string sResult = "";
    int nLength = GetStringLength(sInput);
    int i;
    for (i = 0; i < nLength; i++) {
        string sChar = GetSubString(sInput, i, 1);
        if (sChar != " " && sChar != "\t" && sChar != "\n" && sChar != "\r") {
            sResult += sChar;
        }
    }
    return sResult;
}
*/
void fCloseLock()
    {
    ActionCloseDoor(OBJECT_SELF);
    SetLocked(OBJECT_SELF, 1);
    }


void main()
    {

    DelayCommand(120.0, fCloseLock());
    }
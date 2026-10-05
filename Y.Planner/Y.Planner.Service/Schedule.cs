namespace Y.Planner.Service;

public class Schedule
{
    public DateOnly Date { get; set; }

    public Routine[] Routines { get; private set; }
}

public class Routine { }
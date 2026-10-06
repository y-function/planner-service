namespace Y.Planner.Service;

public interface IPlannerService
{
    Result<Schedule> GetToday();
}
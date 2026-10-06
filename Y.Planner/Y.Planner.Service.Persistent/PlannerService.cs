namespace Y.Planner.Service.Persistent;

internal class PlannerService : IPlannerService
{
    public Result<Schedule> GetToday()
    {
        return Result.Success(new Schedule());
    }
}
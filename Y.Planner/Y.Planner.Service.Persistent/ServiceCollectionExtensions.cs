using Microsoft.Extensions.DependencyInjection;

namespace Y.Planner.Service.Persistent;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddPlannerService(this IServiceCollection services)
    {
        return services.AddSingleton<IPlannerService, PlannerService>();
    }
}
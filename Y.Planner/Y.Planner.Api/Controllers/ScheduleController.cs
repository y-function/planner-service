using Microsoft.AspNetCore.Mvc;
using Y.Planner.Service;

namespace Y.Planner.Api.Controllers;

[Route("api/[controller]")]
public class ScheduleController(IPlannerService plannerService) : Controller
{
    private IPlannerService PlannerService { get; } = plannerService ?? throw new ArgumentNullException(nameof(plannerService));

    [HttpGet]
    public IActionResult GetTodaysSchedule()
    {
        var result = PlannerService.GetToday();
        return Ok(result);
    }
}
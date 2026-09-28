using Microsoft.AspNetCore.Mvc;

namespace Y.Planner.Api.Controllers;

[Route("api/[controller]")]
public class ScheduleController : Controller
{
    [HttpGet]
    public IActionResult GetTodaysSchedule()
    {
        return Ok();
    }
}
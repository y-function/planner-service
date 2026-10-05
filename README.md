# planner-service

To build the container image, do the following:

- In PowerShell, set NUGET_USERNAME and NUGET_PASSWORD
- Then build with:

```
docker build --secret id=nuget_username,env=NUGET_USERNAME --secret id=nuget_password,env=NUGET_PASSWORD -t planner-api .
```
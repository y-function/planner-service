# planner-service

## Configure private NuGet feed credentials

The repository-level `local.env` file is ignored by Git and is intended for local
NuGet credentials only. It stores the values as plain text, so keep the file on
a trusted, access-controlled machine and never commit or share it.

Edit `local.env` and fill in your GitHub username and a token with access to the
private NuGet packages:

```dotenv
NUGET_USERNAME=your-github-username
NUGET_PASSWORD=your-github-token
```

In PowerShell, run the setup script from the repository root:

```powershell
.\load-local-env.ps1
```

The script saves both variables to your Windows user environment and loads them
into its current process. Open a new PowerShell window to use the saved
variables, or dot-source the script to load them into the current window:

```powershell
. .\load-local-env.ps1
```

Build the container image from that PowerShell window. BuildKit passes the
credentials as secrets for NuGet restore rather than embedding them in the
image:

```powershell
docker build --secret id=nuget_username,env=NUGET_USERNAME --secret id=nuget_password,env=NUGET_PASSWORD -t planner-api .
```
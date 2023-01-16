<#

Author: Mike Pfeiffer

Sample Docker Client Setup Script

Disclaimers

!!!!!!!!!!
This script is provided as an example and is not directly intended to be run as-is.
!!!!!!!!!!

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

$package = "https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip"

Invoke-WebRequest $package `
-OutFile "$env:TEMP\docker.zip" `
-UseBasicParsing

Expand-Archive -Path "$env:TEMP\docker.zip" `
-DestinationPath $env:ProgramFiles

[Environment]::SetEnvironmentVariable(
  "Path", $env:Path + ";$($env:ProgramFiles)\Docker", [EnvironmentVariableTarget]::Machine
)

[Environment]::SetEnvironmentVariable(
  "DOCKER_HOST", "192.168.1.144", [EnvironmentVariableTarget]::Machine
)

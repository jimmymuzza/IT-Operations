<#

Author: Mike Pfeiffer

Sample script to configure Docker engine for remote connections

Disclaimers

This example code is provided without copyright and AS IS.  It is free for you to use and modify.
Note: These demos should not be run as a script. These are the commands that I use in the 
demonstrations and would need to be modified for your environment.

#>

netsh advfirewall firewall add rule name="Docker daemon" dir=in action=allow protocol=TCP localport=2375

new-item -Type File c:\ProgramData\docker\config\daemon.json

Add-Content 'c:\ProgramData\docker\config\daemon.json' '{ "hosts": ["tcp://0.0.0.0:2375", "npipe://"] }'

Restart-Service docker

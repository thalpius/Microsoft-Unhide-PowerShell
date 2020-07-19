# Unhide PowerShell

PowerShell supports a command line parameter “WindowStyle” as shown below. The parameter “WindowStyle” sets the window style for that session. Valid values are Normal, Minimized, Maximized and Hidden.

Most malicious PowerShell scripts run PowerShell with the window style “Hidden”. When the process starts with WindowStyle hidden, no PowerShell console is displayed, so it runs unnoticed for the logged-in user.I created a script to unhide all PowerShell processes.

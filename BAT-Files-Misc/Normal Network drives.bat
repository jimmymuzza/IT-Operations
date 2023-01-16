@echo off
CLS
echo Connecting Drives for users .....
IF EXIST H:\. NET USE H: /DELETE

net use q: \\<SHARE LOCATION>


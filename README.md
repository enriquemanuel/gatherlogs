# gatherlogs
Script that automatically connects to all servers and brings the access logs to a centralized location for later use. (data mining)

## Execution
```bash
sh gatherlogs.sh 
```
### How does it look while executing?
```bash
What is the Client Code that you want to get the logs? For Example: fgprd-100840-12459
fgprd-301590-154567
Please enter the start date of the logs to grab: (format: 2015-04-22): 2015-04-25
Please enter the end date of the logs to grab: (format: 2015-04-22): 2015-04-27

Reviewing fgprd-301590-154567-app001 
  App Server is October 2014 Release.
Reviewing fgprd-301590-154567-app002 
  App Server is October 2014 Release.
Reviewing fgprd-301590-154567-app003 
  App Server is October 2014 Release.
Reviewing fgprd-301590-154567-app004 
  App Server is October 2014 Release.
Reviewing fgprd-301590-154567-app005 
  App Server is October 2014 Release.
Reviewing fgprd-301590-154567-db001 
  Err: Not an App Server. Exiting this server
Reviewing fgprd-301590-154567-app006 
  App Server is October 2014 Release.
  
Listing
total 25808812
      4 drwxr-xr-x  2 root   root         4096 Apr 27 11:49 .
      8 drwxr-xr-x 18 bbuser bbuser       8192 Apr 27 11:44 ..
   1928 -rw-r--r--  1 root   root      1965410 Apr 27 11:44 fgprd-301590-154567-app001-bb-access-log.2015-04-25.txt
   2308 -rw-r--r--  1 root   root      2350864 Apr 27 11:44 fgprd-301590-154567-app001-bb-access-log.2015-04-26.txt
    856 -rw-r--r--  1 root   root       870784 Apr 27 11:44 fgprd-301590-154567-app001-bb-access-log.2015-04-27.txt
1865892 -rw-r--r--  1 root   root   1903167432 Apr 27 11:44 fgprd-301590-154567-app002-bb-access-log.2015-04-25.txt
2568696 -rw-r--r--  1 root   root   2620022251 Apr 27 11:45 fgprd-301590-154567-app002-bb-access-log.2015-04-26.txt
 875512 -rw-r--r--  1 root   root    893004736 Apr 27 11:45 fgprd-301590-154567-app002-bb-access-log.2015-04-27.txt
1910152 -rw-r--r--  1 root   root   1948315389 Apr 27 11:45 fgprd-301590-154567-app003-bb-access-log.2015-04-25.txt
2580104 -rw-r--r--  1 root   root   2631658209 Apr 27 11:46 fgprd-301590-154567-app003-bb-access-log.2015-04-26.txt
 854744 -rw-r--r--  1 root   root    871817907 Apr 27 11:46 fgprd-301590-154567-app003-bb-access-log.2015-04-27.txt
1714572 -rw-r--r--  1 root   root   1748825376 Apr 27 11:46 fgprd-301590-154567-app004-bb-access-log.2015-04-25.txt
2443400 -rw-r--r--  1 root   root   2492217933 Apr 27 11:47 fgprd-301590-154567-app004-bb-access-log.2015-04-26.txt
 837580 -rw-r--r--  1 root   root    854311929 Apr 27 11:47 fgprd-301590-154567-app004-bb-access-log.2015-04-27.txt
1773308 -rw-r--r--  1 root   root   1808740063 Apr 27 11:48 fgprd-301590-154567-app005-bb-access-log.2015-04-25.txt
2577592 -rw-r--r--  1 root   root   2629092776 Apr 27 11:48 fgprd-301590-154567-app005-bb-access-log.2015-04-26.txt
 819576 -rw-r--r--  1 root   root    835945341 Apr 27 11:48 fgprd-301590-154567-app005-bb-access-log.2015-04-27.txt
1725704 -rw-r--r--  1 root   root   1760180642 Apr 27 11:49 fgprd-301590-154567-app006-bb-access-log.2015-04-25.txt
2415212 -rw-r--r--  1 root   root   2463468155 Apr 27 11:49 fgprd-301590-154567-app006-bb-access-log.2015-04-26.txt
 841664 -rw-r--r--  1 root   root    858478375 Apr 27 11:50 fgprd-301590-154567-app006-bb-access-log.2015-04-27.txt
```
 
### A few caveats
1. it will go over 3 directories (BBHOME/LOGS = default) + (BBHOME/ASP/hostname/tomcat = rotated new) + (BBHOME/ASP/hostname/VAR/LOGS/TOMCAT = rotated old) (Managed Hosting Specific)
2. it will fail in some since the directories or the files do not exist. don’t worry, it will list them afterwards

### Risk?
Well at this time there is low risk in its usage but high in the amount of storage used for the data specific. The idea is to delete after the period of time of usage but it depends on the "analyzer" (human - interaction)

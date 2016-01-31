# space_mongix
Space Monger version for linux

## General Background
This project is in honor to to Space Monger http://edgerunner.com/spacemonger  utility on Windows. This utility is the best way I know to answer the following problem: "Well my disk if full , now what do I do ?"

## How to run details 

### Server bash script to run
The script space_monger.sh runs on current directory and display a tree-like display of big files and directories. 
The parameter that it gets is the magnitude of K's that interests us , for example 3 means that all files and directories below 10**3 K size (AKA 1Mb does not interest us) 

### Sample output 
Here is a sample output:
>usr,967164,944Mb,0.92Gb,0<br/>
>__usr/lib,370508,362Mb,0.35Gb,1<br/>
>____usr/lib/x86_64-linux-gnu,152380,149Mb,0.15Gb,2<br/>
>__usr/share,283180,277Mb,0.27Gb,1<br/>
>__usr/bin,150208,147Mb,0.14Gb,1<br/>
>__usr/src,110412,108Mb,0.11Gb,1<br/>

Each line represents a path in linux and the size it takes , for example first line is directory usr which has 967164 K or 944Mb , or 0.92Gb and it is at level 0. usr/lib is under usr (obviously) has 370508K which are 362MB or 0.35Gb and it is of level 1. 

## Where does it work and how was it tested
This project is for *nix systems , It was tested on Ubuntu Linux server and Mac/OSX one also. 

### Future plans
For now the only thing that works is the script that runs on server itself 
In future versions I will enable a UI similar to Space Monger that enables browsing through those files easily.
I will also add a procedure to collect files from several servers. 

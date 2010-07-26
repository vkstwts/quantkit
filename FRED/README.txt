
1/Unzip the FRED data file in your FRED directory. 


2/Open the README_SERIES_ID_SORT.txt file and strip out the lines at the top of the file, leave as first line the line:

	File                                    ;Title; Units; Frequency; Seasonal Adjustment; Last Updated

Strip out the lines at the bottom of the file from:

	Abbreviations:

on, and save the file as "FRED_KEY.txt"

3/In MySQL create a database "FRED"

4/Create a user localHack, give that user a password localHackPass and grant that user read/write writes on FRED; its recomended to allow localHack access to FRED only from the system you wish to work on. 

5/Modify .config in the FRED/Perl directory to point to your "FRED" directory and to the "data" directory created when FRED unzipped and to the FRED_KEY.txt file you created. 




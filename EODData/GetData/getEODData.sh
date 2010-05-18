cd ~/quantkit/EODData/Data

ncftpget -T -d ncftp.log -R -v -u "yourEODUserName" -p "yourEODPassWord" ftp.eoddata.com . /  

mkdir "./Archive/"$(date +%d%m%y)

mkdir "./Archive/"$(date +%d%m%y)"/Fundamentals"
mkdir "./Archive/"$(date +%d%m%y)"/Names"
mkdir "./Archive/"$(date +%d%m%y)"/Splits"
mkdir "./Archive/"$(date +%d%m%y)"/Technical"
mkdir "./Archive/"$(date +%d%m%y)"/ncftp"


mv -f ./Fundamentals/* "./Archive/"$(date +%d%m%y)"/Fundamentals"
mv -f ./Names/* "./Archive/"$(date +%d%m%y)"/Names"
mv -f ./Splits/* "./Archive/"$(date +%d%m%y)"/Splits"
mv -f ./Technical/* "./Archive/"$(date +%d%m%y)"/Technical"

rmdir Fundamentals
rmdir Names
rmdir Splits
rmdir Technical

rm terms.txt
mv -f ncftp.log "./Archive/"$(date +%d%m%y)"/ncftp/ncftp_"$(date +%H%M%S)".log"
rm readme.txt



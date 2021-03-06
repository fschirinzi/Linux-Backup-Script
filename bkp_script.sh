#!/bin/bash
# https://github.com/fschirinzi/Linux-Backup-Script

SCRIPTPATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOTBKDIR="/backup"

FILES="${SCRIPTPATH}/config/*"
for f in ${FILES}
do
    cd $SCRIPTPATH
    source "${f}"

    if [ -n "${SERVICE}" ] || [ -n "${SERVERIP}" ] || [ -n "${USER}" ] || [ -n "${PORT}" ] || [ -n "${DBUSER}" ] || [ -n "${DBPASSWD}" ] || [ -n "${DBHOST}" ];
    then

        echo "Processing ${f} file..."

        #display var
        num=1

        #Important Informations
        TODAY=$(date +"%d%m%y")
        DNUM=$(date +"%u")
        WNUM=$(date +"%V")
        YEAR=$(date +"%G")

        #Fileinfo
        #CSr = MD5 CHECKSUMM - "r" is for REMOTE; "l" is for local
        BKFILE="${SERVICE}-${TODAY}.tar.gz"
        CSr="${SERVICE}-md5r.txt"
        CSl="${SERVICE}-md5l.txt"
        LOGFILENAME="${SERVICE}.log"

        #Backupdirectory to use (2013/48/1 for 02.11.2013)
        # 48 - Weeknumber
        #  1 - Daynumber
        LocalBackupDir="${ROOTBKDIR}${ADDDIR}/${SERVICE}/${YEAR}/${WNUM}/${DNUM}"
        RemoteBackupDir="/tmp/${SERVICE}"
        BackupFilePath="$RBKDIR/${BKFILE}"
        LOGDIR="${ROOTBKDIR}${ADDDIR}/${SERVICE}"
        LOGFILE="${LOGDIR}/${LOGFILENAME}"


        echo ""
        echo ""
        echo "STEP ${num}"
        echo "Create folder if they not exist"
        echo ""

        if [ ! -d "${LocalBackupDir}" ]; then
            mkdir -p ${LocalBackupDir}
        fi

ssh -p ${PORT} ${USER}@${SERVERIP} <<EOF
if [ ! -d "${RemoteBackupDir}" ]; then
mkdir -p ${RemoteBackupDir}
fi
exit
EOF

        num=$((num + 1))

        if [ "${BBKFOLDERS}" == "TRUE" ]; then

            echo ""
            echo ""
            echo "STEP ${num}"
            echo "TAR all Folders in ARRAY"
            echo ""

            #TAR all folders in ARRAY
            for (( i = 0 ; i < ${#BKFOLDERS[@]} ; i++ )) do
                FOLDERPATH=${BKFOLDERS[$i]}
                TMPFILE="${RemoteBackupDir}/${i}-DIR-${BKFILE}"
                echo ${FOLDERPATH}
ssh -p ${PORT} ${USER}@${SERVERIP} <<EOF
tar -cvzf ${TMPFILE} ${FOLDERPATH}
exit
EOF
            done

            num=$((num + 1))

        fi

        if [ "${BBKFILES}" == "TRUE" ]; then

            echo ""
            echo ""
            echo "STEP ${num}"
            echo "TAR all Files in ARRAY"
            echo ""

            #TAR all files in ARRAY
            for (( i = 0 ; i < ${#BKFILES[@]} ; i++ )) do
                FILEPATH=${BKFILES[$i]}
                TMPFILE="${RemoteBackupDir}/${i}-FILE-${BKFILE}"
ssh -p ${PORT} ${USER}@${SERVERIP} <<EOF
tar -cvzf ${TMPFILE} ${FILEPATH}
exit
EOF
            done

            num=$((num + 1))

        fi

        if [ "${BBKDBS}" == "TRUE" ]; then

            echo ""
            echo ""
            echo "STEP ${num}"
            echo "TAR all Databases in ARRAY"
            echo ""

            #DUMB all DBs in ARRAY
            for (( i = 0 ; i < ${#BKDBs[@]} ; i++ )) do
                DBNAME="${BKDBs[$i]}"
                TMPPATH="${RemoteBackupDir}/${DBNAME}.sql"
                echo ${DBNAME}
                echo ${TMPPATH}
ssh -p ${PORT} ${USER}@${SERVERIP} <<EOF
mysqldump -u${DBUSER} -h ${DBHOST} -p${DBPASSWD} ${DBNAME} > ${TMPPATH}
exit
EOF
            done

            num=$((num + 1))
        fi


        echo ""
        echo ""
        echo "STEP ${num}"
        echo "TAR all Files in ARRAY"
        echo ""

        #TAR all Files togehter
        md5r="/tmp/${CSr}"
ssh -p ${PORT} ${USER}@${SERVERIP} <<EOF
tar -cvzf "/tmp/${BKFILE}" ${RemoteBackupDir}
md5sum < "/tmp/${BKFILE}" > ${md5r}
exit
EOF

        num=$((num + 1))


        echo ""
        echo ""
        echo "STEP ${num}"
        echo "Download file from Server"
        echo ""

        #Files to get
        getfile1="/tmp/${BKFILE}"
        getfile2="/tmp/${CSr}"

        putfile1="${LocalBackupDir}/${BKFILE}"
        putfile2="${LocalBackupDir}/${CSr}"

        scp -P ${PORT} ${USER}@${SERVERIP}:${getfile1} ${putfile1}
        scp -P ${PORT} ${USER}@${SERVERIP}:${getfile2} ${putfile2}

        num=$((num + 1))

        cd ${LocalBackupDir}

        md5sum < ${putfile1} > "${CSl}"

        if diff "${CSl}" "${CSr}" > /dev/null 2>&1
        then

ssh -p ${PORT} ${USER}@${SERVERIP} <<EOF
rm -Rf "${RemoteBackupDir}/"
rm ${getfile1}
rm ${getfile2}
exit
EOF

            rm ${putfile2}
            rm "${LocalBackupDir}/${CSl}"

        else
            echo ${subject} >> "${LOGFILE}"

            for (( i = 0 ; i < ${#emails[@]} ; i++ )) do
                email="${emails[$i]}"
                sudo "${SCRIPTPATH}/sendinfos.sh" "${subject}" "${email}"
                echo ${email}
            done
        fi
    fi
done

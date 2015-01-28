#!/bin/bash
# https://github.com/fschirinzi/Linux-Backup-Script

SCRIPTPATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOTBKDIR="/backup"

FILES="${SCRIPTPATH}/config/*"
for f in ${FILES}
do
    cd $SCRIPTPATH
    source "${f}"
    
    if [ "${DELETE}" -eq "1" ];
    then
        if [ -n "${SERVICE}" ] || [ -n "${ADDDIR}" ] || [ -n "${time}" ] || [ -n "${atime}" ];
        then
            echo ""
            echo ""
            echo "##############################################"
            echo "# Start with deletion - ${SERVICE}"
            echo "# Processing ${f} file..."
            echo "##############################################"

            #Important Informations
            TODAY=$(date +"%d.%m.%y")
            DNUM=$(date +"%u")
            WNUM=$(date +"%V")
            YEAR=$(date +"%G")
            LASTDNUM=`date --date="-${atime} ${time}" +"%u"`
            LASTWNUM=`date --date="-${atime} ${time}" +"%V"`
            LASTYEAR=`date --date="-${atime} ${time}" +"%G"`

            BKDIR="${ROOTBKDIR}${ADDDIR}/${SERVICE}"

            echo "Backup dir: ${BKDIR}"
            echo "Today: ${TODAY}"
            echo "Last remaining folder: .../${LASTYEAR}/${LASTWNUM}/${LASTDNUM}"
            echo "     --------     "

            for D in `find ${BKDIR} -maxdepth 1 -type d -printf "%f\n" | sort`
            do
                    if [ "${D}" != "${SERVICE}" ];
                    then
                            if [ ${D} -lt ${LASTYEAR} ];
                            then
                                    echo ""
                                    echo "Delete year dir ${D}"
                                    rm -rf "${BKDIR}/${D}"
                            elif [ ${D} -eq ${LASTYEAR} ];
                            then
                                    echo ""
                                    echo "Go into year ${D}"

                                    for sD1 in `find "${BKDIR}/${D}" -maxdepth 1 -type d -printf "%f\n" | sort`
                                    do
                                            if [ ${sD1} -lt ${LASTWNUM} ];
                                            then
                                                    echo "  Delete week dir ${sD1}"
                                                    rm -rf "${BKDIR}/${D}/${sD1}"
                                            elif [ ${sD1} -eq ${LASTWNUM} ];
                                            then
                                                    echo "  Go into week dir ${sD1}"
                                                    for sD2 in `find "${BKDIR}/${D}/${sD1}" -maxdepth 1 -type d -printf "%f\n" | sort`
                                                    do
                                                            if [ ${sD2} -lt ${LASTDNUM} ];
                                                            then
                                                                    echo "    Delete day dir ${sD2}"
                                                                    rm -rf "${BKDIR}/${D}/${sD1}/${sD2}"
                                                            fi
                                                    done
                                            fi
                                    done
                            fi
                    fi
            done

            echo "##############################################"
            echo "# End with deletion - ${SERVICE}"
            echo "##############################################"
        fi
    fi
done

#!/bin/bash

iModeSort=0
iModeJoin=0

strSourceDir="./unsorted"
strTargetDir="./sorted"
iTotal=0
iTempTot=0
iTempAct=0
iRefresh=0

function error
{
        printf "%s\n" "Op not ok"
        exit 1
}

function countu
{
    for file in ${strSourceDir}/*.txt; do
        iTempAct=$(cat "${file}" | wc -l)
        iTempTot=$((${iTempTot}+${iTempAct}))
    done
}

# Manage arguments
while [ -n "${1}" ]; do
    case "${1}" in
        "-sd"|"--source-dir")
            shift
            strSourceDir="${1}"
            ;;
        "-td"|"--target-dir")
            shift
            strTargetDir="${1}"
            ;;
        "-s"|"--sort")
            shift
            iModeSort=1
            ;;
        "-j"|"--join")
            shift
            iModeJoin=1
            ;;
    esac
    shift
done

if [ "${iModeSort}" = "1" ]; then
    countu
    printf "%s" "${iTempTot} files found. Continue? <y/n>"
    read strAnswer
    if [ "${strAnswer}" = "y" ]; then
        printf "%s\n" "OK. Start sorting :)"
    else
        exit 1
    fi 

    for strInputFile in ${strSourceDir}/*.txt; do
        # Loop
        while read line; do
            strLet1=$(printf "%s\n" ${line:0:1} | awk '{print tolower($0)}') || error
            strLet2=$(printf "%s\n" ${line:1:1} | awk '{print tolower($0)}') || error
            strLet3=$(printf "%s\n" ${line:2:1} | awk '{print tolower($0)}') || error
    
            if [[ ${strLet1} == [a-zA-Z0-9] ]]; then
                printf "%s\n" "letter ok" > /dev/null || error
            else
                strLet1="special"
            fi
        
            if [[ ${strLet2} == [a-zA-Z0-9] ]]; then
                printf "%s\n" "letter ok" > /dev/null || error
            else
                strLet2="special"
            fi
    
            if [[ ${strLet3} == [a-zA-Z0-9] ]]; then
                printf "%s\n" "letter ok" > /dev/null || error
                else
                strLet3="special"
            fi
    
            if [ -d "${strTargetDir}/${strLet1}" ]; then
                printf "%s\n" a > /dev/null || error
            else
                mkdir "${strTargetDir}/${strLet1}" || error
            fi
        
            if [ -d "${strTargetDir}/${strLet1}/${strLet2}" ]; then
                printf "%s\n" a > /dev/null || error
            else
                mkdir "${strTargetDir}/${strLet1}/${strLet2}" || error
            fi
       
            printf "%s\n" "${line}" >> "${strTargetDir}/${strLet1}/${strLet2}/${strLet3}" || error
            iTotal=$(($iTotal+1))
            
            # Save history for status display
            for i in {19..1..-1}; do
                strHistTargetDir[$((${i}+1))]=${strHistTargetDir[${i}]}
                strHistUser[$((${i}+1))]=${strHistUser[${i}]}
                strHistPass[$((${i}+1))]=${strHistPass[${i}]}
            done
            strHistTargetDir[1]=${strTargetDir}/${strLet1}/${strLet2}/${strLet3}
            strHistUser[1]=$(echo ${line} | awk -F':' '{print $1}')
            strHistPass[1]=$(echo ${line} | awk -F':' '{print $2}')

            if [ ${iRefresh} -eq 0 ]; then
                clear
                cat << _EOF
         _____ _     _        ____              _ 
        |_   _(_) __| |_   _ / ___|_ __ ___  __| |
          | | | |/ _' | | | | |   | '__/ _ \/ _' |
          | | | | (_| | |_| | |___| | |  __/ (_| |
          |_| |_|\__,_|\__, |\____|_|  \___|\__,_|
                       |___/                      

_EOF
                #printf "%50s\n" "By ChownRootRoot"
                printf "%s\n" "----------------------------------------------------------------------"
                printf "%-24s%-30s%s\n" "SORTED" "TOTAL" "DONE"
                printf "%-24d%-30d%d%%\n" ${iTotal} ${iTempTot} $((($iTotal*100)/$iTempTot))
                printf "\n%s\n----------------------------------------------------------------------\n" "BUFFER"
                printf "%-3s%-21s%-30s%-30s\n" "#" "DIRECTORY" "USERNAME" "PASSWORD"
                for i in {1..20}; do
                    printf "%-3.02i%-21s%-30s%-30s\n" ${i} ${strHistTargetDir[${i}]} ${strHistUser[${i}]} ${strHistPass[${i}]}
                done
                iRefresh=18
            fi
            iRefresh=$((${iRefresh}-1))
        done < ${strInputFile}
    done
    exit 0
fi

if [ "${iModeJoin}" = "1" ]; then
    printf "%s\n" "Join mode not yet implemented"
    exit 0
fi

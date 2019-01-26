#!/bin/bash

strUDir="./unsorted"
strSDir="./sorted"
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
    for file in ${strUDir}/*.txt; do
        iTempAct=$(cat "${file}" | wc -l)
        iTempTot=$((${iTempTot}+${iTempAct}))
    done
}

# Manage arguments
while [ -n "${1}" ]; do
    case "${1}" in
        "-u"|"--unsorted-dir")
            shift
            strUDir="${1}"
            ;;
        "-s"|"--sorted-dir")
            shift
            strSDir="${1}"
            ;;
    esac
    shift
done

countu
printf "%s" "${iTempTot} files found. Continue? <y/n>"
read strAnswer
if [ "${strAnswer}" = "y" ]; then
    printf "%s\n" "OK. Start sorting :)"
else
    exit 1
fi 

for strInputFile in ${strUDir}/*.txt; do
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
    
        if [ -d "${strSDir}/${strLet1}" ]; then
            printf "%s\n" a > /dev/null || error
        else
            mkdir "${strSDir}/${strLet1}" || error
        fi
        
        if [ -d "${strSDir}/${strLet1}/${strLet2}" ]; then
            printf "%s\n" a > /dev/null || error
        else
            mkdir "${strSDir}/${strLet1}/${strLet2}" || error
        fi
       
        printf "%s\n" "${line}" >> "${strSDir}/${strLet1}/${strLet2}/${strLet3}" || error
        iTotal=$(($iTotal+1))
        if [ ${iRefresh} -eq 0 ]; then
            clear
            cat << _EOF
  ____      _ _           _   _                              _            
 / ___|___ | | | ___  ___| |_(_) ___  _ __    ___  ___  _ __| |_ ___ _ __ 
| |   / _ \| | |/ _ \/ __| __| |/ _ \| '_ \  / __|/ _ \| '__| __/ _ \ '__|
| |__| (_) | | |  __/ (__| |_| | (_) | | | | \__ \ (_) | |  | ||  __/ |   
 \____\___/|_|_|\___|\___|\__|_|\___/|_| |_| |___/\___/|_|   \__\___|_|   
_EOF
            printf "%70s\n" "By ChownRootRoot"
            printf "%s\n" "----------------------------------------------------------------------"
            printf "%-25s%-25s%-10s%-10s%s\n" "SOURCE" "TARGET" "SORTED" "TOTAL" "DONE"
            printf "%-25s%-25s%-10d%-10d%d%%\n" "${strInputFile}" "${strSDir}/${strLet1}/${strLet2}/${strLet3}" ${iTotal} ${iTempTot} $((($iTotal*100)/$iTempTot))
            iRefresh=18
        fi
        iRefresh=$((${iRefresh}-1))
    done < ${strInputFile}
done
exit 0

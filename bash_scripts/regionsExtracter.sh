#!/bin/bash

set -e
set -o pipefail

#   Extract regions from a BAM file

#   Make sure SAMTools is installed
if ! `command -v samtools > /dev/null 2> /dev/null`
then
    echo "Cannot find SAMTools!"
    exit 1
fi

#   Do we have our two required arguments
if [[ "$#" -lt 2 ]]
then
    echo -e "\
Usage:  ./regionsExtracter.sh sample_info num_regions [out_directory] [out_name] [ref_gen] \n\
Where:  'sample_info' is a list of BAM files that have similar regions \n\
\n\
        'num_regions' is the desired number of regions to extract \n\
\n\
        'out_directory' is the directory to put the output regions file \n\
            this defaults to: \n\
            `pwd` \n\
\n\
        'out_name' is the name of the output file \n\
            this defaults to: \n\
            'extractedRegions.txt' \n\
\n\
        'ref_gen' is an optional reference genome which extracted regions will\n\
            be compared to ensuring that all regions are found within \n\
            the reference \n\
" >&2
    exit 1
fi

#   Give names and set defaults for arguments
SAMPLE_INFO=$1
NUM_REGIONS=$2
OUTDIR=${3:-`pwd`}
OUTFILE=${4:-extractedRegions.txt}
REF_GEN=${5:-}

#   Make sure that the outdirectory exists
mkdir -p ${OUTDIR}

#   Make a function to compare a selected region to a reference file
function referenceRegion() {
    local reference="$1"
    local region="$2"
    grep ">$region\b" "$reference" > /dev/null 2> /dev/null #    Search for $region in $reference
    if [[ "$?" -eq 0 ]] #   If we found something
    then
        return 0 #  Set exit status to be zero
    else #  Otherwise
        return 1 #  Set exit status to be one
    fi
}

#   Export the function to be used
export -f referenceRegion

#   Begin the subsetting here
#       Find the regions of one of the BAM files, pick one at random
echo "There are $( wc -l < ${SAMPLE_INFO} ) BAM files listed in ${SAMPLE_INFO}"
FILE_NUM=$(echo "$(( $RANDOM%`wc -l < ${SAMPLE_INFO}` ))" )
FILE=`head -"${FILE_NUM}" "${SAMPLE_INFO}" | tail -1`
#       Extract all regions from the header
#           use SAMTools view to only view the header information
#           find only the @SQ lines, as those have region information
#           it's tab-delimited, and the region information is in the second field
#           now get rid of the "SN:" from the region information
echo "Collecting all regions from $FILE ..."
declare -a REGIONS=(`samtools view -H "${FILE}" | grep "@SQ" | cut -f 2 | cut -d ':' -f 2`)
echo "Looking at ${#REGIONS[@]} regions..."
#       Take a subset of regions
echo "Selecting ${NUM_REGIONS} regions:"
#REG_LIMIT=`echo "${#REG_ARRAY[@]}"` #  Get the length of the REGIONS array
counter=0 # Set up a counter for a while loop
while [ "$counter" -le "$(( ${NUM_REGIONS} - 1 ))" ]
do
    region="${REGIONS[$(( $RANDOM%${#REGIONS[@]} ))]}"
    if [[ -f "${REF_GEN}" ]] #    Do we have a reference genome?
    then
        echo "Searching for $region in ${REF_GEN} ..."
        referenceRegion "${REF_GEN}" "$region" #   Make sure the region is in the reference
        if [[ "$?" -ne 0 ]] #   If not
        then
            echo "Failed to find $region!"
            continue #  Don't advance the counter, try again with another region
        fi
    fi
    SUB_REG["$counter"]="$region"
    let "counter += 1" #    Increment count
done
#       Compare to the regions found in each BAM file specified by SAMPLE_INFO
for bamfile in `cat "${SAMPLE_INFO}"`
do
    echo "Comparing regions with $bamfile"
    repeat=1 #  Set this to be 1
    while [[ "$repeat" -eq 1 ]] #   As long as 'repeat' is 1, keep repeating
    do
        declare -a MISSING #    Initialize an array to hold missing indecies
        #if [[ "$?" -ne 0 ]]
        index=0 #   Create a counter for indecies in the MISSING array
        for reg_num in `seq 0 "$(( ${#SUB_REG[@]} - 1 ))"`
        do
            reg=`echo "${SUB_REG[$reg_num]}"` #  Get the region
            echo "Looking for $reg"
            samtools view -H "$bamfile" | grep "$reg\s" > /dev/null 2> /dev/null #   Is the region present in $bamfile?
            if [[ "$?" -ne 0 ]] #   If not
            then
                echo "Failed to find $reg in $bamfile"
                MISSING["${index}"]="${reg_num}" #  Add the index to the MISSING array
                let "index += 1" #    Increment the counter
            fi
        done
        if ! [[ -z "${MISSING}" ]] #    Do we have missing values (if ${MISSING} is not empty)
        then #  If there are mismatches
            echo "Found ${#MISSING[@]} mismatches between the regions and $bamfile"
            for specific in "${MISSING[@]}"
            do
                echo "Replacing ${REGIONS[$specific]}"
                doagian=1 #  Set to 1 to force a repeating loop
                while [ "$doagain" -ne 0 ] #    As long as $doagain is not zero, repeat
                do
                    region="${REGIONS[$(( $RANDOM%$REG_LIMIT ))]}" #    Sample another region
                    if [[ -f "${REF_GEN}" ]] #    Do we have a reference genome?
                    then
                        referenceRegion "${REF_GEN}" "$region" #   Make sure the region is in the reference
                        if [[ "$?" -ne 0 ]] #   If not
                        then
                            continue #  Don't advance the counter, try again with another region
                        fi
                    fi
                    SUB_REG["$specific"]="$region" #    Replace the missing region
                    doagain=0 # End the repeat
                done
            done
        else #  If not
            echo "Found no mismatches, moving on to the next"
            repeat=0 #  Set 'repeat' to be 0 to stop the while loop
        fi
    done
done

echo "The regions we're using are:"
#   Create an output file
for region in "${SUB_REG[@]}" # Iterate through the regions defined in the subset file
do
    echo -e "$region:" | tee -a "${OUTDIR}"/"${OUTFILE}" #    Append to a file
done

#   Create an output message
echo "Final output file with ${NUM_REGIONS} regions extracted can be found at ${OUTDIR}/${OUTFILE}"

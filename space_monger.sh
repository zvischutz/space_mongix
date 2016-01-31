#!/bin/bash
# Read the file in parameter and fill the array named "array"
getArray() {
    array=() # Create array
    while IFS= read -r line # Read a line
    do
        array+=("$line") # Append line to the array
    done < "$1"
}

get_number_of_spaces_at_beginning() {
    local return_to=$1
    local var="$2"
    local trimmed="${var#"${var%%[!_]*}"}"   
    eval $return_to="$(( ${#var} - ${#trimmed} ))"
}
get_path_of_line() {
    local return_to=$1
    local var="$2"
    IFS=',' read -r -a arr_var <<< "$var"
    eval $return_to="${arr_var[0]}"
}
get_level_of_line() {
    local return_to=$1
    local var="$2"
    IFS=',' read -r -a arr_var <<< "$var"
    eval $return_to="${arr_var[@]:(-1)}"
}

if [ "$(uname)" == "Darwin" ]; then
	GREP_FLAG=-E
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	GREP_FLAG=-P
fi
LOW_FILES=\\,\\d{1,$1}$
du -ak * | awk -F$'\t'  '{print $2 "," $1} ' | sort --field-separator=, -g -k 2 | grep $GREP_FLAG -v $LOW_FILES | awk 'BEGIN { FS = "," } ; {x=$2/1024; printf("%s,%s,%.0fMb,%.2fGb\n",$1,$2,x,(x/1024))}' > /tmp/dd.txt
getArray "/tmp/dd.txt"
res=()
for (( i=${#array[@]}-1; i>=0 ; i-- ))
do 
    #echo "main array : $i : ${array[i]}"
    keepj=-1
    offset=""

	for (( j=0; j<${#res[@]}; j++ ))
	do
        var="${res[j]}"
        temp_resj="${var#"${var%%[!_]*}"}"
        IFS=',' read -r -a arr_resj <<< "$temp_resj"
        IFS=',' read -r -a arr_arrayi <<< "${array[i]}"
		if [[ ${arr_arrayi[0]} == ${arr_resj[0]}* ]]; then
            get_number_of_spaces_at_beginning num_of_blanks ${res[j]}
            num_of_blanks=$(( $num_of_blanks + 2))
            read offset <<< $(head -c $num_of_blanks < /dev/zero | tr '\0' '_')
            keepj="$j"
            level="$(( num_of_blanks / 2 ))"
        fi        
	done
    #echo "keepj: $keepj"
    if [[ keepj -gt -1 ]]; then
        for (( k=keepj+1; k<${#res[@]}; k++ ))
        do
            get_level_of_line existing_line_level ${res[k]}
            if [[ level -gt existing_line_level ]]; then
                keepj=$k
                break
            fi
            var="${res[k]}"
            temp_resk="${var#"${var%%[!_]*}"}"
            get_path_of_line pathresk ${temp_resk}
            get_path_of_line pathresarrayi ${array[i]}
            #echo "pathresk: $pathresk"
            #echo "pathresarrayi: $pathresarrayi"
            if [[ $pathresk == $pathresarrayi* ]]; then 
                #echo "inner level before upper"
                res[k]="__${res[k]}"
                keepj="$k"
                break
            fi                
        done
        #echo "keepj: $keepj"
        if [[ k -eq ${#res[@]} ]]; then
            res+=("$offset${array[i]},$level")
        else    
            res=("${res[@]:0:keepj}" "$offset${array[i]},$level" "${res[@]:keepj}")
        fi
    else
        res+=("${array[i]},0")
    fi
    #echo "after $i iteration : ${res[@]}"

done
printf '%s\n' "${res[@]}"; echo


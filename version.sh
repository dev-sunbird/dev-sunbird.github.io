echo -e "\n\n\033[1;35m==============================================================\033[39m"
echo -e "\033[1;35m==============# Version File Processing Starts #==============\033[39m"
echo -e "\033[1;35m==============================================================\033[39m"

# Read data from branches.yaml file
versions=$(cat ../_data/branches.yaml | yq .versions)
if [ $? -eq 0 ]; then
    echo -e "\n\033[1;32mSuccessful - Versions file data read successfully !!\033[39m"
else
    echo -e "\n\033[1;31mFAILED !! - Versions file data read failed !!\033[39m"
fi


for version in $(echo $versions | jq -r '.[] | @base64')
do
	_jq() 
    {
    echo ${version} | base64 --decode | jq -r ${1}
    }
    
    branch=$(_jq '.branch')
    branchbuildable=$(_jq '.build')
    
    # if branch is allowed to build then only build
    if [[ "$branchbuildable" == "true" ]]
    then
    echo -e "\n\n\033[1;35m======== Version -> $branch Starts ======== \033[39m"
	
	# read version meta and concate them in single file
    cat $branch/version.yaml >> ../_data/versions.yaml && rm $branch/version.yaml
    if [ $? -eq 0 ]; then
		echo -e "\n\033[1;32mSuccessful - version.yaml file from " $branch" folder successfully appended to _data/versions.yaml file !!\033[39m"
	else
		echo -e "\n\033[1;31mFAILED !! - version.yaml file from " $branch" folder failed to append in _data/versions.yaml file !!\033[39m"
	fi
	
    echo -e "\n\n\033[1;35m========  Version -> $branch Ends ======== \033[39m"
    fi
done 
echo -e "\n\n\033[1;35m==============================================================\033[39m"
echo -e "\033[1;35m===============# Version File Processing Ends #===============\033[39m"
echo -e "\033[1;35m==============================================================\033[39m\n\n"

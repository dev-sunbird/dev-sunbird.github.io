echo -e "\n\n\033[1;35m==============================================================\033[39m"
echo -e "\033[1;35m====================# Fetch Docs Starts  #====================\033[39m"
echo -e "\033[1;35m==============================================================\033[39m"

# Delete and recreate versions.yaml file
rm  _data/versions.yaml && touch _data/versions.yaml
if [ $? -eq 0 ]; then
    echo -e "\n\033[1;32mSuccessful - Versions file regeneration was Successful!!\033[39m"
else
    echo -e "\n\033[1;31mFAILED !! - Versions file regeneration was Failed !!\033[39m"
fi

# Delete and recreate docs folder
rm -rf docs/ && mkdir docs/ && cd docs/
if [ $? -eq 0 ]; then
    echo -e "\n\033[1;32mSuccessful - Docs folder regeneration was Successful!!\033[39m"
else
    echo -e "\n\033[1;31mFAILED !! - Docs folder regeneration was Failed !!\033[39m"
fi

# Read data from branches.yaml file
versions=$(cat ../_data/branches.yaml | yq .versions)
if [ $? -eq 0 ]; then
    echo -e "\n\033[1;32mSuccessful - Branches file data read successfully !!\033[39m"
else
    echo -e "\n\033[1;31mFAILED !! - Branches file data read failed !!\033[39m"
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
    echo -e "\n\033[1;35mFetching Docs Version -" $branch " inside " $branch " folder ... \033[39m\n"
    
    # git clone branch inside branch folder
    git clone -q --depth 1 --branch $branch --single-branch git@github.com:dev-sunbird/docs.git  $branch
    if [ $? -eq 0 ]; then
		echo -e "\n\033[1;32mSuccessful - Fetching version " $branch " was Successful !!\033[39m"
	else
		echo -e "\n\033[1;31mFAILED !! - Fetching version " $branch " was Failed !!\033[39m"
	fi
	
	# cleanup
    rm -rf $branch/.git
    if [ $? -eq 0 ]; then
		echo -e "\n\033[1;32mSuccessful - Deleting .git folder from " $branch " folder was Successful !!\033[39m"
	else
		echo -e "\n\033[1;31mFAILED !! - Deleting .git folder from " $branch " folder was Failed !!\033[39m"
	fi
	
    echo -e "\n\n\033[1;35m========  Version -> $branch Ends ======== \033[39m"
    fi
done 
echo -e "\n\n\033[1;35m==============================================================\033[39m"
echo -e "\033[1;35m=====================# Fetch Docs Ends  #=====================\033[39m"
echo -e "\033[1;35m==============================================================\033[39m\n\n"

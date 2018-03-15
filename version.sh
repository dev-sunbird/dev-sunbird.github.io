echo -e "\n\n\033[1;35m==============================================================\033[39m"
echo -e "\033[1;35m==============# Version File Processing Starts #==============\033[39m"
echo -e "\033[1;35m==============================================================\033[39m"

# Read data from branches.yaml file
versions=$(cat _data/branches.yaml | yq .)
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
    branchname=$(_jq '.name')
    branchbuildable=$(_jq '.build')
    branchlatest=$(_jq '.latest')
    branchpublished=$(_jq '.published')
    branchallowIndexing=$(_jq '.allowIndexing')
    branchreleasedate=$(_jq '.releaseDate')
    
    # if branch is allowed to build then only build
    if [[ "$branchbuildable" == "true" ]]
    then
    echo -e "\n\n\033[1;35m======== Version -> $branch Starts ======== \033[39m"
	
	# read version meta and concate them in single file
	echo "- name: '"$branchname"'" >> _data/versions.yaml
	echo "  branch: '"$branch"'" >> _data/versions.yaml
	echo "  latest: "$branchlatest"" >> _data/versions.yaml
	echo "  published: "$branchpublished"" >> _data/versions.yaml
	echo "  allowIndexing: "$branchallowIndexing"" >> _data/versions.yaml
	echo "  release-date: "$branchreleasedate"" >> _data/versions.yaml
	
    cat docs/$branch/version.yaml >> _data/versions.yaml #&& rm docs/$branch/version.yaml
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

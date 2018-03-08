echo -e "\n\n\033[1;35m==============================================================\033[39m"
echo -e "\033[1;35m======================# Process Starts #======================\033[39m"
echo -e "\033[1;35m==============================================================\033[39m"
rm -rf ../_data/version/ && mkdir ../_data/version/
if [ $? -eq 0 ]; then
    echo -e "\n\033[1;32mSuccessful - Version folder regeneration was Successful!!\033[39m"
else
    echo -e "\n\033[1;31mFAILED !! - Version folder regeneration was Failed !!\033[39m"
fi
rm -rf docs/ && mkdir docs/ && cd docs/
if [ $? -eq 0 ]; then
    echo -e "\n\033[1;32mSuccessful - Docs folder regeneration was Successful!!\033[39m"
else
    echo -e "\n\033[1;31mFAILED !! - Docs folder regeneration was Failed !!\033[39m"
fi
versions=$(cat ../_data/versions.yaml | yq .versions)
if [ $? -eq 0 ]; then
    echo -e "\n\033[1;32mSuccessful - Versions data read successfully !!\033[39m"
else
    echo -e "\n\033[1;31mFAILED !! - Versions data read failed !!\033[39m"
fi
for version in $(echo $versions | jq -r '.[] | @base64')
do
	_jq() 
    {
    echo ${version} | base64 --decode | jq -r ${1}
    }
    versionname=$(_jq '.name')
    versionalias=$(_jq '.alias')
    versionbuildable=$(_jq '.build')
    if [[ "$versionbuildable" == "true" ]]
    then
    echo -e "\n\n\033[1;35m======== Version -> $versionalias Starts ======== \033[39m"
    echo -e "\n\033[1;35mFetching Docs Version -" $versionalias " inside " $versionalias " folder ... \033[39m\n"
    git clone --depth 1 --branch $versionalias --single-branch git@github.com:dev-sunbird/docs.git  $versionalias
    if [ $? -eq 0 ]; then
		echo -e "\n\033[1;32mSuccessful - Fetching version " $versionname " was Successful !!\033[39m"
	else
		echo -e "\n\033[1;31mFAILED !! - Fetching version " $versionname " was Failed !!\033[39m"
	fi
    rm -rf $versionalias/.git
    if [ $? -eq 0 ]; then
		echo -e "\n\033[1;32mSuccessful - Deleting .git folder from " $versionalias " was Successful !!\033[39m"
	else
		echo -e "\n\033[1;31mFAILED !! - Deleting .git folder from " $versionalias " was Failed !!\033[39m"
	fi
    if [[ "$versionname" != "Contributions" ]]
    then
    rm ../_data/version/$versionalias.yaml
    if [ $? -eq 0 ]; then
		echo -e "\n\033[1;32mSuccessful - Deleting old " $versionalias ".yaml was Successful !!\033[39m"
	else
		echo -e "\n\033[1;31mFAILED !! - Deleting old " $versionalias ".yaml was Failed !!\033[39m"
	fi
    mv $versionalias/version.yaml ../_data/version/$versionalias.yaml
    if [ $? -eq 0 ]; then
		echo -e "\n\033[1;32mSuccessful - Creation of " $versionalias ".yaml in _data folder was Successful !!\033[39m"
	else
		echo -e "\n\033[1;31mFAILED !! - Creation of" $versionalias ".yaml in _data folder was Failed !!\033[39m"
	fi
    fi
    echo -e "\n\n\033[1;35m========  Version -> $versionalias Ends ======== \033[39m"
    fi
done 
echo -e "\n\n\033[1;35m==============================================================\033[39m"
echo -e "\033[1;35m=======================# Process Ends #=======================\033[39m"
echo -e "\033[1;35m==============================================================\033[39m\n\n"

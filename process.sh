versions=$(cat _data/versions.yaml | yq .versions)
cd docs/
#echo $versions
for row in $(echo $versions | jq -r '.[] | @base64')
do
	_jq() 
    {
    echo ${row} | base64 --decode | jq -r ${1}
    }
    version=$(_jq '.name')
    versionbuildable=$(_jq '.build')
    if [[ "$versionbuildable" == "true" ]]
    then
    echo $version
    git clone --depth 1 --branch $version --single-branch git@github.com:dev-sunbird/docs.git  $version
    rm -rf $version/.git
    #sidebar=$(cat $version/version.yaml | yq .version.sidebar)
    #echo $sidebar
    fi
done 

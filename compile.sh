echo `date +'[%b %e %R:%S] '` "New connection!" >> /home/hippie/build/auth.log


AUTH=(jamie-ayylmao chron-swaggity crystal-russia kokojo-bobray9 whitefox-hodogg69 scooter-schnoof)

echo
echo
echo "Auth required:"
echo
echo
read input

echo `date +'[%b %e %R:%S] '` "Got input of: $input" >> /home/hippie/build/auth.log

username=`echo $input |awk -F"-" '{print $1}'`
password=`echo $input |awk -F"-" '{print $2}'`

echo `date +'[%b %e %R:%S] '` "Got Username of: $username" >> /home/hippie/build/auth.log
echo `date +'[%b %e %R:%S] '` "Got Password of: $password" >> /home/hippie/build/auth.log

# first, strip underscores
username=${username//_/}
# next, replace spaces with underscores
username=${username// /_}
# now, clean out anything that's not alphanumeric or an underscore
username=${username//[^a-zA-Z0-9_]/}
# finally, lowercase with TR
username=`echo -n $username | tr A-Z a-z`


# first, strip underscores
password=${password//_/}
# next, replace spaces with underscores
password=${password// /_}
# now, clean out anything that's not alphanumeric or an underscore
password=${password//[^a-zA-Z0-9_]/}
# finally, lowercase with TR
password=`echo -n $password | tr A-Z a-z`

echo `date +'[%b %e %R:%S] '` "Sanitized Username down to: $username" >> /home/hippie/build/auth.log
echo `date +'[%b %e %R:%S] '` "Sanitized Password down to: $password" >> /home/hippie/build/auth.log

authcred="$username-$password"


if c=$'\x1E' && p="${c}${authcred} ${c}" && [[  "${AUTH[@]/#/${c}} ${c}" =~ $p ]]; then
	echo `date +'[%b %e %R:%S] '` "Access granted to: $c $p" >> /home/hippie/build/auth.log

	echo Access Granted

	git remote update
	echo "Checking Git"

	LOCAL=$(git rev-parse @{0})
	REMOTE=$(git rev-parse @{u})
	BASE=$(git merge-base @ @{u})

	if [ $LOCAL = $REMOTE ]; then
		echo "Up-to-date"
		exit
	elif [ $LOCAL = $BASE ]; then
		echo "Need to pull"
		git pull
	elif [ $REMOTE = $BASE ]; then
		echo "Need to push"
		exit
	else
		echo "Diverged"
	fi

	echo "Recompiling"

	/home/hippie/hippiestation13/./dm.sh tgstation.dme
else
	echo `date +'[%b %e %R:%S] '` "Access denied" >> /home/hippie/build/auth.log

	echo Go away
fi


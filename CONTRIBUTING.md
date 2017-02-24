### Contributing to the Repository

Before starting your contribution the following pre-requisites have to be met.

1. git(OSX or Linux) and gitBash(Windows)


Go to your directory where you want to work in gitbash and run the following commands.

### Pulling code from the repository

1. Fork the project from isteer_mobile_apps / lifeline_iOS to upi gitlab 

2. Getting the fork to your local
```sh
$git clone git@gitlab.com:<Username>/lifeline_iOS.git
$cd lifeline_iOS
$git remote remote upstream add git@gitlab.com:isteer_mobile_apps/lifeline_iOS.git
```
3. Contributions
```sh 
$cd lifeline_iOS
<Make your changes in an editor of your choice>
$git status
$git add ./<fileame where changes are made>
$git commit -m 'message saying what the change made does'
$git push -u origin master
```
then Going into the gitlab webpage whic points to <username>/lifeline_iOS
and create a merge request assigning it ot the master of the repository.

always pull from upstream using the following command to get the latest code.
```sh
$git pull upstream master
``` 
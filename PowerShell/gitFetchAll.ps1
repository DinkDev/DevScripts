

<#
    .SYNOPSIS

		Demonstrates how to manipulate git via PoSH.

		Based on a given starting folder this will do a git fetch/merge against all subfolders/projects.
		If you are like me you probably have tens of git repos you use daily.  In many cases only a few
		of those you actually make changes to.  For the others you really just want to fetch/merge for
		origin/master, probably daily.

		This script does that for Windows.  It uses posh-git for all git manipulations, but this script
		will install posh-git if needed.

		posh-git:  https://github.com/dahlbyk/posh-git


	.REQUIRES
		msysgit (you should have that already).
		post-git module (this script will download and install it if required)
	.DESCRIPTION
		See the synopsis.
		Hardcoded to the local machine only.
		$RootFolder is set in the code, but can be parameterized.
		Almost no error-handling.  This was written for me and I don't make mistakes.  This script
		can certainly be improved upon, modularized, etc.  I leave that as an exercise for the reader.
		I merely share this code to illustrate a concept (using git from PoSH).

		Make sure you run as Administrator.  I didn't test this under any other security configuration.
		Don't forget: Set-ExecutionPolicy Unrestricted

	.NOTES
		File Name	:	gitFetchAll.ps1
		Author		:	Dave Wentzel
		Prereqs		:	msysgit, Windows
		Copyright	:	None.  Use at your own risk.
	.LINK
		http://www.davewentzel.com

#>

#CHANGEME
#$RootFolder = "C:\git"		# set this using current directory
$RootFolder = Get-Location

#save the current pwd
pushd

[string] $ModuleName
$ModuleName = "posh-git"

function Main {

	loadPoshGit

	#Loop through all folders, but not recursively
	foreach ($subfolder in Get-ChildItem $RootFolder | Where-Object {$_.PSIsContainer} | Sort-Object Name){
		cd (join-path -path $RootFolder -childpath $subfolder.name)

		if (test-path .git){
			echo $subfolder.name
			# if there is another uncommitted let's prompt for that
			# git add -A
			# git commit
			# git push
			git pull
		}
	}

	echo "Done with gitFetchAll.ps1"
	#get us out at the same location we entered
	popd
}

function loadPoshGit {
	#let's see if posh-git is loaded
	if (-not(Get-Module -name $ModuleName))
	{
		#not currently loaded, let's see if it is available to be loaded
		if (Get-Module -ListAvailable | Where-Object {$_.name -eq $name})
		{
			##it is, load it
			Import-Module -Name $ModuleName
		}
		else
		{
			#download it, and load it
			#we use PsGet to do this, it is similar to wget on Unix
			#build the string and pass it to Invoke-Expression
			#this also takes care of the above Import-Module code.  Very nice.
			(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
			install-module $ModuleName
		}
	}
}

Main


$PictureBackUpPath = "F:/backup/Pictures"
$DocumentBackUpPath = "F:/backup/Documents" 
$ErrorAction = 'Ignore'

#algorithm: get each child inside main directories (pictures and documents), check if the backup has that child. Yes- move onto next. No- backup. Each child of pictures should be a directory of the 
#day the pictures were taken. Each child of documents could be different files or directories 

#Get-Childitem $parent | Copy-Item -Destination $BackUpPath 

#pictures backup first 
$desktop = [Environment]::GetFolderPath("Desktop")
$logfile = Join-Path $desktop \backupLog.txt



function Write-Log($num)
{ 
	
    $timeStamp = (Get-Date).toString("yyyy/MM/dd hh:mm:ss")
	if($num -eq 0){
	    $msg = "No Changes needed"
	}
	else{
	    $msg = "$num folders backed up"
	} 
	$line = "$timeStamp $msg" 
	if($logfile){
	    Add-Content $logfile -Value $line
	}
	else{
	    Write-Host "No log file at $logfile" -foregroundcolor black -backgroundcolor white 
		New-Item -Path $logfile -type file 
		if($logfile){
		    Write-Host "Successfully created log file" -foregroundcolor black -backgroundcolor white
		}
	}
	
}

function backupPictures($nm)
{
    $parent = [Environment]::GetFolderPath("MyPictures")
    $par = Get-Childitem $parent
    $xd = Get-Childitem $PictureBackUpPath
    $temp = $false
	# dir is the items in the parent path, looping through each
    foreach($dir in $par){
	    # $xd is the backup directory
        foreach($ch in $xd){
		    $comp = Join-Path $PictureBackUpPath $ch
		    if(Test-Path $comp){
		        if((Get-FileHash $dir).hash -eq (Get-FileHash $comp).hash){
		            $temp = $true
			        Write-Host "They are equal!" -foregroundcolor green
			        Break
		        } 
		        else{
		             Write-Host "$ch" -backgroundcolor green -foregroundcolor red
		        }
		    }
		    else{
		        Write-Host "$comp does not exist" -foregroundcolor red -backgroundcolor yellow
		    }
	    } 
	    #if the folder alreadye exists, print that. Else, copy it over
	    if($temp){
		    Write-Host "temp = $temp" -foregroundcolor black
	        Write-Host "$dir already exists" -foregroundcolor green
		    $temp = $false 
			Write-Host "temp changed to $temp" -foregroundcolor black 
	    }
	    else{ 
	        Write-Host "$dir does not exist in $PictureBackUpPath" -foregroundcolor red
		    $combo = Join-Path $parent $dir
	        Copy-Item -Path $combo -Destination $PictureBackUpPath -Recurse
		    Write-Host "$dir created" -foregroundcolor yellow
		    $nm = $nm
			Write-Host "$numChanged" -foregroundcolor white -backgroundcolor black
	    } 

    } 
}

function backupDocuments
{
    $parent = [Environment]::GetFolderPath("MyDocuments")
	$p = Get-Childitem $parent
    $xd = Get-Childitem $DocumentBackUpPath
    $temp = $false
	#$p is the items in the parent path, looping through each
    foreach($dir in $p){
	    #$xd is the backup directory
        foreach($ch in $xd){
		    $comp = Join-Path $DocumentBackUpPath $ch
		    if(Test-Path $comp){
		        if((Get-FileHash $dir).hash -eq (Get-FileHash $comp).hash){
		            $temp = $true
			        Write-Host "They are equal!" -foregroundcolor green
			        Break
		        } 
		        else{
		             Write-Host "$ch" -backgroundcolor green -foregroundcolor red
		        }
		    }
		    else{
		        Write-Host "$comp does not exist" -foregroundcolor red -backgroundcolor yellow
		    }
	    } 
	    #if the folder already exists, print that. Else, copy it over
	    if($temp){
	        Write-Host "$dir already exists" -foregroundcolor green
		    $temp = $false
	    }
	    else{ 
	        Write-Host "$dir does not exist in $DocumentBackUpPath" -foregroundcolor red
		    $combo = Join-Path $parent $dir
	        Copy-Item -Path $combo -Destination $DocumentBackUpPath -Recurse
		    Write-Host "$dir created" -foregroundcolor yellow
		    $numChanged = $numChanged + 1
			Write-Host "$numChanged" -foregroundcolor white -backgroundcolor black
	    } 

    } 
    
}
$global:numChanged = 0 

backupPictures
backupDocuments
Write-Host "Finished" -foregroundcolor magenta -backgroundcolor yellow
#Write-Log $numChanged

#ii "F:/backup"
#ii $logfile 

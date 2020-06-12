$letters = "A","B","C","D","E","F","G","H" ,"I","J","K","L","M","N","O" ,"P","Q","R","S","T","U","V" ,"W","X","Y","Z"

$PreSuxs = "Charles","Heath","Shire","Bally","Dun","Dune","Cresent","Port" ,"Lin","Water","Chester","Clear","Saint","Annes","Valley","Pool","Sea","Don","Vale","Town","Mouth","Ford" ,"More","Ear","Toll","Sol"

$Sufs = " United"," F.C"," City"," A.F.C"," Athletic"," Town"

function GenTeamNames
{
[int] $rand = Get-Random -Minimum 0 -Maximum $PreSuxs.Count
[int] $rand2 = Get-Random -Minimum 0 -Maximum $PreSuxs.Count
[int] $rand3 = Get-Random -Minimum 0 -Maximum $Sufs.Count

$word1 = $PreSuxs[$rand]
$word2 = $PreSuxs[$rand2]
$word3 = $Sufs[$rand3]
$combo = $word1 + $word2 + $word3
return $combo
}

$staminaDrain=10
[int] $division = 1

$442= new-object psobject -prop @{DF=4;MF=4;FW=2;Name="4-4-2"}
$343= new-object psobject -prop @{DF=3;MF=4;FW=3;Name="3-4-3"}
$541= new-object psobject -prop @{DF=5;MF=4;FW=1;Name="5-4-1"}

$PrevFixtures
$Transfers=New-Object System.Collections.ArrayList
$Teams=New-Object System.Collections.ArrayList
$AOTeams=New-Object System.Collections.ArrayList
$Fixtures=New-Object System.Collections.ArrayList
$Forms=New-Object System.Collections.ArrayList
$Forms+=$442
$Forms+=$343
$Forms+=$541

$TotDFPoints
$TotMFPoints
$TotFWPoints

function GetName($r)
{
	$name = ""
	[int] $rand = Get-Random -Minimum 0 -Maximum 26
	$letter = $letters[$rand]
	[int] $rand = Get-Random -Minimum 0 -Maximum 26
	$letter2 = $letters[$rand]
	$name =$letter+$letter2
	if($r -eq 1)
	{
		[int] $rand = Get-Random -Minimum 0 -Maximum 26
		$letter3 = $letters[$rand]
		$name =$name+$letter3
	}
	return $name
}

function GenTransfers($division)
{
	$transferTargets = GenPlayers -amount 20 -div $division -age 0
	Return $transferTargets
	#CallPlayers -players $transferTargets
}

function GenYouth($division)
{
	$transferTargets = GenPlayers -amount 20 -div $division -age 17
	Return $transferTargets
	#CallPlayers -players $transferTargets
}

function GetForm($inp)
{
	$form = $Forms[$inp]
	return $form
}

function Random($min,$max)
{
	$num = Get-Random -Minimum $min -Maximum $max
	return $num
}

function GetOvr($pos,$gk,$df,$mf,$fw)
{
	if($pos -eq "GK")
	{
		$ovr = ( ($gk+$df)/150 ) * 100
	}
	if($pos -eq "DF")
	{
		$ovr = ( ($df+$mf)/180 ) * 100
	}
	if($pos -eq "MF")
	{
		$ovr = ( ($df+$mf+$fw)/180 ) * 100
	}
	if($pos -eq "FW")
	{
		$ovr = ( ($mf+$fw)/180 ) * 100
	}
	return $ovr
}

function GetStats($pos,$div,$maxStats)
{
	$maximum = 100
	if($div -eq 1)
	{
		$maximum = 75
	}
	if($div -eq 2)
	{
		$maximum = 90
	}
	if($maxStats -eq 70)
	{
		$maximum = 60
	}
	if($pos -eq "GK")
	{
		$minGK=59
		$maxGK=$maximum 
		$minDF=25
		$maxDF=50
		$minMF=0
		$maxMF=10
		$minFW=0
		$maxFW=10
	}
	if($pos -eq "DF")
	{
		$minGK=25
		$maxGK=50
		$minDF=59
		$maxDF=$maximum 
		$minMF=50
		$maxMF=$maximum
		$minFW=0
		$maxFW=20
	}
	if($pos -eq "MF")
	{
		$minGK=0
		$maxGK=10
		$minDF=10
		$maxDF=30
		$minMF=59
		$maxMF=$maximum 
		$minFW=10
		$maxFW=50
	}
	if($pos -eq "FW")
	{
		$minGK=0
		$maxGK=10
		$minDF=0
		$maxDF=20
		$minMF=50
		$maxMF=$maximum
		$minFW=59
		$maxFW=$maximum 
	}
	
	$gk = Random -min $minGK -max $maxGK
	$df = Random -min $minDF -max $maxDF
	$mf = Random -min $minMF -max $maxMF
	$fw = Random -min $minFW -max $maxFW
	
	[int]$ovr = GetOvr -pos $pos -gk $gk -df $df -mf $mf -fw $fw
	$stats= new-object psobject -prop @{Gk=$gk; DF=$df; MF=$mf ;FW=$fw;OVR=$ovr}
	return $stats
}

function GenPlayers($amount,$div,$age)
{
	$ReturnedPlayers=New-Object System.Collections.ArrayList
	for($i=0; $i -lt $amount; $i++ )
	{
		$maxStats = 100
		if($age -ne 17)
		{
			$age =  Random -min 18 -max 35
		}
		
		if($age -eq 17)
		{
			$maxStats=70
		}
		
		if($i -eq 0)
		{
			$pos="GK"
		}
		if($i -gt 0 -And $i -lt 5)
		{
			$pos="DF"
		}
		if($i -gt 5 -And $i -lt 10)
		{
			$pos="MF"
		}
		elseif($i -gt 10)
		{
			$pos="FW"
		}
		$name=""
		$name=GetName
		$stats= GetStats -pos $pos -div $div -maxStats $maxStats
		[int] $value=$stats.OVR / 4
		$player= new-object psobject -prop @{Injury=0;Stamina=100;Age=$age;Value=$value;Pos=$pos; Name=$name; GKPoints=$stats.GK; DFPoints=$stats.DF;MFPoints=$stats.MF; FWPoints=$stats.FW; Ovr=$stats.OVR}
		
		$ReturnedPlayers +=$player	
		#Write-host $player
		
	}
	return $ReturnedPlayers
}


function splitP($players)
{
	$GKo=New-Object System.Collections.ArrayList
	$DFo=New-Object System.Collections.ArrayList
	$MFo=New-Object System.Collections.ArrayList
	$FWo=New-Object System.Collections.ArrayList

	for($i=0; $i -lt $players.Count; $i++ )
	{
		
		#Write-host $players[$i].Name $players[$i].Pos $players[$i].Ovr
		$pos=$players[$i].Pos
		if($pos -eq "GK")
		{
			$GKo+=$players[$i]
		}
		if($pos -eq "DF")
		{
			$DFo+=$players[$i]
		}
		if($pos -eq "MF")
		{
			$MFo+=$players[$i]
		}
		if($pos -eq "FW")
		{
			$FWo+=$players[$i]
		}
		
	}
	$GKo = $GKo | Sort-Object {$_.Ovr} -descending
	$DFo = $DFo | Sort-Object {$_.Ovr} -descending
	$MFo = $MFo | Sort-Object {$_.Ovr} -descending
	$FWo = $FWo | Sort-Object {$_.Ovr} -descending
	$split = $team= new-object psobject -prop @{GK=$GKo;DF=$DFo;MF=$MFo;FW=$FWo}
	return $split
}


function GenLineup($form,$split)
{	
	$Lineup=New-Object System.Collections.ArrayList
	
	for($i=0; $i -lt 1; $i++ )
	{
		$Lineup+=$split.GK[$i]
	}
	for($i=0; $i -lt $form.DF; $i++ )
	{	
		$Lineup+=$split.DF[$i]
	}
	for($i=0; $i -lt $form.MF; $i++ )
	{
		$Lineup+=$split.MF[$i]
	}
	for($i=0; $i -lt $form.FW; $i++ )
	{
		$Lineup+=$split.FW[$i]
	}
	
	return $lineup
}

function CallLineup($lineup)
{
	for($i=0; $i -lt $lineup.Count; $i++ )
	{
		Write-host $lineup[$i].Name $Lineup[$i].Pos $Lineup[$i].Ovr
	}
}

function GetPosPoints($num,$split,$pos,$gk)
{
	if($pos -eq "DF")
	{
		for($i=0; $i -lt $num; $i++ )
		{	
			$calPoints= ($split.DF[$i].DFPoints + $gk)/2
			#add in keeper as well
			$totalPoints+=$calPoints
		}
		[int] $overall = ($totalPoints / $num +1)
	}
	if($pos -eq "MF")
	{
		for($i=0; $i -lt $num; $i++ )
		{	
			$totalPoints+=$split.MF[$i].MFPoints
		}
		[int] $overall = ($totalPoints / $num )
	}
	if($pos -eq "FW")
	{
		for($i=0; $i -lt $num; $i++ )
		{	
			$totalPoints+=$split.FW[$i].FWPoints
		}
		[int] $overall = ($totalPoints / $num )
	}
	
	return $overall
}

function CallPlayers($players)
{
	for($i=0; $i -lt $players.count; $i++ )
	{
		Write-host $i ")" $players[$i].Name "Stm:"$players[$i].Stamina "Inj:"$players[$i].Injury "Pos:"$players[$i].Pos "Ovr:"$players[$i].Ovr "Age:"$players[$i].Age
	}
}

function GetSubs($players,$lineup)
{
	$subs=New-Object System.Collections.ArrayList
	foreach($player in $players)
	{
		if($lineup.Contains($player))
		{
		}
		else
		{
			$subs+=$player
		}
	}
	return $subs
}

function MakeSubs($players,$lineup,$subs,$out,$in)
{	
	$playerOut=$lineup[$out]
	$playerIn=$subs[$in]
	
	$lineup[$out]=$playerIn
	$subs[$in]=$playerOut
	
	$changes= new-object psobject -prop @{Lineup=$lineup;Subs=$subs}
	Return $changes
}

function Subs($team)
{
	$p1 = Read-Host "out?"
	$p2 = Read-Host "in?"
	$changes= MakeSubs -players $team.Players -lineup $team.Lineup -subs $team.Subs -out $p1 -in $p2	
	$team.Lineup = $changes.lineup
	$team.Subs = $changes.subs
	$newSplitLineup = splitP -players $team.Lineup
	
	$team.DFPoints = GetPosPoints -num $team.NumDf -split $newSplitLineup -pos "DF" -gk $team.Lineup[0].GKPoints
	$team.MFPoints = GetPosPoints -num $team.NumMf -split $newSplitLineup -pos "MF" -gk $team.Lineup[0].GKPoints
	$team.FWPoints = GetPosPoints -num $team.NumFw -split $newSplitLineup -pos "FW" -gk $team.Lineup[0].GKPoints
	
	foreach($sub in $team.Subs)
	{
		if($sub -eq $null)
		{
			#Remove null player
			$team.Subs = { $team.Subs }.Invoke()
			#Remove item by reference.
			$team.Subs.Remove($sub)
		}
	}
	
	return $team
}

function ShowLineup($team)
{
	if($team.Formation.Name -eq "4-4-2")
	{
		Write-Host "---------"$team.Lineup[0].Pos"-------"
		Write-Host "---------"$team.Lineup[0].Name"-------"
		Write-Host "---------"$team.Lineup[0].Ovr"-------"
		Write-Host "--------- 00 -------"
		Write-Host "--------------------"
		
		Write-Host $team.Lineup[1].Pos"--"$team.Lineup[2].Pos"--"$team.Lineup[3].Pos"--"$team.Lineup[4].Pos
		Write-Host $team.Lineup[1].Name"--"$team.Lineup[2].Name"--"$team.Lineup[3].Name"--"$team.Lineup[4].Name
		Write-Host $team.Lineup[1].Ovr"--"$team.Lineup[2].Ovr"--"$team.Lineup[3].Ovr"--"$team.Lineup[4].Ovr
		Write-Host "01 -- 02 -- 03 -- 04"
		Write-Host "--------------------"

		Write-Host $team.Lineup[5].Pos"--"$team.Lineup[6].Pos"--"$team.Lineup[7].Pos"--"$team.Lineup[8].Pos
		Write-Host $team.Lineup[5].Name"--"$team.Lineup[6].Name"--"$team.Lineup[7].Name"--"$team.Lineup[8].Name
		Write-Host $team.Lineup[5].Ovr"--"$team.Lineup[6].Ovr"--"$team.Lineup[7].Ovr"--"$team.Lineup[8].Ovr
		Write-Host "05 -- 06 -- 07 -- 08"
		Write-Host "--------------------"

		Write-Host "-----"$team.Lineup[9].Pos"--"$team.Lineup[10].Pos"-----"
		Write-Host "-----"$team.Lineup[9].Name"--"$team.Lineup[10].Name"-----"
		Write-Host "-----"$team.Lineup[9].Ovr"--"$team.Lineup[10].Ovr"-----"
		Write-Host "----- 09 -- 10 -----"
	}
	if($team.Formation.Name -eq "3-4-3")
	{
		Write-Host "--------"$team.Lineup[0].Pos"--------"
		Write-Host "--------"$team.Lineup[0].Name"--------"
		Write-Host "--------"$team.Lineup[0].Ovr"--------"
		Write-Host "-------- 00 --------"
		Write-Host "--------------------"
		
		Write-Host "--"$team.Lineup[1].Pos"--"$team.Lineup[2].Pos"--"$team.Lineup[3].Pos"--"
		Write-Host "--"$team.Lineup[1].Name"--"$team.Lineup[2].Name"--"$team.Lineup[3].Name"--"
		Write-Host "--"$team.Lineup[1].Ovr"--"$team.Lineup[2].Ovr"--"$team.Lineup[3].Ovr"--"
		Write-Host "-- 01 -- 02 -- 03 --"
		Write-Host "--------------------"
		
		Write-Host $team.Lineup[4].Pos"--"$team.Lineup[5].Pos"--"$team.Lineup[6].Pos"--"$team.Lineup[7].Pos
		Write-Host $team.Lineup[4].Name"--"$team.Lineup[5].Name"--"$team.Lineup[6].Name"--"$team.Lineup[7].Name
		Write-Host $team.Lineup[4].Ovr"--"$team.Lineup[5].Ovr"--"$team.Lineup[6].Ovr"--"$team.Lineup[7].Ovr
		Write-Host "04 -- 05 -- 06 -- 07"
		Write-Host "--------------------"
		
		Write-Host "--"$team.Lineup[8].Pos"--"$team.Lineup[9].Pos"--"$team.Lineup[10].Pos"--"
		Write-Host "--"$team.Lineup[8].Name"--"$team.Lineup[9].Name"--"$team.Lineup[10].Name"--"
		Write-Host "--"$team.Lineup[8].Ovr"--"$team.Lineup[9].Ovr"--"$team.Lineup[10].Ovr"--"
		Write-Host "-- 08 -- 09 -- 10 --"
	}
	if($team.Formation.Name -eq "5-4-1")
	{
		Write-Host "---------"$team.Lineup[0].Pos"---------"
		Write-Host "---------"$team.Lineup[0].Name"---------"
		Write-Host "---------"$team.Lineup[0].Ovr"---------"
		Write-Host "--------- 00 ---------"
		Write-Host "----------------------"
		
		Write-Host $team.Lineup[1].Pos"-"$team.Lineup[2].Pos"-"$team.Lineup[3].Pos"-"$team.Lineup[4].Pos"-"$team.Lineup[5].Pos
		Write-Host $team.Lineup[1].Name"-"$team.Lineup[2].Name"-"$team.Lineup[3].Name"-"$team.Lineup[4].Name"-"$team.Lineup[5].Name
		Write-Host $team.Lineup[1].Ovr"-"$team.Lineup[2].Ovr"-"$team.Lineup[3].Ovr"-"$team.Lineup[4].Ovr"-"$team.Lineup[5].Ovr
		Write-Host "01 - 02 - 03 - 04 - 05"
		Write-Host "----------------------"
		
		Write-Host $team.Lineup[6].Pos"---"$team.Lineup[7].Pos"--"$team.Lineup[8].Pos"---"$team.Lineup[9].Pos
		Write-Host $team.Lineup[6].Name"---"$team.Lineup[7].Name"--"$team.Lineup[8].Name"---"$team.Lineup[9].Name
		Write-Host $team.Lineup[6].Ovr"---"$team.Lineup[7].Ovr"--"$team.Lineup[8].Ovr"---"$team.Lineup[9].Ovr
		Write-Host "06 --- 07 -- 08 --- 09"
		Write-Host "----------------------"
		
		Write-Host "---------"$team.Lineup[10].Pos"---------"
		Write-Host "---------"$team.Lineup[10].Name"---------"
		Write-Host "---------"$team.Lineup[10].Ovr"---------"
		Write-Host "--------- 10 ---------"	
	}
	Write-host "Points [ DF:" $team.DFPoints "MF:" $team.MFPoints "FW:" $team.FWPoints "]"	
}

function GenTeam ($name,$id,$div)
{
	[int] $ran = Get-Random -Minimum 0 -Maximum 2
	$form=GetForm -inp $ran
	$players = GenPlayers -amount 15 -div $div
	$split = splitP -players $players
	$lineup = GenLineup -form $form -split $split
	
	$splitLineup = splitP -players $lineup
	
	$subs = GetSubs -players $players -lineup $lineup
	
	$DFTotal = GetPosPoints -num $form.DF -split $splitLineup -pos "DF" -gk $players[0].GKPoints
	$MFTotal = GetPosPoints -num $form.MF -split $splitLineup -pos "MF" -gk $players[0].GKPoints
	$FWTotal = GetPosPoints -num $form.FW -split $splitLineup -pos "FW" -gk $players[0].GKPoints
	
	$team = new-object psobject -prop @{Tactic=1;staminaDrain=10;Streak=0;Security=50;SE=3;SF=0;Div=$div;Id=$id;Funds=50;Goals=0; Subs=$subs; Players=$players;Formation=$form ;Lineup=$lineup; Name=$name; DFPoints=$DFTotal; MFPoints=$MFTotal ;FWPoints=$FWTotal; NumGk=1; NumDf=$form.DF ; NumMf=$form.Mf; NumFw=$form.Fw;Wins=0;Draws=0;Losses=0;GamesPlayed=0;TeamsPlayed=New-Object System.Collections.ArrayList}
	
	return $team
}

###########################################################

function GetChances($team, $teamB)
{
	$max= $team.MFPoints / $teamB.NumDf
	[int] $chances = Get-Random -Minimum $team.NumMf -Maximum $max
	$diff = $team.FWPoints - $teamB.DFPoints
	$exChances = $diff / 5
	$chances = $chances + $exChances
	return $chances
}

function GetGoals($chances, $team, $teamB)
{
	$goals = 0
	$max= $team.MFPoints / $teamB.NumDf
	[int] $target = Get-Random -Minimum $team.NumMf -Maximum $max
	
	$totattempts=New-Object System.Collections.ArrayList
	
	for($attempts=0; $attempts -lt $chances; $attempts++ )
	{
		#Clear-host
		$chancenum = $attempts + 1
		[int] $roll = Get-Random -Minimum $team.NumMf -Maximum $max
		if($roll -eq $target)
		{
			$goals+=1
		}
	}
	Read-Host "Continue..."
	
}

function ShowMatchLineups($teamA,$teamB)
{
Write-host $teamA.Name
	ShowLineup -team $teamA
	Write-host ""
	Write-host $teamB.Name
	
	$newSplitLineup = splitP -players $teamB.Lineup
	
	$teamB.DFPoints = GetPosPoints -num $teamB.NumDf -split $newSplitLineup -pos "DF" -gk $teamB.Lineup[0].GKPoints
	$teamB.MFPoints = GetPosPoints -num $teamB.NumMf -split $newSplitLineup -pos "MF" -gk $teamB.Lineup[0].GKPoints
	$teamB.FWPoints = GetPosPoints -num $teamB.NumFw -split $newSplitLineup -pos "FW" -gk $teamB.Lineup[0].GKPoints
	
	ShowLineup -team $teamB
	Read-Host "Return?"
}
function PlayMatch($teamA,$teamB)
{
	$chancesA = GetChances -team $teamA -teamB $teamB
	$chancesB = GetChances -team $teamB -teamB $teamA
####################################################################################	
	$goalsA = 0
	$max= $teamA.MFPoints / $teamB.NumDf
	[int] $target = Get-Random -Minimum $teamA.NumMf -Maximum $max
		
	for($attempts=0; $attempts -lt $chancesA; $attempts++ )
	{
		$chancenum = $attempts + 1
		[int] $roll = Get-Random -Minimum $teamA.NumMf -Maximum $max
		if($roll -eq $target)
		{
			$goalsA+=1
		}
	}
####################################################################################		
	$goalsB = 0
	$max= $teamB.MFPoints / $teamA.NumDf
	[int] $target = Get-Random -Minimum $teamB.NumMf -Maximum $max
		
	for($attempts=0; $attempts -lt $chancesB; $attempts++ )
	{
		$chancenum = $attempts + 1
		[int] $roll = Get-Random -Minimum $teamB.NumMf -Maximum $max
		if($roll -eq $target)
		{
			$goalsB+=1
		}
	}
	
#####################################################################################
	$totalAttempts=New-Object System.Collections.ArrayList
	
	for($i=0; $i -lt $chancesA; $i++ )
	{
		$a= new-object psobject -prop @{Team=$teamA.Name;Goal=0;Num=$i;Com="but its a miss!"}
		$totalAttempts +=$a
	}
	if($goalsA -ne 0)
	{
		for($i=0; $i -lt $goalsA; $i++ )
		{
			$a= new-object psobject -prop @{Team=$teamA.Name;Goal=1;Num=$i;Com="and its a GOAL!"}
			$totalAttempts +=$a
			$teamA.Goals ++
		}
	}
	for($i=0; $i -lt $chancesB; $i++ )
	{
		$a= new-object psobject -prop @{Team=$teamB.Name;Goal=0;Num=$i;Com="but its a miss!"}
		$totalAttempts +=$a
	}
	if($goalsB -ne 0)
	{
		for($i=0; $i -lt $goalsB; $i++ )
		{
			$a= new-object psobject -prop @{Team=$teamB.Name;Goal=1;Num=$i;Com="and its a GOAL!"}
			$totalAttempts +=$a
			$teamB.Goals ++
		}
	}
	##if user
	$totalAttempts = $totalAttempts | Sort-Object {Get-Random}
	$teamAGoals=0
	$teamBGoals=0
	[int] $mins = 90 / $totalAttempts.length
	[int] $mins2 = $mins
	foreach($att in $totalAttempts)
	{
		Clear-host
		Write-host $mins2
		$mins2 += $mins
		Write-host $teamAGoals "-" $teamBGoals
		Write-host "Chance for" $att.Team "..."
		Write-host $att.Com
		
		if($att.Goal -eq 1)
		{
			if($att.Team -eq $teamA.Name)
			{
				$teamAGoals++
			}
			else
			{
				$teamBGoals++
			}
		Write-host $teamAGoals "-" $teamBGoals
		}
		Read-host "Continue?"
		
	}	
	##
#######################################################################	
	
	$teamA.Goals = $goalsA
	$teamB.Goals = $goalsB
	##if user##
	Write-Host "Final Score"
	Write-Host $teamA.Name $teamA.Goals "-" $teamB.Goals $teamB.Name 
	##if user##
	if($teamA.Goals -gt $teamB.Goals)
	{
		$teamA.Wins ++
		$teamB.Losses ++
		
		if($teamA.Streak -ge 0)
		{
			$teamA.Streak = $teamA.Streak+1
		}
		else
		{
			$teamA.Streak = 0
		}
		
	}
	elseif($teamB.Goals -gt $teamA.Goals)
	{
		$teamA.Losses ++
		$teamB.Wins ++
		
		if($teamA.Streak -le 0)
		{
			$teamA.Streak = $teamA.Streak-1
		}
		else
		{
			$teamA.Streak = 0
		}
	}
	else
	{
		$teamA.Draws ++
		$teamB.Draws ++
		$teamA.Streak = $teamA.Streak=0
	}
	$teamA.GamesPlayed ++
	$teamB.GamesPlayed ++
	
	foreach($p in $teamA.Lineup)
	{
		$p.Stamina -= $TeamA.staminaDrain
		if($p.Stamina -lt 50)
		{
			[int] $rand = Get-Random -Minimum 1 -Maximum 25
			#write-host $rand
			if($rand -eq 15)
			{
				[int] $outFor = Get-Random -Minimum 1 -Maximum 5
				$p.Injury=$outFor
				Write-Host $p.Name "picked up an injury for" $outFor "games"
			}
		}
		#Write-host $p.Name $p.Stamina
	}
		
	#Write-host "Subs"
	foreach($p in $teamA.Subs)
	{
		$p.Stamina = 100
		if($p.Injury -ne 0)
		{
			$p.Injury --
		}
		#Write-host $p.Name $p.Stamina
	}
	#Read-host "End"
	$teamA.Security = $teamA.Streak + $teamA.Security 
	return $teamA
}

################################################################
function GetResult($teamA,$teamB)
{
	$chancesA = GetChances -team $teamA -teamB $teamB
	$chancesB = GetChances -team $teamB -teamB $teamA
####################################################################################	
	$goalsA = 0
	$max= $teamA.MFPoints / $teamB.NumDf
	[int] $target = Get-Random -Minimum $teamA.NumMf -Maximum $max
		
	for($attempts=0; $attempts -lt $chancesA; $attempts++ )
	{
		$chancenum = $attempts + 1
		[int] $roll = Get-Random -Minimum $teamA.NumMf -Maximum $max
		if($roll -eq $target)
		{
			$goalsA+=1
		}
	}
####################################################################################		
	$goalsB = 0
	$max= $teamB.MFPoints / $teamA.NumDf
	[int] $target = Get-Random -Minimum $teamB.NumMf -Maximum $max
		
	for($attempts=0; $attempts -lt $chancesB; $attempts++ )
	{
		$max= $teamB.MFPoints / $teamA.NumDf
		$chancenum = $attempts + 1
		[int] $roll = Get-Random -Minimum $teamB.NumMf -Maximum $max
		if($roll -eq $target)
		{
			$goalsB+=1
		}
	}
	
#####################################################################################
	$totalAttempts=New-Object System.Collections.ArrayList
	
	for($i=0; $i -lt $chancesA; $i++ )
	{
		$a= new-object psobject -prop @{Team=$teamA.Name;Goal=0;Num=$i;Com="but its a miss!"}
		$totalAttempts +=$a
	}
	if($goalsA -ne 0)
	{
		for($i=0; $i -lt $goalsA; $i++ )
		{
			$a= new-object psobject -prop @{Team=$teamA.Name;Goal=1;Num=$i;Com="and its a GOAL!"}
			$totalAttempts +=$a
			$teamA.Goals ++
		}
	}
	for($i=0; $i -lt $chancesB; $i++ )
	{
		$a= new-object psobject -prop @{Team=$teamB.Name;Goal=0;Num=$i;Com="but its a miss!"}
		$totalAttempts +=$a
	}
	if($goalsB -ne 0)
	{
		for($i=0; $i -lt $goalsB; $i++ )
		{
			$a= new-object psobject -prop @{Team=$teamB.Name;Goal=1;Num=$i;Com="and its a GOAL!"}
			$totalAttempts +=$a
			$teamB.Goals ++
		}
	}
#######################################################################	
	
	$teamA.Goals = $goalsA
	$teamB.Goals = $goalsB
	if($teamA.Goals -gt $teamB.Goals)
	{
		$teamA.Wins ++
		$teamB.Losses ++
	}
	elseif($teamB.Goals -gt $teamA.Goals)
	{
		$teamA.Losses ++
		$teamB.Wins ++
	}
	else
	{
		$teamA.Draws ++
		$teamB.Draws ++
	}
	Write-host $teamA.Name $teamA.Goals "-" $teamB.Goals $teamB.Name 
	$teamA.GamesPlayed ++
	$teamB.GamesPlayed ++
}
################################################################

function CallTeams()
{	
	$i=0
	foreach($team in $teams)
	{
		Write-host $i ")" $team.Id $team.Name "Won:" $team.Wins "Drew:" $team.Draws "Lost:" $team.Losses "Played:" $team.GamesPlayed
		$i++
	}
}
################################################################

function GenTable()
{
	Clear-Host
	$table=New-Object System.Collections.ArrayList
	foreach($team in $teams)
	{
		$points=0
		$WPoints = $team.Wins * 3
		$DPoints = $team.Draws
		$points = $WPoints + $DPoints
		$Ti= new-object psobject -prop @{Points=$points;Name=$team.Name;Played=$team.GamesPlayed}
		$table += $Ti
	}
	$pos = 1
	$table = $table | Sort-Object {$_.Points} -descending
	Write-Host "POS PTS FIX  "
	foreach($team in $table)
	{		
		if($pos -lt 10)
		{
			Write-Host  $pos " |" $team.Points"|"$team.Played"|"$team.Name
		} 
		else
		{
			Write-Host  $pos" |" $team.Points"|"$team.Played"|"$team.Name

		}
		$pos +=1
	}
	Read-Host "Return?"
	Return $table
}

################################################################
function NewSeason()
{
	$table=New-Object System.Collections.ArrayList
	foreach($team in $teams)
	{
		$points=0
		$WPoints = $team.Wins * 3
		$DPoints = $team.Draws
		$points = $WPoints + $DPoints
		$Ti= new-object psobject -prop @{Id=$team.Id;Points=$points;Name=$team.Name;Played=$team.GamesPlayed}
		$table += $Ti
	}
	$table = $table | Sort-Object {$_.Points} -descending	
	#Clear-host
	$playerTeam = $teams[0]
	
	Write-Host "Champions are" $table[0].Name "!!!"

	foreach($team in $Teams)
	{
		$team.GamesPlayed = 0
		$team.Wins = 0
		$team.Losses = 0
		$team.Draws = 0
	}
	Read-host "Continue?"
	return $table[0]
}

function GetTable()
{
	$table=New-Object System.Collections.ArrayList
	foreach($team in $teams)
	{
		$points=0
		$WPoints = $team.Wins * 3
		$DPoints = $team.Draws
		$points = $WPoints + $DPoints
		$Ti= new-object psobject -prop @{Id=$team.Id;Points=$points;Name=$team.Name;Played=$team.GamesPlayed}
		$table += $Ti
	}
	$table = $table | Sort-Object {$_.Points} -descending	
	return $table
}

function GetLastPlace()
{
	$table=New-Object System.Collections.ArrayList
	foreach($team in $teams)
	{
		$points=0
		$WPoints = $team.Wins * 3
		$DPoints = $team.Draws
		$points = $WPoints + $DPoints
		$Ti= new-object psobject -prop @{Id=$team.Id;Points=$points;Name=$team.Name;Played=$team.GamesPlayed}
		$table += $Ti
	}
	$table = $table | Sort-Object {$_.Points} -descending
	clear-host
	return $table[9]
}
################################################################

function RemoveTeam($r)
{
		##Transfers##
		$teams = { $teams }.Invoke()
		#Remove item by index.
		$teams.RemoveAt($r)
		
		foreach($t in $teams)
		{
			Write-host $t.Name			
		}
		
		Read-host "?"
		
		return $teams
}

function RemovePlayer($players,$r)
{
		##Transfers##
		$players = { $players }.Invoke()
		#Remove item by index.
		$players.RemoveAt($r)
		return $players
}

################################################################
function GetFixtures($Fixtures)
{
		$SF=$teams[0].SF
		$SE=$teams[0].SE
		if($week -ne 1)
		{
			$SF=$SF+4
			$teams[0].SF=$SF
			$SE=$SE+4
			$teams[0].SE=$SE
		}
		
		#Write-host "W" $week "SF" $SF "SE" $SE $teams[0].Name "V" $teams[$week].Name
		
		for($f=$SF;$f -le $SE; $f++)
		{
			#Write-host $Fixtures[$f].IdA $teams[$Fixtures[$f].IdA].Name "v" $Fixtures[$f].IdB $teams[$Fixtures[$f].IdB].Name
			#Play Match
			GetResult -teamA $teams[$Fixtures[$f].IdA] -teamB $teams[$Fixtures[$f].IdB]
		}
		#Read-host "Return?"
}
################################################################

function TransferPer($teamA,$trans,$per)
{
		#####################################################################
		##Player Offers
		#####################################################################
		
		Write-Host "Offers from other teams..."
		[int] $rand1 = Get-Random -Minimum 1 -Maximum $teams[0].Players.Count
		$offeredPlayer=$teams.Players[$rand1]
		
		[int] $rand = Get-Random -Minimum 1 -Maximum 9
		$offeringTeam=$teams[$rand]
		
		$myPlayers=$teams[0].Players | Sort-Object {$_.Ovr} -descending	
		#write-Host $myPlayers[0]
		
		[int] $bonus = Get-Random -Minimum 0 -Maximum 5
		$offer=$myPlayers[$rand1].Value + $bonus
		Write-host "Offer of" $offer "From" $offeringTeam.Name "For" $myPlayers[$rand1].Name $myPlayers[$rand1].Pos "Age)" $myPlayers[$rand1].Age "Ovr)" $myPlayers[$rand1].Ovr
		$res=Read-Host "Accept?"
		
		if($res -eq "y")
		{
			Read-host "Offer Accepted"			
			##REMOVE PLAYER FROM TEAM
			$teams[0].Funds +=$offer		
			if($teams[0].Lineup.Contains( $myPlayers[$rand1] ) )
			{
				$teams[0].Lineup = { $teams[0].Lineup }.Invoke()
				#Remove item by index.
				$teams[0].Lineup.Remove( $myPlayers[0] )					
				$teams[0].Lineup+= $teams[0].Subs[0]
				$teams[0].Subs = { $teams[0].Subs }.Invoke()
				#Remove item by index.
				$teams[0].Subs.RemoveAt(0)
			}
			if($teams[0].Subs -contains $myPlayers[$rand1] )
			{
				$teams[0].Subs = { $teams[0].Subs }.Invoke()
				#Remove item by ref.
				$teams[0].Subs.Remove( $myPlayers[$rand1] )
			}
			$teams[0].Players = { $teams[0].Players }.Invoke()
			#Remove item by ref.
			$teams[0].Players.Remove( $myPlayers[$rand1] )
			
			##ADD PLAYER TO NEW TEAM
			$pox=0
			$offerId=0
			foreach($t in $teams)
			{
				if($t.Id -eq $offeringTeam.Id)
				{
					$offerId=$pox
				}
				else
				{
					$pox ++
				}
			}
			#Read-host "offer id" $offeringTeam.Id
			#Read-host "offer id" $offerId
			$teams[$offerId].Players+=$myPlayers[$rand1]
			
			#Split players into pos
			$split = splitP -players $teams[$offerId].Players
			
			#gen starting 11
			$lineup = GenLineup -form $teams[$offerId].Formation -split $split
			
			$splitLineup = splitP -players $lineup
			
			$subs = GetSubs -players $teams[$offerId].Players -lineup $lineup
			
			$DFTotal = GetPosPoints -num $teams[$offerId].Formation.DF -split $splitLineup -pos "DF" -gk $teams[$offerId].Players[0].GKPoints
			$MFTotal = GetPosPoints -num $teams[$offerId].Formation.MF -split $splitLineup -pos "MF" -gk $teams[$offerId].Players[0].GKPoints
			$FWTotal = GetPosPoints -num $teams[$offerId].Formation.FW -split $splitLineup -pos "FW" -gk $teams[$offerId].Players[0].GKPoints
			##Update team
			$teams[$offerId].Lineup=$lineup
			$teams[$offerId].Subs=$subs
			$teams[$offerId].DFPoints=$DFTotal
			$teams[$offerId].MFPoints=$MFTotal
			$teams[$offerId].FWPoints=$FWTotal
			
		}
		else
		{
			Read-host "Offer Rejected"
		}
		
		#####################################################################
	$next=0
	while($next -eq 0)
	{
		Clear-host
		Write-Host "Week)" $per "Funds)" $teamA.Funds
		Write-Host "1) See Teams"
		Write-Host "2) Transfers"
		Write-Host "3) Next"
		$select = Read-Host "?"
		
		if($select -eq 1)
		{
			Clear-Host
			CallTeams
			$inp=Read-Host "View"
			if($inp -ne 0)
			{
				CallPlayers -players $teams[$inp].Players
				$inp2=Read-Host "View"
				$price = $teams[$inp].Players[$inp2].Value +5
				$ans=Read-Host "(y/n) Are you sure you want to buy for?" $price 
				if($ans -eq "y")
				{
					if($teams[0].Funds -gt $price)
					{
						$teams[0].Funds -=$price
						
						#Write-host $teams[$inp].Players[$inp2]
						$nName = GetName
						
						$XName = GetName
						$playerHolds =GenPlayers -amount 1 -div $division
						
						##Add player to my team
						$playerHolds[0].Name=$teams[$inp].Players[$inp2].Name
						$playerHolds[0].Pos=$teams[$inp].Players[$inp2].Pos
						$playerHolds[0].GKPoints=$teams[$inp].Players[$inp2].GKPoints
						$playerHolds[0].DFPoints=$teams[$inp].Players[$inp2].DFPoints
						$playerHolds[0].MFPoints=$teams[$inp].Players[$inp2].MFPoints
						$playerHolds[0].FWPoints=$teams[$inp].Players[$inp2].FWPoints
						$playerHolds[0].Ovr=$teams[$inp].Players[$inp2].Ovr
						$playerHolds[0].Value=$teams[$inp].Players[$inp2].Value
						$teams[0].Players+=$playerHolds[0]
						$teams[0].Subs+=$playerHolds[0]
						$newStats= GetStats -pos $teams[$inp].Players[$inp2].Pos -div $division
						
						##Replace old player with new player	
						[int] $newValue=$newStats.OVR / 4			
						$teams[$inp].Players[$inp2].Name=$nName 
						$teams[$inp].Players[$inp2].GKPoints=$newStats.GK
						$teams[$inp].Players[$inp2].DFPoints=$newStats.DF
						$teams[$inp].Players[$inp2].MFPoints=$newStats.MF
						$teams[$inp].Players[$inp2].FWPoints=$newStats.FW
						$teams[$inp].Players[$inp2].Ovr=$newStats.OVR
						$teams[$inp].Players[$inp2].Value=$newValue

						Write-Host "Player Transfered"
						return $Transfers
					}
					else{Write-Host "Not Enough Funds, Transfer Canceled"}
				}
				else{Write-Host "Transfer canceled"}
			}	
			Read-Host "Return?"
		}
		if($select -eq 2)
		{	
			$SB=Read-Host "Sell/Buy?"
			if($SB -eq "s")
			{
				Clear-Host
				Write-host "Sell"
				CallPlayers -players $teams[0].Players
				$r=Read-Host "Sell?"		
				if($r -ne "n")
				{
					$price=$teams[0].Players[$r].Value - 5
					Write-Host "Sold" $teams[0].Players[$r].Name "For" $price
					$teams[0].Funds += $price
									
					if($teams[0].Lineup.Contains($teams[0].Players[$r]) )
					{
						$teams[0].Lineup = { $teams[0].Lineup }.Invoke()
						#Remove item by index.
						$teams[0].Lineup.Remove($teams[0].Players[$r])
						
						$teams[0].Lineup+= $teams[0].Subs[0]
						$teams[0].Subs = { $teams[0].Subs }.Invoke()
						#Remove item by index.
						$teams[0].Subs.RemoveAt(0)
					}
					if($teams[0].Subs -contains $teams[0].Players[$r])
					{
						$teams[0].Subs = { $teams[0].Subs }.Invoke()
						#Remove item by ref.
						$teams[0].Subs.Remove($teams[0].Players[$r])
					}
					$teams[0].Players = RemovePlayer -players $teams[0].Players -r $r
				}
				else
				{
					Write-host "No one sold"
				}
			}
			
			#BUY#
			else
			{
				Clear-Host
				Write-host "Buy"
				CallPlayers -players $Transfers
				$pur=Read-Host "Buy?"
				$playertobuy=$Transfers[$pur] 
				$price = $playertobuy.Value + 5
				Write-host "Buy for " $price
				$sure=Read-Host "Are you sure? Y/N"
				if($sure -eq "y")
				{
					$x = $teams[0].Funds - $price
					if($x -gt 0)
					{
						$teams[0].Players += $playertobuy
						$teams[0].Subs += $playertobuy
						$teams[0].Funds -=$playertobuy.Value
						
						$TransfersU = { $Transfers }.Invoke()
						#Remove item by index.
						$TransfersU.RemoveAt($pur)
						Write-Host "Bought Player"
						Write-Host $Transfers.count
						Write-Host $TransfersU.count
						$Transfers = $TransfersU
						return $Transfers
					}
					else
					{
						Write-host "You do not have enough to buy this player"
					}
				}
				else
				{
					Write-host "Player was not bought"
				}
			}
			Read-Host "Return?"
		}
		if($select -eq 3)
		{
			$next=1
			Read-Host "Continue?"
			return $Transfers
		}
	}
	
}

################################################################
#MENU#
function Menu($teamA,$week,$trans,$fixtures)
{
	Clear-Host
	Write-Host "Week)" $week "Season)" $season "Division)" $division "Security)" $teams[0].Security "Streak)" $teams[0].Streak
	Write-Host "1) See Squad"
	Write-Host "2) Select Formation"
	Write-Host "3) Make Changes"
	Write-Host "4) See Lineup"
	Write-Host "5) See Funds"
	Write-Host "6) Tactics"
	Write-Host "7) Play Match"
	Write-Host "8) See Table"
	Write-Host "9) Youth"
	$select = Read-Host "?"
		
	if($select -eq 0)
	{	
		ShowFixtures
		Read-Host

	}
	
	if($select -eq 1)
	{
		Clear-Host
		Write-host "Squad"
		CallPlayers -players $teamA.Players
		Read-Host "Ok?"
	}
	if($select -eq 2)
	{
		Clear-Host
		
		Write-host "Select Formation"
		Write-host "0) 4-4-2"
		Write-host "1) 3-4-3"
		Write-host "2) 5-4-1"
		$inp= Read-host "?"

		$form=GetForm -inp $inp
		
		Clear-Host
		Write-host $form.Name
		$teamA.Formation = $form
		$teamA.NumDf=$form.DF
		$teamA.NumMf=$form.MF
		$teamA.NumFw=$form.FW
		
		$split = splitP -players $teamA.Players
		
		$lineup = GenLineup -form $form -split $split	
		$teamA.Lineup = $lineup
		
		$splitLineup = splitP -players $lineup
	
		$subs = GetSubs -players $teamA.Players -lineup $lineup
		$teamA.Subs = $subs

		$teamA.DFPoints = GetPosPoints -num $form.DF -split $splitLineup -pos "DF" -gk $teamA.Lineup[0].GKPoints
		$teamA.MFPoints = GetPosPoints -num $form.MF -split $splitLineup -pos "MF" -gk $teamA.Lineup[0].GKPoints
		$teamA.FWPoints = GetPosPoints -num $form.FW -split $splitLineup -pos "FW" -gk $teamA.Lineup[0].GKPoints
		
		Write-host "Lineup"
		ShowLineup -team $teamA
		Write-host "Subs"
		CallPlayers -players $teamA.Subs
		
		Read-Host "Ok?"
	}
	if($select -eq 3)
	{
	$answer="y"
		While($answer -eq "y")
		{
			Clear-Host
			Write-Host $teamA.Formation.Name
			Write-host "Lineup"
			ShowLineup -team $teamA
			Write-host "Subs"
			CallPlayers -players $teamA.Subs
			
			$teamA = Subs -team $teamA
			Clear-Host
			Write-host "Lineup"
			ShowLineup -team $teamA
			Write-host "Subs"
			CallPlayers -players $teamA.Subs
			
			$answer=Read-Host "More Y/N?"
		}
	}
	if($select -eq 4)
	{
		Clear-Host
		ShowLineup -team $teamA
		Read-host "Ok?"
	}
	if($select -eq 5)
	{
		Clear-Host
		Write-Host "Budget"
		Write-Host "Funds:" $teams[0].Funds	
		Read-Host "Return?"
	}	
	
	if($select -eq 7)
	{
		$play=$true
		foreach($p in $teams[0].Lineup)
		{
			if($p.Injury -gt 0)
			{
				$play = $False
			}
		}
		
		if($play -eq $False)
		{
			Read-Host "CANT PLAY WITH INJURED PLAYER IN STARTING 11"
		}
		elseif($teamA.Lineup.count -lt 11)
		{
			Read-Host "CANT PLAY NOT ENOUGH PLAYERS IN STARTING 11"
		}
		else
		{
			$next=0
			while($next -eq 0)
			{
				Clear-Host
				$teamB = $teams[$week]
			
				Write-Host $teamA.Name "v" $teamB.Name
				Write-Host "1) Play"
				Write-Host "2) See Teams"
				Write-Host "3) Make Subs"
				Write-Host "4) See Table"
				$ans=Read-Host "?"
				if($ans -eq 1)
				{
					$next = 1
				}
				if($ans -eq 2)
				{
					ShowMatchLineups -teamA $teamA -teamB $teamB
				}
				if($ans -eq 3)
				{
					$answer="y"
					While($answer -eq "y")
					{
						Clear-Host
						Write-Host $teamA.Formation.Name
						Write-host "Lineup"
						ShowLineup -team $teamA
						Write-host "Subs"
						CallPlayers -players $teamA.Subs
						
						$teamA = Subs -team $teamA
						Clear-Host
						Write-host "Lineup"
						ShowLineup -team $teamA
						Write-host "Subs"
						CallPlayers -players $teamA.Subs
						
						$answer=Read-Host "More Y/N?"
					}
				}
				if($ans -eq 4)
				{
					GenTable
				}
			}
			$teamA=PlayMatch -teamA $teamA -teamB $teamB
			Read-Host "Return?"
			
			Clear-Host
			<#Write-host "Other Results"
					
			foreach($team in $teams)
			{
				if($team -ne $teams[0] -and $team -ne $teams[$week])
				{
					$teamX = GenTeam -name "TEST" -div $division
					GetResult -teamA $team -teamB $teamX
				}
			}#>	
			########################
			GetFixtures -fixtures $Fixtures
			#######################
		}		
		Read-Host "Return?"
	}
	if($select -eq 8)
	{
		GenTable
	}
	
	if($select -eq 9)
	{	
		#BUY#
			Clear-Host
			Write-host "Youth Team"
			CallPlayers -players $YouthTransfers
			$pur=Read-Host "Sign?"
			$playertobuy=$YouthTransfers[$pur] 
			#$price = $playertobuy.Value - 5
			Write-host "Buy for " 3
			$sure=Read-Host "Are you sure? Y/N"
			if($sure -eq "y")
			{
				$x = $teams[0].Funds - 3
				if($x -gt 0)
				{
					$teams[0].Players += $playertobuy
					$teams[0].Subs += $playertobuy
					$teams[0].Funds -= 3
					
					$TransfersU = { $YouthTransfers }.Invoke()
					#Remove item by index.
					$TransfersU.RemoveAt($pur)
					Write-Host "Signed Player"
					Write-Host $YouthTransfers.count
					Write-Host $TransfersU.count
					$YouthTransfers = $TransfersU
					return $YouthTransfers
				}
				else
				{
					Write-host "You do not have enough to sign this player"
				}
			}
			else
			{
				Write-host "Player was not signed"
			}
			Read-Host "Return?"
	}
	
	
	if($select -eq 6)
	{
		Clear-host
		$splitLineup = splitP -players $teamA.lineup
		#RESET Stats
		#Write-host $teamA.NumDF
		$teamA.DFPoints = GetPosPoints -num $teamA.NumDF -split $splitLineup -pos "DF" -gk $teamA.Lineup[0].GKPoints
		$teamA.MFPoints = GetPosPoints -num $teamA.NumMF -split $splitLineup -pos "MF" -gk $teamA.Lineup[0].GKPoints
		$teamA.FWPoints = GetPosPoints -num $teamA.NumFW -split $splitLineup -pos "FW" -gk $teamA.Lineup[0].GKPoints
		
		$TeamA.staminaDrain=10
		
		#Clear-host
		Write-host "Tactics"
		Write-host "1)Normal"
		Write-host "2)Attacking"
		Write-host "3)Defensive"
		Write-host "4)Aggressive"
		Write-host "5)Take it easy"
		$ans = Read-host "Select..."
		
		if($ans -eq 1)
		{
			$TeamA.staminaDrain=10
		}
		if($ans -eq 2)
		{
			$teamA.DFPoints -= 10
			$teamA.FWPoints += 10
			$TeamA.staminaDrain=10
		}
		if($ans -eq 3)
		{
			$teamA.DFPoints += 10
			$teamA.FWPoints -= 10
			$TeamA.staminaDrain=10
		}
		if($ans -eq 4)
		{
			$TeamA.staminaDrain=25
			$teamA.DFPoints += 10
			$teamA.FWPoints += 10	
		}
		if($ans -eq 5)
		{
			$TeamA.staminaDrain=5
			$teamA.DFPoints -= 10
			$teamA.FWPoints -= 10	
		}
	}
	return $YouthTransfers
}
$testWk=1
$diff=Read-host "Difficulty? (1-3)"
$name=Read-host "Name?"
$teamA = GenTeam -name $name -id 0 -div $diff
[int] $division = $diff
$teams+= $teamA

for($i=0;$i -lt 9;$i++)
{
	$tId = $i+1
	$name=""
	$name=GenTeamNames
	$newTeam = GenTeam -name $name -id $tId -div $division
	$teams += $newTeam
	$AOTeams += $newTeam
}

$teamCopy = $teams
$week = 1
$season = 1
$q=1
$SF=0
$SE=$week+2

function DisplayFixtures($fl)
{
	foreach($f in $fl)
	{
		Write-host $f.Name
	}
}

function ShowFixtures()
{
	DisplayFixtures -fl $teamCopy
	
	$teamCopy = UpFixtures
	
	Read-Host
}

function UpFixtures()
{
	$NewArray=@()
	for($i=0; $i -lt 10; $i++ )
	{
		if($i -eq 0)
		{
			$NewArray += $teamCopy[$i].Name
		}
		elseif($i -eq 1)
		{
			$NewArray += $teamCopy[$teamCopy.length -1].Name
		}
		else
		{
			$NewArray += $teamCopy[$i-1].Name
		}
	}
	return $NewArray
}



function GenFixtures()
{
	for ($x = 1; $x -lt $teams.Count; $x++) 
	{
		for ($y = $x - 1; $y -gt -1; $y--) 
		{
			if($teams[$y].Id -ne 0)
			{
				#$fix= new-object psobject -prop @{IdA=$teams[$y].Id;IdB=$teams[$x].Id}
				$fix= new-object psobject -prop @{IdA=$y;IdB=$x}
				$Fixtures = {$Fixtures}.Invoke()
				$Fixtures += $fix
				#Write-Host $q $teams[$y].Id $teams[$y].Name "plays" $teams[$x].Name $teams[$x].Id
				$q++
			}	
		}		
	}
	return $Fixtures
}

$Fixtures = GenFixtures 
#$Fixtures = $Fixtures | Sort-Object {Get-Random}
$Transfers=GenTransfers -division $division
$YouthTransfers=GenYouth -division 1
$transferPeriod=0
While ($teams[0].Security -gt 0)
{
	foreach($yp in $YouthTransfers)
	{
		if($yp.Name -eq $null)
		{
			$YouthTransfers = { $YouthTransfers }.Invoke()
			#Remove item by index.
			$YouthTransfers.Remove($yp)
		}
	}
		
	while($transferPeriod -gt 0)
	{
		clear-host
		$Transfers=TransferPer -teamA $teamA -trans $Transfers -per $transferPeriod
		$transferPeriod--	
		foreach($tr in $Transfers)
		{
			if($tr.Name -eq $null)
			{
				$Transfers = { $Transfers }.Invoke()
				#Remove item by index.
				$Transfers.Remove($tr)
			}
		}
	}
	
	if($teams[0].Security -gt 100)
	{
		$teams[0].Security = 100
	}
	
	$currWeek = $teams[0].GamesPlayed
	$YouthTransfers = Menu -teamA $teamA -week $week -trans $YouthTransfers -fixtures $Fixtures
	#Read-Host $Transfers
	if($Transfers[0].Name -eq $null)
	{
		$TransfersU = { $Transfers }.Invoke()
		#Remove item by index.
		$TransfersU.RemoveAt(0)
		$Transfers = $TransfersU
	}

	if($teams[0].GamesPlayed -gt $currWeek)
	{
		$week++
	}
	
	if($week -gt 9)
	{
		$transferPeriod = 5
		Clear-host
		$xx=1
		
		$myPosition=0
		$tab = GetTable
		foreach($te in $tab)
		{
			#Write-host $te.Id
			if($te.Id -eq 0)
			{
				$myPosition=$xx
			}
			else
			{
				$xx ++
			}
		}
		GenTable
		Clear-host
		Write-host "You Finished in" $myPosition
		$addFunds= (11 - $myPosition) * $division
		Write-host "You gain an additional"	 $addFunds
		$teams[0].Funds+=$addFunds	
		Read-host
		####################################################################################	
		$pos = 0
		$pos2 = 0
		$relegated = GetLastPlace
		#TEST HERE#
		$tse = 0
		$champs = NewSeason
		
		if($champs.Id -eq 0)
		#if($tse -eq 0)
		{
			$teams[0].Security+=20
			$teams[0].Funds+=20
			Write-Host "Congratulations you have won!"
			[int] $division ++
			Read-Host "You have been promoted to Division" $division
			for($i=1;$i -lt 10;$i++)
			{
				$teams = {$teams}.Invoke()
				#Remove item by pos.
				$teams.RemoveAt(1)
			}
			##Add new teams to league
			for($i=0;$i -lt 9;$i++)
			{
				$tId = $i+1
				$name=""
				$name=GetName -r 1
				$newTeam = GenTeam -name $name -id $tId -div $division
				$teams += $newTeam
			}
		}
		else
		{
			foreach($t in $teams)
			{
				if($t.Id -eq $champs.Id)
				{
					$cId=$pos
				}
				else
				{
					$pos ++
				}
			}
			$newName = ""
			$newName = GetName -r 1
			Write-Host $newName "Promoted From lower league"	
		
			#Remove 1st place
			$teams = {$teams}.Invoke()
			#Remove item by ref.
			$teams.RemoveAt($cId)
			
			##Add team
			$yId = $season + 10
			$teamY = GenTeam -name $newName -id $yId -div $division
			$teams += $teamY
		}	
		
		if($division -ne 1)
		{
			if($relegated.Id -eq 0)
			{
				$teams[0].Security-=20
				$teams[0].Funds-=10
				Write-Host "Sorry you have been relegated!"
				$division -=1
				for($i=1;$i -lt 10;$i++)
				{
					$teams = {$teams}.Invoke()
					#Remove item by pos.
					$teams.RemoveAt(1)
				}
				##Add new teams to league
				for($i=0;$i -lt 9;$i++)
				{
					$tId = $i+1
					$nameX = ""
					$nameX = GetName -r 1
					$newTeam = GenTeam -name $nameX -id $tId -div $division
					$teams += $newTeam
				}		
			}
			elseif($champs.Id -ne 0)
			#elseif($tse -ne 0)
			{
				Write-host $relegated.Name "have been relegated"
				foreach($t in $teams)
				{
				if($t.Id -eq $relegated.Id)
				{
					$rId=$pos2
				}
				else
				{
					$pos2 ++
				}
				}
				$newNameR = ""
				$newNameR = GetName -r 1
				Write-Host $newNameR "Promoted From lower league"	
				
				#Remove 1st place
				$teams = {$teams}.Invoke()
				#Remove item by ref.
				$teams.RemoveAt($rId)
				
				##Add team
				$xId = $season + 9
				$teamX = GenTeam -name $newNameR -id $xId -div $division
				$teams += $teamX
				
			}
			Read-Host "Continue..."
		}
		
		#if($champs.Id -eq 0)
		#{
		#	[int] $division ++
		#}
		
		#####################################################################
		#UPDATEPLAYERS STATS
		#####################################################################
		for($i = 0; $i -lt $teams.count;$i++)
		{
			for($x = 0; $x -lt $teams[$i].Players.count;$x++)
			{
				if($teams[$i].Players[$x].Age -gt 27)
				{
					#All stats -1
					if($teams[$i].Players[$x].GKPoints -ne 0)
					{
						$teams[$i].Players[$x].GKPoints-=1
					}
					if($teams[$i].Players[$x].DFPoints -ne 0)
					{
						$teams[$i].Players[$x].DFPoints-=1
					}
					if($teams[$i].Players[$x].MFPoints -ne 0)
					{
						$teams[$i].Players[$x].MFPoints-=1
					}
					if($teams[$i].Players[$x].FWPoints -ne 0)
					{
						$teams[$i].Players[$x].FWPoints-=1
					}
					[int]$ovr = GetOvr -pos $teams[$i].Players[$x].Pos -gk $teams[$i].Players[$x].GKPoints -df $teams[$i].Players[$x].DFPoints -mf $teams[$i].Players[$x].MFPoints -fw $teams[$i].Players[$x].FWPoints
					$teams[$i].Players[$x].Ovr=$ovr

				}
				else
				{
					#All stats +1
					if($teams[$i].Players[$x].GKPoints -ne 99)
					{
						$teams[$i].Players[$x].GKPoints+=1
					}
					if($teams[$i].Players[$x].DFPoints -ne 99)
					{
						$teams[$i].Players[$x].DFPoints+=1
					}
					if($teams[$i].Players[$x].MFPoints -ne 99)
					{
						$teams[$i].Players[$x].MFPoints+=1
					}
					if($teams[$i].Players[$x].FWPoints -ne 99)
					{
						$teams[$i].Players[$x].FWPoints+=1
					}
					[int]$ovr = GetOvr -pos $teams[$i].Players[$x].Pos -gk $teams[$i].Players[$x].GKPoints -df $teams[$i].Players[$x].DFPoints -mf $teams[$i].Players[$x].MFPoints -fw $teams[$i].Players[$x].FWPoints
					$teams[$i].Players[$x].Ovr=$ovr
				}
				$teams[$i].Players[$x].Age++
			}
		}
		#####################################################################
		foreach($p in $teamA.Lineup)
		{
			$p.Stamina=100
		}
		foreach($p in $teamA.Lineup)
		{
			$p.Stamina=100
		}
		
		Read-Host "New Season..."
		$teamCopy = $teams
		$teams[0].SF=0
		$teams[0].SE=3
		$Fixtures=@()
		$Fixtures=GenFixtures
		$Fixtures = $Fixtures | Sort-Object {Get-Random}
		$week = 1
		$Transfers=GenTransfers -division $division
		$YouthTransfers=GenYouth -division 1
		$season ++
	}
}

Read-host "Due to poor performance you have been let go from the club"

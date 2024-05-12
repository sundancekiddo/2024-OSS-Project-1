#!/bin/bash

files=("players.csv" "matches.csv" "teams.csv")
missing_files=()
wrong_files=()

for expected in "${files[@]}"; do
	found=false
	for file in "$@"; do
		if [ "$file" = "$expected" ]; then
			found=true
			break
		fi
	done
	if [ "$found" = false ]; then
		missing_files+=("$expected")
	fi
done


for file in "$@"; do
	if [ ! -f "$file" ]; then
		wrong_files+=("$file")
	fi
done

if [ ${#missing_files[@]} -ne 0 ]; then
		if [ ${#wrong_files[@]} -ne 0 ]; then
        		echo "Wrong files: "
        		for wrong in "${wrong_files[@]}"; do
                		echo "$wrong"
        		done
		fi
	echo "Missing files: "
	for missing in "${missing_files[@]}"; do
		echo "$missing"
	done
	echo "usage: ./proj1_12192874_jominsu.sh file1 file2 file3"
	exit 1
fi


WHOAMI="
**************OSS - Project1***************
*	    StudentID : 12192874	  *
*	      Name: Minsu Jo		  *
*******************************************"


MENU="

[MENU]
1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in players.csv
2. Get the team data to enter a league position in teams.csv
3. Get the Top-3 Attendance matches in mateches.csv
4. Get the team's league position and team's top scorer in teams.csv & players.csv
5. Get the modified format of date_GMTin matches.csv
6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv
7. Exit"


function Display_Menu {
	while true; do
		echo "$MENU"
		read -p "Enter your CHOICE (1~7) : " choice

		case $choice in
			1)
				Question1
				;;
			2)
				Question2
				;;
			3)
				Question3
				;;
			4)
				Question4
				;;
			5)
				Question5
				;;
			6)
				Question6
				;;
			7)
				break
				;;
			*)
				echo "Wrong CHOICE. try again!"
				;;
		esac
	done
}


function Question1 {
	read -p "Do you want to get the Heung-Min Son's data? (y/n) : " choice

	if [ "$choice" == "n" ]; then
		return 0
	else
		awk -F',' '$1 == "Heung-Min Son" {print "Team:" $4 ", Appearance:" $6 ", Goal:" $7 ", Assist:" $8}' players.csv
	fi
}


function Question2 {
	read -p "Enter the league position [1-20]: " pos
	if [[ "$pos" -gt 20 || "$pos" -lt 1 ]]; then
		return 0
	fi
    awk -F',' -v pos="$pos" '
    $6 == pos {
        games = $2 + $3 + $4;
        if (games > 0) {
            winning_rate = $2 / games;
        } else {
            winning_rate = 0;
        }
        printf "%d %s %.6f\n", pos, $1, winning_rate;
    }' teams.csv    
}


function Question3 {
	read -p "Do you want to know Top-3 attendance data and average attendance? (y/n) :" choice
	if [ "$choice" == "n" ]; then
		return 0
	else
		echo "***Top-3 Attendance Matches***
"
		sort -t',' -k2,2nr matches.csv | head -n3 | awk -F',' '{
		printf "%s vs %s (%s)\n\n", $3, $4, $1}'
	fi
}


function Question4 {
	read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " choice
	if [ "$choice" == "n" ]; then
		return 0
	else
		declare -A top_scorer_names
        	declare -A top_scorer_goals
        	declare -A team_positions
        	declare -a sorted_positions

        	while IFS=',' read -r team league_position; do
            	    team_positions["$team"]=$league_position
            	    sorted_positions+=("$league_position,$team")
        	done < <(awk -F',' '{print $1 "," $6}' teams.csv)

        	while IFS=',' read -r player team goals; do
            	    if [[ ! ${top_scorer_goals[$team]} || ${top_scorer_goals[$team]} -lt $goals ]]; then
                	top_scorer_goals[$team]=$goals
                	top_scorer_names[$team]="$player"
            	    fi
        	done < <(awk -F',' '{print $1 "," $4 "," $7}' players.csv)

        	local original_ifs="$IFS"
        	IFS=$'\n'
        	sorted_positions=($(sort -t ',' -k1,1n <<< "${sorted_positions[*]}"))
        	IFS="$original_ifs"

        	for entry in "${sorted_positions[@]}"; do
            	    IFS=',' read -r position team <<< "$entry"
            	    if [[ ${top_scorer_names[$team]} ]]; then
                	echo "$position $team"
                	echo "${top_scorer_names[$team]} ${top_scorer_goals[$team]}"
			echo " "
            	    fi
        	done
	fi
}


function Question5 {

    	read -p "Do you want to modify the format of date? (y/n) : " choice
    	if [ $choice == "y" ]; then
        	tail -n +2 matches.csv | sed -r 's/([A-Za-z]{3}) (\d{2}) (\d{4}) - (\d{1,2}:\d{2})(am|pm)/\3\/\1\/\2 \4\5/' > temp.csv

        	awk -F',' '{print $1}' temp.csv | head -n10

        	rm temp.csv
    	else
        	return 0
    	fi
}


function Question6 {
    declare -A teams
    teams[1]="Arsenal"
    teams[2]="Tottenham Hotspur"
    teams[3]="Manchester City"
    teams[4]="Leicester City"
    teams[5]="Crystal Palace"
    teams[6]="Everton"
    teams[7]="Burnley"
    teams[8]="Southampton"
    teams[9]="AFC Bournemouth"
    teams[10]="Manchester United"
    teams[11]="Liverpool"
    teams[12]="Chelsea"
    teams[13]="West Ham United"
    teams[14]="Watford"
    teams[15]="Newcastle United"
    teams[16]="Cardiff City"
    teams[17]="Fulham"
    teams[18]="Brighton & Hove Albion"
    teams[19]="Huddersfield Town"
    teams[20]="Wolverhampton Wanderers"

    local idx=0
    local max_teams=20
    local columns=2
    local per_col=$((max_teams / columns))

    for (( i=1; i <= per_col; i++ )); do
        idx=$i
        printf "%2d) %-20s" "$idx" "${teams[$idx]}"
        
        idx=$((i + per_col))
        if [ $idx -le $max_teams ]; then
            printf "   %2d) %-20s\n" "$idx" "${teams[$idx]}"
        else
            printf "\n"
        fi
    done

    read -p "Enter your team number: " team_number
    team_name="${teams[$team_number]}"

    echo " "

    max_diff=$(awk -F',' -v team="$team_name" '$3 == team { diff = $5 - $6; if (diff > 0 && diff > max_diff) max_diff = diff }' matches.csv)
    awk -F',' -v team="$team_name" -v max_diff="$max_diff"'
    $3 == team {
        diff = $5 - $6
        if (diff == max_diff) {
            print $1 " - " $3 " "\n" " $5 " vs " $6 " " $4 " "\n"
        }
    }' matches.csv | sort -t'(' -k2 -nr
}



echo "$WHOAMI"
Display_Menu
echo "Bye!"



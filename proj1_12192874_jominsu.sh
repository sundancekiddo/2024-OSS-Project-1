#!/bin/bash

files=("players.csv" "matches.csv" "teams.csv")
missing_files=()
wrong_files=()

for expected in "${files[@]}"; do
	found=false
	for file in"$@"; do
		if ["$file" = "$expected" ]; then
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


for file in "$@"; do
	if [ "$file" = "players.csv" ]; then
		players=$file
	elif [ "$file" = "teams.csv" ]; then
		teams=$file
	elif [ "$file" = "matches.csv" ]; then
		matches=$file
	fi
done


WHOAMI="
**************OSS - Project1***************
*	    StudentID : 12192874	  *
*	      Name: Minsu Jo		  *
*******************************************"


MENU="[MENU]
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

	if [ $choice = "n"]; then
		return 0
	else
		
	fi
}

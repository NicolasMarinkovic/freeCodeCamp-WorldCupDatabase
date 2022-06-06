#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  echo -e "\nConectado a WorldCupTest"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
  echo -e "\nConectado a WorldCup"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#$($PSQL "<query_here>")
echo "$($PSQL "truncate table games, teams;")"

cat games.csv | while IFS="," read YEAR ROUND WIN OPP WIN_G OPP_G
do
    if [[ $YEAR != year ]]
        then
        #get team_id
        WIN_ID=$($PSQL "select team_id from teams where name='$WIN'")
        #if not found
        if [[ -z $WIN_ID ]]
            then
            #insert team
            INSERT_WIN_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WIN')")
            if [[ $INSERT_WIN_RESULT == "INSERT 0 1" ]]
                then
                echo "Inserted into majors, $WIN"
            fi
        #get new win_id
        WIN_ID=$($PSQL "select team_id from teams where name='$WIN'")
        fi
        #get team_id
        OPP_ID=$($PSQL "select team_id from teams where name='$OPP'")
        #if not found
        if [[ -z $OPP_ID ]]
            then
            #insert team
            INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPP')")
            if [[ $INSERT_OPP_RESULT == "INSERT 0 1" ]]
                then
                echo "Inserted into majors, $OPP"
            fi
        #get new opp_id
        OPP_ID=$($PSQL "select team_id from teams where name='$OPP'")
        fi

        #get game_id
        GAME_ID=$($PSQL "select game_id from games full join teams on games.winner_id = teams.team_id where year=$YEAR and winner_id=$WIN_ID and opponent_id=$OPP_ID")
        #if not found
        if [[ -z $GAME_ID ]]
            then
            #insert team            
            INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_G, $OPP_G)")
            if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
                then
                echo "Inserted into games, $YEAR $ROUND $WIN $OPP $WIN_G $OPP_G"
            fi
        fi
    fi
done

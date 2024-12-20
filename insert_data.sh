#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE teams, games")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINER_GOALS OPPONENT_GOALS
do
# Solo detecta info
if [[ $YEAR != 'year' ]]
then
# detecta repetidos de winner y agrega
TEAM_WINNER_NAME="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'" )"
if [[ -z $TEAM_WINNER_NAME ]]
then
INSERT_TEAM_NAME="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')" )"
echo $INSERT_TEAM_NAME
fi

# detecta repetidos de opponent y agrega
TEAM_OPPONENT_NAME="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'" )"
if [[ -z $TEAM_OPPONENT_NAME ]]
then
INSERT_TEAM_NAME="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')" )"
echo $INSERT_TEAM_NAME
fi



#seleccionar winner_id Y opponent_id
WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'" )"
OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'" )"
# insertar en games table
INSERT_YEAR_GAME="$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)" )"

 
fi
done

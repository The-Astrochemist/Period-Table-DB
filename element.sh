#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #check if arg is a number or string
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #if arg is a number
    EL_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING (atomic_number) WHERE atomic_number = $1")
    ATOMIC_NUMBER=$1
    SYMBOL=$($PSQL "SELECT symbol FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number = $1")
    NAME=$($PSQL "SELECT name FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number = $1")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING (type_id) WHERE atomic_number = $1")
  else
    #if arg is a string
    EL_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING (atomic_number) WHERE name = '$1' OR symbol = '$1'")
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties INNER JOIN elements USING (atomic_number) WHERE name = '$1' OR symbol = '$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM properties INNER JOIN elements USING (atomic_number) WHERE name = '$1' OR symbol = '$1'")
    NAME=$($PSQL "SELECT name FROM properties INNER JOIN elements USING (atomic_number) WHERE name = '$1' OR symbol = '$1'")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING (atomic_number) WHERE name = '$1' OR symbol = '$1'")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING (atomic_number) WHERE name = '$1' OR symbol = '$1'")
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING (type_id) INNER JOIN elements USING (atomic_number) WHERE name = '$1' OR symbol = '$1'")
  fi  
  
  #check if argument is in database
  if [[ -z $EL_MASS ]]
  then
    echo "I could not find that element in the database."
  else
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $EL_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."  
  fi

  
fi


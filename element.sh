#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
fi

SET_PROPERTIES() {
  #set atomic mass
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  #set melting point
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  #set boiling point
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  #set type id
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  #set type
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
}

RESULT() {
echo The element with atomic number $ATOMIC_NUMBER is $NAME "("$SYMBOL"). It's a "$TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.
}

#input is a number
if [[ $1 =~ ^[0-9]+$ ]]
then 
   
   #check atomic number
   ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$1")
   if [[ $ATOMIC_NUMBER ]]
   then
     #set name
     NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
     #set symbol
     SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
     SET_PROPERTIES
     RESULT
   fi

fi 

#if input not a number
if [[ ! $1 =~ ^[0-9]+$ ]]
then   
   
   #check symbol
   SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
   if [[ $SYMBOL ]]
   then
     #set atomic number
     ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
     # set name
     NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL'")
     SET_PROPERTIES
     RESULT
   fi

    #check name
    NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
    if [[ $NAME ]]
    then
      #set atomic number
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
      #set symbol
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME'")
      SET_PROPERTIES
      RESULT
    fi

fi

#if not found
if [[ -z $ATOMIC_NUMBER && $1 ]]
then
  echo I could not find that element in the database.
fi

#!/usr/bin/bash
shopt -s extglob
export LC_COLLATE=C
echo "Welcome To DBMS"
function dataBaseMenu {
select choice in "press 1 to Create Database" "press 2 to List Databases" "press 3 to Connect To Databases" "press 4 to Drop Database" "press 5 to Exit"
do
case $REPLY in
1) createDatabase
;;
2) listDatabases
;;
3) connectToDatabase
;;
4) dropDatabase
;;
5) exit
;;
*) echo $REPLY is not one of the choices.
;;
esac
done
}

function createDatabase {
read -p "enter the database name: " name
if [[ -d ./DBMS/$name ]]; 
then
    echo "This database already exists, please try another name."
else
mkdir ./Databases/$name
if [ $? == 0 ];
then
    echo "Database was created successfully."
else
  echo "Database wasn't created, please try again."
fi

fi
read -p "Press Enter to continue"
dataBaseMenu
}

function listDatabases {

ls ./Databases
read -p "Press Enter to continue"  
dataBaseMenu
}

function connectToDatabase {
read -p "enter the database name: " name
if [[ -d ./Databases/$name ]]; 
then
    	cd ./Databases/$name
	if [ $? == 0 ];
	then
		echo "You are now working in database $name."
		#TableMenu
	else
 		echo "Database wasn't selected, please try again."
	fi
else
	echo "Database doesn't exist.here is the names of existed databases, please write the name correctly: "
  	ls ./Databases
  	connectToDatabase
fi

}

function dropDatabase {
read -p "enter the database name to drop: " name
read -p "Are you sure you want to drop $name:(enter y or n) "
case $REPLY in
y) rm -r ./Databases/$name
if [ $? == 0 ];
then
    echo "Database was deleted successfully."
else
  echo "Database wasn't deleted, please try again."
fi
;;
n) dataBaseMenu
;;
*) echo "please enter y or n".
;;
esac
read -p "Press Enter to continue"  
dataBaseMenu
}
dataBaseMenu

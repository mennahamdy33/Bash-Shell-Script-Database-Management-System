#!/usr/bin/bash
shopt -s extglob
export LC_COLLATE=C
mkdir -p ./Databases
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
if [[ -d ./Databases/$name ]]; 
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
		tableMenu
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
if [[ -d ./Databases/$name ]]; 
then
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
else
	echo "Database doesn't exist."
fi
read -p "Press Enter to continue"  
dataBaseMenu
}
function tableMenu {
    select choice in "press 1 to Create table" "press 2 to list Extisitng Table " "press 3 to insert into table" "press 4 to select from table" "press 5 to delete from table " "press 6 to drop table" "press 7 to go back to database menu" "press 8 to exit"
    do 
        case $REPLY in 
        1)createTable
        	;;

	2)listTables 
		;;
        3)insertIntoTable
                ;;
            
        4)selectFromTable
                ;;    
	5)deleteFromTable
		;;
	6)dropTable
		;;
	7)dataBaseMenu
		;;
	8)exit
		;;
	
	*) echo $REPLY is not one of the choices.
		;;
	esac 
done 
}
function createTable {
    echo "Please,Enter Table Name"
    read tableName
    echo "Enter number of columns"
    read colNum
    testInput $colNum "int"
    if [ $? -eq 0 ]
    then
    echo "Please enter number of columns in integer type"
    tableMenu
    fi
     if [ -f $tableName ]
    then
        echo "Table already exist"
        tableMenu
    else
        touch $tableName
    fi
    typeset -i i=0
    columns=""
        echo "Please note that the first column to enter will be the primary key"
    while [ $i -lt $colNum ] 
    do
        echo "Enter column Name"
        read colName
        echo "Select column type"
        if [ $i -eq 0 ]
        then                        
	pk=$colName
        colName+="(pk)"
        fi
        
        select type in "int" "string"
        do
            colType=$type
            break
        done
        columns+="$colName:$colType;"
        i=$i+1
    done
    printf $columns>>$tableName;
    # echo pk:$pk>>$tableName;
    tableMenu
}    

function listTables {

	ls 
	read -p "Press Enter to continue"  
	tableMenu
}

function insertIntoTable {
  echo -e "Enter Table Name to insert into: "
  read tableName
  if ! [[ -f $tableName ]]; then
    echo "Table $tableName isn't existed ,choose another Table"
    tableMenu
  fi
    typeset -i i=1;
    colName=`cut -d";" -f $i $tableName|cut -d":" -f 1|head -1`;
    colType=`cut -d";" -f $i $tableName|cut -d":" -f 2|head -1`;
    field='';
    while [[ -n $colName ]]
    do
        echo "Enter Value of $colName";
        read value
        testInput $value $colType
        if [ $? -eq 1 ]
        then
            field+="$value;"
        else
            echo "Somthing Wrong!"
            tableMenu
        fi
        #echo $testPk
        checkPk $tableName $value
        if [ $? -eq 0 ]
        then
             echo "this value exist in pk column!"
             tableMenu
        fi
        i=$i+1;
        colName=`cut -d";" -f $i $tableName|cut -d":" -f 1|head -1`; 
        colType=`cut -d";" -f $i $tableName|cut -d":" -f 2|head -1`;
    done
    printf "\n">>$tableName
    printf "$field">>$tableName
  tableMenu
}
function testInput {
    # echo $1
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        type="string"
    else
        type="int"
    fi
    if [[ "$type" == "$2" ]]
    then
        return 1
    else
        return 0
    fi
}
function checkPk {
    pksValues=`sed '1d' $1|cut -d ";" -f 1 `
    re='^[0-9]+$'
    for value in $pksValues
    do
        if ! [[ $2 =~ $re ]] ; 
        then
            # type="string"
            if [ $2 = $value ]
            then
                return 0
            fi
        else
            # type="int"
            if [ $2 -eq $value ]
            then
                return 0
            fi
        fi
    done
    return 1
}
function deleteFromTable {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter the id to delete its record: \c"
    read val
    res=`cut -d ";" -f 1 $tName 2>/dev/null|awk "/$val/ "'{print NR}' `
    if [[ -z $res  ]]
    then
      echo "Value Not Found"
      tableMenu
    else
    echo $res
      sed -i ''$res'd' $tName 2> /dev/null
       echo "Row Deleted Successfully"
       tableMenu
    fi
  
}
function selectFromTable {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter the id to show its record: \c"
    read val
    res=`cut -d ";" -f 1 $tName 2>/dev/null|awk "/$val/ "'{print NR}' `
    if [[ -z $res  ]]
    then
      echo "Value Not Found"
      tableMenu
    else
    echo $res
      sed  -n `expr $res + 0`p $tName
       
       tableMenu
    fi
  
}

function dropTable {
  echo -e "Enter Table Name: \c"
  read tName
  if [ -f $tName ]
    then
        rm $tName
        if [ $? -eq 0 ]
    	then
  	   echo "Table Dropped Successfully"
   	else
 	   echo "Error Dropping Table $tName"
        fi
    
    else
	echo "Table doesn't exist"
    fi
        tableMenu
   
  
}


dataBaseMenu

#!/usr/bin/bash
shopt -s extglob
export LC_COLLATE=C
mkdir -p ./Databases
echo -e "\e[1m\e[34m\e[40mWelcome To DBMS  \e[49m"

function dataBaseMenu {
select choice in  "press 1 to Create Database" "press 2 to List Databases" "press 3 to Connect To Databases" "press 4 to Drop Database" "press 5 to Exit"
do
case $REPLY in
1) createDatabase;
;;
2) listDatabases
;;
3) connectToDatabase
;;
4) dropDatabase
;;
5)echo -e "\e[0m\e[39m"; exit
;;
*) echo $REPLY is not one of the choices.
;;
esac
done

}

function createDatabase {
read -p "Enter the database name: " name
if [[ -d ./Databases/$name ]];
then
    echo -e "\e[31mThis database already exists, please try another name."
else
mkdir ./Databases/$name
if [ $? == 0 ];
then
    echo -e "\e[35mDatabase was created successfully."
else
  echo -e "\e[31mDatabase wasn't created, please try again."
fi

fi
echo -e "\e[34m"
read -p "Press Enter to continue"
dataBaseMenu
}

function listDatabases {
echo -e "\e[95m"

ls -1 ./Databases
echo -e "\e[34m"

read -p "Press Enter to continue"
dataBaseMenu
}

function connectToDatabase {
read -p "Enter the database name: " name
if [[ -d ./Databases/$name ]];
then
    	cd ./Databases/$name
	if [ $? == 0 ];
	then
		echo -e "\e[35mYou are now working in database $name.\e[34m"
		tableMenu
	else
 		echo -e "\e[31mDatabase wasn't selected, please try again."
	fi
else
	echo -e "\e[31mDatabase doesn't exist.here is the names of existed databases, please write the name correctly: "
  	ls ./Databases
  	connectToDatabase
fi

}

function dropDatabase {
read -p "Enter the database name to drop: " name
if [[ -d ./Databases/$name ]];
then
rm -ir ./Databases/$name
else
	echo -e "\e[31mDatabase doesn't exist."
fi
echo -e "\e[34m"
read -p "press Enter to continue"
dataBaseMenu
}
function tableMenu {
echo -e "\e[40mTables Menu:  \e[49m"
    select choice in "press 1 to Create table" "press 2 to list Extisitng Table " "press 3 to insert into table" "press 4 to go to select menu" "press 5 to delete from table " "press 6 to drop table" "press 7 to go back to database menu" "press 8 to exit"
    do
        case $REPLY in
        1)createTable
        	;;

	2)listTables
		;;
        3)insertIntoTable
                ;;

        4)selectMenu
                ;;

	5)deleteFromTable
		;;
	6)dropTable
		;;
	7)BaseMenu
		;;
	8)echo -e "\e[0m\e[39m"; exit
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
    echo -e "\e[31mPlease enter number of columns in integer type\e[34m"
    tableMenu
    fi
     if [ -f $tableName ]
    then
        echo -e "\e[31mTable already exist\e[34m"
        tableMenu
    else
        touch $tableName
    fi
    typeset -i i=0
    columns=""
        echo -e "\e[31mPlease note that the first column to enter will be the primary key\e[34m"
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
echo -e "\e[35mTable was created successfully.\e[34m"
    # echo pk:$pk>>$tableName;
    tableMenu
}

function listTables {
echo -e "\e[95m"
	ls -1
echo -e "\e[34m"
	read -p "Press Enter to continue"
	tableMenu
}

function insertIntoTable {
  echo  "Enter Table Name to insert into: "
  read tableName
  if ! [[ -f $tableName ]]; then
    echo -e "\e[31mTable $tableName isn't existed ,choose another Table\e[34m"
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
            echo -e "\e[31mSomthing Wrong!, please try again\e[34m"
            insertIntoTable
        fi
        #echo $testPk
        checkPk $tableName $value
        if [ $? -eq 0 ]
        then
             echo -e "\e[31mthis value exist in pk column!, please try again.\e[34m"
             insertIntoTable
        fi
        i=$i+1;
        colName=`cut -d";" -f $i $tableName|cut -d":" -f 1|head -1`;
        colType=`cut -d";" -f $i $tableName|cut -d":" -f 2|head -1`;
    done
    printf "\n">>$tableName
    printf "$field">>$tableName
echo -e "\e[35m done successfully.\e[34m"
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
      echo "1."$value
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
      echo -e "\e[31mValue Not Found\e[34m"
      tableMenu
    else

      sed -i ''$res'd' $tName 2> /dev/null
       echo -e "\e[35mRow Deleted Successfully\e[34m"
       tableMenu
    fi

}
function selectMenu {
echo -e "\e[40mSelect Menu:  \e[49m"
 select choice in  "press 1 to select from table using PK" "press 2 to select All from table" "press 3 to select by column from table" "press 4 to go back to table menu" "press 5 to exit"
    do
        case $REPLY in

        1)selectFromTable
                ;;
        2)selectAll
                ;;
        3)selectByColumn
                ;;

	4)tableMenu
		;;
	5)echo -e "\e[0m\e[39m"; exit
		;;

	*) echo $REPLY is not one of the choices.
		;;
	esac
done
}
function selectFromTable {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter the id to show its record: \c"
    read val
    res=`cut -d ";" -f 1 $tName 2>/dev/null|awk "/$val/ "'{print NR}' `
    if [[ -z $res  ]]
    then
      echo -e "\e[31mValue Not Found\e[34m"
      tableMenu
    else
      echo -e "\e[95m"
      sed  -n "1p;`expr $res + 0`p;" $tName | column -t -s ';' -o '|'
    #        sed  -n `expr $res + 0`p $tName | column -t -s ';' -o '|'
       echo -e "\e[34m"
       tableMenu
    fi

}
function selectAll {
  echo -e "Enter Table Name: \c"
  read tName
 echo -e "\e[95m"
  column -t -s ';' -o '|' $tName 2> /dev/null
  echo -e "\e[34m"
  if [[ $? != 0 ]]
  then
    echo -e "\e[31mError Displaying Table $tName\e[34m"
  fi
  tableMenu
}
function selectByColumn {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Column Name: \c"
   read colName
   declare -i colNo=`head -1 $tName | tr -s ';' '\n' | nl -nln |  grep $colName | cut -f1`
  echo -e "\e[95m"
 awk 'BEGIN{FS=";"}{print $'$colNo'}' $tName
  echo -e "\e[34m"
 tableMenu
}
function dropTable {
  echo  "Enter table name to drop: \c";
  read tname;
  rm $tname .$tname 2> /dev/null

  if [ -f $tname ]
  then
    echo -e "\e[35mTable $tname Dropped Successfully\e[34m"
  else
    echo -e "\e[31mCannot Drop Table $tname, table may not exists\e[34m"
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
  	   echo -e "\e[35mTable Dropped Successfully\e[34m"
   	else
 	   echo -e "\e[31mError Dropping Table $tName\e[34m"
        fi

    else
	echo -e "\e[31mTable doesn't exist\e[34m"
    fi
        tableMenu


}


dataBaseMenu

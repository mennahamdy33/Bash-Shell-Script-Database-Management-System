#!/usr/bin/bash
shopt -s extglob
export LC_COLLATE=C
mkdir -p ./Databases
echo "Welcome To Table-Part"

function tableMenue {
    select choice in "press 1 to Create table" "press 2 to list Extisitng Table " "press 3 to insert into table" "press 4 to select from table" "press 5 to delete from table " "press 6 to drop table" "press 7 to exit"
    do 
        case $REPLY in 
        1)create new table
            ;;

	2)list Extisitng Table 
		;;
        3)insert into table
                ;;
            
        4)selectfrom table
                ;;    
	5)delete from table
		;;
	6)drop table
		;;
	7)exit
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
    tableMenue
    fi
     if [ -f $tableName ]
    then
        echo "Table already exist"
        tableMenue
    else
        touch $tableName
    fi
    typeset -i i=0
    columns=""
    while [ $i -lt $colNum ] 
    do
        echo "Enter column Name"
        read colName
        echo "Select column type"
        select type in "int" "string"
        do
            colType=$type
            break
        done
        # read colType
        if [ -z $pk ]
        then
            echo "Primarykey??"
            select answer in "yes" "no"
            do 
                case $REPLY in 
                1) 
                    pk=$colName
                    colName+="(pk)"
                    break;;
                2)  break;;
                *) echo " Please Select from yes or no " ;;
                esac
            done
        fi
        columns+="$colName:$colType;"
        i=$i+1
    done
    printf $columns>>$tableName;
    # echo pk:$pk>>$tableName;
    tableMenue
}    

function dropTable {
  echo -e "Enter Table Name: \c"
  read tName
  rm $tName .$tName 2>>./.error.log
  if [[ $? == 0 ]]
  then
    echo "Table Dropped Successfully"
  else
    echo "Error Dropping Table $tName"
  fi
  tablesMenu
}

#!/bin/bash
####################Table_Part#########################

function tableMenu {
        echo -e "\n______________TABLE_MENU_________________"
        echo "|__1.Create New Table__|"
        echo "|__2.List Extisting Tables__|"
        echo "|__3.Insert Into Tables__|"
        echo "|__4.Select From Tables__|"
        echo "|__5.Delect From Tables__|"
        echo "|__6.Drop Table__|"
        echo "|__7.Back To Main Menu__|"
        echo "|__8.Exit__|"
        echo "+-------------------------------+"
        echo -e "Enter Choice: \c"         
read ch
  case $ch in
    1)  createTable ;;
    2)  ls .; tableMenu ;;
    3)  insert ;;
    4)  clear; selectMenu ;;
    5)  deleteFromTable;;
    6)  dropTable;;
    7) clear; cd ../.. 2>>./.error.log; mainMenu ;;
    8) exit ;;
    *) echo " Wrong Choice " ; tableMenu;
  esac

}

####________________Create New Table________________####
function createTable {
read -p "Enter Table Name: " tbname
if [[ -f data/$1/$tbname ]]; then
	echo "Table $tbname already exists";
else
	touch data/$1/$tbname;
	read -p "Enter No of columns :" n;

	for (( i = 1; i <= n; i++ )); do
		read -p "Enter column $i name :" name;
		read -p "Enter column datatype : [string/int]" dtype;
		while [[ "$dtype" != *(int)*(string) || -z "$dtype" ]]; do
			echo "Invalid datatype";
			read -p "Enter column datatype : [string/int]" dtype;
		done
		if [[ i -eq n ]]; then
			echo  $name >> data/$1/$tbname;
			echo  $dtype >> data/$1/$tbname.tp;

		else
			echo -n $name":" >> data/$1/$tbname;
			echo -n $dtype":" >> data/$1/$tbname.tp;
		fi

	done
	echo "$tbname has been created"
fi
}



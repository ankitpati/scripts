#!/bin/bash

username="type-your-username-here"
password="type-your-password-here"
findword="type-your-search-term-here"

for dbase in `mysql -u"$username" -p"$password" 2>/dev/null <<< "show databases;" | egrep -v ".*_schema$|^mysql$|^sys$" | tail -n +2`
do
    echo "Matches in database: $dbase"
    for table in `mysql -u"$username" -p"$password" "$dbase" 2>/dev/null <<< "show tables;" | tail -n +2`
    do
        echo "Matches in table: $table"
        mysql -u"$username" -p"$password" "$dbase" 2>/dev/null <<< "select * from $table" | grep "$findword"
        echo
    done
    echo
done

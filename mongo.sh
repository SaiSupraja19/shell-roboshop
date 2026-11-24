#!/bin/bash

USER=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"


CHECK_ROOT() {
    if [ $USER ! = 0 ]; then
        echo "Please execute this with root user"
        exit 1
}

VALIDATE() {
    if [ $1 ! = 0 ]; then
        echo "$2...FAILURE"
        exit 1
    else
        echo "$2...SUCCESS"
    fi
}

CHECK_ROOT


cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILE
VALIDATE $? "Copying mongo file"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing mongod"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "Enabling Mongod"

systemctl start mongod &>>$LOGS_FILE
VALIDATE $? "Starting Mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGS_FILE
VALIDATE $? "Changing Configuration"

systemctl restart mongod &>>$LOGS_FILE
VALIDATE $? "Restarting Mongod"
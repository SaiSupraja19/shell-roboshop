#!/bin/bash

USER=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
SOURCE_DIR=$PWD

CHECK_ROOT() {
    if [ "$USER" != 0 ]; then
        echo "Please run the script using root user"
        exit 1
    fi 
}

VALIDATE() {
    if [ $1 != 0 ]; then
        echo "$2...FAILURE"
        exit 1
    else 
        echo "$2...SUCCESS"
    fi
}

CHECK_ROOT

dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGS_FILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGS_FILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGS_FILE
VALIDATE $? "Removing default html content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
VALIDATE $? "Extracting the code"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOGS_FILE
VALIDATE $? "Unzipping the code"

cp $SOURCE_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOGS_FILE
VALIDATE $? "Copying the conf file"

systemctl restart nginx &>>$LOGS_FILE
VALIDATE $? "Restarting nginx"
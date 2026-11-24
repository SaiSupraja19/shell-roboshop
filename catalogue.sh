#!/bin/bash

USER=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"

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

# dnf module disable nodejs -y
# VALIDATE $? "Disabling default version"

# dnf module enable nodejs:20 -y
# VALIDATE $? "Enabling version required"

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "Installing Nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
VALIDATE $? "Creating system user"

mkdir /app &>>$LOGS_FILE

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOGS_FILE
VALIDATE $? "Copying code from developer"

cd /app
unzip /tmp/catalogue.zip &>>$LOGS_FILE
VALIDATE $? "Unzipping the code to /app directory"

npm install  &>>$LOGS_FILE
VALIDATE $? "Installing dependencies"

cp catalogue.service /etc/systemd/system/catalogue.service &>>$LOGS_FILE
VALIDATE $? "Copying service file"

systemctl daemon-reload &>>$LOGS_FILE
VALIDATE $? "Reloading the server"

systemctl enable catalogue 
systemctl start catalogue &>>$LOGS_FILE
VALIDATE $?  "Enabling and starting the server"
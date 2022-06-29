#!/bin/bash   

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "

echo -e "\n\n~~~~~~~~~~~~~ Welcome To Salon ~~~~~~~~~~~~~\n"

MAIN_MENU(){

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  #first show services
  echo -e "\nServices Offered\n"
  OS=$($PSQL "SELECT service_id, name FROM services order by service_id")
  echo "$OS" | while read SERVICE_ID bar SERVICE
    do
      echo -e "$SERVICE_ID) $SERVICE" 
    done
  #ask customer to select service
  echo -e "\nPlease select the service you would like by \nentering the corresponding number.\n"
  #get user input  
  read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  1) SERVICES ;;
  2) SERVICES ;;
  3) SERVICES ;;
  4) SERVICES ;;
  *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

SERVICES() { #FUNCTION for creating appointments

  SRV=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nOkay, lets get your$SRV booked! Please enter your phone number."
  read CUSTOMER_PHONE
  C_PHONE=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE' ")
  if [[ -z $C_PHONE ]]
    then
      echo "What name should we use for the appointment?"
      read CUSTOMER_NAME
      echo "When would you like your appointment?"
      read SERVICE_TIME  
      CPI=$($PSQL "INSERT INTO customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      JN=$($PSQL "SELECT customer_id FROM customers LEFT JOIN appointments USING(customer_id) WHERE phone = '$CUSTOMER_PHONE'")
      APP_INSERT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values('$JN','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
      
  else 
    C_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE' ")
    echo "Welcome back $C_NAME."
    echo "When would you like your appointment?"
    read SERVICE_TIME
    RTN_IN=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values('$C_PHONE','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
  fi

  C_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE' ")

  echo "I have put you down for a$SRV at $SERVICE_TIME,$C_NAME."

}

MAIN_MENU

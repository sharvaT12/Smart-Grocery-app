#include<SoftwareSerial.h>

int analogInPin = A0;

int sensorValue = 0;

int outputValue = 0;

int transistorPin = 3;



SoftwareSerial S_port(10,9);

void setup()

{

Serial.begin(9600);
S_port.begin(9600);

//pinMode(0,INPUT);
//pinMode(1,OUTPUT);
pinMode(8, OUTPUT);
pinMode(9, OUTPUT);
pinMode(transistorPin, OUTPUT);
}

void loop()

{
 

  sensorValue = analogRead(analogInPin);
  
  outputValue = map(sensorValue, 0, 1023, 0, 255);

  // Array to hold the message from the temp sensor
  
  if(Serial.available()== 2  ){
    char Mymessage[2];
    Serial.readBytes(Mymessage,2); 
    Serial.print("Received ");
    Serial.println(Mymessage);
    
    if(Mymessage[0] == '1' && Mymessage[1] == '1'){
      analogWrite(transistorPin, 240);
      S_port.write('1');
      delay(2000);
    }
    else if(Mymessage[0] == '0' && Mymessage[1] == '1'){
      analogWrite(transistorPin, 240);
      S_port.write('0');
      delay(2000);
    }
     else if(Mymessage[0] == '1' && Mymessage[1] == '0'){
      analogWrite(transistorPin, outputValue);
      S_port.write('1');
      delay(2000);
    }
     else if(Mymessage[0] == '0' && Mymessage[1] == '0'){
      analogWrite(transistorPin, outputValue);
      S_port.write('0');
      delay(2000);
    }
    else if( Mymessage[1] == '1'){
      analogWrite(transistorPin, 240);
      delay(2000);
    }
    else{
      analogWrite(transistorPin, outputValue);
      delay(2000);
    }

  }
  else{
    analogWrite(transistorPin, outputValue);
  }

}
 //Initialized variable to store recieved data
  
//void setup() {
//  // Begin the Serial at 9600 Baud
//  Serial.begin(9600);
//}
//
//void loop() {
//  Serial.readBytes(Mymessage,1); //Read the serial data and store in var
//  Serial.println(Mymessage); //Print data on Serial Monitor
//  delay(1000);
//}

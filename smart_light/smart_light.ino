
void setup() {
  pinMode(11,OUTPUT);// led
  pinMode(2,INPUT);//
//  Serial.begin(4800);


}

void loop() {
///

if(digitalRead(2)==0){
  //there is a car
  analogWrite(11,255);
}else{
  analogWrite(11,45);
}



///
}

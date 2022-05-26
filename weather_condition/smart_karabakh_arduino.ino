#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "DHT.h"

#define DHTPIN 23
#define DHTTYPE DHT11 

const char* ssid = "MyComp";
const char* password = "tekno12345";

String baseUrl="https://us-central1-smartkarabakh.cloudfunctions.net/main";
String smartLightingUrl=baseUrl+"/main/getLedData";
StaticJsonDocument<200> doc;
bool led_init=true;
unsigned long lastTime = 0;

unsigned long timerDelay = 30;//ms
DHT dht(DHTPIN, DHTTYPE);
float h=0.0;
float t=0.0;

void setup() {
  Serial.begin(115200); 
  pinMode(22,OUTPUT);
 
  
  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());
  dht.begin();
}

void loop() {
  //Send an HTTP POST request every 10 minutes
  if ((millis() - lastTime) > timerDelay) {
    //Check WiFi connection status
    if(WiFi.status()== WL_CONNECTED){
      HTTPClient http;
      // Your Domain name with URL path or IP address with path
      
      h = dht.readHumidity();
  // Read temperature as Celsius (the default)
      t = dht.readTemperature();
      ///TODo

      if (isnan(h) || isnan(t)) {
        
           Serial.println(F("Failed to read from DHT sensor!"));
           delay(1000);
           return;
      }
      http.begin(smartLightingUrl+"?t="+t+"&h="+h);
      
      // Send HTTP GET request
      int httpResponseCode = http.GET();
      
      if (httpResponseCode>0) {
        Serial.print("HTTP Response code: ");
        Serial.println(httpResponseCode);
        String payload = http.getString();
         DeserializationError error = deserializeJson(doc, payload);
         if (error) {
         Serial.print(F("deserializeJson() failed: "));
         Serial.println(error.f_str());
          return;
         }
               
               float energy = doc[F("ledEnergy")];
               Serial.println(energy);
               analogWrite(22, energy);
              
//         if(doc["led"]=="on"){
//          digitalWrite(2, 1);
//           Serial.println("on");
//         }else{
//          digitalWrite(2, 0);
//            Serial.println("off");
//         }
      }
      else {
        Serial.print("Error code: ");
        Serial.println(httpResponseCode);
      }
      // Free resources
      http.end();
    }
    else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
    led_init=false;
  }  
}

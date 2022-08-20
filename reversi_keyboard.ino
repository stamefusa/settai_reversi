// Arduino Leonardoとして書き込む必要がある

#include <Keyboard.h>

int pin1 = 3;
int pin2 = 4;

int val1 = 0, pre_val1 = 0;
int val2 = 0, pre_val2 = 0;

void setup() {
  //Serial.begin(9600);
  Keyboard.begin();
  pinMode(pin1, INPUT_PULLUP);
  pinMode(pin2, INPUT_PULLUP);
}

void loop() {
  val1 = digitalRead(pin1);
  val2 = digitalRead(pin2);
  if ((pre_val1 == 1 && val1 == 0)
    || (pre_val2 == 1 && val2 == 0)) {
    //Serial.println("push");
    Keyboard.press('s');
  }
  pre_val1 = val1;
  pre_val2 = val2;
  delay(100);
  Keyboard.releaseAll();
}

#include <stdint.h>
#ifndef MOTOR
#define MOTOR
#include <AccelStepper.h>
#include "Arduino.h"

class Motor {
  
  private:

    uint8_t id;       // motor identifier
    uint8_t pin;      // index of PWM pin
    uint8_t speed;    // current motor state

  public:
    Motor();
    Motor(uint8_t id, uint8_t pin);

    uint8_t getId();
    uint8_t getPin();

    uint8_t getSpeed();
    void setSpeed(uint8_t speed);

    String toString();
};

class Stepper {

  private:

    uint8_t id;
    AccelStepper* driver;

    int position;

  public:
    Stepper();
    Stepper(uint8_t id, int steps, uint8_t directionPin, uint8_t stepPin);

    uint8_t getId();   
    int getPosition();
    void setPosition(int position);
    AccelStepper* getDriver();
};

#endif
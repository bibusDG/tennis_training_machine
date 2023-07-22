#include "AccelStepper.h"
#include "motor.h"

// MOTOR //////////////////////////////////////////////////////////////////////////////////

Motor::Motor() {}

Motor::Motor(uint8_t id, uint8_t pin) {
  this->id = id;
  this->pin = pin;
  this->speed = 0;
}

uint8_t Motor::getId() {
  return this->id;
}

uint8_t Motor::getPin() {
  return this->pin;
}

uint8_t Motor::getSpeed() {
  return this->speed;
}

void Motor::setSpeed(uint8_t speed) {
  this->speed = speed;
}

String Motor::toString() {
  return "(Motor)[id: " + (String)this->id + ", pin: " + (String)this->pin + ", speed: " + (String)this->speed + "]";
}

// STEPPER ////////////////////////////////////////////////////////////////////////////////

Stepper::Stepper() {}

Stepper::Stepper(uint8_t id, int steps, uint8_t directionPin, uint8_t stepPin) {
  this->id = id;
  this->position = 0;
  this->driver = new AccelStepper(1, stepPin, directionPin);
  this->driver->setMaxSpeed(1000);
}

uint8_t Stepper::getId() {
  return this->id;
}

int Stepper::getPosition() {
  return this->position;
}

void Stepper::setPosition(int position) {
  this->position = position;
}

AccelStepper* Stepper::getDriver() {
  return this->driver;
}

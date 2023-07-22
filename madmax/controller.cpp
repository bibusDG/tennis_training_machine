#include "AccelStepper.h"
#include <stdint.h>
#include "Arduino.h"
#include "controller.h"

MotorController::MotorController(uint8_t motorCount, uint8_t stepperCount) {
  this->motors = new Motor[motorCount];
  this->steppers = new Stepper[stepperCount];  
}

void MotorController::addMotor(Motor* motor) {
  this->motors[motor->getId()] = *motor;
  pinMode(motor->getPin(), OUTPUT);
  digitalWrite(motor->getPin(), LOW);
}

uint8_t MotorController::getMotorSpeed(uint8_t id) {
  Motor* motor = &this->motors[id];
  return motor->getSpeed();
}

void MotorController::setMotorSpeed(uint8_t id, uint8_t speed) {
  Motor* motor = &this->motors[id];
  if (motor->getSpeed() != speed) {
    analogWrite(motor->getPin(), speed);
    motor->setSpeed(speed);
  }
  debug(motor);
}

void MotorController::addStepper(Stepper* stepper) {
  this->steppers[stepper->getId()] = *stepper;
}

Stepper* MotorController::getStepper(uint8_t id) {
  return &this->steppers[id];
}

void MotorController::moveToPosition(uint8_t id, int position) {
  Stepper* stepper = &this->steppers[id];
  stepper->getDriver()->moveTo(STEP_RESOLUTION*position);
}

void MotorController::invalidate() {
  AccelStepper* driver = this->steppers[LEFT_SHAFT].getDriver();
  driver->setSpeed(400);
  driver->runSpeedToPosition();  
  
  driver = this->steppers[RIGHT_SHAFT].getDriver();
  driver->setSpeed(400);
  driver->runSpeedToPosition();  
}

void MotorController::debug(Motor* motor) {
  Serial.println(motor->toString());
}


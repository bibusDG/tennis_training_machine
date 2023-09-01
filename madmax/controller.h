#include <stdint.h>
#ifndef CONTROLLER
#define CONTROLLER

#include "motor.h"

#define BOT_ROLLER 0
#define TOP_ROLLER 1
#define LEFT_SHAFT 1
#define RIGHT_SHAFT 2
#define FEEDER 3

#define STEP_RESOLUTION 5

class MotorController {

  private:

    Motor* motors;
    Stepper* steppers;

    void debug(Motor* motor);

  public:
    MotorController(uint8_t motorCount, uint8_t stepperCount);

    void invalidate();

    // motor control
    void addMotor(Motor* motor);
    uint8_t getMotorSpeed(uint8_t id);
    void setMotorSpeed(uint8_t id, uint8_t speed);

    // stepper control
    void addStepper(Stepper* stepper);
    Stepper* getStepper(uint8_t id);
    void moveToPosition(uint8_t id, int position);
    void moveBy(uint8_t id, int steps);
    void move(uint8_t id, float speed);
};

#endif
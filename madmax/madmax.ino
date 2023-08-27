#include "controller.h"
#include "plan.h"
#include "counter.h"

#define MAX_BALLS 150

Counter* counter;
Limiter* limiter;
MotorController* controller;
Configuration* plan = new Configuration[MAX_BALLS];
Configuration* configuration;

uint8_t ballCount = 0;

void setup() {

  // // Pins D3 and D11 - 31.4 kHz
  TCCR2B = 0b00000001; // x1
  TCCR2A = 0b00000001; // phase correct

  Serial.begin(9600);

  // create an instance of ball counter, with switch connected to pin14 (Analog 0)
  // and set a sensitivity to 50ms
  counter = new Counter(ANALOG_0, 50, 4);

  limiter = new Limiter(ANALOG_1, 30);

  // create an instance of motor controller, and add both dc & stepper motors
  //
  controller = new MotorController(2, 3);
  controller->addMotor(new Motor(BOT_ROLLER, DIGITAL_9_PWM));
  controller->addMotor(new Motor(TOP_ROLLER, DIGITAL_10_PWM));
  controller->addStepper(new Stepper(LEFT_SHAFT, 200, DIGITAL_5_PWM, DIGITAL_2));
  controller->addStepper(new Stepper(RIGHT_SHAFT, 200, DIGITAL_7, DIGITAL_4));
  controller->addStepper(new Stepper(FEEDER, 200, DIGITAL_6_PWM, DIGITAL_3_PWM));

  // initialize memory chunk
  for (int i = 0; i < 150; i++) {
    plan[i] = Configuration(0, 0, 0, 0, 0, 0);
  }

  // plan[0].update(0, 0, 0, 0, 0, 0);
  // plan[1].update(255, 255, 255, 255, 0, 0);
  // plan[2].update(100, 100, 255, 200, 0, 0);
  // plan[3].update(50, 50, 200, 255, 0, 0);
  controller->setMotorSpeed(BOT_ROLLER, 120);
  controller->setMotorSpeed(TOP_ROLLER, 120);  
  //controller->setStepperSpeed(FEEDER, 400);
}

void loop() {

  // update counter state
  invalidateCounter(counter);
  // update limiters state
  invalidateLimiter(limiter);

  // if (ballCount != counter->getCount()) {
  //   ballCount = counter->getCount();
  //   Serial.println("balls: " + (String)ballCount);
    
  //   configuration = &plan[ballCount];
  //   Serial.println(configuration->toString());

  //   controller->setMotorSpeed(BOT_ROLLER, configuration->getBotSpeed());
  //   controller->setMotorSpeed(TOP_ROLLER, configuration->getTopSpeed());
  //   controller->moveToPosition(LEFT_SHAFT, configuration->getLeft());
  //   controller->moveToPosition(RIGHT_SHAFT, configuration->getRight());
  // }
  
  controller->invalidate();

  // if (limiter->getState()) {
  //   controller->moveToPosition(LEFT_SHAFT, 200);
  //   controller->moveToPosition(RIGHT_SHAFT, 200);
  // }

}

// interrupt service routine for analog pins (A0-5, Port C)
ISR (PCINT1_vect) {
  
  // check ball counter state
  if (digitalRead(counter->getPin()) == LOW && !counter->isUpdating()) {
    counter->startUpdate();
  }
  // check shaft limiters
  else  if (digitalRead(limiter->getPin()) == LOW && !limiter->isUpdating() && !limiter->getState()) {
    limiter->startUpdate();
  }
  else if (digitalRead(limiter->getPin()) == HIGH && !limiter->isUpdating() && limiter->getState()) {
    limiter->startUpdate();
  }
  // TODO: check feeder limiter
}

void invalidateCounter(Counter* instance) {
  if (instance->isUpdating()) {
    if (digitalRead(instance->getPin()) == HIGH) {
      delay(instance->getSensitivity()); // debouncing
      if (digitalRead(instance->getPin()) == HIGH) {
        instance->finishUpdate();
      }
    }
  }
}

void invalidateLimiter(Limiter* instance) {
  if (instance->isUpdating()) {
    if (digitalRead(instance->getPin()) == LOW) {
      delay(instance->getSensitivity());
      if (digitalRead(instance->getPin()) == LOW) {
        instance->finishUpdate(true);
        Serial.println("ON");
      }
    }
    else 
    if (digitalRead(instance->getPin()) == HIGH) {
      delay(instance->getSensitivity());
      if (digitalRead(instance->getPin()) == HIGH) {
        instance->finishUpdate(false);
        Serial.println("OFF");
      }
    }    
  }
}

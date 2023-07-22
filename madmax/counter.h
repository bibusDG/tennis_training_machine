#include <stdint.h>
#include "Arduino.h"
#ifndef COUNTER
#define COUNTER

#define ANALOG_0 14
#define ANALOG_1 15
#define ANALOG_2 16

#define DIGITAL_2 2
#define DIGITAL_3_PWM 3
#define DIGITAL_4 4
#define DIGITAL_5_PWM 5
#define DIGITAL_6_PWM 6
#define DIGITAL_7 7
#define DIGITAL_8 8
#define DIGITAL_9_PWM 9
#define DIGITAL_10_PWM 10
#define DIGITAL_11_PWM 11
#define DIGITAL_12 12

class BaseSwitch {

  protected:
    uint8_t pin;                       // sensor analog pin (A0 - A5)
    uint8_t sensitivity;              // can register a single counter update in this time window
    volatile bool updating = false;    // indicates that the counter is in the middle of the value update
    volatile long updateStartMs = 0L;  // first occurence of the interrupt on the pin

  public:
    BaseSwitch();
    BaseSwitch(uint8_t pin, uint8_t sensitivity);

    uint8_t getPin();
    uint8_t getSensitivity();
    bool isUpdating();
    void startUpdate();
    bool finishUpdate();
};

class Counter : public BaseSwitch {

  protected:
    uint8_t count = 0;                 // count value
    uint8_t max;                       // max counter value - it will wrap around to 0 on next update

  public:
      Counter();
      Counter(uint8_t pin, uint8_t sensitivity, uint8_t max);
      uint8_t getCount();
      bool finishUpdate();
};

class Limiter : public BaseSwitch {

  protected:
    bool state = false;  // limiter state

  public:
    Limiter();
    Limiter(uint8_t pin, uint8_t sensitivity);

    bool getState();
    bool finishUpdate(bool state);
};

#endif
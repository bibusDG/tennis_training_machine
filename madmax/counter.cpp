#include <stdint.h>
#include "counter.h"

// BASE ////////////////////////////////////////////////////////////////////////////////////

BaseSwitch::BaseSwitch() {}

BaseSwitch::BaseSwitch(uint8_t pin, uint8_t sensitivity) {
  this->pin = pin;
  this->sensitivity = sensitivity;
  pinMode(this->pin, INPUT_PULLUP);
  // enable interrupts on port C (A0-5 pins)
  PCICR  |= B00000010;
  // register pin change interrupts on our analog pin
  PCMSK1 |= (byte) (1 << (this->pin - ANALOG_0)); 
}

uint8_t BaseSwitch::getPin() {
  return this->pin;
}

uint8_t BaseSwitch::getSensitivity() {
  return this->sensitivity;
}

bool BaseSwitch::isUpdating() {
  return this->updating;
}

void BaseSwitch::startUpdate() {
  if (!this->updating) {
    this->updating = true;
    this->updateStartMs = millis();
  }
  else {
    if (millis() - this->updateStartMs >= this->sensitivity) {
      this->updateStartMs = millis();
    }
  }

}

bool BaseSwitch::finishUpdate() {
  if (this->updating) {
    if (millis() - this->updateStartMs >= this->sensitivity) {
      this->updating = false;
      return true;
    }
  }
  return false;
}

// COUNTER ////////////////////////////////////////////////////////////////////////////////

Counter::Counter() {}

Counter::Counter(uint8_t pin, uint8_t sensitivity, uint8_t max) : BaseSwitch(pin, sensitivity) {
  this->max = max;
}

uint8_t Counter::getCount() {
  return this->count;
}

bool Counter::finishUpdate() {
  if (BaseSwitch::finishUpdate()) {
    this->count = ((this->count + 1) % this->max);
    return true;
  }
  return false;
}

// LIMITER //////////////////////////////////////////////////////////////////////////////

Limiter::Limiter() {}

Limiter::Limiter(uint8_t pin, uint8_t sensitivity) : BaseSwitch(pin, sensitivity) {}

bool Limiter::getState() {
  return this->state;
}

bool Limiter::finishUpdate(bool state) {
  if (BaseSwitch::finishUpdate()) {
    this->state = state;
    return true;
  }
  return false;
}



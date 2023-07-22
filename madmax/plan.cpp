#include "plan.h"

Configuration::Configuration() {}

Configuration::Configuration(uint8_t left, uint8_t right, uint8_t topSpeed, uint8_t botSpeed, uint8_t repeat, uint8_t delay) {
  this->update(left, right, topSpeed, botSpeed, repeat, delay);
}

void Configuration::update(uint8_t left, uint8_t right, uint8_t topSpeed, uint8_t botSpeed, uint8_t repeat, uint8_t delay) {
  this->left = left;
  this->right = right;
  this->topSpeed = topSpeed;
  this->botSpeed = botSpeed;
  this->repeat = repeat;
  this->delay = delay;
}

uint8_t Configuration::getLeft() {
  return this->left;
}

uint8_t Configuration::getRight() {
  return this->right;
}

uint8_t Configuration::getTopSpeed() {
  return this->topSpeed;
}

uint8_t Configuration::getBotSpeed() {
  return this->botSpeed;
}

uint8_t Configuration::getRepat() {
  return this->repeat;
}
    
uint8_t Configuration::getDealy() {
  return this->delay;
}

String Configuration::toString() {
  return "(Configuration)[left: " + (String)this->left + ", right: " + (String)this->right + ", topSpeed: " + (String)this->topSpeed + ", botSpeed: " + (String)this->botSpeed + ", delay: " + (String)this->delay + "]";
}


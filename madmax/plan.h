#include <stdint.h>
#include "Arduino.h"
#ifndef PLAN
#define PLAN

class Configuration {
  
  private:

    uint8_t left;     // left shaft position
    uint8_t right;    // right shaft position
    uint8_t topSpeed; // top roller speed
    uint8_t botSpeed; // bot roller speed
    uint8_t repeat;   // ball count in this setup
    uint8_t delay;    // dealy between balls

  public:
    Configuration();
    Configuration(uint8_t left, uint8_t right, uint8_t topSpeed, uint8_t botSpeed, uint8_t repeat, uint8_t delay);
    void update(uint8_t left, uint8_t right, uint8_t topSpeed, uint8_t botSpeed, uint8_t repeat, uint8_t delay);

    uint8_t getLeft();
    uint8_t getRight();
    uint8_t getTopSpeed();
    uint8_t getBotSpeed();
    uint8_t getRepat();
    uint8_t getDealy();

    String toString();
};

class Group {

  private:
    // group can either be a container for other groups, or it can contain a vector of configurations (tree leaf)
    // these are mutually exclusive - a group with both children and configurations is not legal
    // 
    // Example:
    //    G1(C1), G2( G3(C31, C32), G4(C41, C42, C43)), G3(G4(G5(C51, C52, C53)))
    //
    Configuration* configurations;
    Group* children;

    uint8_t repeat; // applies to either child groups or a vector of configurations
                    // G1(G2, G3, r=2)      -> G2, G3, G2, G3
                    // G1(C1, C2(r=2), r=2) -> C1, C2, C2, C1, C2, C2

    uint8_t delay;  // delay applied at the end of group execution

  public:

    Group();

    // flattens this group configuration into a given buffer, starting at startIndex (recursive)
    // returns: number of added configurations
    //
    // example:
    //     G1( G2(C1, C2), G3(C3, r=2), r = 2) -> [ C1, C2, C3, C3, C1, C2, C3, C3]
    //                                                      ------          ------
    //                                              --------------  --------------
    uint8_t flattenTo(Configuration* buffer, uint8_t startIndex);
};

#endif
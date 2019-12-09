// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header

#ifndef _VDownsample__Syms_H_
#define _VDownsample__Syms_H_

#include "verilated.h"

// INCLUDE MODULE CLASSES
#include "VDownsample.h"

// SYMS CLASS
class VDownsample__Syms : public VerilatedSyms {
  public:
    
    // LOCAL STATE
    const char* __Vm_namep;
    bool __Vm_didInit;
    
    // SUBCELL STATE
    VDownsample*                   TOPp;
    
    // CREATORS
    VDownsample__Syms(VDownsample* topp, const char* namep);
    ~VDownsample__Syms() {}
    
    // METHODS
    inline const char* name() { return __Vm_namep; }
    
} VL_ATTR_ALIGNED(64);

#endif  // guard

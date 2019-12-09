// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header

#ifndef _VSDRAMController__Syms_H_
#define _VSDRAMController__Syms_H_

#include "verilated.h"

// INCLUDE MODULE CLASSES
#include "VSDRAMController.h"

// SYMS CLASS
class VSDRAMController__Syms : public VerilatedSyms {
  public:
    
    // LOCAL STATE
    const char* __Vm_namep;
    bool __Vm_didInit;
    
    // SUBCELL STATE
    VSDRAMController*              TOPp;
    
    // CREATORS
    VSDRAMController__Syms(VSDRAMController* topp, const char* namep);
    ~VSDRAMController__Syms() {}
    
    // METHODS
    inline const char* name() { return __Vm_namep; }
    
} VL_ATTR_ALIGNED(64);

#endif  // guard

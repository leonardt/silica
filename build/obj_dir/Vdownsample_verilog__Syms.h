// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header

#ifndef _Vdownsample_verilog__Syms_H_
#define _Vdownsample_verilog__Syms_H_

#include "verilated.h"

// INCLUDE MODULE CLASSES
#include "Vdownsample_verilog.h"

// SYMS CLASS
class Vdownsample_verilog__Syms : public VerilatedSyms {
  public:
    
    // LOCAL STATE
    const char* __Vm_namep;
    bool __Vm_didInit;
    
    // SUBCELL STATE
    Vdownsample_verilog*           TOPp;
    
    // CREATORS
    Vdownsample_verilog__Syms(Vdownsample_verilog* topp, const char* namep);
    ~Vdownsample_verilog__Syms() {}
    
    // METHODS
    inline const char* name() { return __Vm_namep; }
    
} VL_ATTR_ALIGNED(64);

#endif  // guard

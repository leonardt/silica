// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VDownsample_H_
#define _VDownsample_H_

#include "verilated.h"

class VDownsample__Syms;

//----------

VL_MODULE(VDownsample) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    // Begin mtask footprint  all: 
    VL_IN8(CLK,0,0);
    VL_IN8(RESET,0,0);
    VL_OUT8(data_in_ready,0,0);
    VL_OUT8(data_out_valid,0,0);
    VL_IN8(data_in_valid,0,0);
    VL_IN8(data_out_ready,0,0);
    VL_OUT16(data_out_data,15,0);
    VL_IN16(data_in_data,15,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    // Begin mtask footprint  all: 
    VL_SIG8(Downsample__DOT__keep,0,0);
    VL_SIG8(Downsample__DOT__y,4,0);
    VL_SIG8(Downsample__DOT__y_next,4,0);
    VL_SIG8(Downsample__DOT__x,4,0);
    VL_SIG8(Downsample__DOT__x_next,4,0);
    VL_SIG8(Downsample__DOT__yield_state,0,0);
    VL_SIG8(Downsample__DOT__yield_state_next,0,0);
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    // Begin mtask footprint  all: 
    VL_SIG8(__Vclklast__TOP__CLK,0,0);
    VL_SIG8(__Vclklast__TOP__RESET,0,0);
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    VDownsample__Syms* __VlSymsp;  // Symbol table
    
    // PARAMETERS
    // Parameters marked /*verilator public*/ for use by application code
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(VDownsample);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    VDownsample(const char* name="TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~VDownsample();
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval();
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(VDownsample__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(VDownsample__Syms* symsp, bool first);
  private:
    static QData _change_request(VDownsample__Syms* __restrict vlSymsp);
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(VDownsample__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif // VL_DEBUG
  public:
    static void _eval_initial(VDownsample__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(VDownsample__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__1(VDownsample__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__2(VDownsample__Syms* __restrict vlSymsp);
    static void _settle__TOP__3(VDownsample__Syms* __restrict vlSymsp);
} VL_ATTR_ALIGNED(128);

#endif // guard

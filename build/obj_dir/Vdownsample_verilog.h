// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _Vdownsample_verilog_H_
#define _Vdownsample_verilog_H_

#include "verilated.h"

class Vdownsample_verilog__Syms;

//----------

VL_MODULE(Vdownsample_verilog) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    // Begin mtask footprint  all: 
    VL_IN8(CLK,0,0);
    VL_IN8(RESET,0,0);
    VL_IN8(data_in_valid,0,0);
    VL_OUT8(data_in_ready,0,0);
    VL_OUT8(data_out_valid,0,0);
    VL_IN8(data_out_ready,0,0);
    VL_IN16(data_in_data,15,0);
    VL_OUT16(data_out_data,15,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    // Begin mtask footprint  all: 
    VL_SIG8(downsample_verilog__DOT__x,4,0);
    VL_SIG8(downsample_verilog__DOT__y,4,0);
    VL_SIG8(downsample_verilog__DOT__x_next,4,0);
    VL_SIG8(downsample_verilog__DOT__y_next,4,0);
    VL_SIG8(downsample_verilog__DOT__keep,0,0);
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    // Begin mtask footprint  all: 
    VL_SIG8(__Vclklast__TOP__CLK,0,0);
    VL_SIG8(__Vclklast__TOP__RESET,0,0);
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vdownsample_verilog__Syms* __VlSymsp;  // Symbol table
    
    // PARAMETERS
    // Parameters marked /*verilator public*/ for use by application code
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vdownsample_verilog);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vdownsample_verilog(const char* name="TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vdownsample_verilog();
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval();
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vdownsample_verilog__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vdownsample_verilog__Syms* symsp, bool first);
  private:
    static QData _change_request(Vdownsample_verilog__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__1(Vdownsample_verilog__Syms* __restrict vlSymsp);
    static void _combo__TOP__4(Vdownsample_verilog__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vdownsample_verilog__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif // VL_DEBUG
  public:
    static void _eval_initial(Vdownsample_verilog__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vdownsample_verilog__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__3(Vdownsample_verilog__Syms* __restrict vlSymsp);
    static void _settle__TOP__2(Vdownsample_verilog__Syms* __restrict vlSymsp) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(128);

#endif // guard

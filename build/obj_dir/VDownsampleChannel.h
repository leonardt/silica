// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VDownsampleChannel_H_
#define _VDownsampleChannel_H_

#include "verilated.h"

class VDownsampleChannel__Syms;
class VerilatedVcd;

//----------

VL_MODULE(VDownsampleChannel) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    // Begin mtask footprint  all: 
    VL_IN8(CLK,0,0);
    VL_OUT8(data_out_valid,0,0);
    VL_OUT8(data_in_ready,0,0);
    VL_IN8(data_in_valid,0,0);
    VL_IN8(data_out_ready,0,0);
    VL_OUT16(data_out_data,15,0);
    VL_IN16(data_in_data,15,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    // Begin mtask footprint  all: 
    VL_SIG8(DownsampleChannel__DOT__x,4,0);
    VL_SIG8(DownsampleChannel__DOT__x_next,4,0);
    VL_SIG8(DownsampleChannel__DOT__y,4,0);
    VL_SIG8(DownsampleChannel__DOT__y_next,4,0);
    VL_SIG8(DownsampleChannel__DOT__keep,0,0);
    VL_SIG8(DownsampleChannel__DOT__keep_next,0,0);
    VL_SIG8(DownsampleChannel__DOT__yield_state,2,0);
    VL_SIG8(DownsampleChannel__DOT__yield_state_next,2,0);
    VL_SIG16(DownsampleChannel__DOT__data,15,0);
    VL_SIG16(DownsampleChannel__DOT__data_next,15,0);
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    // Begin mtask footprint  all: 
    VL_SIG8(__Vclklast__TOP__CLK,0,0);
    VL_SIG(__Vm_traceActivity,31,0);
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    VDownsampleChannel__Syms* __VlSymsp;  // Symbol table
    
    // PARAMETERS
    // Parameters marked /*verilator public*/ for use by application code
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(VDownsampleChannel);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    VDownsampleChannel(const char* name="TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~VDownsampleChannel();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options=0);
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval();
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(VDownsampleChannel__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(VDownsampleChannel__Syms* symsp, bool first);
  private:
    static QData _change_request(VDownsampleChannel__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__3(VDownsampleChannel__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(VDownsampleChannel__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif // VL_DEBUG
  public:
    static void _eval_initial(VDownsampleChannel__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(VDownsampleChannel__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__2(VDownsampleChannel__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__1(VDownsampleChannel__Syms* __restrict vlSymsp);
    static void traceChgThis(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__2(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__3(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__4(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__5(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceFullThis(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) VL_ATTR_COLD;
    static void traceFullThis__1(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) VL_ATTR_COLD;
    static void traceInitThis(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) VL_ATTR_COLD;
    static void traceInitThis__1(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) VL_ATTR_COLD;
    static void traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code);
} VL_ATTR_ALIGNED(128);

#endif // guard

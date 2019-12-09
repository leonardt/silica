// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VSDRAMController_H_
#define _VSDRAMController_H_

#include "verilated.h"

class VSDRAMController__Syms;

//----------

VL_MODULE(VSDRAMController) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    // Begin mtask footprint  all: 
    VL_IN8(CLK,0,0);
    VL_IN8(RESET,0,0);
    VL_OUT8(cmd,7,0);
    VL_IN8(rd_enable,0,0);
    VL_OUT8(state,4,0);
    VL_IN8(wr_enable,0,0);
    VL_IN16(refresh_cnt,9,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    // Begin mtask footprint  all: 
    VL_SIG8(SDRAMController__DOT___SDRAMController_inst0_cmd,7,0);
    VL_SIG8(SDRAMController__DOT___SDRAMController_inst0_n,3,0);
    VL_SIG8(SDRAMController__DOT___SDRAMController_inst0__DOT__cmd_next,7,0);
    VL_SIG8(SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state,4,0);
    VL_SIG8(SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state_next,4,0);
    VL_SIG8(SDRAMController__DOT__enable_inst0__DOT__count,3,0);
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    // Begin mtask footprint  all: 
    VL_SIG8(__Vclklast__TOP__CLK,0,0);
    VL_SIG8(__Vclklast__TOP__RESET,0,0);
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    VSDRAMController__Syms* __VlSymsp;  // Symbol table
    
    // PARAMETERS
    // Parameters marked /*verilator public*/ for use by application code
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(VSDRAMController);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    VSDRAMController(const char* name="TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~VSDRAMController();
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval();
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(VSDRAMController__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(VSDRAMController__Syms* symsp, bool first);
  private:
    static QData _change_request(VSDRAMController__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__3(VSDRAMController__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(VSDRAMController__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif // VL_DEBUG
  public:
    static void _eval_initial(VSDRAMController__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(VSDRAMController__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__1(VSDRAMController__Syms* __restrict vlSymsp);
    static void _settle__TOP__2(VSDRAMController__Syms* __restrict vlSymsp) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(128);

#endif // guard

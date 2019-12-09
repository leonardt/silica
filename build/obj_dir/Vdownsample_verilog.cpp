// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdownsample_verilog.h for the primary calling header

#include "Vdownsample_verilog.h"
#include "Vdownsample_verilog__Syms.h"


//--------------------
// STATIC VARIABLES


//--------------------

VL_CTOR_IMP(Vdownsample_verilog) {
    Vdownsample_verilog__Syms* __restrict vlSymsp = __VlSymsp = new Vdownsample_verilog__Syms(this, name());
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vdownsample_verilog::__Vconfigure(Vdownsample_verilog__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

Vdownsample_verilog::~Vdownsample_verilog() {
    delete __VlSymsp; __VlSymsp=NULL;
}

//--------------------


void Vdownsample_verilog::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vdownsample_verilog::eval\n"); );
    Vdownsample_verilog__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
	VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
	_eval(vlSymsp);
	if (VL_UNLIKELY(++__VclockLoop > 100)) {
	    // About to fail, so enable debug to see what's not settling.
	    // Note you must run make with OPT=-DVL_DEBUG for debug prints.
	    int __Vsaved_debug = Verilated::debug();
	    Verilated::debug(1);
	    __Vchange = _change_request(vlSymsp);
	    Verilated::debug(__Vsaved_debug);
	    VL_FATAL_MT(__FILE__,__LINE__,__FILE__,"Verilated model didn't converge");
	} else {
	    __Vchange = _change_request(vlSymsp);
	}
    } while (VL_UNLIKELY(__Vchange));
}

void Vdownsample_verilog::_eval_initial_loop(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
	_eval_settle(vlSymsp);
	_eval(vlSymsp);
	if (VL_UNLIKELY(++__VclockLoop > 100)) {
	    // About to fail, so enable debug to see what's not settling.
	    // Note you must run make with OPT=-DVL_DEBUG for debug prints.
	    int __Vsaved_debug = Verilated::debug();
	    Verilated::debug(1);
	    __Vchange = _change_request(vlSymsp);
	    Verilated::debug(__Vsaved_debug);
	    VL_FATAL_MT(__FILE__,__LINE__,__FILE__,"Verilated model didn't DC converge");
	} else {
	    __Vchange = _change_request(vlSymsp);
	}
    } while (VL_UNLIKELY(__Vchange));
}

//--------------------
// Internal Methods

VL_INLINE_OPT void Vdownsample_verilog::_combo__TOP__1(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_combo__TOP__1\n"); );
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->data_out_data = vlTOPp->data_in_data;
}

void Vdownsample_verilog::_settle__TOP__2(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_settle__TOP__2\n"); );
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->data_out_data = vlTOPp->data_in_data;
    vlTOPp->downsample_verilog__DOT__keep = ((0U == 
					      VL_MODDIV_III(32, (IData)(vlTOPp->downsample_verilog__DOT__x), (IData)(2U))) 
					     & (0U 
						== 
						VL_MODDIV_III(32, (IData)(vlTOPp->downsample_verilog__DOT__y), (IData)(2U))));
    vlTOPp->data_out_valid = ((IData)(vlTOPp->downsample_verilog__DOT__keep) 
			      & (IData)(vlTOPp->data_in_valid));
    vlTOPp->data_in_ready = (1U & ((IData)(vlTOPp->data_out_ready) 
				   | (~ (IData)(vlTOPp->downsample_verilog__DOT__keep))));
    // ALWAYS at downsample_verilog.v:23
    vlTOPp->downsample_verilog__DOT__x_next = (0x1fU 
					       & (((IData)(vlTOPp->data_in_ready) 
						   & (IData)(vlTOPp->data_in_valid))
						   ? 
						  ((IData)(1U) 
						   + (IData)(vlTOPp->downsample_verilog__DOT__x))
						   : (IData)(vlTOPp->downsample_verilog__DOT__x)));
    // ALWAYS at downsample_verilog.v:23
    vlTOPp->downsample_verilog__DOT__y_next = (0x1fU 
					       & (((IData)(vlTOPp->data_in_ready) 
						   & (IData)(vlTOPp->data_in_valid))
						   ? 
						  ((0x1fU 
						    == (IData)(vlTOPp->downsample_verilog__DOT__x))
						    ? 
						   ((IData)(1U) 
						    + (IData)(vlTOPp->downsample_verilog__DOT__y))
						    : (IData)(vlTOPp->downsample_verilog__DOT__y))
						   : (IData)(vlTOPp->downsample_verilog__DOT__y)));
}

VL_INLINE_OPT void Vdownsample_verilog::_sequent__TOP__3(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_sequent__TOP__3\n"); );
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // ALWAYS at downsample_verilog.v:38
    vlTOPp->downsample_verilog__DOT__y = ((IData)(vlTOPp->RESET)
					   ? 0U : (IData)(vlTOPp->downsample_verilog__DOT__y_next));
    // ALWAYS at downsample_verilog.v:38
    vlTOPp->downsample_verilog__DOT__x = ((IData)(vlTOPp->RESET)
					   ? 0U : (IData)(vlTOPp->downsample_verilog__DOT__x_next));
    vlTOPp->downsample_verilog__DOT__keep = ((0U == 
					      VL_MODDIV_III(32, (IData)(vlTOPp->downsample_verilog__DOT__x), (IData)(2U))) 
					     & (0U 
						== 
						VL_MODDIV_III(32, (IData)(vlTOPp->downsample_verilog__DOT__y), (IData)(2U))));
}

VL_INLINE_OPT void Vdownsample_verilog::_combo__TOP__4(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_combo__TOP__4\n"); );
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->data_out_valid = ((IData)(vlTOPp->downsample_verilog__DOT__keep) 
			      & (IData)(vlTOPp->data_in_valid));
    vlTOPp->data_in_ready = (1U & ((IData)(vlTOPp->data_out_ready) 
				   | (~ (IData)(vlTOPp->downsample_verilog__DOT__keep))));
    // ALWAYS at downsample_verilog.v:23
    vlTOPp->downsample_verilog__DOT__x_next = (0x1fU 
					       & (((IData)(vlTOPp->data_in_ready) 
						   & (IData)(vlTOPp->data_in_valid))
						   ? 
						  ((IData)(1U) 
						   + (IData)(vlTOPp->downsample_verilog__DOT__x))
						   : (IData)(vlTOPp->downsample_verilog__DOT__x)));
    // ALWAYS at downsample_verilog.v:23
    vlTOPp->downsample_verilog__DOT__y_next = (0x1fU 
					       & (((IData)(vlTOPp->data_in_ready) 
						   & (IData)(vlTOPp->data_in_valid))
						   ? 
						  ((0x1fU 
						    == (IData)(vlTOPp->downsample_verilog__DOT__x))
						    ? 
						   ((IData)(1U) 
						    + (IData)(vlTOPp->downsample_verilog__DOT__y))
						    : (IData)(vlTOPp->downsample_verilog__DOT__y))
						   : (IData)(vlTOPp->downsample_verilog__DOT__y)));
}

void Vdownsample_verilog::_eval(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_eval\n"); );
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
    if ((((IData)(vlTOPp->CLK) & (~ (IData)(vlTOPp->__Vclklast__TOP__CLK))) 
	 | ((IData)(vlTOPp->RESET) & (~ (IData)(vlTOPp->__Vclklast__TOP__RESET))))) {
	vlTOPp->_sequent__TOP__3(vlSymsp);
    }
    vlTOPp->_combo__TOP__4(vlSymsp);
    // Final
    vlTOPp->__Vclklast__TOP__CLK = vlTOPp->CLK;
    vlTOPp->__Vclklast__TOP__RESET = vlTOPp->RESET;
}

void Vdownsample_verilog::_eval_initial(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_eval_initial\n"); );
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__CLK = vlTOPp->CLK;
    vlTOPp->__Vclklast__TOP__RESET = vlTOPp->RESET;
}

void Vdownsample_verilog::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::final\n"); );
    // Variables
    Vdownsample_verilog__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vdownsample_verilog::_eval_settle(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_eval_settle\n"); );
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__2(vlSymsp);
}

VL_INLINE_OPT QData Vdownsample_verilog::_change_request(Vdownsample_verilog__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_change_request\n"); );
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vdownsample_verilog::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((data_in_valid & 0xfeU))) {
	Verilated::overWidthError("data_in_valid");}
    if (VL_UNLIKELY((data_out_ready & 0xfeU))) {
	Verilated::overWidthError("data_out_ready");}
    if (VL_UNLIKELY((CLK & 0xfeU))) {
	Verilated::overWidthError("CLK");}
    if (VL_UNLIKELY((RESET & 0xfeU))) {
	Verilated::overWidthError("RESET");}
}
#endif // VL_DEBUG

void Vdownsample_verilog::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdownsample_verilog::_ctor_var_reset\n"); );
    // Body
    data_in_valid = VL_RAND_RESET_I(1);
    data_in_data = VL_RAND_RESET_I(16);
    data_in_ready = VL_RAND_RESET_I(1);
    data_out_valid = VL_RAND_RESET_I(1);
    data_out_data = VL_RAND_RESET_I(16);
    data_out_ready = VL_RAND_RESET_I(1);
    CLK = VL_RAND_RESET_I(1);
    RESET = VL_RAND_RESET_I(1);
    downsample_verilog__DOT__x = VL_RAND_RESET_I(5);
    downsample_verilog__DOT__y = VL_RAND_RESET_I(5);
    downsample_verilog__DOT__x_next = VL_RAND_RESET_I(5);
    downsample_verilog__DOT__y_next = VL_RAND_RESET_I(5);
    downsample_verilog__DOT__keep = VL_RAND_RESET_I(1);
}

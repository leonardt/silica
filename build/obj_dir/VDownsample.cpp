// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VDownsample.h for the primary calling header

#include "VDownsample.h"
#include "VDownsample__Syms.h"


//--------------------
// STATIC VARIABLES


//--------------------

VL_CTOR_IMP(VDownsample) {
    VDownsample__Syms* __restrict vlSymsp = __VlSymsp = new VDownsample__Syms(this, name());
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void VDownsample::__Vconfigure(VDownsample__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

VDownsample::~VDownsample() {
    delete __VlSymsp; __VlSymsp=NULL;
}

//--------------------


void VDownsample::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VDownsample::eval\n"); );
    VDownsample__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
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

void VDownsample::_eval_initial_loop(VDownsample__Syms* __restrict vlSymsp) {
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

void VDownsample::_initial__TOP__1(VDownsample__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_initial__TOP__1\n"); );
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // INITIAL at Downsample.v:21
    vlTOPp->Downsample__DOT__x = 0U;
    vlTOPp->Downsample__DOT__y = 0U;
}

VL_INLINE_OPT void VDownsample::_sequent__TOP__2(VDownsample__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_sequent__TOP__2\n"); );
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // ALWAYS at Downsample.v:85
    if (vlTOPp->RESET) {
	vlTOPp->Downsample__DOT__keep = 1U;
    }
    // ALWAYS at Downsample.v:85
    if (vlTOPp->RESET) {
	vlTOPp->data_out_data = vlTOPp->data_in_data;
    }
    // ALWAYS at Downsample.v:85
    if (vlTOPp->RESET) {
	vlTOPp->data_out_valid = vlTOPp->data_in_valid;
    }
    // ALWAYS at Downsample.v:85
    if (vlTOPp->RESET) {
	vlTOPp->Downsample__DOT__y_next = 0U;
	vlTOPp->Downsample__DOT__y = 0U;
    } else {
	vlTOPp->Downsample__DOT__y = vlTOPp->Downsample__DOT__y_next;
    }
    // ALWAYS at Downsample.v:85
    if (vlTOPp->RESET) {
	vlTOPp->Downsample__DOT__x_next = 0U;
	vlTOPp->data_in_ready = vlTOPp->data_out_ready;
	if (((IData)(vlTOPp->data_in_ready) & (IData)(vlTOPp->data_in_valid))) {
	    if ((0x1fU == (IData)(vlTOPp->Downsample__DOT__x_next))) {
		vlTOPp->Downsample__DOT__yield_state_next = 0U;
	    } else {
		vlTOPp->Downsample__DOT__x_next = (0x1fU 
						   & ((IData)(1U) 
						      + (IData)(vlTOPp->Downsample__DOT__x_next)));
		vlTOPp->Downsample__DOT__yield_state_next = 1U;
	    }
	} else {
	    vlTOPp->Downsample__DOT__yield_state_next = 1U;
	}
	vlTOPp->Downsample__DOT__x = vlTOPp->Downsample__DOT__x_next;
	vlTOPp->Downsample__DOT__yield_state = vlTOPp->Downsample__DOT__yield_state_next;
    } else {
	vlTOPp->Downsample__DOT__x = vlTOPp->Downsample__DOT__x_next;
	vlTOPp->Downsample__DOT__yield_state = vlTOPp->Downsample__DOT__yield_state_next;
    }
}

VL_INLINE_OPT void VDownsample::_settle__TOP__3(VDownsample__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_settle__TOP__3\n"); );
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // ALWAYS at Downsample.v:27
    vlTOPp->Downsample__DOT__x_next = vlTOPp->Downsample__DOT__x;
    vlTOPp->Downsample__DOT__y_next = vlTOPp->Downsample__DOT__y;
    if (vlTOPp->Downsample__DOT__yield_state) {
	vlTOPp->Downsample__DOT__keep = ((0U == VL_MODDIV_III(32, (IData)(vlTOPp->Downsample__DOT__x_next), (IData)(2U))) 
					 & (0U == VL_MODDIV_III(32, (IData)(vlTOPp->Downsample__DOT__y_next), (IData)(2U))));
	vlTOPp->data_out_data = vlTOPp->data_in_data;
	vlTOPp->data_out_valid = ((IData)(vlTOPp->Downsample__DOT__keep) 
				  & (IData)(vlTOPp->data_in_valid));
	vlTOPp->data_in_ready = (1U & ((IData)(vlTOPp->data_out_ready) 
				       | (~ (IData)(vlTOPp->Downsample__DOT__keep))));
	if (((IData)(vlTOPp->data_in_ready) & (IData)(vlTOPp->data_in_valid))) {
	    if ((0x1fU == (IData)(vlTOPp->Downsample__DOT__x_next))) {
		vlTOPp->Downsample__DOT__yield_state_next = 0U;
	    } else {
		vlTOPp->Downsample__DOT__x_next = (0x1fU 
						   & ((IData)(1U) 
						      + (IData)(vlTOPp->Downsample__DOT__x_next)));
		vlTOPp->Downsample__DOT__yield_state_next = 1U;
	    }
	} else {
	    vlTOPp->Downsample__DOT__yield_state_next = 1U;
	}
    } else {
	if ((0x1fU == (IData)(vlTOPp->Downsample__DOT__y_next))) {
	    vlTOPp->Downsample__DOT__y_next = 0U;
	    vlTOPp->Downsample__DOT__x_next = 0U;
	    vlTOPp->Downsample__DOT__keep = 1U;
	    vlTOPp->data_out_valid = vlTOPp->data_in_valid;
	    vlTOPp->data_out_data = vlTOPp->data_in_data;
	    vlTOPp->data_in_ready = vlTOPp->data_out_ready;
	    if (((IData)(vlTOPp->data_in_ready) & (IData)(vlTOPp->data_in_valid))) {
		if ((0x1fU == (IData)(vlTOPp->Downsample__DOT__x_next))) {
		    vlTOPp->Downsample__DOT__yield_state_next = 0U;
		} else {
		    vlTOPp->Downsample__DOT__x_next 
			= (0x1fU & ((IData)(1U) + (IData)(vlTOPp->Downsample__DOT__x_next)));
		    vlTOPp->Downsample__DOT__yield_state_next = 1U;
		}
	    } else {
		vlTOPp->Downsample__DOT__yield_state_next = 1U;
	    }
	} else {
	    vlTOPp->Downsample__DOT__y_next = (0x1fU 
					       & ((IData)(1U) 
						  + (IData)(vlTOPp->Downsample__DOT__y_next)));
	    vlTOPp->data_out_data = vlTOPp->data_in_data;
	    vlTOPp->Downsample__DOT__x_next = 0U;
	    vlTOPp->Downsample__DOT__keep = (0U == 
					     VL_MODDIV_III(32, (IData)(vlTOPp->Downsample__DOT__y_next), (IData)(2U)));
	    vlTOPp->data_out_valid = ((IData)(vlTOPp->Downsample__DOT__keep) 
				      & (IData)(vlTOPp->data_in_valid));
	    vlTOPp->data_in_ready = (1U & ((IData)(vlTOPp->data_out_ready) 
					   | (~ (IData)(vlTOPp->Downsample__DOT__keep))));
	    if (((IData)(vlTOPp->data_in_ready) & (IData)(vlTOPp->data_in_valid))) {
		if ((0x1fU == (IData)(vlTOPp->Downsample__DOT__x_next))) {
		    vlTOPp->Downsample__DOT__yield_state_next = 0U;
		} else {
		    vlTOPp->Downsample__DOT__x_next 
			= (0x1fU & ((IData)(1U) + (IData)(vlTOPp->Downsample__DOT__x_next)));
		    vlTOPp->Downsample__DOT__yield_state_next = 1U;
		}
	    } else {
		vlTOPp->Downsample__DOT__yield_state_next = 1U;
	    }
	}
    }
}

void VDownsample::_eval(VDownsample__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_eval\n"); );
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if ((((IData)(vlTOPp->CLK) & (~ (IData)(vlTOPp->__Vclklast__TOP__CLK))) 
	 | ((IData)(vlTOPp->RESET) & (~ (IData)(vlTOPp->__Vclklast__TOP__RESET))))) {
	vlTOPp->_sequent__TOP__2(vlSymsp);
    }
    vlTOPp->_settle__TOP__3(vlSymsp);
    // Final
    vlTOPp->__Vclklast__TOP__CLK = vlTOPp->CLK;
    vlTOPp->__Vclklast__TOP__RESET = vlTOPp->RESET;
}

void VDownsample::_eval_initial(VDownsample__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_eval_initial\n"); );
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
    vlTOPp->__Vclklast__TOP__CLK = vlTOPp->CLK;
    vlTOPp->__Vclklast__TOP__RESET = vlTOPp->RESET;
}

void VDownsample::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::final\n"); );
    // Variables
    VDownsample__Syms* __restrict vlSymsp = this->__VlSymsp;
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VDownsample::_eval_settle(VDownsample__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_eval_settle\n"); );
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__3(vlSymsp);
}

VL_INLINE_OPT QData VDownsample::_change_request(VDownsample__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_change_request\n"); );
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void VDownsample::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_eval_debug_assertions\n"); );
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

void VDownsample::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsample::_ctor_var_reset\n"); );
    // Body
    data_out_data = VL_RAND_RESET_I(16);
    data_in_ready = VL_RAND_RESET_I(1);
    data_out_valid = VL_RAND_RESET_I(1);
    data_in_valid = VL_RAND_RESET_I(1);
    data_in_data = VL_RAND_RESET_I(16);
    data_out_ready = VL_RAND_RESET_I(1);
    CLK = VL_RAND_RESET_I(1);
    RESET = VL_RAND_RESET_I(1);
    Downsample__DOT__keep = VL_RAND_RESET_I(1);
    Downsample__DOT__y = VL_RAND_RESET_I(5);
    Downsample__DOT__y_next = VL_RAND_RESET_I(5);
    Downsample__DOT__x = VL_RAND_RESET_I(5);
    Downsample__DOT__x_next = VL_RAND_RESET_I(5);
    Downsample__DOT__yield_state = VL_RAND_RESET_I(1);
    Downsample__DOT__yield_state_next = VL_RAND_RESET_I(1);
}

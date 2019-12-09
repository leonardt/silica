// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VDownsampleChannel.h for the primary calling header

#include "VDownsampleChannel.h"
#include "VDownsampleChannel__Syms.h"


//--------------------
// STATIC VARIABLES


//--------------------

VL_CTOR_IMP(VDownsampleChannel) {
    VDownsampleChannel__Syms* __restrict vlSymsp = __VlSymsp = new VDownsampleChannel__Syms(this, name());
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void VDownsampleChannel::__Vconfigure(VDownsampleChannel__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

VDownsampleChannel::~VDownsampleChannel() {
    delete __VlSymsp; __VlSymsp=NULL;
}

//--------------------


void VDownsampleChannel::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VDownsampleChannel::eval\n"); );
    VDownsampleChannel__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
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
	vlSymsp->__Vm_activity = true;
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

void VDownsampleChannel::_eval_initial_loop(VDownsampleChannel__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
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

VL_INLINE_OPT void VDownsampleChannel::_sequent__TOP__1(VDownsampleChannel__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_sequent__TOP__1\n"); );
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // ALWAYS at DownsampleChannel.v:211
    vlTOPp->DownsampleChannel__DOT__data = vlTOPp->DownsampleChannel__DOT__data_next;
    // ALWAYS at DownsampleChannel.v:211
    vlTOPp->DownsampleChannel__DOT__keep = vlTOPp->DownsampleChannel__DOT__keep_next;
    // ALWAYS at DownsampleChannel.v:211
    vlTOPp->DownsampleChannel__DOT__yield_state = vlTOPp->DownsampleChannel__DOT__yield_state_next;
    // ALWAYS at DownsampleChannel.v:211
    vlTOPp->DownsampleChannel__DOT__x = vlTOPp->DownsampleChannel__DOT__x_next;
    // ALWAYS at DownsampleChannel.v:211
    vlTOPp->DownsampleChannel__DOT__y = vlTOPp->DownsampleChannel__DOT__y_next;
}

void VDownsampleChannel::_initial__TOP__2(VDownsampleChannel__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_initial__TOP__2\n"); );
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // INITIAL at DownsampleChannel.v:23
    vlTOPp->DownsampleChannel__DOT__x = 0U;
    vlTOPp->DownsampleChannel__DOT__x_next = 0U;
    vlTOPp->DownsampleChannel__DOT__y = 0U;
    vlTOPp->DownsampleChannel__DOT__y_next = 0U;
    vlTOPp->DownsampleChannel__DOT__yield_state = 0U;
}

VL_INLINE_OPT void VDownsampleChannel::_combo__TOP__3(VDownsampleChannel__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_combo__TOP__3\n"); );
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // ALWAYS at DownsampleChannel.v:32
    vlTOPp->DownsampleChannel__DOT__keep_next = vlTOPp->DownsampleChannel__DOT__keep;
    vlTOPp->DownsampleChannel__DOT__y_next = vlTOPp->DownsampleChannel__DOT__y;
    vlTOPp->DownsampleChannel__DOT__x_next = vlTOPp->DownsampleChannel__DOT__x;
    vlTOPp->DownsampleChannel__DOT__data_next = vlTOPp->DownsampleChannel__DOT__data;
    if ((0U == (IData)(vlTOPp->DownsampleChannel__DOT__yield_state))) {
	vlTOPp->data_in_ready = 0U;
	vlTOPp->DownsampleChannel__DOT__y_next = 0U;
	vlTOPp->DownsampleChannel__DOT__x_next = 0U;
	vlTOPp->data_out_valid = 0U;
	vlTOPp->data_out_data = 0U;
	vlTOPp->DownsampleChannel__DOT__keep_next = 1U;
	if ((1U & ((~ (IData)(vlTOPp->data_out_ready)) 
		   | (~ (IData)(vlTOPp->data_in_valid))))) {
	    vlTOPp->DownsampleChannel__DOT__yield_state_next = 2U;
	} else {
	    vlTOPp->data_in_ready = 1U;
	    if (vlTOPp->data_in_valid) {
		vlTOPp->DownsampleChannel__DOT__data_next 
		    = vlTOPp->data_in_data;
		if (vlTOPp->DownsampleChannel__DOT__keep_next) {
		    vlTOPp->data_out_valid = 1U;
		    vlTOPp->data_out_data = vlTOPp->DownsampleChannel__DOT__data_next;
		    if (vlTOPp->data_out_ready) {
			vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
		    }
		} else {
		    vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
		}
	    }
	}
    } else {
	if ((1U == (IData)(vlTOPp->DownsampleChannel__DOT__yield_state))) {
	    vlTOPp->data_in_ready = 0U;
	    vlTOPp->DownsampleChannel__DOT__y_next = 0U;
	    vlTOPp->DownsampleChannel__DOT__x_next = 0U;
	    vlTOPp->data_out_valid = 0U;
	    vlTOPp->data_out_data = 0U;
	    vlTOPp->DownsampleChannel__DOT__keep_next = 1U;
	    if ((1U & ((~ (IData)(vlTOPp->data_out_ready)) 
		       | (~ (IData)(vlTOPp->data_in_valid))))) {
		vlTOPp->DownsampleChannel__DOT__yield_state_next = 2U;
	    } else {
		vlTOPp->data_in_ready = 1U;
		if (vlTOPp->data_in_valid) {
		    vlTOPp->DownsampleChannel__DOT__data_next 
			= vlTOPp->data_in_data;
		    if (vlTOPp->DownsampleChannel__DOT__keep_next) {
			vlTOPp->data_out_valid = 1U;
			vlTOPp->data_out_data = vlTOPp->DownsampleChannel__DOT__data_next;
			if (vlTOPp->data_out_ready) {
			    vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
			}
		    } else {
			vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
		    }
		}
	    }
	} else {
	    if ((2U == (IData)(vlTOPp->DownsampleChannel__DOT__yield_state))) {
		vlTOPp->data_in_ready = 0U;
		vlTOPp->data_out_valid = 0U;
		vlTOPp->data_out_data = 0U;
		if ((1U & (((IData)(vlTOPp->DownsampleChannel__DOT__keep_next) 
			    & (~ (IData)(vlTOPp->data_out_ready))) 
			   | (~ (IData)(vlTOPp->data_in_valid))))) {
		    vlTOPp->DownsampleChannel__DOT__yield_state_next = 2U;
		} else {
		    vlTOPp->data_in_ready = 1U;
		    if (vlTOPp->data_in_valid) {
			vlTOPp->DownsampleChannel__DOT__data_next 
			    = vlTOPp->data_in_data;
			if (vlTOPp->DownsampleChannel__DOT__keep_next) {
			    vlTOPp->data_out_valid = 1U;
			    vlTOPp->data_out_data = vlTOPp->DownsampleChannel__DOT__data_next;
			    if (vlTOPp->data_out_ready) {
				vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
			    }
			} else {
			    vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
			}
		    }
		}
	    } else {
		if ((3U == (IData)(vlTOPp->DownsampleChannel__DOT__yield_state))) {
		    vlTOPp->data_in_ready = 0U;
		    vlTOPp->data_out_valid = 0U;
		    vlTOPp->data_out_data = 0U;
		    vlTOPp->data_in_ready = 1U;
		    if (vlTOPp->data_in_valid) {
			vlTOPp->DownsampleChannel__DOT__data_next 
			    = vlTOPp->data_in_data;
			if (vlTOPp->DownsampleChannel__DOT__keep_next) {
			    vlTOPp->data_out_valid = 1U;
			    vlTOPp->data_out_data = vlTOPp->DownsampleChannel__DOT__data_next;
			    vlTOPp->DownsampleChannel__DOT__yield_state_next 
				= ((IData)(vlTOPp->data_out_ready)
				    ? 5U : 4U);
			} else {
			    vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
			}
		    } else {
			vlTOPp->DownsampleChannel__DOT__yield_state_next = 3U;
		    }
		} else {
		    if ((4U == (IData)(vlTOPp->DownsampleChannel__DOT__yield_state))) {
			vlTOPp->data_in_ready = 0U;
			vlTOPp->data_out_valid = 0U;
			vlTOPp->data_out_data = 0U;
			vlTOPp->DownsampleChannel__DOT__yield_state_next 
			    = ((IData)(vlTOPp->data_out_ready)
			        ? 5U : 4U);
			vlTOPp->data_out_valid = 1U;
			vlTOPp->data_out_data = vlTOPp->DownsampleChannel__DOT__data_next;
		    } else {
			if ((5U == (IData)(vlTOPp->DownsampleChannel__DOT__yield_state))) {
			    vlTOPp->data_in_ready = 0U;
			    vlTOPp->data_out_valid = 0U;
			    vlTOPp->data_out_data = 0U;
			    if ((0x1fU == (IData)(vlTOPp->DownsampleChannel__DOT__x_next))) {
				if ((0x1fU == (IData)(vlTOPp->DownsampleChannel__DOT__y_next))) {
				    vlTOPp->DownsampleChannel__DOT__keep_next = 1U;
				    vlTOPp->DownsampleChannel__DOT__y_next = 0U;
				    vlTOPp->DownsampleChannel__DOT__x_next = 0U;
				    if ((1U & ((~ (IData)(vlTOPp->data_out_ready)) 
					       | (~ (IData)(vlTOPp->data_in_valid))))) {
					vlTOPp->DownsampleChannel__DOT__yield_state_next = 2U;
				    } else {
					vlTOPp->data_in_ready = 1U;
					if (vlTOPp->data_in_valid) {
					    vlTOPp->DownsampleChannel__DOT__data_next 
						= vlTOPp->data_in_data;
					    if (vlTOPp->DownsampleChannel__DOT__keep_next) {
						vlTOPp->data_out_valid = 1U;
						vlTOPp->data_out_data 
						    = vlTOPp->DownsampleChannel__DOT__data_next;
						if (vlTOPp->data_out_ready) {
						    vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
						}
					    } else {
						vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
					    }
					}
				    }
				} else {
				    vlTOPp->DownsampleChannel__DOT__y_next 
					= (0x1fU & 
					   ((IData)(1U) 
					    + (IData)(vlTOPp->DownsampleChannel__DOT__y_next)));
				    vlTOPp->DownsampleChannel__DOT__x_next = 0U;
				    vlTOPp->DownsampleChannel__DOT__keep_next 
					= (0U == VL_MODDIV_III(32, (IData)(vlTOPp->DownsampleChannel__DOT__y_next), (IData)(2U)));
				    if ((1U & (((IData)(vlTOPp->DownsampleChannel__DOT__keep_next) 
						& (~ (IData)(vlTOPp->data_out_ready))) 
					       | (~ (IData)(vlTOPp->data_in_valid))))) {
					vlTOPp->DownsampleChannel__DOT__yield_state_next = 2U;
				    } else {
					vlTOPp->data_in_ready = 1U;
					if (vlTOPp->data_in_valid) {
					    vlTOPp->DownsampleChannel__DOT__data_next 
						= vlTOPp->data_in_data;
					    if (vlTOPp->DownsampleChannel__DOT__keep_next) {
						vlTOPp->data_out_valid = 1U;
						vlTOPp->data_out_data 
						    = vlTOPp->DownsampleChannel__DOT__data_next;
						if (vlTOPp->data_out_ready) {
						    vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
						}
					    } else {
						vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
					    }
					}
				    }
				}
			    } else {
				vlTOPp->DownsampleChannel__DOT__x_next 
				    = (0x1fU & ((IData)(1U) 
						+ (IData)(vlTOPp->DownsampleChannel__DOT__x_next)));
				vlTOPp->DownsampleChannel__DOT__keep_next 
				    = ((0U == VL_MODDIV_III(32, (IData)(vlTOPp->DownsampleChannel__DOT__x_next), (IData)(2U))) 
				       & (0U == VL_MODDIV_III(32, (IData)(vlTOPp->DownsampleChannel__DOT__y_next), (IData)(2U))));
				if ((1U & (((IData)(vlTOPp->DownsampleChannel__DOT__keep_next) 
					    & (~ (IData)(vlTOPp->data_out_ready))) 
					   | (~ (IData)(vlTOPp->data_in_valid))))) {
				    vlTOPp->DownsampleChannel__DOT__yield_state_next = 2U;
				} else {
				    vlTOPp->data_in_ready = 1U;
				    if (vlTOPp->data_in_valid) {
					vlTOPp->DownsampleChannel__DOT__data_next 
					    = vlTOPp->data_in_data;
					if (vlTOPp->DownsampleChannel__DOT__keep_next) {
					    vlTOPp->data_out_valid = 1U;
					    vlTOPp->data_out_data 
						= vlTOPp->DownsampleChannel__DOT__data_next;
					    if (vlTOPp->data_out_ready) {
						vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
					    }
					} else {
					    vlTOPp->DownsampleChannel__DOT__yield_state_next = 5U;
					}
				    }
				}
			    }
			}
		    }
		}
	    }
	}
    }
}

void VDownsampleChannel::_eval(VDownsampleChannel__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_eval\n"); );
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (((IData)(vlTOPp->CLK) & (~ (IData)(vlTOPp->__Vclklast__TOP__CLK)))) {
	vlTOPp->_sequent__TOP__1(vlSymsp);
	vlTOPp->__Vm_traceActivity = (2U | vlTOPp->__Vm_traceActivity);
    }
    vlTOPp->_combo__TOP__3(vlSymsp);
    vlTOPp->__Vm_traceActivity = (4U | vlTOPp->__Vm_traceActivity);
    // Final
    vlTOPp->__Vclklast__TOP__CLK = vlTOPp->CLK;
}

void VDownsampleChannel::_eval_initial(VDownsampleChannel__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_eval_initial\n"); );
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__CLK = vlTOPp->CLK;
    vlTOPp->_initial__TOP__2(vlSymsp);
    vlTOPp->__Vm_traceActivity = (1U | vlTOPp->__Vm_traceActivity);
}

void VDownsampleChannel::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::final\n"); );
    // Variables
    VDownsampleChannel__Syms* __restrict vlSymsp = this->__VlSymsp;
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VDownsampleChannel::_eval_settle(VDownsampleChannel__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_eval_settle\n"); );
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__3(vlSymsp);
    vlTOPp->__Vm_traceActivity = (1U | vlTOPp->__Vm_traceActivity);
}

VL_INLINE_OPT QData VDownsampleChannel::_change_request(VDownsampleChannel__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_change_request\n"); );
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void VDownsampleChannel::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((data_in_valid & 0xfeU))) {
	Verilated::overWidthError("data_in_valid");}
    if (VL_UNLIKELY((data_out_ready & 0xfeU))) {
	Verilated::overWidthError("data_out_ready");}
    if (VL_UNLIKELY((CLK & 0xfeU))) {
	Verilated::overWidthError("CLK");}
}
#endif // VL_DEBUG

void VDownsampleChannel::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VDownsampleChannel::_ctor_var_reset\n"); );
    // Body
    data_out_valid = VL_RAND_RESET_I(1);
    data_in_ready = VL_RAND_RESET_I(1);
    data_out_data = VL_RAND_RESET_I(16);
    data_in_data = VL_RAND_RESET_I(16);
    data_in_valid = VL_RAND_RESET_I(1);
    data_out_ready = VL_RAND_RESET_I(1);
    CLK = VL_RAND_RESET_I(1);
    DownsampleChannel__DOT__data = VL_RAND_RESET_I(16);
    DownsampleChannel__DOT__data_next = VL_RAND_RESET_I(16);
    DownsampleChannel__DOT__x = VL_RAND_RESET_I(5);
    DownsampleChannel__DOT__x_next = VL_RAND_RESET_I(5);
    DownsampleChannel__DOT__y = VL_RAND_RESET_I(5);
    DownsampleChannel__DOT__y_next = VL_RAND_RESET_I(5);
    DownsampleChannel__DOT__keep = VL_RAND_RESET_I(1);
    DownsampleChannel__DOT__keep_next = VL_RAND_RESET_I(1);
    DownsampleChannel__DOT__yield_state = VL_RAND_RESET_I(3);
    DownsampleChannel__DOT__yield_state_next = VL_RAND_RESET_I(3);
    __Vm_traceActivity = VL_RAND_RESET_I(32);
}

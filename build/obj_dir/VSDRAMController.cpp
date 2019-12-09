// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VSDRAMController.h for the primary calling header

#include "VSDRAMController.h"
#include "VSDRAMController__Syms.h"


//--------------------
// STATIC VARIABLES


//--------------------

VL_CTOR_IMP(VSDRAMController) {
    VSDRAMController__Syms* __restrict vlSymsp = __VlSymsp = new VSDRAMController__Syms(this, name());
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void VSDRAMController::__Vconfigure(VSDRAMController__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

VSDRAMController::~VSDRAMController() {
    delete __VlSymsp; __VlSymsp=NULL;
}

//--------------------


void VSDRAMController::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VSDRAMController::eval\n"); );
    VSDRAMController__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
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

void VSDRAMController::_eval_initial_loop(VSDRAMController__Syms* __restrict vlSymsp) {
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

VL_INLINE_OPT void VSDRAMController::_sequent__TOP__1(VSDRAMController__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_sequent__TOP__1\n"); );
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    // Begin mtask footprint  all: 
    VL_SIG8(__Vdly__SDRAMController__DOT__enable_inst0__DOT__count,3,0);
    // Body
    __Vdly__SDRAMController__DOT__enable_inst0__DOT__count 
	= vlTOPp->SDRAMController__DOT__enable_inst0__DOT__count;
    // ALWAYS at SDRAMController.v:4
    __Vdly__SDRAMController__DOT__enable_inst0__DOT__count 
	= (0xfU & ((IData)(vlTOPp->RESET) ? ((0U == (IData)(vlTOPp->SDRAMController__DOT__enable_inst0__DOT__count))
					      ? (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0_n)
					      : ((IData)(vlTOPp->SDRAMController__DOT__enable_inst0__DOT__count) 
						 - (IData)(1U)))
		    : 0xfU));
    // ALWAYS at SDRAMController.v:144
    if (vlTOPp->RESET) {
	if ((0U == (IData)(vlTOPp->SDRAMController__DOT__enable_inst0__DOT__count))) {
	    vlTOPp->SDRAMController__DOT___SDRAMController_inst0_cmd 
		= vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__cmd_next;
	}
    } else {
	vlTOPp->SDRAMController__DOT___SDRAMController_inst0_cmd = 0xb8U;
    }
    // ALWAYS at SDRAMController.v:144
    if (vlTOPp->RESET) {
	if ((0U == (IData)(vlTOPp->SDRAMController__DOT__enable_inst0__DOT__count))) {
	    vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state 
		= vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state_next;
	}
    } else {
	vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state = 8U;
    }
    vlTOPp->SDRAMController__DOT__enable_inst0__DOT__count 
	= __Vdly__SDRAMController__DOT__enable_inst0__DOT__count;
    vlTOPp->cmd = vlTOPp->SDRAMController__DOT___SDRAMController_inst0_cmd;
    vlTOPp->state = vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state;
    // ALWAYS at SDRAMController.v:32
    vlTOPp->SDRAMController__DOT___SDRAMController_inst0_n 
	= ((8U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
	    ? 0U : ((9U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
		     ? 0U : ((5U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
			      ? 0U : ((0xaU == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
				       ? 7U : ((0xbU 
						== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
					        ? 0U
					        : (
						   (0xcU 
						    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						    ? 7U
						    : 
						   ((0xdU 
						     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						     ? 0U
						     : 
						    ((0xeU 
						      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						      ? 1U
						      : 
						     ((0xfU 
						       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						       ? 0U
						       : 
						      ((0U 
							== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						        ? 0U
						        : 
						       ((1U 
							 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							 ? 0U
							 : 
							((2U 
							  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							  ? 0U
							  : 
							 ((3U 
							   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							   ? 7U
							   : 
							  ((4U 
							    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							    ? 0U
							    : 
							   ((0x18U 
							     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							     ? 1U
							     : 
							    ((0x19U 
							      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							      ? 0U
							      : 
							     ((0x1aU 
							       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							       ? 1U
							       : 
							      ((0x1bU 
								== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							        ? 0U
							        : 
							       ((0x10U 
								 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								 ? 1U
								 : 
								((0x11U 
								  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								  ? 0U
								  : 
								 ((0x12U 
								   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								   ? 1U
								   : 0U)))))))))))))))))))));
}

void VSDRAMController::_settle__TOP__2(VSDRAMController__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_settle__TOP__2\n"); );
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->cmd = vlTOPp->SDRAMController__DOT___SDRAMController_inst0_cmd;
    vlTOPp->state = vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state;
    // ALWAYS at SDRAMController.v:32
    vlTOPp->SDRAMController__DOT___SDRAMController_inst0_n 
	= ((8U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
	    ? 0U : ((9U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
		     ? 0U : ((5U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
			      ? 0U : ((0xaU == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
				       ? 7U : ((0xbU 
						== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
					        ? 0U
					        : (
						   (0xcU 
						    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						    ? 7U
						    : 
						   ((0xdU 
						     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						     ? 0U
						     : 
						    ((0xeU 
						      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						      ? 1U
						      : 
						     ((0xfU 
						       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						       ? 0U
						       : 
						      ((0U 
							== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						        ? 0U
						        : 
						       ((1U 
							 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							 ? 0U
							 : 
							((2U 
							  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							  ? 0U
							  : 
							 ((3U 
							   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							   ? 7U
							   : 
							  ((4U 
							    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							    ? 0U
							    : 
							   ((0x18U 
							     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							     ? 1U
							     : 
							    ((0x19U 
							      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							      ? 0U
							      : 
							     ((0x1aU 
							       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							       ? 1U
							       : 
							      ((0x1bU 
								== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							        ? 0U
							        : 
							       ((0x10U 
								 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								 ? 1U
								 : 
								((0x11U 
								  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								  ? 0U
								  : 
								 ((0x12U 
								   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								   ? 1U
								   : 0U)))))))))))))))))))));
    // ALWAYS at SDRAMController.v:32
    vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state_next 
	= ((8U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
	    ? 9U : ((9U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
		     ? 5U : ((5U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
			      ? 0xaU : ((0xaU == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
					 ? 0xbU : (
						   (0xbU 
						    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						    ? 0xcU
						    : 
						   ((0xcU 
						     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						     ? 0xdU
						     : 
						    ((0xdU 
						      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						      ? 0xeU
						      : 
						     ((0xeU 
						       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						       ? 0xfU
						       : 
						      ((0xfU 
							== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						        ? 0U
						        : 
						       ((0U 
							 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							 ? 
							((0x207U 
							  <= (IData)(vlTOPp->refresh_cnt))
							  ? 1U
							  : 
							 ((IData)(vlTOPp->wr_enable)
							   ? 0x18U
							   : 
							  ((IData)(vlTOPp->rd_enable)
							    ? 0x10U
							    : 0U)))
							 : 
							((1U 
							  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							  ? 2U
							  : 
							 ((2U 
							   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							   ? 3U
							   : 
							  ((3U 
							    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							    ? 4U
							    : 
							   ((4U 
							     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							     ? 0U
							     : 
							    ((0x18U 
							      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							      ? 0x19U
							      : 
							     ((0x19U 
							       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							       ? 0x1aU
							       : 
							      ((0x1aU 
								== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							        ? 0x1bU
							        : 
							       ((0x1bU 
								 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								 ? 0U
								 : 
								((0x10U 
								  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								  ? 0x11U
								  : 
								 ((0x11U 
								   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								   ? 0x12U
								   : 
								  ((0x12U 
								    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								    ? 0x13U
								    : 
								   ((0x13U 
								     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								     ? 0x14U
								     : 0U))))))))))))))))))))));
    // ALWAYS at SDRAMController.v:32
    vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__cmd_next 
	= ((8U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
	    ? 0x91U : ((9U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
		        ? 0xb8U : ((5U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
				    ? 0x88U : ((0xaU 
						== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
					        ? 0xb8U
					        : (
						   (0xbU 
						    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						    ? 0x88U
						    : 
						   ((0xcU 
						     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						     ? 0xb8U
						     : 
						    ((0xdU 
						      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						      ? 0x80U
						      : 
						     ((0xeU 
						       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						       ? 0xb8U
						       : 
						      ((0xfU 
							== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						        ? 0xb8U
						        : 
						       ((0U 
							 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							 ? 
							((0x207U 
							  <= (IData)(vlTOPp->refresh_cnt))
							  ? 0x91U
							  : 
							 ((IData)(vlTOPp->wr_enable)
							   ? 0x98U
							   : 
							  ((IData)(vlTOPp->rd_enable)
							    ? 0x98U
							    : 0xb8U)))
							 : 
							((1U 
							  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							  ? 0xb8U
							  : 
							 ((2U 
							   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							   ? 0x88U
							   : 
							  ((3U 
							    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							    ? 0xb8U
							    : 
							   ((4U 
							     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							     ? 0xb8U
							     : 
							    ((0x18U 
							      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							      ? 0xb8U
							      : 
							     ((0x19U 
							       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							       ? 0xa1U
							       : 
							      ((0x1aU 
								== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							        ? 0xb8U
							        : 
							       ((0x1bU 
								 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								 ? 0xb8U
								 : 
								((0x10U 
								  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								  ? 0xb8U
								  : 
								 ((0x11U 
								   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								   ? 0xa9U
								   : 0xb8U))))))))))))))))))));
}

VL_INLINE_OPT void VSDRAMController::_combo__TOP__3(VSDRAMController__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_combo__TOP__3\n"); );
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // ALWAYS at SDRAMController.v:32
    vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state_next 
	= ((8U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
	    ? 9U : ((9U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
		     ? 5U : ((5U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
			      ? 0xaU : ((0xaU == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
					 ? 0xbU : (
						   (0xbU 
						    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						    ? 0xcU
						    : 
						   ((0xcU 
						     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						     ? 0xdU
						     : 
						    ((0xdU 
						      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						      ? 0xeU
						      : 
						     ((0xeU 
						       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						       ? 0xfU
						       : 
						      ((0xfU 
							== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						        ? 0U
						        : 
						       ((0U 
							 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							 ? 
							((0x207U 
							  <= (IData)(vlTOPp->refresh_cnt))
							  ? 1U
							  : 
							 ((IData)(vlTOPp->wr_enable)
							   ? 0x18U
							   : 
							  ((IData)(vlTOPp->rd_enable)
							    ? 0x10U
							    : 0U)))
							 : 
							((1U 
							  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							  ? 2U
							  : 
							 ((2U 
							   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							   ? 3U
							   : 
							  ((3U 
							    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							    ? 4U
							    : 
							   ((4U 
							     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							     ? 0U
							     : 
							    ((0x18U 
							      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							      ? 0x19U
							      : 
							     ((0x19U 
							       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							       ? 0x1aU
							       : 
							      ((0x1aU 
								== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							        ? 0x1bU
							        : 
							       ((0x1bU 
								 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								 ? 0U
								 : 
								((0x10U 
								  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								  ? 0x11U
								  : 
								 ((0x11U 
								   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								   ? 0x12U
								   : 
								  ((0x12U 
								    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								    ? 0x13U
								    : 
								   ((0x13U 
								     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								     ? 0x14U
								     : 0U))))))))))))))))))))));
    // ALWAYS at SDRAMController.v:32
    vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__cmd_next 
	= ((8U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
	    ? 0x91U : ((9U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
		        ? 0xb8U : ((5U == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
				    ? 0x88U : ((0xaU 
						== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
					        ? 0xb8U
					        : (
						   (0xbU 
						    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						    ? 0x88U
						    : 
						   ((0xcU 
						     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						     ? 0xb8U
						     : 
						    ((0xdU 
						      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						      ? 0x80U
						      : 
						     ((0xeU 
						       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						       ? 0xb8U
						       : 
						      ((0xfU 
							== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
						        ? 0xb8U
						        : 
						       ((0U 
							 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							 ? 
							((0x207U 
							  <= (IData)(vlTOPp->refresh_cnt))
							  ? 0x91U
							  : 
							 ((IData)(vlTOPp->wr_enable)
							   ? 0x98U
							   : 
							  ((IData)(vlTOPp->rd_enable)
							    ? 0x98U
							    : 0xb8U)))
							 : 
							((1U 
							  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							  ? 0xb8U
							  : 
							 ((2U 
							   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							   ? 0x88U
							   : 
							  ((3U 
							    == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							    ? 0xb8U
							    : 
							   ((4U 
							     == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							     ? 0xb8U
							     : 
							    ((0x18U 
							      == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							      ? 0xb8U
							      : 
							     ((0x19U 
							       == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							       ? 0xa1U
							       : 
							      ((0x1aU 
								== (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
							        ? 0xb8U
							        : 
							       ((0x1bU 
								 == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								 ? 0xb8U
								 : 
								((0x10U 
								  == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								  ? 0xb8U
								  : 
								 ((0x11U 
								   == (IData)(vlTOPp->SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state))
								   ? 0xa9U
								   : 0xb8U))))))))))))))))))));
}

void VSDRAMController::_eval(VSDRAMController__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_eval\n"); );
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if ((((IData)(vlTOPp->CLK) & (~ (IData)(vlTOPp->__Vclklast__TOP__CLK))) 
	 | ((~ (IData)(vlTOPp->RESET)) & (IData)(vlTOPp->__Vclklast__TOP__RESET)))) {
	vlTOPp->_sequent__TOP__1(vlSymsp);
    }
    vlTOPp->_combo__TOP__3(vlSymsp);
    // Final
    vlTOPp->__Vclklast__TOP__CLK = vlTOPp->CLK;
    vlTOPp->__Vclklast__TOP__RESET = vlTOPp->RESET;
}

void VSDRAMController::_eval_initial(VSDRAMController__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_eval_initial\n"); );
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__CLK = vlTOPp->CLK;
    vlTOPp->__Vclklast__TOP__RESET = vlTOPp->RESET;
}

void VSDRAMController::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::final\n"); );
    // Variables
    VSDRAMController__Syms* __restrict vlSymsp = this->__VlSymsp;
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VSDRAMController::_eval_settle(VSDRAMController__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_eval_settle\n"); );
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__2(vlSymsp);
}

VL_INLINE_OPT QData VSDRAMController::_change_request(VSDRAMController__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_change_request\n"); );
    VSDRAMController* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void VSDRAMController::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((CLK & 0xfeU))) {
	Verilated::overWidthError("CLK");}
    if (VL_UNLIKELY((RESET & 0xfeU))) {
	Verilated::overWidthError("RESET");}
    if (VL_UNLIKELY((rd_enable & 0xfeU))) {
	Verilated::overWidthError("rd_enable");}
    if (VL_UNLIKELY((refresh_cnt & 0xfc00U))) {
	Verilated::overWidthError("refresh_cnt");}
    if (VL_UNLIKELY((wr_enable & 0xfeU))) {
	Verilated::overWidthError("wr_enable");}
}
#endif // VL_DEBUG

void VSDRAMController::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSDRAMController::_ctor_var_reset\n"); );
    // Body
    CLK = VL_RAND_RESET_I(1);
    RESET = VL_RAND_RESET_I(1);
    cmd = VL_RAND_RESET_I(8);
    rd_enable = VL_RAND_RESET_I(1);
    refresh_cnt = VL_RAND_RESET_I(10);
    state = VL_RAND_RESET_I(5);
    wr_enable = VL_RAND_RESET_I(1);
    SDRAMController__DOT___SDRAMController_inst0_cmd = VL_RAND_RESET_I(8);
    SDRAMController__DOT___SDRAMController_inst0_n = VL_RAND_RESET_I(4);
    SDRAMController__DOT___SDRAMController_inst0__DOT__cmd_next = VL_RAND_RESET_I(8);
    SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state = VL_RAND_RESET_I(5);
    SDRAMController__DOT___SDRAMController_inst0__DOT__yield_state_next = VL_RAND_RESET_I(5);
    SDRAMController__DOT__enable_inst0__DOT__count = VL_RAND_RESET_I(4);
}

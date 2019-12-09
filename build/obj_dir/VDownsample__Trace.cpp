// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VDownsample__Syms.h"


//======================

void VDownsample::traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    VDownsample* t=(VDownsample*)userthis;
    VDownsample__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (vlSymsp->getClearActivity()) {
	t->traceChgThis(vlSymsp, vcdp, code);
    }
}

//======================


void VDownsample::traceChgThis(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 1U))))) {
	    vlTOPp->traceChgThis__2(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & ((vlTOPp->__Vm_traceActivity 
				| (vlTOPp->__Vm_traceActivity 
				   >> 1U)) | (vlTOPp->__Vm_traceActivity 
					      >> 2U))))) {
	    vlTOPp->traceChgThis__3(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((2U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__4(vlSymsp, vcdp, code);
	}
	vlTOPp->traceChgThis__5(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void VDownsample::traceChgThis__2(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus(c+1,(vlTOPp->Downsample__DOT__y),5);
	vcdp->chgBus(c+2,(vlTOPp->Downsample__DOT__x),5);
    }
}

void VDownsample::traceChgThis__3(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit(c+3,(vlTOPp->Downsample__DOT__keep));
	vcdp->chgBus(c+4,(vlTOPp->Downsample__DOT__y_next),5);
	vcdp->chgBus(c+5,(vlTOPp->Downsample__DOT__x_next),5);
	vcdp->chgBit(c+6,(vlTOPp->Downsample__DOT__yield_state_next));
    }
}

void VDownsample::traceChgThis__4(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit(c+7,(vlTOPp->Downsample__DOT__yield_state));
    }
}

void VDownsample::traceChgThis__5(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus(c+8,(vlTOPp->data_out_data),16);
	vcdp->chgBit(c+9,(vlTOPp->data_in_ready));
	vcdp->chgBit(c+10,(vlTOPp->data_out_valid));
	vcdp->chgBit(c+11,(vlTOPp->data_in_valid));
	vcdp->chgBus(c+12,(vlTOPp->data_in_data),16);
	vcdp->chgBit(c+13,(vlTOPp->data_out_ready));
	vcdp->chgBit(c+14,(vlTOPp->CLK));
	vcdp->chgBit(c+15,(vlTOPp->RESET));
    }
}

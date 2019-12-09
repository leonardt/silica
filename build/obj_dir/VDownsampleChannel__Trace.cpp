// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VDownsampleChannel__Syms.h"


//======================

void VDownsampleChannel::traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    VDownsampleChannel* t=(VDownsampleChannel*)userthis;
    VDownsampleChannel__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (vlSymsp->getClearActivity()) {
	t->traceChgThis(vlSymsp, vcdp, code);
    }
}

//======================


void VDownsampleChannel::traceChgThis(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 1U))))) {
	    vlTOPp->traceChgThis__2(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
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

void VDownsampleChannel::traceChgThis__2(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus(c+1,(vlTOPp->DownsampleChannel__DOT__x),5);
	vcdp->chgBus(c+2,(vlTOPp->DownsampleChannel__DOT__y),5);
	vcdp->chgBus(c+3,(vlTOPp->DownsampleChannel__DOT__yield_state),3);
    }
}

void VDownsampleChannel::traceChgThis__3(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus(c+4,(vlTOPp->DownsampleChannel__DOT__data_next),16);
	vcdp->chgBus(c+5,(vlTOPp->DownsampleChannel__DOT__x_next),5);
	vcdp->chgBus(c+6,(vlTOPp->DownsampleChannel__DOT__y_next),5);
	vcdp->chgBit(c+7,(vlTOPp->DownsampleChannel__DOT__keep_next));
	vcdp->chgBus(c+8,(vlTOPp->DownsampleChannel__DOT__yield_state_next),3);
    }
}

void VDownsampleChannel::traceChgThis__4(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus(c+9,(vlTOPp->DownsampleChannel__DOT__data),16);
	vcdp->chgBit(c+10,(vlTOPp->DownsampleChannel__DOT__keep));
    }
}

void VDownsampleChannel::traceChgThis__5(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit(c+11,(vlTOPp->data_out_valid));
	vcdp->chgBit(c+12,(vlTOPp->data_in_ready));
	vcdp->chgBus(c+13,(vlTOPp->data_out_data),16);
	vcdp->chgBus(c+14,(vlTOPp->data_in_data),16);
	vcdp->chgBit(c+15,(vlTOPp->data_in_valid));
	vcdp->chgBit(c+16,(vlTOPp->data_out_ready));
	vcdp->chgBit(c+17,(vlTOPp->CLK));
    }
}

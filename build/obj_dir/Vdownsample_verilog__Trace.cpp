// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdownsample_verilog__Syms.h"


//======================

void Vdownsample_verilog::traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vdownsample_verilog* t=(Vdownsample_verilog*)userthis;
    Vdownsample_verilog__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (vlSymsp->getClearActivity()) {
	t->traceChgThis(vlSymsp, vcdp, code);
    }
}

//======================


void Vdownsample_verilog::traceChgThis(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
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
	if (VL_UNLIKELY((4U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__4(vlSymsp, vcdp, code);
	}
	vlTOPp->traceChgThis__5(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void Vdownsample_verilog::traceChgThis__2(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus(c+1,(vlTOPp->downsample_verilog__DOT__x_next),5);
	vcdp->chgBus(c+2,(vlTOPp->downsample_verilog__DOT__y_next),5);
    }
}

void Vdownsample_verilog::traceChgThis__3(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit(c+3,(vlTOPp->downsample_verilog__DOT__keep));
    }
}

void Vdownsample_verilog::traceChgThis__4(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus(c+4,(vlTOPp->downsample_verilog__DOT__x),5);
	vcdp->chgBus(c+5,(vlTOPp->downsample_verilog__DOT__y),5);
    }
}

void Vdownsample_verilog::traceChgThis__5(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit(c+6,(vlTOPp->data_in_valid));
	vcdp->chgBus(c+7,(vlTOPp->data_in_data),16);
	vcdp->chgBit(c+8,(vlTOPp->data_in_ready));
	vcdp->chgBit(c+9,(vlTOPp->data_out_valid));
	vcdp->chgBus(c+10,(vlTOPp->data_out_data),16);
	vcdp->chgBit(c+11,(vlTOPp->data_out_ready));
	vcdp->chgBit(c+12,(vlTOPp->CLK));
    }
}

// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VDownsampleChannel__Syms.h"


//======================

void VDownsampleChannel::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addCallback(&VDownsampleChannel::traceInit, &VDownsampleChannel::traceFull, &VDownsampleChannel::traceChg, this);
}
void VDownsampleChannel::traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->open()
    VDownsampleChannel* t=(VDownsampleChannel*)userthis;
    VDownsampleChannel__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (!Verilated::calcUnusedSigs()) {
	VL_FATAL_MT(__FILE__,__LINE__,__FILE__,"Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vcdp->scopeEscape(' ');
    t->traceInitThis(vlSymsp, vcdp, code);
    vcdp->scopeEscape('.');
}
void VDownsampleChannel::traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    VDownsampleChannel* t=(VDownsampleChannel*)userthis;
    VDownsampleChannel__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    t->traceFullThis(vlSymsp, vcdp, code);
}

//======================


void VDownsampleChannel::traceInitThis(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    vcdp->module(vlSymsp->name());  // Setup signal names
    // Body
    {
	vlTOPp->traceInitThis__1(vlSymsp, vcdp, code);
    }
}

void VDownsampleChannel::traceFullThis(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vlTOPp->traceFullThis__1(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void VDownsampleChannel::traceInitThis__1(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->declBit(c+11,"data_out_valid",-1);
	vcdp->declBit(c+12,"data_in_ready",-1);
	vcdp->declBus(c+13,"data_out_data",-1,15,0);
	vcdp->declBus(c+14,"data_in_data",-1,15,0);
	vcdp->declBit(c+15,"data_in_valid",-1);
	vcdp->declBit(c+16,"data_out_ready",-1);
	vcdp->declBit(c+17,"CLK",-1);
	vcdp->declBit(c+11,"DownsampleChannel data_out_valid",-1);
	vcdp->declBit(c+12,"DownsampleChannel data_in_ready",-1);
	vcdp->declBus(c+13,"DownsampleChannel data_out_data",-1,15,0);
	vcdp->declBus(c+14,"DownsampleChannel data_in_data",-1,15,0);
	vcdp->declBit(c+15,"DownsampleChannel data_in_valid",-1);
	vcdp->declBit(c+16,"DownsampleChannel data_out_ready",-1);
	vcdp->declBit(c+17,"DownsampleChannel CLK",-1);
	vcdp->declBus(c+9,"DownsampleChannel data",-1,15,0);
	vcdp->declBus(c+4,"DownsampleChannel data_next",-1,15,0);
	vcdp->declBus(c+1,"DownsampleChannel x",-1,4,0);
	vcdp->declBus(c+5,"DownsampleChannel x_next",-1,4,0);
	vcdp->declBus(c+2,"DownsampleChannel y",-1,4,0);
	vcdp->declBus(c+6,"DownsampleChannel y_next",-1,4,0);
	vcdp->declBit(c+10,"DownsampleChannel keep",-1);
	vcdp->declBit(c+7,"DownsampleChannel keep_next",-1);
	vcdp->declBus(c+3,"DownsampleChannel yield_state",-1,2,0);
	vcdp->declBus(c+8,"DownsampleChannel yield_state_next",-1,2,0);
    }
}

void VDownsampleChannel::traceFullThis__1(VDownsampleChannel__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsampleChannel* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->fullBus(c+1,(vlTOPp->DownsampleChannel__DOT__x),5);
	vcdp->fullBus(c+2,(vlTOPp->DownsampleChannel__DOT__y),5);
	vcdp->fullBus(c+3,(vlTOPp->DownsampleChannel__DOT__yield_state),3);
	vcdp->fullBus(c+4,(vlTOPp->DownsampleChannel__DOT__data_next),16);
	vcdp->fullBus(c+5,(vlTOPp->DownsampleChannel__DOT__x_next),5);
	vcdp->fullBus(c+6,(vlTOPp->DownsampleChannel__DOT__y_next),5);
	vcdp->fullBit(c+7,(vlTOPp->DownsampleChannel__DOT__keep_next));
	vcdp->fullBus(c+8,(vlTOPp->DownsampleChannel__DOT__yield_state_next),3);
	vcdp->fullBus(c+9,(vlTOPp->DownsampleChannel__DOT__data),16);
	vcdp->fullBit(c+10,(vlTOPp->DownsampleChannel__DOT__keep));
	vcdp->fullBit(c+11,(vlTOPp->data_out_valid));
	vcdp->fullBit(c+12,(vlTOPp->data_in_ready));
	vcdp->fullBus(c+13,(vlTOPp->data_out_data),16);
	vcdp->fullBus(c+14,(vlTOPp->data_in_data),16);
	vcdp->fullBit(c+15,(vlTOPp->data_in_valid));
	vcdp->fullBit(c+16,(vlTOPp->data_out_ready));
	vcdp->fullBit(c+17,(vlTOPp->CLK));
    }
}

// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VDownsample__Syms.h"


//======================

void VDownsample::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addCallback(&VDownsample::traceInit, &VDownsample::traceFull, &VDownsample::traceChg, this);
}
void VDownsample::traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->open()
    VDownsample* t=(VDownsample*)userthis;
    VDownsample__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (!Verilated::calcUnusedSigs()) {
	VL_FATAL_MT(__FILE__,__LINE__,__FILE__,"Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vcdp->scopeEscape(' ');
    t->traceInitThis(vlSymsp, vcdp, code);
    vcdp->scopeEscape('.');
}
void VDownsample::traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    VDownsample* t=(VDownsample*)userthis;
    VDownsample__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    t->traceFullThis(vlSymsp, vcdp, code);
}

//======================


void VDownsample::traceInitThis(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    vcdp->module(vlSymsp->name());  // Setup signal names
    // Body
    {
	vlTOPp->traceInitThis__1(vlSymsp, vcdp, code);
    }
}

void VDownsample::traceFullThis(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vlTOPp->traceFullThis__1(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void VDownsample::traceInitThis__1(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->declBus(c+8,"data_out_data",-1,15,0);
	vcdp->declBit(c+9,"data_in_ready",-1);
	vcdp->declBit(c+10,"data_out_valid",-1);
	vcdp->declBit(c+11,"data_in_valid",-1);
	vcdp->declBus(c+12,"data_in_data",-1,15,0);
	vcdp->declBit(c+13,"data_out_ready",-1);
	vcdp->declBit(c+14,"CLK",-1);
	vcdp->declBit(c+15,"RESET",-1);
	vcdp->declBus(c+8,"Downsample data_out_data",-1,15,0);
	vcdp->declBit(c+9,"Downsample data_in_ready",-1);
	vcdp->declBit(c+10,"Downsample data_out_valid",-1);
	vcdp->declBit(c+11,"Downsample data_in_valid",-1);
	vcdp->declBus(c+12,"Downsample data_in_data",-1,15,0);
	vcdp->declBit(c+13,"Downsample data_out_ready",-1);
	vcdp->declBit(c+14,"Downsample CLK",-1);
	vcdp->declBit(c+15,"Downsample RESET",-1);
	vcdp->declBit(c+3,"Downsample keep",-1);
	vcdp->declBus(c+1,"Downsample y",-1,4,0);
	vcdp->declBus(c+4,"Downsample y_next",-1,4,0);
	vcdp->declBus(c+2,"Downsample x",-1,4,0);
	vcdp->declBus(c+5,"Downsample x_next",-1,4,0);
	vcdp->declBit(c+7,"Downsample yield_state",-1);
	vcdp->declBit(c+6,"Downsample yield_state_next",-1);
    }
}

void VDownsample::traceFullThis__1(VDownsample__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VDownsample* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->fullBus(c+1,(vlTOPp->Downsample__DOT__y),5);
	vcdp->fullBus(c+2,(vlTOPp->Downsample__DOT__x),5);
	vcdp->fullBit(c+3,(vlTOPp->Downsample__DOT__keep));
	vcdp->fullBus(c+4,(vlTOPp->Downsample__DOT__y_next),5);
	vcdp->fullBus(c+5,(vlTOPp->Downsample__DOT__x_next),5);
	vcdp->fullBit(c+6,(vlTOPp->Downsample__DOT__yield_state_next));
	vcdp->fullBit(c+7,(vlTOPp->Downsample__DOT__yield_state));
	vcdp->fullBus(c+8,(vlTOPp->data_out_data),16);
	vcdp->fullBit(c+9,(vlTOPp->data_in_ready));
	vcdp->fullBit(c+10,(vlTOPp->data_out_valid));
	vcdp->fullBit(c+11,(vlTOPp->data_in_valid));
	vcdp->fullBus(c+12,(vlTOPp->data_in_data),16);
	vcdp->fullBit(c+13,(vlTOPp->data_out_ready));
	vcdp->fullBit(c+14,(vlTOPp->CLK));
	vcdp->fullBit(c+15,(vlTOPp->RESET));
    }
}

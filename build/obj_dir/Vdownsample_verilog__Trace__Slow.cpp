// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdownsample_verilog__Syms.h"


//======================

void Vdownsample_verilog::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addCallback(&Vdownsample_verilog::traceInit, &Vdownsample_verilog::traceFull, &Vdownsample_verilog::traceChg, this);
}
void Vdownsample_verilog::traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->open()
    Vdownsample_verilog* t=(Vdownsample_verilog*)userthis;
    Vdownsample_verilog__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (!Verilated::calcUnusedSigs()) {
	VL_FATAL_MT(__FILE__,__LINE__,__FILE__,"Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vcdp->scopeEscape(' ');
    t->traceInitThis(vlSymsp, vcdp, code);
    vcdp->scopeEscape('.');
}
void Vdownsample_verilog::traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vdownsample_verilog* t=(Vdownsample_verilog*)userthis;
    Vdownsample_verilog__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    t->traceFullThis(vlSymsp, vcdp, code);
}

//======================


void Vdownsample_verilog::traceInitThis(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    vcdp->module(vlSymsp->name());  // Setup signal names
    // Body
    {
	vlTOPp->traceInitThis__1(vlSymsp, vcdp, code);
    }
}

void Vdownsample_verilog::traceFullThis(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vlTOPp->traceFullThis__1(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void Vdownsample_verilog::traceInitThis__1(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->declBit(c+6,"data_in_valid",-1);
	vcdp->declBus(c+7,"data_in_data",-1,15,0);
	vcdp->declBit(c+8,"data_in_ready",-1);
	vcdp->declBit(c+9,"data_out_valid",-1);
	vcdp->declBus(c+10,"data_out_data",-1,15,0);
	vcdp->declBit(c+11,"data_out_ready",-1);
	vcdp->declBit(c+12,"CLK",-1);
	vcdp->declBit(c+6,"downsample_verilog data_in_valid",-1);
	vcdp->declBus(c+7,"downsample_verilog data_in_data",-1,15,0);
	vcdp->declBit(c+8,"downsample_verilog data_in_ready",-1);
	vcdp->declBit(c+9,"downsample_verilog data_out_valid",-1);
	vcdp->declBus(c+10,"downsample_verilog data_out_data",-1,15,0);
	vcdp->declBit(c+11,"downsample_verilog data_out_ready",-1);
	vcdp->declBit(c+12,"downsample_verilog CLK",-1);
	vcdp->declBus(c+4,"downsample_verilog x",-1,4,0);
	vcdp->declBus(c+5,"downsample_verilog y",-1,4,0);
	vcdp->declBus(c+1,"downsample_verilog x_next",-1,4,0);
	vcdp->declBus(c+2,"downsample_verilog y_next",-1,4,0);
	vcdp->declBit(c+3,"downsample_verilog keep",-1);
    }
}

void Vdownsample_verilog::traceFullThis__1(Vdownsample_verilog__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vdownsample_verilog* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->fullBus(c+1,(vlTOPp->downsample_verilog__DOT__x_next),5);
	vcdp->fullBus(c+2,(vlTOPp->downsample_verilog__DOT__y_next),5);
	vcdp->fullBit(c+3,(vlTOPp->downsample_verilog__DOT__keep));
	vcdp->fullBus(c+4,(vlTOPp->downsample_verilog__DOT__x),5);
	vcdp->fullBus(c+5,(vlTOPp->downsample_verilog__DOT__y),5);
	vcdp->fullBit(c+6,(vlTOPp->data_in_valid));
	vcdp->fullBus(c+7,(vlTOPp->data_in_data),16);
	vcdp->fullBit(c+8,(vlTOPp->data_in_ready));
	vcdp->fullBit(c+9,(vlTOPp->data_out_valid));
	vcdp->fullBus(c+10,(vlTOPp->data_out_data),16);
	vcdp->fullBit(c+11,(vlTOPp->data_out_ready));
	vcdp->fullBit(c+12,(vlTOPp->CLK));
    }
}

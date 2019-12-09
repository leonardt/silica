// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vdownsample_verilog__Syms.h"
#include "Vdownsample_verilog.h"

// FUNCTIONS
Vdownsample_verilog__Syms::Vdownsample_verilog__Syms(Vdownsample_verilog* topp, const char* namep)
	// Setup locals
	: __Vm_namep(namep)
	, __Vm_didInit(false)
	// Setup submodule names
{
    // Pointer to top level
    TOPp = topp;
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOPp->__Vconfigure(this, true);
}

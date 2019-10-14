from staticfg import CFGBuilder


cfg = CFGBuilder().build_from_file("fsm.py", "./fsm.py")
cfg.build_visual("JTAG_FSM", 'pdf')

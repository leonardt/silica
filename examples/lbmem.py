import silica as si


@si.coroutine
def Fifo(depth=1024,fifo_width=5):
  fifo = [-1 for i in range(depth)]
  raddr = 0
  waddr = 0
  cnt = 0
  state = 0
  while (state==0):
    valid = 0
    rdata = fifo[raddr]
    wdata, wen = yield rdata, valid
    if (wen):
      cnt = cnt+1
      fifo[waddr] = wdata
      if (waddr==depth-1):
        waddr = 0
      else:
        waddr = waddr+1
    if cnt == fifo_width:
      state = 1

  while (state==1):
    valid = 1
    rdata = fifo[raddr]
    wdata, wen = yield rdata, valid
    if (raddr==depth-1):
      raddr = 0
    else:
      raddr = raddr+1
    
    if (wen):
      fifo[waddr] = wdata
      if (waddr==depth-1):
        waddr = 0
      else:
        waddr = waddr+1
    else:
      cnt = cnt-1
    
    if cnt==0:
      state = 0
    

if __name__ == "__main__":
  fifo = Fifo()
  wdata = [i for i in range(30)]
  wen =   [i%2 for i in range(30)]
  for inputs in zip(wdata,wen):
    print(f"inputs={inputs}, rdata={fifo.rdata}, valid={fifo.valid}")
    fifo.send(inputs)
  si.compile(fifo, file_name="fifo.magma.py")

import silica as si

@si.coroutine
def Fifo():
  fifo = [0 for i in range(4)]
  raddr = 0
  waddr = 0
  while True:
    rdata = fifo[raddr]
    empty = raddr == waddr
    wdata, wen, ren = yield rdata, empty
    if (wen):
      fifo[waddr] = wdata
    if (ren and not empty):
      if (raddr==3):
        raddr = 0
      else:
        raddr = raddr+1
    if (wen):
      if (waddr==3):
        waddr = 0
      else:
        waddr = waddr+1

if __name__ == "__main__":
  fifo = Fifo()
  wdata = [4,3,5,6,9,3,2,0]
  wen =   [0,1,1,1,0,1,1,0]
  ren =   [1,1,1,0,1,0,1,1]
  for inputs in zip(wdata,wen,ren):
    print(f"inputs={inputs}, rdata={fifo.rdata}, empty={fifo.empty}")
    fifo.send(inputs)
  si.compile(fifo, file_name="fifo.magma.py")

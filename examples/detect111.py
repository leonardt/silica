import silica as si

@si.coroutine
def detect111():
  cnt = si.uint(0,n=2)
  while True:
    O = (cnt == 3)
    I = yield O
    if (I):
      if (cnt<3):
        cnt = cnt+1
    else:
      cnt = 0

if __name__ == "__main__":
  detect = detect111()
  for i in [1,1,0,1,1,1,0,1,0,1,1,1,1,1,1]:
    print(f"i={i}, O={detect.O}")
    detect.send(i)
  silica.compile(detect, file_name="detect.magma.py")
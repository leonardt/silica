import glob
import subprocess
import os

for file in ["silica", "counter"]:
    os.remove(f"notebooks/{file}.py")
    os.symlink(f"../{file}.py", f"notebooks/{file}.py")

for file in glob.glob("*.py"):
    base_name = file.split(".")[0] 
    if base_name in {"silica", "generate_notebooks"}:
        continue
    subprocess.call(f"python -m py2nb {file} notebooks/{base_name}.ipynb".split(" "))
    subprocess.call(f"jupyter nbconvert --to notebook --inplace --execute notebooks/{base_name}.ipynb".split(" "))

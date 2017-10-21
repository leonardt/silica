import glob
import subprocess
import os

with open("README.md", "w") as readme:
    readme.write("""\
# Silica
Using coroutines to specify sequential logic circuits

# Setup
```
pip install -e .
```

# Examples
""")
    for file in glob.glob("examples/*.py"):
        base_name = file.split("/")[1].split(".")[0]
        os.symlink(f"../{file}", f"./notebooks/{base_name}.py")
        readme.write(f"* [{base_name}](./notebooks/{base_name}.ipynb)\n")

    for file in glob.glob("examples/*.py"):
        base_name = file.split("/")[1].split(".")[0]
        subprocess.call(f"python -m py2nb {file} notebooks/{base_name}.ipynb".split(" "))
        subprocess.call(f"jupyter nbconvert --to notebook --inplace --execute notebooks/{base_name}.ipynb".split(" "))

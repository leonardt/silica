import glob
import subprocess
import os
from py2nb.tools import python_to_notebook

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
        if os.path.isfile(f"./notebooks/{base_name}.py"):
            os.remove(f"./notebooks/{base_name}.py")
        os.symlink(f"../{file}", f"./notebooks/{base_name}.py")
        readme.write(f"* [{base_name}](./notebooks/{base_name}.ipynb)\n")

    for file in glob.glob("examples/*.py"):
        base_name = file.split("/")[1].split(".")[0]

        python_to_notebook(input_filename=file, output_filename=f"notebooks/{base_name}.ipynb")
        subprocess.call(f"jupyter nbconvert --to notebook --inplace --execute notebooks/{base_name}.ipynb".split(" "))

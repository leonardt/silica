#!/usr/bin/env python


import pandas as pd
import matplotlib.pyplot as plt

results = pd.read_json("results.json")
col_len = (len(results.columns) // 2)
fig, axes = plt.subplots(nrows=2, ncols=col_len, sharey='row')
for row in range(0, 2):
    for i, columns in enumerate(zip(results.columns[::2], results.columns[1::2])):
        curr = results[list(columns)]
        curr = curr.loc[(curr != 0).all(axis=1), :]
        if row == 0:
            curr = curr.filter(like="SB_", axis=0)
        elif row == 1:
            curr = curr.filter(regex="(wires|wire bits|public wires|memories|memory bits|processes|cells)", axis=0)
        # print(curr)
        if not curr.empty:
            curr.plot.barh(ax=axes[row, i])
plt.show()

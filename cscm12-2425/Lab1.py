import matplotlib.pyplot as plt
import numpy as np
import csv
import sys

filepath = sys.argv[1] if len(sys.argv) > 1 else 'Lab1.csv'

# ybound is the maximal value plotted onto the y-axis; feel free to modify if
# you want to see more of the vertical part of the graph
ybound = 4000

fig, ax = plt.subplots(layout='constrained')

with open(filepath) as file:
  dataReader = csv.reader(file, delimiter=',')
  data = [(row[0], [int(x) for x in row[1:-1]]) for row in dataReader]



indices = data[0]
xbound = indices[1][-1]
data = data[1:]

for (label, row) in data:
    ax.plot(indices[1][0:len(row)],row,'o-',label=label)

ax.set_xlabel(indices[0])
ax.set_ylabel('Running time (ms)')

# uncomment the following lines to also plot the functions for question 2d
# finex=np.linspace(0,xbound)
# ax.plot(finex, [x * np.log(1 + x) for x in finex], label='n log(n) (roughly)')
# ax.plot(finex, [x * x / 10 for x in finex], label='n² (roughly)')
# ax.plot(finex, [x ** 3 for x in finex], label='n³ (roughly)')

ax.set_xbound(0,xbound)
ax.set_ybound(0,ybound)
ax.legend()
plt.show()

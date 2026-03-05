import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Create a sample dataset
data = pd.DataFrame({
    'Month': ['01-01-2023', '01-02-2023', '01-03-2023', '01-04-2023', '01-05-2023', '01-06-2023', '01-07-2023', '01-08-2023', '01-09-2023', '01-10-2023', '01-11-2023', '01-12-2023'],
    'Event': ['Event A', 'Event B', 'Event C', 'Event A', 'Event B', 'Event C', 'Event A', 'Event B', 'Event C', 'Event A', 'Event B', 'Event C'],
    'Count': [5, 8, 6, 4, 7, 9, 3, 6, 5, 2, 4, 6],
    'Type': ['Type 1', 'Type 2', 'Type 1', 'Type 2', 'Type 1', 'Type 2', 'Type 1', 'Type 2', 'Type 1', 'Type 2', 'Type 1', 'Type 2']
})

# Convert Month column to datetime
data['Month'] = pd.to_datetime(data['Month'], format='%d-%m-%Y')


# Assign numeric values to months
data['Month_Num'] = pd.Categorical(data['Month'], categories=data['Month'].unique(), ordered=True).codes

# Plot the graph
fig, ax = plt.subplots()
colors = {'Type 1': 'blue', 'Type 2': 'red'}
for i, row in data.iterrows():
    ax.add_patch(
        plt.Rectangle((row['Month_Num'] - 0.4, 0), 0.8, row['Count']), 
                               #color=colors[row['Type']], 
                               # edgecolor='black')
    )

ax.set_xlabel('Month')

plt.show()
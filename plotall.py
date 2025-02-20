import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
plt.style.use('classic')
mpl.use('pdf')
mpl.rcParams['xtick.major.size'] = 8
mpl.rcParams['xtick.major.width'] = 2
mpl.rcParams['ytick.major.size'] = 8
mpl.rcParams['ytick.major.width'] = 2
mpl.rcParams['axes.linewidth']= 2
pattern=input("Enter the pattern: ")
file=['hbonds_pnw','hbonds_pnp','radius_of_gyration','rmsd','sasa',"Distance_GLU35_ASP52"]
for a in file:
    data=np.genfromtxt(a+'.dat')
    plt.figure(facecolor='white')
    plt.title(a,weight='bold')
    plt.plot(data[:,0], data[:,1], color='red')
    plt.xticks(rotation=75,weight='bold')
    plt.yticks(weight='bold')
    plotfile=a+'.png'
    plt.savefig(pattern+plotfile, dpi=300, bbox_inches='tight')



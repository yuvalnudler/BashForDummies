import sys
from pathlib import Path
import matplotlib.pyplot as plt

def read_fasta(path):
    seqs = []
    current = []
    with open(path) as f:
        for line in f:
            line=line.strip()
            if line.startswith(">"):
                if current:
                    seqs.append("".join(current))
                    current=[]
            else:
                current.append(line)
        if current:
            seqs.append("".join(current))
    return seqs

if len(sys.argv)!=4:
    print("Usage: python analyze_fasta.py <fasta> <name> <motif>")
    sys.exit(1)

fasta = Path(sys.argv[1])
motif = sys.argv[3].upper()

seqs = read_fasta(fasta)
counts = [s.count(motif) for s in seqs]

Path("output").mkdir(exist_ok=True)

with open("output/motif_counts_local.csv","w") as f:
    f.write("sequence_index,count
")
    for i,c in enumerate(counts):
        f.write(f"{i},{c}
")

plt.bar(range(len(counts)), counts)
plt.xlabel("Sequence index")
plt.ylabel("Motif count")
plt.savefig("output/python_motif_hist_local.png")

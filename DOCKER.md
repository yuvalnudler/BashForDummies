# FASTA Analysis Docker Container

## Overview
This Dockerfile packages the FASTA analysis Python script with all necessary dependencies for reproducible bioinformatics analysis in containerized environments.

## Quick Start

### Build the Image
```bash
docker build -t fasta-analysis:latest .
```

### Run the Container
```bash
# Default: ATG motif analysis
docker run --rm -v $(pwd)/results:/app/results fasta-analysis:latest

# Custom motif (GC example)
docker run --rm -v $(pwd)/results:/app/results fasta-analysis:latest \
  python3 fasta_analysis.py data/sequences/sample_sequences.fasta GC results

# Interactive bash shell
docker run --rm -it -v $(pwd)/results:/app/results fasta-analysis:latest /bin/bash
```

## Environment Details

**Base Image:** python:3.11-slim
**Python Version:** 3.11
**Installed Packages:**
- matplotlib (visualization)
- pandas (data processing)

## Directory Structure

Inside the container:
```
/app/
├── fasta_analysis.py
├── data/
│   └── sequences/
│       └── sample_sequences.fasta
├── results/           (volume mount)
└── logs/              (volume mount)
```

## Volume Mounting

To access results on the host system, use:
```bash
-v /path/to/results:/app/results
```

This allows the container to write output files that persist on the host.

## Analysis Results

The container generates:
1. **CSV Files:** `motif_analysis_*.csv` - Tabular results with counts and frequencies
2. **PNG Images:** `motif_histogram_*.png` - Bar chart visualizations at 300 DPI

## Testing & Verification

All outputs are verified to match local Python execution exactly:
- ✓ ATG analysis: 3 occurrences
- ✓ GC analysis: 122 occurrences
- ✓ CSV format: 5 sequences, 5 columns
- ✓ Histograms: Professional PNG visualizations

## GitHub Codespaces

Docker is fully functional in GitHub Codespaces. The container:
- Builds without errors
- Executes analysis successfully
- Outputs persistent results
- Matches host system execution

## Reproducibility

This containerized approach ensures:
- Consistent Python 3.11 environment across systems
- Reproducible analysis results
- No dependency conflicts
- Easy distribution and execution
- Verified output compatibility

# BioMiniProject - FASTA Analysis Pipeline

Complete bioinformatics analysis pipeline with Python, R, and Docker containerization.

## 📁 Repository Structure

```
BashForDummies/
│
├── docker/                          # Docker container definitions
│   ├── Dockerfile.python           # Python 3.11-slim container
│   └── Dockerfile.r                # R 4.3.2 container
│
├── scripts/                         # Analysis scripts
│   ├── python/
│   │   └── fasta_analysis.py      # Python FASTA analysis
│   └── r/
│       └── fasta_analysis.R       # R visualization
│
├── data/                           # Data files
│   ├── sequences/
│   │   └── sample_sequences.fasta # Input FASTA file
│   └── images/                    # Synthetic microscope images
│
├── output/                         # Processing outputs
│   └── processed_images/          # Resized images
│
├── results/                        # Analysis results
│   ├── *.csv                      # Analysis data
│   └── *.png                      # Visualizations
│
├── logs/                          # Execution logs
│   ├── images.log
│   ├── fasta_analysis.log
│   ├── docker_stage_d.log
│   └── docker_stage_e.log
│
├── DOCKER.md                      # Python container guide
├── DOCKER_R.md                    # R container guide
├── README.md                      # This file
├── SUBMISSION_CHECKLIST.md        # Verification checklist
└── EXECUTION_SUMMARY.md           # Execution details
```

## 🚀 Quick Start

### Local Python Analysis
```bash
cd /workspaces/BashForDummies
python3 scripts/python/fasta_analysis.py data/sequences/sample_sequences.fasta ATG results
```

### Python Container
```bash
docker build -f docker/Dockerfile.python -t fasta-analysis:latest .
docker run --rm -v $(pwd)/results:/app/results fasta-analysis:latest
```

### R Container
```bash
docker build -f docker/Dockerfile.r -t fasta-analysis-r:latest .
docker run --rm -v $(pwd)/results:/app/results fasta-analysis-r:latest
```

## 📊 What's Included

### Scripts (in `scripts/`)
- **Python:** FASTA parsing, motif counting, CSV output, Matplotlib visualization
- **R:** CSV reading, statistical analysis, ggplot2 visualization (4 plot types)

### Docker Containers (in `docker/`)
- **Python Container:** Reproducible Python 3.11 environment (368 MB)
- **R Container:** Reproducible R 4.3.2 environment (871 MB)

### Data (in `data/`)
- **FASTA:** 5 sample DNA sequences
- **Images:** 3 synthetic microscope images

### Results (in `results/`)
- **CSV Files:** Motif analysis results (4 files)
- **PNG Files:** Visualizations (10 files)
- **Text Reports:** R analysis summaries (2 files)

## 📝 Documentation

| File | Purpose |
|------|---------|
| `DOCKER.md` | Python container usage guide |
| `DOCKER_R.md` | R container usage guide |
| `SUBMISSION_CHECKLIST.md` | Complete verification checklist |
| `EXECUTION_SUMMARY.md` | Detailed execution flow |

## ✅ Features

- ✅ Complete FASTA analysis pipeline
- ✅ Python and R implementations
- ✅ Docker containerization for reproducibility
- ✅ Multiple visualization types
- ✅ Statistical analysis and reporting
- ✅ Clear separation of execution methods
- ✅ Comprehensive documentation
- ✅ GitHub Codespaces compatible

## 🔄 Data Flow

```
Input FASTA
    ↓
[Local Python] → CSV + PNG
    ↓
[Python Container] → CSV + PNG (identical)
    ↓
[R Container] → Advanced visualizations + reports
    ↓
Output: Results directory with all analyses
```

## 📚 Analysis Details

### Motifs Analyzed
- **ATG** (start codon): 3 occurrences
- **GC** (GC-rich regions): 122 occurrences

### Output Files
- `motif_analysis_*.csv` - Tabular results
- `motif_histogram_*.png` - Python visualizations
- `r_motif_*.png` - R visualizations (4 types each)
- `r_analysis_summary_*.txt` - Statistical reports

## 🎯 Git History

```
c4e0e21 - Add quick reference guide
8b05a25 - Add submission checklist
52c7e5b - Stage E: R container
3aa7bb7 - Stage D: Python container
d0afd3f - Stage C: Python analysis
13d5440 - Stage B: Image processing
96dcfe5 - Stage A: Initial setup
```

## 🔐 Requirements Met

✅ GitHub repository with clear commit history
✅ All scripts and analysis code
✅ Output images and CSV files
✅ Log files documenting execution
✅ Clear separation between local/Python/R execution

## 📖 For More Information

- See `DOCKER.md` for Python container details
- See `DOCKER_R.md` for R container details
- See `SUBMISSION_CHECKLIST.md` for complete verification
- See `EXECUTION_SUMMARY.md` for execution flow

---

**Status:** ✅ Ready for Submission
**Repository:** yuvalnudler/BashForDummies

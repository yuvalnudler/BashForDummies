#!/usr/bin/env python3
"""
FASTA Analysis Script
Reads FASTA files, counts biological motifs, and generates visualizations
"""

import sys
import csv
from pathlib import Path
import matplotlib.pyplot as plt
from collections import defaultdict

def read_fasta(filepath):
    """
    Read a FASTA file and return sequences with their headers.
    
    Args:
        filepath: Path to FASTA file
        
    Returns:
        List of tuples: (header, sequence)
    """
    sequences = []
    current_header = None
    current_seq = []
    
    try:
        with open(filepath, 'r') as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                    
                if line.startswith('>'):
                    if current_header is not None:
                        sequences.append((current_header, ''.join(current_seq)))
                    current_header = line[1:]  # Remove '>'
                    current_seq = []
                else:
                    current_seq.append(line)
            
            # Don't forget the last sequence
            if current_header is not None:
                sequences.append((current_header, ''.join(current_seq)))
    
    except FileNotFoundError:
        print(f"Error: File {filepath} not found", file=sys.stderr)
        sys.exit(1)
    
    return sequences

def count_motif(sequence, motif):
    """
    Count non-overlapping occurrences of a motif in a sequence.
    
    Args:
        sequence: DNA/RNA sequence string
        motif: Motif to search for
        
    Returns:
        Count of motif occurrences
    """
    motif_upper = motif.upper()
    sequence_upper = sequence.upper()
    return sequence_upper.count(motif_upper)

def analyze_fasta(fasta_file, motif):
    """
    Analyze FASTA file for motif occurrences.
    
    Args:
        fasta_file: Path to FASTA file
        motif: Motif to search for
        
    Returns:
        List of (header, count) tuples
    """
    sequences = read_fasta(fasta_file)
    results = []
    
    for header, sequence in sequences:
        count = count_motif(sequence, motif)
        results.append({
            'sequence_id': header,
            'sequence_length': len(sequence),
            'motif': motif.upper(),
            'count': count,
            'frequency': count / (len(sequence) - len(motif) + 1) if len(sequence) >= len(motif) else 0
        })
    
    return results

def save_results_csv(results, output_file):
    """
    Save analysis results to CSV file.
    
    Args:
        results: List of result dictionaries
        output_file: Path to output CSV file
    """
    output_file = Path(output_file)
    output_file.parent.mkdir(parents=True, exist_ok=True)
    
    with open(output_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['sequence_id', 'sequence_length', 'motif', 'count', 'frequency'])
        writer.writeheader()
        writer.writerows(results)
    
    print(f"Results saved to {output_file}")

def generate_histogram(results, output_file, motif):
    """
    Generate a histogram of motif counts.
    
    Args:
        results: List of result dictionaries
        output_file: Path to output PNG file
        motif: Motif being analyzed
    """
    output_file = Path(output_file)
    output_file.parent.mkdir(parents=True, exist_ok=True)
    
    sequence_ids = [r['sequence_id'] for r in results]
    counts = [r['count'] for r in results]
    
    fig, ax = plt.subplots(figsize=(10, 6))
    bars = ax.bar(range(len(sequence_ids)), counts, color='steelblue', edgecolor='navy', alpha=0.7)
    
    ax.set_xlabel('Sequence', fontsize=12, fontweight='bold')
    ax.set_ylabel('Motif Count', fontsize=12, fontweight='bold')
    ax.set_title(f'Occurrences of Motif "{motif.upper()}" in Sequences', fontsize=14, fontweight='bold')
    ax.set_xticks(range(len(sequence_ids)))
    ax.set_xticklabels(sequence_ids, rotation=45, ha='right')
    
    # Add value labels on bars
    for i, (bar, count) in enumerate(zip(bars, counts)):
        ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.1, 
                str(count), ha='center', va='bottom', fontweight='bold')
    
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"Histogram saved to {output_file}")
    plt.close()

def main():
    """Main analysis pipeline"""
    
    if len(sys.argv) < 3:
        print("Usage: python fasta_analysis.py <fasta_file> <motif> [output_dir]")
        print("Example: python fasta_analysis.py data/sequences/sample_sequences.fasta ATG results")
        sys.exit(1)
    
    fasta_file = Path(sys.argv[1])
    motif = sys.argv[2]
    output_dir = Path(sys.argv[3]) if len(sys.argv) > 3 else Path('results')
    
    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"Analyzing {fasta_file} for motif: {motif.upper()}")
    
    # Perform analysis
    results = analyze_fasta(fasta_file, motif)
    
    # Display summary
    print(f"\nAnalysis Summary:")
    print(f"Total sequences: {len(results)}")
    total_motif_count = sum(r['count'] for r in results)
    print(f"Total motif occurrences: {total_motif_count}")
    print(f"\nSequence Details:")
    for result in results:
        print(f"  {result['sequence_id']}: {result['count']} occurrences (length: {result['sequence_length']} bp)")
    
    # Save results
    csv_output = output_dir / f'motif_analysis_{motif.upper()}.csv'
    save_results_csv(results, csv_output)
    
    # Generate visualization
    hist_output = output_dir / f'motif_histogram_{motif.upper()}.png'
    generate_histogram(results, hist_output, motif)
    
    print(f"\nAnalysis complete!")

if __name__ == '__main__':
    main()

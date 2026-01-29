FROM python:3.11-slim

# Install required dependencies
RUN pip install --no-cache-dir matplotlib pandas

# Set working directory
WORKDIR /app

# Copy the FASTA analysis script
COPY fasta_analysis.py /app/fasta_analysis.py

# Copy FASTA data
COPY data/sequences /app/data/sequences

# Create output directory
RUN mkdir -p /app/results /app/logs

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Default command - run analysis for ATG motif
CMD ["python3", "fasta_analysis.py", "data/sequences/sample_sequences.fasta", "ATG", "results"]

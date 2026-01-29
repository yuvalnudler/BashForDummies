FROM python:3.11-slim
RUN pip install matplotlib pandas
WORKDIR /app
COPY analysis/analyze_fasta.py /app/analyze_fasta.py
COPY data /app/data
RUN mkdir -p /app/output
CMD ["python","analyze_fasta.py","data/fasta/virus_hiv.fasta","HIV","ATG"]

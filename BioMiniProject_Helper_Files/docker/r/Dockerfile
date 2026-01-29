FROM rocker/r-base:4.3.2
RUN R -e "install.packages('ggplot2', repos='https://cloud.r-project.org')"
WORKDIR /app
COPY analysis/analyze_fasta.R /app/analyze_fasta.R
CMD ["Rscript","analyze_fasta.R"]

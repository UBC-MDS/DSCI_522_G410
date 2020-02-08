
# Docker file 
# Created collaboratively by DSCI 522 Group 410
# Members: Merve Sahin, Sakariya Aynashe, Huayue (Luke) Lu, and Holly Williams
# February, 2020
#
# This file loads all the software and libraries/packages needed to run our analysis pipeline,
# and then runs our makefile to reproduce our analysis from beginning to end!
#

# Use rocker/tidyverse as the base image
FROM rocker/tidyverse

# Install the anaconda distribution of python
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda update -n base -c defaults conda

RUN apt-get update && apt install -y chromium && apt-get install -y libnss3 && apt-get install unzip

# Install chromedriver
RUN wget -q "https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip && chown root:root /usr/bin/chromedriver && chmod +x /usr/bin/chromedriver

# Install extra R packages
RUN R -e "install.packages('broom', repos=‘https://cloud.r-project.org/’)"
RUN R -e "install.packages('scales', repos=‘https://cloud.r-project.org/’)"
RUN R -e "install.packages('testthat', repos=‘https://cloud.r-project.org/’)"
RUN R -e "install.packages(‘tools’, repos=‘https://cloud.r-project.org/’)"
RUN R -e "install.packages(‘cowplot’, repos=‘https://cloud.r-project.org/’)"
RUN R -e "install.packages(‘RCurl’, repos=‘https://cloud.r-project.org/’)"

# Install altair, cowplot, selenium and docopt
RUN conda install -y -c conda-forge altair && conda install -y selenium && \
    conda install -y -c anaconda docopt
    
    
# Install make file
RUN apt-get update && apt-get install make

# Put anaconda python in path
ENV PATH="/opt/conda/bin:${PATH}"
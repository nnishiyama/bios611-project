BIOS611 Project
===============

This is my project to analyze expression Quantitative Trait Loci (eQTL) from the Genotype-Tissue Expression (GTEx) project (https://www.gtexportal.org/home/documentationPage). eQTL analysis finds statistical associations between genetic variants within a population and expression of a particular gene. GTEx has quantified eQTLs in over 40 human tissues. This project will use summary statistics and meta-data to interrogate these findings further. For example, eQTLs may have commonalities or differences across tissues such as in their presence/absence and effect size since gene expression can also be specific to a given tissue. I am interested to see if I can find patterns within this data across tissues, either from the variant or the gene perspective. Some questions I will try to answer:
 - Does the distance between a genetic variant and a gene affect its significance?
 - Similarly, does the distance determine the effect size of the eQTL?
 - Are variants located within gene dense regions more likely to be associated with eQTLs that variants located in sparse gene regions?
 - Are there leading genetic variants/genes/eQTLs that are shared across a majority of tissues or tissue systems?
 - If I can detect some leading or shared signals, do genetic variants act in the same way across tissues (or do the effects correlate?)?
 - And other fun stuff!

*** Fair Warning: the source data for this project requires ~10G of space, so plan accordingly! ***

**Also, please make sure your Docker container resources are set with a memory limit of at least 6G. Unfortunately, I couldn't figure out how to set this when setting up the container (using the --memory=6g flag did not seem to work for me). If you have the Docker Desktop GUI installed, open it and go to Settings/Preferences -> Resources -> drag the memory bar to the desired amount -> click Apply & Restart . Otherwise, you will likely get dumped when running processes and targets will not complete.**



To run this code, first clone this repo by typing the following into your command line/terminal:

```
git clone https://github.com/nnishiyama/bios611-project
cd bios611-project/
```

Then build the Docker container as follows:

```
docker build . -t eqtl
```

And then start an RStudio server inside the Docker container like this:

```
docker run -e PASSWORD=pilot \
  -v $(pwd):/home/rstudio/project\
  -p 8787:8787 --rm\
  eqtl
```

Then visit http://localhost:8787 in your browser. Log in with user `rstudio` and password `pilot`.

Within RStudio, select the `Terminal` tab and move into the project directory:

```
cd project/
```

Finally, use `make` to generate targets. Such as:

```
make figures/fig1.png
```

To build the report summarizing my data science project, run the following command in the `Terminal` tab:

```
make report.pdf
```


Shiny App
=========

To run the shiny app, clone this repo, build the docker image, then run:

```
docker run -d \
       -p 8080:8080 \
       -p 8787:8787 \
       -e PASSWORD=pilot
       -v $(pwd):/home/rstudio/project
       -t eqtl
```

Then connect via the browser: http://localhost:8787 with user `rstudio` and password `pilot`.

Launch the Shiny app from the command line/terminal within Rstudio:

```
cd project/;
Rscript shiny/shiny_plot_eqtls.R;
```

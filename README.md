BIOS611 Project
===============

This is my project to analyze eQTLs from the Genotype-Tissue Expression (GTEx) project.
Something about why eQTLs are important & interesting. 

To run this code, first clone this repo by typing the following into your command line/terminal:

```
git clone https://github.com/nnishiyama/bios611-project
cd bios611-project/
```

Then build the docker container as follows:

```
docker build . -t eqtl
```

And then start an RStudio server like this:

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

Finally, use `make` to generate targets.


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

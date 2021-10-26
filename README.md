BIOS611 Project
===============

This is my project to analyze eQTLs from the Genotype-Tissue Expression (GTEx) project.
Something about why eQTLs are important & interesting. 

To run this code, build the docker container as follows:

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


Shiny App
=========

To run the shiny app, clone this repo then run:

```
docker run \
-p 8080:8080 \
-v `pwd`:/home/rstudio/project \
-e PASSWORD=$SECRET_PWD \
-it l13 sudo -H -u rstudio \
/bin/bash -c "cd ~/project; Rscript scripts/shiny_plot_eqtls.R"
```

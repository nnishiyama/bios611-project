FROM rocker/verse 
RUN R -e "install.packages(c('shiny','data.table','formattable','htmltools', 'R.utils'))";
RUN R -e "install.packages('tinytex')"; 
RUN R -e "tinytex::install_tinytex()";
RUN R -e "install.packages('webshot')"; 
RUN R -e "webshot::install_phantomjs()";
FROM rocker/verse 
RUN R -e "install.packages(\"shiny\", \"data.table\", \"formattable\", \"htmltools\")";
RUN R -e "install.packages(\"tinytex\")"; tinytex::install_tinytex();
RUN R -e "install.packages(\"webshot\")"; webshot::install_phantomjs();
.PHONY: clean

test.pdf:
	Rscript -e “rmarkdown::render(‘./scratch/test.Rmd’)”

report.pdf: preprocessed_data download_source_data
	rm report.pdf;

figures/fig3.png: working_data/merged_egenes.txt preprocessed_data download_source_data
	rm -f figures/fig3.png;
	Rscript scripts/tss_distance_vs_slope_plot.R

figures/fig2.png: working_data/merged_egenes.txt preprocessed_data download_source_data
	rm -f figures/fig2.png;
	Rscript scripts/tss_distance_vs_significance.R

figures/fig1.png: working_data/merged_egenes.txt preprocessed_data download_source_data
	rm -f figures/fig1.png;
	mkdir figures;
	Rscript scripts/tss_distance_plots.R

working_data/merged_egenes.txt: preprocessed_data download_source_data source_data/GTEx_Analysis_v8_eQTL/genes/
	rm -f working_data/merged_egenes.txt;
	mkdir working_data;
	head -1 source_data/GTEx_Analysis_v8_eQTL/genes/Lung.v8.egenes.txt > working_data/merged_egenes.txt;
	tail -n +2 -q source_data/GTEx_Analysis_v8_eQTL/genes/*.v8.egenes.txt >> working_data/merged_egenes.txt;

preprocessed_data: download_source_data source_data/GTEx_Analysis_v8_eQTL/
	rm -f preprocessed_data;
	./scripts/add_tissue_type.sh source_data/GTEx_Analysis_v8_eQTL/;
	mkdir source_data/GTEx_Analysis_v8_eQTL/eqtl;
	mkdir source_data/GTEx_Analysis_v8_eQTL/genes;
	mv source_data/GTEx_Analysis_v8_eQTL/*.v8.egenes.txt source_data/GTEx_Analysis_v8_eQTL/genes/;
	mv source_data/GTEx_Analysis_v8_eQTL/*.v8.signif_variant_gene_pairs.txt source_data/GTEx_Analysis_v8_eQTL/eqtl;
	touch preprocessed_data

download_source_data:
	rm -f download_source_data;
	echo "WARNING: the source data for this project is ~10G";
	mkdir source_data;
	curl -o source_data/GTEx_Analysis_v8_eQTL.tar https://storage.googleapis.com/gtex_analysis_v8/single_tissue_qtl_data/GTEx_Analysis_v8_eQTL.tar;
	tar -xvf source_data/GTEx_Analysis_v8_eQTL.tar -C source_data/;
	rm -rf source_data/GTEx_Analysis_v8_eQTL.tar;
	./scripts/extract_files.sh source_data/GTEx_Analysis_v8_eQTL/;
	touch download_source_data


clean:
	rm -f report.pdf
	rm -rf working_data/
	rm -rf figures/
	rm -rf source_data/
	rm -f download_source_data
	rm -f preprocessed_data

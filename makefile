.PHONY: clean

test.pdf:
	Rscript -e “rmarkdown::render(‘./scratch/test.Rmd’)”

report.pdf: figures/fig1.png figures/fig2.png figures/fig3.png figures/fig4.png figures/fig5.png
	rm -f report.pdf;

figures/fig5.png: data/merged_eqtl.txt.gz scripts/variant_distribution_genome.R
	rm -f figures/fig5.png;
	Rscript scripts/variant_distribution_genome.R

figures/fig4.png: data/merged_egenes.txt scripts/gene_distribution_genome.R
	rm -f figures/fig4.png;
	Rscript scripts/gene_distribution_genome.R

figures/fig3.png: data/merged_egenes.txt scripts/tss_distance_vs_slope_plot.R
	rm -f figures/fig3.png;
	Rscript scripts/tss_distance_vs_slope_plot.R

figures/fig2.png: data/merged_egenes.txt scripts/tss_distance_vs_significance.R
	rm -f figures/fig2.png;
	Rscript scripts/tss_distance_vs_significance.R

figures/fig1.png: data/merged_egenes.txt scripts/tss_distance_plots.R
	rm -f figures/fig1.png;
	Rscript scripts/tss_distance_plots.R

data/merged_eqtl.txt.gz: make_directories
	rm -f data/merged_eqtl.txt.gz;
	head -1 source_data/GTEx_Analysis_v8_eQTL/eqtl/Lung.v8.signif_variant_gene_pairs.txt > data/merged_eqtl.txt;
	tail -n +2 -q source_data/GTEx_Analysis_v8_eQTL/eqtl/*.v8.signif_variant_gene_pairs.txt >> data/merged_eqtl.txt;
	gzip data/merged_eqtl.txt;
	#rm -fr source_data/GTEx_Analysis_v8_eQTL/eqtl/;

data/merged_egenes.txt: make_directories
	rm -f data/merged_egenes.txt;
	head -1 source_data/GTEx_Analysis_v8_eQTL/genes/Lung.v8.egenes.txt > data/merged_egenes.txt;
	tail -n +2 -q source_data/GTEx_Analysis_v8_eQTL/genes/*.v8.egenes.txt >> data/merged_egenes.txt

make_directories: preprocessed_data
	rm -f make_directories;
	mkdir data figures;
	touch make_directories;

preprocessed_data: download_source_data scripts/add_tissue_type.sh
	rm -f preprocessed_data;
	./scripts/add_tissue_type.sh source_data/GTEx_Analysis_v8_eQTL/;
	mkdir source_data/GTEx_Analysis_v8_eQTL/eqtl;
	mkdir source_data/GTEx_Analysis_v8_eQTL/genes;
	mv source_data/GTEx_Analysis_v8_eQTL/*.v8.egenes.txt source_data/GTEx_Analysis_v8_eQTL/genes/;
	mv source_data/GTEx_Analysis_v8_eQTL/*.v8.signif_variant_gene_pairs.txt source_data/GTEx_Analysis_v8_eQTL/eqtl;
	touch preprocessed_data

download_source_data: scripts/extract_files.sh
	rm -f download_source_data;
	echo "WARNING: the source data for this project is ~10G";
	mkdir source_data;
	curl -o source_data/GTEx_Analysis_v8_eQTL.tar https://storage.googleapis.com/gtex_analysis_v8/single_tissue_qtl_data/GTEx_Analysis_v8_eQTL.tar;
	tar -xvf source_data/GTEx_Analysis_v8_eQTL.tar -C source_data/;
	rm -rf source_data/GTEx_Analysis_v8_eQTL.tar;
	./scripts/extract_files.sh source_data/GTEx_Analysis_v8_eQTL/;
	touch download_source_data


clean:
	rm -f report.pdf;
	rm -rf data/;
	rm -rf figures/;
	rm -rf source_data/;
	rm -f download_source_data;
	rm -f preprocessed_data;
	rm -f make_directories;

# makefile: Rnw -> tex -> pdf
# v 2.0
# .Rnw extension is automatically added
file_name = probability_hse_exams

.PHONY: R clean

auto_tikz_folder = auto_figures_tikz
r_plots_folder = R_plots

# get the list of all .R files
r_full_plots_files = $(wildcard $(r_plots_folder)/*.R)

# remove R_plots before
r_plots_files = $(r_full_plots_files:R_plots/%=%)

# replace .R by .Rdone for evey file
r_done_files = $(r_full_plots_files:.R=.Rdone)

# replace .R by .tex for every file
tikz_from_R_files = $(r_plots_files:.R=.tex)

# replace .R by .pdf for every file
pdf_from_R_files = $(r_plots_files:.R=.pdf)

# add folder before each file
pdf_full_from_R_files = $(addprefix $(auto_tikz_folder)/, $(pdf_from_R_files))

all: $(r_done_files) $(file_name).pdf excerpt_minima.pdf excerpt_exam_questions.pdf

# to build "all" target we need updated .Rdone files for each R script and main pdf file
# to build main pdf file we need: main tex file, chapters tex files, pdf files of plots
# to build pdf files of plots we need tex files of plots
# to build .Rdone file we just execute script and touch file
# each sript creates png and tex (tikz) file of plot
# so :)
# 1. all R sripts will be run and png and tex plot files will be produced and .Rdone will be touched
# 2. all tex plots will be transformed to small pdfs
# 3. main tex file will be proceeded

excerpt_minima.pdf: excerpt_minima.tex chapters/*.tex 
	# protection against biber error
	# http://tex.stackexchange.com/questions/140814/
	rm -rf `biber --cache`

	# create pdf
	# will automatically run pdflatex/biber if necessary
	latexmk -xelatex -latexoption=-shell-escape excerpt_minima.tex

	# clean
	latexmk -c excerpt_minima.tex


excerpt_exam_questions.pdf: excerpt_exam_questions.tex chapters/*.tex 
	# protection against biber error
	# http://tex.stackexchange.com/questions/140814/
	rm -rf `biber --cache`

	# create pdf
	# will automatically run pdflatex/biber if necessary
	latexmk -xelatex -latexoption=-shell-escape excerpt_exam_questions.tex

	# clean
	latexmk -c excerpt_exam_questions.tex




$(file_name).pdf: $(file_name).tex chapters/*.tex $(pdf_full_from_R_files)
	# protection against biber error
	# http://tex.stackexchange.com/questions/140814/
	rm -rf `biber --cache`

	# create pdf
	# will automatically run pdflatex/biber if necessary
	latexmk -xelatex -latexoption=-shell-escape $(file_name).tex

	# clean
	latexmk -c $(file_name).tex


# $(file_name).tex: $(file_name).Rnw
#	Rscript -e "library(knitr); knit('$(file_name).Rnw')"

$(auto_tikz_folder)/%.pdf: $(auto_tikz_folder)/%.tex
	latexmk -xelatex -cd $<
	latexmk -c $<
	# $< means the name of the first prerequisite
	# %.pdf is a wildcard (every .pdf)

R_plots/%.Rdone: R_plots/%.R
	Rscript $<
	touch $@

R: $(r_done_files)



clean:
	latexmk -c $(file_name).tex
	-rm $(file_name).amc $(file_name).bbl $(file_name).log
	-rm $(file_name).fdb_latexmk $(file_name).fls $(file_name).xdv

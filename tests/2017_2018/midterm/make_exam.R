# install most recent version of exam package
# install.packages("exams", repos="http://R-Forge.R-project.org")

library(exams)

# check whether latex is present and specify path to latexmk
Sys.which("latexmk")
latex_executable <- Sys.which("pdflatex")
options(texi2dvi = latex_executable)



files_all <- list.files('rmd/', pattern = "*.Rmd", full.names = TRUE)
files_all




# every variant should go into separate folder
# for the moment n > 1 does overwrite old questions in texdir folder
# scrambling is done by sample()



set.seed(777)
files_shuffled <- sample(files_all)
files_shuffled

files_sample = files_shuffled[1:40]
files_sample



dir.create("pdf")
dir.create("tex")

exams <- exams2nops(files_sample, n = 1, 
                    dir = "pdf", 
                    verbose = TRUE, 
                    language = "ru",
            texdir = "tex", 
            name = "the_exam",
            date = "2018-09-18", institution = "Higher School of Economics",
            logo = "",
            encoding = "UTF-8",
            samepage = TRUE, 
            reglength = 3, # is not working?
            blank = 0,
            header = "\\input{../header.tex}",
            title = "Probability theory and Statistics")

sol <- exams_metainfo(exams)
print(sol, 1)




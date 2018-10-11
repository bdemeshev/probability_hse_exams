# install most recent version of exam package
# install.packages("exams", repos="http://R-Forge.R-project.org")

library(exams)

# check whether latex is present and specify path to latexmk
Sys.which("latexmk")
latex_executable <- Sys.which("pdflatex")
options(texi2dvi = latex_executable)



files <- list.files('rmd/', full.names = TRUE)

files = setdiff(files, c("rmd//vanya_10.Rmd", "rmd//vanya_07.Rmd", 
                "rmd//boris_05.Rmd", "rmd//boris_03.Rmd", "rmd//boris_02.Rmd",
                "rmd/elena_01.Rmd", "rmd//kolya_01.Rmd", "rmd//kolya_09.Rmd",
                "rmd//dima_02.Rmd", "rmd//dima_04.Rmd", "rmd//bogdan_08.Rmd",
                "rmd//bogdan_02.Rmd", "rmd//kolya_08.Rmd", "rmd//bogdan_01.Rmd",
                "rmd//dima_07.Rmd", "rmd//boris_01.Rmd"))

# files = files[15]

# every variant should go into separate folder
# for the moment n > 1 does overwrite old questions in texdir folder
# scrambling is done by sample()



set.seed(777)
files <- sample(files)

exams <- exams2nops(files, n = 1, 
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




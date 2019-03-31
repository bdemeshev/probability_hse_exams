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



# set.seed(777)
# files_shuffled <- sample(files_all)


useful = setdiff(2*(1:34), c(7, 8, 35, 36, 43, 48, 10))

files_sample = files_all[useful]


# dir.create("pdf")
# dir.create("tex")

# exams <- exams2nops(files_sample, n = 1, startid = 665 +
#                     dir = "pdf",
#                     verbose = TRUE,
#                     language = "ru",
#             texdir = "tex",
#             name = "exam_",
#             date = "2018-09-18", institution = "Высшая школа экономики",
#             logo = "",
#             encoding = "UTF-8",
#             samepage = TRUE,
#             reglength = 3, # is not working?
#             blank = 0,
#             header = "\\input{../header.tex}",
#             title = "Теория вероятностей :)")
# 
# sol <- exams_metainfo(exams)
# print(sol, 1)


# 
# exams <- exams2pdf(files_sample, n = 1,
#                     dir = "pdf",
#                     verbose = TRUE,
#                     language = "ru",
#             texdir = "tex",
#             name = "the_exam",
#             date = "2018-09-18", institution = "Higher School of Economics",
#             logo = "",
#             encoding = "UTF-8",
#             samepage = TRUE,
#             reglength = 3, # is not working?
#             blank = 0,
#             header = "\\input{../header.tex}",
#             title = "Probability theory and Statistics")
# 





exams2pdf_source = function(files_sample, n_vars = 1, add_seed = 777, 
                            pdf_dir = "pdf",
                            language = "ru",
                            tex_dir = "tex",
                            name = "the_exam",
                            date = "2018-12-28", institution = "Теория вероятностей",
                            logo = "",
                            encoding = "UTF-8",
                            samepage = TRUE,
                            reglength = 3, # is not working?
                            blank = 0,
                            header = "\\input{../header.tex}",
                            title = "С Наступающим Новым Годом :)") {
  for (var_no in 1:n_vars) {
    var_no_string = stringr::str_pad(var_no, 2, pad = "0")
    pdf_dir_no = paste0(pdf_dir, "_", var_no_string)
    dir.create(pdf_dir_no)
    tex_dir_no = paste0(tex_dir, "_", var_no_string)
    dir.create(pdf_dir_no)
    temp_dir_no = paste0("temp_", var_no_string)
    # dir.create(temp_dir_no)
    supp_dir_no = paste0("supp_", var_no_string)
    # dir.create(supp_dir_no)
    
    
    name_no = paste0(name, "_", var_no_string)
    
    set.seed(var_no + add_seed)
    files_sample = sample(files_sample)
    
    set.seed(var_no + add_seed)
    exams <- exams2nops(files_sample, n = 1, startid = var_no + add_seed,
                          dir = pdf_dir_no,
                        verbose = TRUE,
                        language = language,
                        texdir = tex_dir_no,
                        name = name,
                        date = date, institution = institution,
                        logo = "",
                        encoding = encoding,
                        samepage = samepage,
                        reglength = reglength, # is not working?
                        blank = blank,
                        header = "\\input{../header.tex}",
                        title = title)
  
  }
  return(TRUE)
}

exams2pdf_source(files_sample, n_vars = 5, title = "Теория вероятностей!", institution = "С Новым Годом :)")


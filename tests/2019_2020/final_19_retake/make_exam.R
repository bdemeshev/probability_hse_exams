# install.packages("exams", repos="http://R-Forge.R-project.org")
library(exams)

Sys.which("latexmk") # check whether latex is present and specify path to latexmk
latex_executable <- Sys.which("pdflatex")
options(texi2dvi = latex_executable)

files_all <- list.files('rmd/', pattern = "*.Rmd", full.names = TRUE)
files_all
useful = 1:min(60, length(files_all))
# original exam!
# files_sample = files_all[c(1, 4, 6, 7, 10, 13, 14, 15, 19, 22, 24, 25, 28, 30, 31, 32, 34, 41, 42, 43, 44, 49, 50, 51, 52, 53, 57, 58, 36, 20)]
# retake day 1
# files_sample = files_all[c(2, 3, 5, 8, 9, 11, 12, 17, 18, 20, 21, 23, 26, 27, 29, 33, 35, 36, 37, 38, 39, 40, 46, 47, 48, 54, 55, 56, 59, 60)]
# retake day 2
files_sample = files_all[c(2, 3, 5, 8, 9, 11, 12, 17, 18, 20, 21, 23, 26, 27, 29, 33, 35, 36, 37, 42, 43, 44, 49, 50, 51, 52, 53, 57, 58, 36)]


files_sample
length(files_sample)

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
                            title = "С Наступающим Новым Годом :)", 
                            nops = TRUE, shuffle = TRUE) {
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
    
    if (shuffle) {
      set.seed(var_no + add_seed)
      files_sample = sample(files_sample)
    }
    
    set.seed(var_no + add_seed)
    if (nops) {
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
    } else {
      exams <- exams2pdf(files_sample, n = 1, 
                          dir = pdf_dir_no,
                          verbose = TRUE,
                          language = language,
                          texdir = tex_dir_no,
                          encoding = encoding,
                          template = "plain_no_sweave.tex",
                          header = "\\input{../header.tex}")
    }
      
  
  }
  return(TRUE)
}

exams2pdf_source(files_sample, date = "2019-09-27",
                 n_vars = 2, title = "Теория вероятностей!", institution = "Поехали :)", nops = TRUE, shuffle = TRUE)


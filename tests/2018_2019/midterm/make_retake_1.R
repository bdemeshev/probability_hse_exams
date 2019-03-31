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

black_list = c(7, 8, 35, 36, 43, 48, 10)

exam_questions = setdiff(2*(1:34), black_list) # even numbers not in black list
set.seed(777)
ten_old = sample(exam_questions, 10)
twenty_new = setdiff(2*(1:23) - 1, black_list) # odd numbers not in black list

retake_questions = c(ten_old, twenty_new)
files_sample = files_all[retake_questions]


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

exams2pdf_source(files_sample, n_vars = 2, 
                 title = "Теория вероятностей!", 
                 institution = "Пересдача-1",
                 date = "2019-01-21",
                 tex_dir = "tex_ret1",
                 pdf_dir = "pdf_ret1")




data_2_answers = function(filename) {
  exam_data = read_rds(filename)
  exam_vector = unlist(exam_data)
  exam_tibble = tibble(value = exam_vector, branch = names(value))
  exam_tibble = mutate(exam_tibble, n_dots = str_count(branch, pattern = "\\."))
  max_dots = max(exam_tibble$n_dots)
  exam_tibble = mutate(exam_tibble, branch = pmap_chr(list(branch, n_dots),
                                                      ~paste0(.x, rep(".", max_dots - .y), collapse = "")))
  
  exam_tibble = tidyr::separate(exam_tibble, branch, into = c("variant", "exercise", "level1", "level2"), sep = "\\.")
  exam_tibble = select(exam_tibble, -n_dots)
  
  ex_answers = filter(exam_tibble, 
                      (level1 == "metainfo") & ((level2 == "name") | (str_detect(level2, "solution")))) %>%
    select(-level1)
  
  ex_answers_wide = spread(ex_answers, level2, value)
  ex_answers_wide = mutate(ex_answers_wide, ans_letter = 
                             pmap_chr(list(solution1, solution2, solution3, solution4, solution5),
                                      ~ paste0(ifelse(..1, "a", ""), 
                                               ifelse(..2, "b", ""), 
                                               ifelse(..3, "c", ""), 
                                               ifelse(..4, "d", ""), 
                                               ifelse(..5, "e", ""), collape = "")))
  ex_answers_wide = select(ex_answers_wide, variant, exercise, name, ans_letter)
  
  return(ex_answers_wide)
}



ans_ret_v1 = data_2_answers("pdf_ret1_01/the_exam.rds")
ans_ret_v1
rio::export(ans_ret_v1, "retake_ans_01.xlsx")

ans_ret_v2 = data_2_answers("pdf_ret1_02/the_exam.rds")
ans_ret_v2
rio::export(ans_ret_v2, "retake_ans_02.xlsx")



# from files to table with answers
library(tidyverse)
library(stringr)
library(purrr)
library(tidyr)
library(rio)



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


filename1 = "~/Documents/probability_hse_exams/tests/2018_2019/midterm/pdf_01/the_exam.rds"
filename2 = "~/Documents/probability_hse_exams/tests/2018_2019/midterm/pdf_02/the_exam.rds"
filename3 = "~/Documents/probability_hse_exams/tests/2018_2019/midterm/pdf_03/the_exam.rds"
filename4 = "~/Documents/probability_hse_exams/tests/2018_2019/midterm/pdf_04/the_exam.rds"
filename5 = "~/Documents/probability_hse_exams/tests/2018_2019/midterm/pdf_05/the_exam.rds"

answers1 = data_2_answers(filename1)
answers2 = data_2_answers(filename2)
answers3 = data_2_answers(filename3)
answers4 = data_2_answers(filename4)
answers5 = data_2_answers(filename5)

true_answers = bind_rows(answers1, answers2, answers3, answers4, answers5)

true_answers = mutate(true_answers, q_no = as.numeric(str_extract(exercise, "[0-9]+$"))) %>% select(-exercise)

export(true_answers, "true_answers_v00.xlsx")

# library(glue)


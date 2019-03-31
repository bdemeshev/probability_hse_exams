library(tidyverse)
library(stringr)
library(exams)
library(reshape2)
library(googlesheets)

nops_scanned2tibble <- function(res_vector) {
  res_interim <- tibble(res = res_vector)
  
  into_names <- c('filename', 'exam_id', 'scrambling', 'n_quest', 'hz', 'stud_id', paste0('q_', 1:45))
  res_df <- separate(res_interim, res, sep = ' ', into = into_names)
  res_df
  
  res_df2 <- select(res_df, -(q_31:q_45), -hz, -scrambling, -n_quest)
  # res_df3 <- mutate(res_df2, variant = as.numeric(str_sub(exam_id, start = -1)))
  
  res_df4 <- res_df2 %>% gather(key = 'q_no', value = 'given_answer', -stud_id, -filename, -exam_id)
  res_df5 <- mutate(res_df4, q_no = as.numeric(str_sub(q_no, start = 3)))
  return(res_df5)
}

nops_list2tibble <- function(nops_list) {
  tans <- unlist(nops_list) 
  
  tans_interim <- tibble(value = tans, name = names(tans))
  
  tans_interim2 <- mutate(tans_interim, 
                          useful = str_detect(name, '.question1$') | 
                            str_detect(name, '.question$') | 
                            str_detect(name, '.questionlist') |
                            str_detect(name, '.metainfo.file') |
                            str_detect(name, '.metainfo.name') |
                            str_detect(name, '.metainfo.solution'))
  tans_interim3 <- filter(tans_interim2, useful) %>% 
    select(-useful) %>%
    mutate(q_no = as.numeric(str_match(name, 'exercise([0-9][0-9])')[, 2]),
           exam_id = str_sub(name, end = 11),
           name = str_sub(name, start = 24),
           name = ifelse(name %in% c('question', 'question1'), 'question', name))
  
  # tans_wide <- spread(tans_interim3, key = 'name', value = 'value')
  tans_wide <- dcast(data = tans_interim3, exam_id + q_no ~ name)
  ans_vars <- vars(metainfo.solution1, metainfo.solution2, metainfo.solution3, metainfo.solution4, metainfo.solution5)
  tans_wide2 <- mutate_at(as_tibble(tans_wide), ans_vars, as.logical) %>% 
    mutate_at(ans_vars, as.numeric) %>% 
    unite(col = 'solution', metainfo.solution1, metainfo.solution2, metainfo.solution3, metainfo.solution4, metainfo.solution5,
          sep = '', remove = FALSE)
  return(tans_wide2)
}

abc2bin <- function(x) {
  x <- str_to_lower(x)
  if (nchar(x[1]) == 1) {
    y <- ifelse(x == 'a', '10000',
                ifelse(x == 'b', '01000',
                       ifelse(x == 'c', '00100',
                              ifelse(x == 'd', '00010',
                                     ifelse(x == 'e', '00001', '-')))))
  } else {
    y <- ifelse(x == '10000', 'a',
                ifelse(x == '01000', 'b',
                       ifelse(x == '00100', 'c',
                              ifelse(x == '00010', 'd',
                                     ifelse(x == '00001', 'e', '-')))))
  }
  return(y)
}

force_exam_id <- function(res_vector, new_exam_id = '18061800004') {
  forced_res <- str_replace(res_vector, pattern = 'XXXXXXXXXXX', replacement = new_exam_id)
  return(forced_res)
}



res_vector_1 <- nops_scan(dir = 'var_01/', file = "scan_results_1.zip", threshold = c(0.04, 0.42))
res_vector_2 <- nops_scan(dir = 'var_02/', file = "scan_results_2.zip", threshold = c(0.04, 0.42))
res_vector_3 <- nops_scan(dir = 'var_03/', file = "scan_results_3.zip", threshold = c(0.04, 0.42))
res_vector_4 <- nops_scan(dir = 'var_04/', file = "scan_results_4.zip", threshold = c(0.04, 0.42))
res_vector <- c(res_vector_1, res_vector_2, res_vector_3, res_vector_4)
# res_vector <- force_exam_id(res_vector, new_exam_id = '18061800004')
answers <- nops_scanned2tibble(res_vector)
table(answers$given_answer)


res_vector = nops_scan(dir = "~/Downloads/decemb/", file = "arch_test.zip", threshold = c(0.04, 0.42))
answers = nops_scanned2tibble(res_vector)


ans_files <- c('nops_pdf_cpy/2017_18_pr201_final_the___4.rds', 'nops_pdf_cpy/2017_18_pr201_final_the___3.rds', 'nops_pdf_cpy/2017_18_pr201_final_the___2.rds', 'nops_pdf_cpy/2017_18_pr201_final_the___1.rds')
etalon <- NULL
for (ans_file in ans_files) {
  true_ans <- read_rds(ans_file)
  etalon_add <- nops_list2tibble(true_ans)
  etalon <- bind_rows(etalon, etalon_add)
}


glimpse(answers) 
glimpse(etalon)



grade <- left_join(answers, etalon, by = c('exam_id', 'q_no')) %>%
  mutate(correct = 1 * (solution == given_answer)) %>%
  group_by(stud_id) %>% mutate(total = sum(correct)) %>% ungroup() 
# %>% select(-(metainfo.solution1:metainfo.solution5))

grade <- mutate(grade,
                marked.cell1 = str_sub(given_answer, 1, 1),
                marked.cell2 = str_sub(given_answer, 2, 2),
                marked.cell3 = str_sub(given_answer, 3, 3),
                marked.cell4 = str_sub(given_answer, 4, 4),
                marked.cell5 = str_sub(given_answer, 5, 5))

# read data from google sheets
all_studs_gs <- gs_title('2017_18_probability_2course')
all_studs_df <- gs_read(all_studs_gs)
all_studs <- select(all_studs_df, stud_id, last_name, first_name, middle_name, group)

grade <- left_join(grade, all_studs, by = 'stud_id')


quest_difficulty <- group_by(grade, metainfo.file) %>%
  summarise(correct = sum(correct), question = first(question), metainfo.name = first(metainfo.name)) %>%
  arrange(correct)



grade_superlong <- melt(grade, 
                        id.vars = c('stud_id', 'exam_id', 'filename', 
                                    'q_no', 'metainfo.file', 'metainfo.name',
                                    'correct', 'total', 'given_answer', 'solution',
                                    'last_name', 'first_name', 'middle_name', 'group'))

grade_superlong <- arrange(grade_superlong, stud_id, q_no)

grade_sl <- select(grade_superlong, 
                   stud_id, filename, q_no, metainfo.file, metainfo.name, last_name, first_name, group, total, variable, value)

grade_wide <- dcast(grade_sl, 
                    stud_id + filename + last_name + first_name + group + total ~ q_no + variable, 
                    value.var = 'value')

grade_wide_unscrambled <- dcast(grade_sl, 
                                stud_id + filename + last_name + first_name + group + total ~ metainfo.name + variable, 
                                value.var = 'value')

glimpse(grade_wide)


# upload to google sheets
grade_gs <- gs_new('grade_long', ws_title = 'results', input = grade, trim = TRUE, verbose = TRUE)
?gs_new

grade_gs <- grade_gs %>% 
  gs_ws_new(ws_title = "question_difficulty", input = quest_difficulty, trim = TRUE, verbose = TRUE)


grade_gs <- grade_gs %>% 
  gs_ws_new(ws_title = "grade_wide", input = grade_wide, trim = TRUE, verbose = TRUE)

grade_gs <- grade_gs %>% 
  gs_ws_new(ws_title = "grade_wide_unscrambled", input = grade_wide_unscrambled, trim = TRUE, verbose = TRUE)



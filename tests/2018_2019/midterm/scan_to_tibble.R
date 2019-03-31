# scan to answers

library(tidyverse)
library(stringr)
library(exams)
library(reshape2)
library(rio)

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



num2abc = function(ans_num) {
  if (nchar(ans_num) < 5) {
    message("В ответе меньше 5 нулей или единиц")
    message(ans_num)
  }
  
  ans_letter = ""
  if (str_sub(ans_num, 1, 1) == "1") {
    ans_letter = paste0(ans_letter, "a", collapse = "")
  }
  
  if (str_sub(ans_num, 2, 2) == "1") {
    ans_letter = paste0(ans_letter, "b", collapse = "")
  }
  
  if (str_sub(ans_num, 3, 3) == "1") {
    ans_letter = paste0(ans_letter, "c", collapse = "")
  }
  
  if (str_sub(ans_num, 4, 4) == "1") {
    ans_letter = paste0(ans_letter, "d", collapse = "")
  }
  
  if (str_sub(ans_num, 5, 5) == "1") {
    ans_letter = paste0(ans_letter, "e", collapse = "")
  }
  
  return(ans_letter)   
}




res_vector_1 <- nops_scan(dir = 'var_01/', file = "scan_1.zip", threshold = c(0.04, 0.42))
answers_1 <- nops_scanned2tibble(res_vector_1)
answers_1 = mutate(answers_1, exam_id = "18122800778")
s1 = mutate(answers_1, ans_letter = map_chr(given_answer, ~num2abc(.))) %>% select(-given_answer)

s1 = mutate(s1, stud_id = ifelse(filename == "165830.png", "0000125", stud_id))
s1 = mutate(s1, stud_id = ifelse(filename == "170244.png", "0000224", stud_id))
s1 = mutate(s1, stud_id = ifelse(filename == "170928.png", "0000347", stud_id))


export(s1, "stud_answers_778.xlsx")


res_vector_4 <- nops_scan(dir = 'var_04/', file = "scan_4.zip", threshold = c(0.04, 0.42))
answers_4 <- nops_scanned2tibble(res_vector_4)
answers_4 = mutate(answers_4, exam_id = "18122800781")
s4 = mutate(answers_4, ans_letter = map_chr(given_answer, ~num2abc(.))) %>% select(-given_answer)

s4 = mutate(s4, stud_id = ifelse(filename == "171540.png", "0000356", stud_id))
s4 = mutate(s4, stud_id = ifelse(filename == "171601.png", "0000184", stud_id))
s4 = mutate(s4, stud_id = ifelse(filename == "171612.png", "0000339", stud_id))
s4 = mutate(s4, stud_id = ifelse(filename == "171830.png", "0000118", stud_id))
s4 = mutate(s4, stud_id = ifelse(filename == "172548.png", "0000367", stud_id))
s4 = mutate(s4, stud_id = ifelse(filename == "172620.png", "0000329", stud_id))
s4 = mutate(s4, stud_id = ifelse(filename == "171809.png", "0000200", stud_id))

filter(s4, stud_id == "4021300")
filter(s4, stud_id == "0000000")


export(s4, "stud_answers_781_part_1.xlsx")


res_vector_4b <- nops_scan(dir = 'var_04_part_2/', file = "scan_4.zip", threshold = c(0.04, 0.42))
answers_4b <- nops_scanned2tibble(res_vector_4b)
answers_4b = mutate(answers_4b, exam_id = "18122800781")
answers_4b = mutate(answers_4b, stud_id = ifelse(is.na(stud_id), "0000163", stud_id)) %>% arrange(stud_id)

vector = c("d", "d", "a", "d", "e", "e", "a", "a", "b", "c", "c", "d", "a", "b", "a",
           "e", "b", "b", "b", "e", "b", "b", "e", "c", "c", "e", "c", "a", "d", "b")

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

answers_4b$given_answer[1:30] = abc2bin(vector)
s4b = mutate(answers_4b, ans_letter = map_chr(given_answer, ~num2abc(.))) %>% select(-given_answer)


export(s4b, "stud_answers_781_part_2.xlsx")





res_vector_5 <- nops_scan(dir = 'var_05/', file = "scan_5.zip", threshold = c(0.04, 0.42))
answers_5 <- nops_scanned2tibble(res_vector_5)
answers_5 = mutate(answers_5, exam_id = "18122800782")
answers_5 = na.omit(answers_5)
s5a = mutate(answers_5, ans_letter = map_chr(given_answer, ~num2abc(.))) %>% select(-given_answer)


s5a = mutate(s5a, stud_id = ifelse(filename == "180658.png", "0000337", stud_id))
s5a = mutate(s5a, stud_id = ifelse(filename == "180709.png", "0000253", stud_id))
s5a = mutate(s5a, stud_id = ifelse(filename == "181001.png", "0000300", stud_id))
s5a = mutate(s5a, stud_id = ifelse(filename == "181539.png", "0000280", stud_id))
s5a = mutate(s5a, stud_id = ifelse(filename == "181625.png", "0000176", stud_id))
s5a = mutate(s5a, stud_id = ifelse(filename == "181958.png", "0000325", stud_id))
s5a = mutate(s5a, stud_id = ifelse(filename == "182009.png", "0000326", stud_id))

export(s5a, "stud_answers_782_part_1.xlsx")





res_vector_2 <- nops_scan(dir = 'var_02/', file = "scan_1.zip", threshold = c(0.04, 0.42))
answers_2 <- nops_scanned2tibble(res_vector_2)
answers_2 = mutate(answers_2, exam_id = "18122800779")
s2 = na.omit(answers_2)

s2 = mutate(s2, ans_letter = map_chr(given_answer, ~num2abc(.))) %>% select(-given_answer)


s2 = mutate(s2, stud_id = ifelse(filename == "163938.png", "0000247", stud_id))
s2 = mutate(s2, stud_id = ifelse(filename == "164107.png", "0000301", stud_id))
s2 = mutate(s2, stud_id = ifelse(filename == "164422.png", "0000317", stud_id))
s2 = mutate(s2, stud_id = ifelse(filename == "164632.png", "0000302", stud_id))
s2 = mutate(s2, stud_id = ifelse(filename == "170242.png", "0000298", stud_id))
s2 = mutate(s2, stud_id = ifelse(filename == "170350.png", "0000415", stud_id))
s2 = mutate(s2, stud_id = ifelse(filename == "170411.png", "0000420", stud_id))
s2 = mutate(s2, stud_id = ifelse(filename == "170453.png", "0000136", stud_id))
s2 = mutate(s2, stud_id = ifelse(filename == "164747.png", "0000207", stud_id))

export(s2, "stud_answers_779.xlsx")






res_vector_3 <- nops_scan(dir = 'var_03/', file = "scan_1.zip", threshold = c(0.04, 0.42))
answers_3 <- nops_scanned2tibble(res_vector_3)
answers_3 = mutate(answers_3, exam_id = "18122800780")
s3 = na.omit(answers_3)
s3 = mutate(s3, ans_letter = map_chr(given_answer, ~num2abc(.))) %>% select(-given_answer)

s3 = mutate(s3, stud_id = ifelse(filename == "173520.png", "0000373", stud_id))
s3 = mutate(s3, stud_id = ifelse(filename == "174149.png", "0000409", stud_id))
s3 = mutate(s3, stud_id = ifelse(filename == "174356.png", "0000111", stud_id))


export(s3, "stud_answers_780.xlsx")











# stud_answers = bind_rows(answers_1, answers_2, answers_3, answers_4, answers_5)

# stud_answers = mutate(stud_answers, ans_letter = map_chr(given_answer, ~num2abc(.))) %>% select(-given_answer)

# export(stud_answers, "stud_answers_v00.xlsx")


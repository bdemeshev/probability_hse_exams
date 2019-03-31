# grade!
library(tidyverse)
library(stringr)
library(rio)

letter_in = function(stud_ans, true_ans) {
  if (stud_ans == "") {
    return(0)
  }
  at_least_one_correct = 0
  no_uncorrect = 1
  for (i in 1:nchar(stud_ans)) {
    if (str_detect(true_ans, str_sub(stud_ans, i, i))) {
      at_least_one_correct = 1
    } else {
      no_uncorrect = 0
    }
  }
  return(at_least_one_correct * no_uncorrect)
}

letter_in("", "abd")
letter_in("ba", "abd")


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

num2abc("10100")
num2abc("")
num2abc("10")



s78 = import("stud_answers_778.xlsx")
s79 = import("stud_answers_779.xlsx")
s80 = import("stud_answers_780.xlsx")
s81a = import("stud_answers_781_part_1.xlsx")
s81b = import("stud_answers_781_part_2.xlsx")
s82 = import("stud_answers_782_part_1.xlsx")
s_manual = import("stud_answers_manual.xlsx") %>% mutate(exam_id = as.character(exam_id))

s_all = bind_rows(s78, s79, s80, s81a, s81b, s82, s_manual)

s_all

true_ans = import("true_answers_v00.xlsx")  %>% rename(exam_id = variant, true_ans = ans_letter)

s_all = left_join(s_all, true_ans, by = c("exam_id", "q_no"))

export(s_all, "s_all.xlsx")



s_corr = import("points_v02.xlsx", sheet = 2)
glimpse(s_corr)

s_corr = mutate(s_corr, ans_letter = ifelse(is.na(ans_letter), "", ans_letter))
s_corr = mutate(s_corr, exam_id = ifelse(stud_id == 183, 18122800780, exam_id))
glimpse(s_corr)
s_corr = mutate(s_corr, point = pmap_dbl(list(ans_letter, true_ans), ~letter_in(.x, .y)))

s_corr2 = s_corr %>% group_by(stud_id, exam_id) %>% summarise(sum_point = sum(point), n_obs = n())

s_corr2 %>% filter(n_obs != 30)


qplot(data = s_corr2, x = sum_point)

export(s_corr2, "results_v02.xlsx")






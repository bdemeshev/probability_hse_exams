library(tidyverse)
a = list()
a[[1]] = read_rds("pdf_01/the_exam.rds")
a[[2]] = read_rds("pdf_02/the_exam.rds")
a[[3]] = read_rds("pdf_03/the_exam.rds")
a[[4]] = read_rds("pdf_04/the_exam.rds")

b = a[[1]][[1]]
bv = as.vector(b)

letters = c("A", "B", "C", "D", "E", "F")

etalon2 = mutate(etalon, letter = case_when(solution == "10000" ~ "A",
                                            solution == "01000" ~ "B",
                                            solution == "00100" ~ "C",
                                            solution == "00010" ~ "D",
                                            solution == "00001" ~ "E",
                                            solution == "00000" ~ "F"))

etalon2
etalon3 = select(etalon2, exam_id, q_no, metainfo.file, solution, letter)

getwd()
etalon4 = mutate(etalon3, var = rep(c("mu", "kappa", "delta", "rho"), each = 30))
etalon4
write_csv(etalon4, "answ.csv")

etalon4 %>% filter(exam_id == "19061800778") %>% pull(letter) %>% paste0(collapse = "")

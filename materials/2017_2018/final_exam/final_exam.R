library(exams)

files <- c("questions/boris_01.Rmd")
tex_location <- "/usr/local/texlive/2018/bin/x86_64-linux/"

files <- list.files("questions/", full.names = TRUE)

options(texi2dvi = "emulation")

set.seed(42)
exams2pdf(files, nsamp = 1, dir = ".", verbose = TRUE, 
          texdir = ".",
          template = c("templates/exam_rus_babel.tex"))

exams2html(files, nsamp = 1, dir = ".", verbose = TRUE)

make_nops_template(30, nchoice = 5, file = "templates/nops_template.tex")


for (id in 1:4) {
set.seed(id)
files <- sample(files)
set.seed(id)
exams2nops2(files, n = 1, nsamp = 1, dir = "nops_pdf_v", verbose = TRUE, language = "ru",
           texdir = ".", name = paste0("2017_18_pr201_final_the___", id),
           date = "2018-06-18", institution = "Higher School of Economics",
           logo = "",
           encoding = "UTF-8",
           samepage = TRUE, 
           reglengh = 3,
           startid = id,
           blank = 0,
           title = "Probability theory and Statistics")
}


res_vector <- nops_scan(dir = 'scan_2/', file = "scan_results.zip")
res_vector

#
# exams_skeleton(dir = ".",
#    writer = c("exams2arsnova", "exams2pdf", "exams2moodle"),
#    markup = c("markdown"), 
#    type = c("num", "schoice", "mchoice"))
# ?exams_skeleton

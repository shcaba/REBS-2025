library(here)
library(dplyr)
library(asar)

alt_text_to_csv <- function(input, output_file){
  
  ##Read input
  #browser()
  input_rename <- here("Document","report", paste0(input, ".qmd"))
  
  read_input <- lapply(input_rename, function(x) {
    readLines(x)
  })
  
  
  ##Extract lines
  
  #Extract the alt text labels in each file that are not commented out
  lab_lines <- lapply(read_input, function(x) {
    x[grepl("label:", x) & !grepl("<!--", x) & !grepl("tbl", x)]
  })
  
  #Extract the alt text captions in each file that are not commented out
  cap_lines <- lapply(read_input, function(x) {
    x[grepl("fig-alt", x) & !grepl("<!--", x)]
  })
  
  #Check to ensure caption and label lists are the same length
  if(!identical(lengths(lab_lines), lengths(cap_lines))) {
    warning(paste("Label and captions list are of unequal length. Check file(s): \n",
                  paste(input_files[which(lengths(lab_lines) != lengths(cap_lines))], collapse = "\n "))
    )
  }
  
  
  ##Extract parts of the lines that are needed
  labs <- lapply(lab_lines, function(x) {
    sub(".*fig-", "", x) #everything after the 'fig-'
  })
  caps <- lapply(cap_lines, function(x) {
    sub(".*:[^\\]{2}", "", x) %>%
      sub("(.{1})$", "", .)
    #everything after the colon '.*:', and then 
    #remove the first two character other than the '\' [^\\]{2}. 
    #Then from that remove the last character '(.{1})$'
  })
  
  
  ##Save the file as a csv
  out <- data.frame("label" = unlist(labs), 
                    #"type" = "figure",
                    "alt_text" = unlist(caps))
  file_name <- here("Document","report", paste0(output_name, ".csv"))
  
  write.csv(out, file = file_name, row.names = F)
  writeLines(paste("Alt text saved to file:\n", file_name))
  
  return(out)
  
}

input_files <- c("01_executive_summary",
                 "09_figures")
output_name <- "captions_alt_text"

alt_text_to_csv(input_files, output_name)


#####

asar::add_accessibility(x="SAR_USWC_Rougheye_and_Blackspotted_Rockfishes_skeleton.tex",
                  dir="C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report",
                  alttext_csv ="C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/captions_alt_text.csv",
                  rename="SAR_USWC_Rougheye_and_Blackspotted_Rockfishes_skeleton_access")


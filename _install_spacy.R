library(reticulate)
library(cleanNLP)

reticulate::use_python("/opt/homebrew/bin/python3")
cleanNLP::cnlp_download_spacy("en_core_web_sm")
cleanNLP::cnlp_init_spacy("en_core_web_sm")

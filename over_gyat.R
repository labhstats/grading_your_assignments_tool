

over_gyat = function(assignment_path,
                     fasit_path,
                     start_page = 2,
                     end_page = 6,
                     ##
                     read_llm = "qwen-3-vl:8b",
                     eval_llm = "ministral-3:8b",
                     ##
                     use_context = 20000,
                     use_temp = 0.5,
                     in_fun_model = ollama_chat, #For different API calls via tidyllm, i.e. function as input
                     use_ollama_server = "http://localhost:11434"){
  
  
  require(tidyllm)
  require(pdftools)
  
  ##
  # Dump (relevant?) text for LLMs to use...
  
  assignment_fasit_list = vector(mode = "list",length = (end_page - start_page) + 1)
  
  out_iter_list = 1
  for(i in start_page:end_page){
    
    page_number = i
    
    assignment_text <- pdf_text(assignment_path)[page_number] #ChatGPT suggestion extended.
    fasit_text <- pdf_text(fasit_path)[page_number]
    
    assignment_fasit_list[[out_iter_list]] = c(assignment_text,
                                               fasit_text)
    
    out_iter_list = out_iter_list + 1
    
  }
  
  ##
  # Eval assigment vs fasit:
  
  out_llm_messages = lapply(assignment_fasit_list, function(x){
    
    print("---")
    print(Sys.time())
    
    use_molded_text = paste("Du er en vurderingsassistent. Basert på følgende besvarelse på en oppgave:\n\n",
                            "{{",x[1],"}}\n\n",
                            "Og følgende fasit / kriterier:\n\n {{",x[2],"}}\n\n",
                            "Gjør følgende: 1. Gi en kort, saklig vurdering opp mot fasit.\n\n",
                            " 2. Avgi deretter en endelig beslutning: 'godkjent' eller 'underkjent'.\n",
                            "Svar KUN i gyldig JSON med denne strukturen:\n",
                            "{vurdering: <kort begrunnelse for vurderingen>,resultat: godkjent | underkjent}"
                            )
    
    out_single_chat <- llm_message(.llm = use_molded_text) |>
      in_fun_model(.model = eval_llm,
                   .num_ctx = use_context,
                   .temperature = use_temp,
                   .ollama_server = use_ollama_server)
    
    print(Sys.time())
    
    return(out_single_chat)
    
  })
  
  
  return(out_llm_messages)
  
}


# pdf_path <- "exs/assignment_example.pdf"
# pdf_path <- "exs/fasit_example.pdf"
# 
# page_number <- 3
# 
# page_text <- pdf_text(pdf_path)[page_number]
# 
# cat(page_text)




























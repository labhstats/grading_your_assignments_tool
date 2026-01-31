
summativ_eval = function(in_text,
                         eval_llm = "ministral-3:8b",
                         ##
                         use_context = 20000,
                         use_temp = 0.5,
                         in_fun_model = ollama_chat, #For different API calls via tidyllm, i.e. function as input
                         use_ollama_server = "http://localhost:11434"){
  
  print("---")
  print(Sys.time())
  
  prompt_use = "Svar kun med ett av disse ordene, uten tegn eller forklaring: godkjent underkjent"
  
  require(tidyllm)
  
  use_molded_text = paste(prompt_use,get_reply(in_text))
  
  out_single_chat <- llm_message(.llm = use_molded_text) |>
    in_fun_model(.model = eval_llm,
                 .num_ctx = use_context,
                 .temperature = use_temp,
                 .ollama_server = use_ollama_server)
  
  print(Sys.time())
  
  return(out_single_chat)
  
}


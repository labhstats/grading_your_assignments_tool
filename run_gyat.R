
source("over_gyat.R")

out_example = over_gyat(assignment_path = "exs/assignment_example.pdf",
                        fasit_path = "exs/fasit_example.pdf",
                        start_page = 2,
                        end_page = 6,
                        ##
                        read_llm = "qwen-3-vl:8b",
                        eval_llm = "ministral-3:8b",
                        ##
                        use_context = 20000,
                        use_temp = 0.5,
                        in_fun_model = ollama_chat, #For different API calls via tidyllm, i.e. function as input
                        use_ollama_server = use_server)


source("summativ_eval.R")

summ_out_example = lapply(X = out_example, function(x){
  summativ_eval(in_text = x,
                eval_llm = "ministral-3:3b",
                ##
                use_context = 20000,
                use_temp = 0.5,
                in_fun_model = ollama_chat, #For different API calls via tidyllm, i.e. function as input
                use_ollama_server = use_server)
  })

lapply(summ_out_example,get_reply)

module RepeatTasksDemo

using Oxygen

const iterations = Ref{Int}(0)

get("/one") do 
    iterations[] += 1
end

get("/two") do 
    iterations[] += 2
end

serve(metrics = true)

end
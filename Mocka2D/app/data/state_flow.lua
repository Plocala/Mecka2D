-- app/src/data/state_flow.lua
return {
     configure = function(flow)
         flow:add_transition("menu_open", "gameplay", "menu")
         flow:configure_state("pause", { keep_previous = true })
     end
}
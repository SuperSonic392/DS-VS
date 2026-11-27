-- todo: implement this guy (oh god that's gonna be hell HOW WILL THE PATHING WORK!?)


---@param obj Object
function bhv_unchained_chomp_init(obj)

end

---@param obj Object
function bhv_unchained_chomp_loop(obj)

end

id_bhvUnchainedChomp = hook_behavior(nil, OBJ_LIST_LEVEL, true, bhv_unchained_chomp_init, bhv_unchained_chomp_loop, "bhvUnchainedChomp")
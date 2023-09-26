pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- over the garden wall
-- made by pepperoni-jabroni
-- configs, state vars & core fns
local walkable=split("43,110,158,185,106,190,191,202,203,205,207,222,223,238,239,240,241,242,244,245,246,247,248,249")
local altsset={}
local inv_items=(function()
  local items={}
  for i in all(split('255,candy,g#214,bird art,g#252,pumpkin shoe,g;w#253,shovel,g;w;b#254,old cat,g;k;y#126,instruments,g', '#')) do
    local idata=split(i)
    add(items,{spridx=idata[1],name=idata[2],charids=split(idata[3],';')})
  end
  return items
end)()
local is_on_trans_loc,repeatedmusic=false
local act_item=nil
local act_useitem=nil
local act_wrld_items={}
local act_x=0
local act_y=0
local act_charid=nil
local act_lookingdir=nil
local act_fliph=false
local act_text_dialog,act_text_maptitle,act_text_charsel={}
local act_stagetype="boot"
local act_dialogspeakidx,numticks=1,0
local ismusicdlg,act_mapsid=true
local edelwood_sels,rockfact_sels={},{}
local party,characters={},{}
local darkanims={}
local compltdlgs,wheatcount,pumpkincount,digcount,oldcats,catscollected={},0,0,0,0,0
local npcs,complete_trigs={},{}
local triggers,maplocking={
  function() return player_location_match"woods1,right_of,8" end,
  function() queue_dialog_by_idx'5' end,
  function() return player_use_item(1,'woods1') and (act_x!=8 or act_y!=8) end,
  function() end,
  function() return player_use_item(1,'woods1',13,7)end,
  function() queue_dialog_by_idx'18' end,
  function() return player_use_item(1,'woods2')end,
  function() end,
  function() return player_sel_location(5,7,'woods2')end,
  function()
    queue_dialog_by_idx'3'
    do_edelwood_select()
   end,
  function() return playmap_npc_visible'woods2,m'end,
  function() queue_dialog_by_idx'4'end,
  function() return dialog_is_complete'4'end,
  function() queue_move_npcs'm,15|0|7|7' end,
  function() return #party==2 and player_location_match'woods3,below,13' end,
  function() queue_dialog_by_idx'7' end,
  function() return player_sel_location(7,10,'woods3')end,
  function() queue_dialog_by_idx'8'end,
  function() return dialog_is_complete'8'end,
  function() add_npcs(join_all{'b',act_mapsid,7,10},true) end,
  function() return playmap_npc_visible'millandriver,m' end,
  function() queue_dialog_by_idx'9' end,
  function() return dialog_is_complete'9' end,
  function() queue_move_npcs'm,7|3|7|11' end,
  function() return act_mapsid=='mill' and #party==2 and get_npc_by_charid('m').mapid=='mill' end,
  function()
    act_item=nil 
    queue_move_npcs'm,7|4'
    remove_charids_in_party'k'
    local k=get_npc_by_charid'k'
    k.mapid,k.x,k.y='millandriver',13,9
    get_map_by_id('millandriver').discvrdtiles={}
    add_npcs'?,millandriver,12,10'
    queue_dialog_by_idx'16'
    add_world_item'214,mill,2,12'
  end,
  function() return playmap_npc_visible'millandriver,?' end,
  function()
    queue_dialog_by_idx'12'
    local dt = get_map_by_id(act_mapsid).discvrdtiles
    add(dt, '12|11')
    add(dt, '13|10')
    add(dt, '13|11')
  end,
  function() return act_mapsid=='home' end,
  function() queue_dialog_by_idx'10' end,
  function() return playmap_npc_visible'woods1,t' end,
  function() queue_dialog_by_idx'11' end,
  function() return dialog_is_complete'12' end,
  function()
    get_npc_by_charid('?').intent = 'chase_candy_and_player'
    transfer_npc_to_party'k'
   end,
  function() 
     local beast=get_npc_by_charid('?')
     return player_location_match'mill,above,0' and beast!=nil and beast.mapid=='mill'
   end,
  function()
    transfer_npc_to_party'w'
    get_map_by_id('mill').playmapspr=124
    queue_dialog_by_idx'20'
   end,
  function() return player_location_match'woods1,left_of,1' end,
  function() queue_dialog_by_idx'14' end,
  function() return player_location_match'mill,left_of,7' end,
  function() queue_dialog_by_idx'13' end,
  function() return player_sel_location(2,12,'mill') end,
  function()
    equip_item'2'
    remove_world_items'214'
    queue_dialog_by_idx'17'
   end,
  function() return dialog_is_complete'19' end,
  function() 
    equip_item'1'
    remove_charids_in_party'w'
    queue_move_npcs'w,2|9'
   end,
  function() 
     local beast=get_npc_by_charid'?'
     return player_sel_location(1,4,'mill') and beast!=nil and beast.mapid=='mill'
   end,
  function()
     transition_to_map('millandriver',7,4)
     del(npcs,get_npc_by_charid'?')
     del(npcs,get_npc_by_charid'm')
     add_npcs'd,millandriver,5,4|t,millandriver,5,5|m,millandriver,6,5'
     queue_dialog_by_idx'22'
     queue_achievement_text'you completed act 1!'
     act_item=nil
   end,
  function() return act_mapsid=='woods3' end,
  function() end,
  function() 
    local m=get_map_by_id(act_mapsid)
    return act_mapsid=='woods3' and mget(m.cellx+act_x,m.celly+act_y)==158
   end,
  function() 
    queue_dialog_by_idx'23'
    equip_item'3'
   end,
  function() 
     local m=get_map_by_id'home'
     return act_mapsid=='pottsfield' and distance(m.playmaplocx,m.playmaplocy)<3
   end,
  function() queue_dialog_by_idx'24' end,
  function() return playmap_npc_visible'barn,o' end,
  function() queue_dialog_by_idx'25' end,
  function() return playmap_npc_visible'barn,e' end,
  function() 
    queue_dialog_by_idx'26' 
    act_item=nil
    queue_move_npcs'e,7|13|7|5,o,7|13|6|5,o,7|13|5|6,o,7|13|7|7,i,7|13|9|5,i,7|13|10|6'
  end,
  function() return player_sel_spr('pottsfield',174) and enoch_in_pottsfield() end,
  function() 
    replace_player_sel'190'
    wheatcount+=1
    if (wheatcount<5)del(complete_trigs,29)
    maybe_queue_collect_text()
  end,
  function() return player_sel_spr('pottsfield',158) and enoch_in_pottsfield() end,
  function() 
    replace_player_sel'190'
    pumpkincount+=1
    if (pumpkincount<5)del(complete_trigs,30)
    maybe_queue_collect_text()
  end,
  function() return enoch_in_pottsfield() and act_mapsid=='pottsfield' end,
  function() queue_dialog_by_idx'27' end,
  function() return digcount==4 end,
  function() 
    act_item=nil
    queue_dialog_by_idx'44'
    queue_move_npcs'o,8|10'
  end,
  function() return player_location_match'school,below,13' end,
  function() 
    queue_dialog_by_idx'29'
    remove_charids_in_party'w,b'
    transfer_npc_to_party'y'
    queue_move_npcs'w,5|11,b,4|11'
  end,
  function() return act_mapsid=='grounds' and #party==2 end,
  function() queue_dialog_by_idx'30' end,
  function() 
    if (not trigger_is_complete'34') return false
    local closest,clostdist=nearest_old_cat()
    return closest==nil
  end,
  function() 
    oldcats+=1
    local x,y=0,0
    while not is_loc_available('grounds',x,y,nil) do 
      x,y=flr(rnd'16'),flr(rnd'16')
    end
    add_world_item(join_all{'254','grounds',x,y})
    if(oldcats<2) del(complete_trigs,35)
  end,
  function() 
    local closest,clostdist=nearest_old_cat()
    return closest != nil
  end,
  function()
    local closest,clostdist=nearest_old_cat()
    if (closest.cldwn==15) then
      closest.x,closest.y=get_available_loc('grounds',closest.x,closest.y)
      closest.cldwn=0
    end
    closest.cldwn+=1
    del(complete_trigs,36)
  end,
  function() 
    local closest,clostdist=nearest_old_cat()
    return clostdist==0
  end,
  function()
    local closest,clostdist=nearest_old_cat()
    catscollected+=1
    if catscollected<2 then
      queue_dialog_by_txt'haha yeah we got one!'
      equip_item'5'
      del(complete_trigs,37)
    else
      queue_dialog_by_idx'31'
      local qx,qy=get_available_loc(act_mapsid,act_x,act_y)
      add_npcs(join_all{'l',act_mapsid,qx,qy})
      get_npc_by_charid('l').intent = 'chase_candy_and_player'
    end
    del(act_wrld_items,closest)
  end,
  function() return catscollected>1 and act_mapsid=='school' end,
  function() 
    queue_dialog_by_idx'32'
    del(npcs,get_npc_by_charid'l')
    act_item=nil
    remove_charids_in_party'y,k'
    queue_move_npcs'r,3|5,w,6|5,b,8|5,u,6|2,c,7|2,y,12|5,k,5|5'
  end,
  function() return trigger_is_complete'38' and player_location_match'school,below,6' end,
  function() queue_dialog_by_idx'33' end,
  function() 
    local r=get_npc_by_charid'r'
    return trigger_is_complete'39' and distance(r.x,r.y) <= 1
  end,
  function() queue_dialog_by_idx'34' end,
  function() return dialog_is_complete'34' end,
  function() 
    queue_dialog_by_idx'35'
    set_repeat_music'17'
    ismusicdlg=true
  end,
  function() return dialog_is_complete'35' end,
  function() 
    queue_dialog_by_idx'36'
    add_world_item'126,school,6,2'
    add_world_item'126,school,7,2'
    add_world_item'126,school,6,5'
    add_world_item'126,school,12,5'
  end,
  function() return dialog_is_complete'36' end,
  function() 
    queue_dialog_by_idx'37'
    add_npcs'C,school,7,6'
    queue_move_npcs'C,7|14|11|4,r,7|9'
    set_repeat_music'-1'
    remove_world_items'126'
    add_world_item'126,grounds,10,4'
    ismusicdlg=false
  end,
  function() 
    local l=get_npc_by_charid'C'
    return l!=nil and l.mapid=='grounds' end,
  function() queue_dialog_by_idx'38' end,
  function() 
    local l=get_npc_by_charid'C'
    return l!=nil and l.intent==nil and playmap_npc_visible'grounds,C' end,
  function() queue_dialog_by_idx'39' end,
  function() return dialog_is_complete'39' end,
  function() 
    queue_dialog_by_idx'40'
    get_npc_by_charid('C').flipv=true
  end,
  function() return trigger_is_complete'46' and player_sel_location(10,4,'grounds') end,
  function() 
    equip_item'6'
    queue_dialog_by_txt'i got em!'
    queue_sys_text'head back to school'
    remove_world_items'126'
  end,
  function() return act_item==6 and act_mapsid=='school' end,
  function() 
    act_item=nil
    queue_dialog_by_idx'41'
    queue_move_npcs'r,7|14|13|10,c,7|14|12|9,u,7|14|11|9,y,7|14|10|10,C,11|11'
    get_npc_by_charid('C').flipv=false
    transfer_npc_to_party'k'
    transfer_npc_to_party'w'
    transfer_npc_to_party'b'
  end,
  function() return trigger_is_complete'48' and player_location_match'grounds,above,0' end,
  function() 
    add_npcs'l,grounds,0,7'
    get_npc_by_charid('l').intent = 'chase_candy_and_player'
    queue_dialog_by_idx'2'
  end,
  function() 
    local n=get_npc_by_charid'l'
    return trigger_is_complete'49' and distance(n.x,n.y)<1
  end,
  function() 
    queue_dialog_by_idx'42'
    local l,r=get_npc_by_charid'l',get_npc_by_charid'r'
    add_npcs(join_all{'j,grounds',l.x,l.y-1})
    set_walk_intent(get_npc_by_charid'j','13|11')
    del(npcs,l)
  end,
  function() 
    local j=get_npc_by_charid'j'
    return j!=nil and j.x==13 and j.y==11 and distance(j.x,j.y)<3
  end,
  function() 
    add_world_item'126,grounds,12,9'
    add_world_item'126,grounds,11,9'
    add_world_item'126,grounds,10,10'
    queue_dialog_by_idx'43'
    set_repeat_music'17'
    queue_achievement_text'you completed act 3!'
  end,
  function() return act_mapsid=='secret' end,
  function() 
    queue_achievement_text'you found the secret room!'
    queue_dialog_by_idx'6'
    local i=1
    for c in all(characters) do 
      if c.mapspridx!='' then 
        add_world_item(join_all{c.mapspridx,'secret',((i*2+1)%10)+3,ceil(i/5)*2+1}) 
        i+=1
      end
    end
  end,
  function() 
    local o=get_npc_by_charid'o'
    return join_all{o.mapid,o.x,o.y} == 'pottsfield,8,10' end,
  function() 
    queue_dialog_by_idx'45'
    local s=get_npc_by_charid's'
    add_npcs(join_all{'p,pottsfield',s.x,s.y})
    queue_achievement_text'you completed act 2!'
    del(npcs,s)
  end,
  function() return player_location_match'woods5,left_of,1' end,
  function() 
    queue_dialog_by_txt'the road ends here for now'
    queue_sys_text'thanks for playing!'
  end,
  function() return trigger_is_complete'54' and #act_text_dialog==0 end,
  function() 
    act_stagetype='endgame'
  end
},split('|woods1,leave a trail of candy|woods1,give the turtle a candy|woods2,leave a trail of candy|woods2,inspect the strange tree|woods2,meet someone new|||woods3,search the bushes||millandriver,talk with the woodsman||millandriver,enter the mill|millandriver,find the frog!|pottsfield,visit the home|woods1,spot the turtle||millandriver,run back to your brother!|||mill,find a club|mill,use the club!|mill,jump the window to escape!,14||woods3,acquire new shoes||pottsfield,meet the residents|barn,meet the host|pottsfield,collect wheat,28|pottsfield,collect pumpkin,28|pottsfield,carry out your sentence|pottsfield,dig at the flower,31|school,start the lesson|grounds,go play outside,33|grounds,play 2 old cat,34|||school,run back to school!,37|school,have lunch,38|school,talk to the teacher,39|||||grounds,explore outside||grounds,grab the instruments!,46|school,talk with ms langtree,47|grounds,visit the school|grounds,head to the plaza,48|||||', '|')
local menuchars,achievs={},{}
local stagefns={
  function()update_boot()end,
  function()draw_boot()end,
  function()update_scene()end,
  function()draw_scene()end,
  function()update_main_menu()end,
  function()draw_main_menu()end,
  function()update_controls()end,
  function()draw_controls()end,
  function()update_intro()end,
  function()draw_introduction()end,
  function()update_play_map()end,
  function()draw_play_map()end,
  function()end,
  function()draw_end_game()end
}
local frog_names=split'kitty,wirt,wirt jr.,george washington,mr. president,benjamin franklin,doctor cucumber,greg jr.,skipper,ronald,jason funderburker'

-- base functions
function is_element_in(array, k)
 for elem in all(array) do
  if (k == elem) return true
 end
 return false
end

function ternary(cond, op1, op2)
 if (cond) return op1
 return op2
end

characters = (function()
  local cchar={}
  for c in all(split('g;greg;0;2;where is that frog o\' mine!|wanna hear a rock fact?#w;wirt;1;4;uh, hi...|oh sorry, just thinking#b;beatrice;16;6;yes, i can talk...|lets get out of here!#k;;17;8;ribbit#a;the beast;32;34#m;the woodsman;33;36;i need more oil|beware these woods#?;the beast?;48;38;*glares at you*;2#d;dog;49;40;*barks*#t;black turtle;64;66;*stares blankly*#z;turkey;65;68;gobble. gobble. gobble.#o;pottsfield citizen 1;80;98;you\'re too early#i;pottsfield citizen 2;80;102;are you new here?#s;skeleton;81;70;thanks for digging me up!#p;partier;96;100;let\'s celebrate!#e;enoch;97;72;you don\'t look like you belong here;2#u;dog student;10;44;humph...|huh...#l;gorilla;113;12;*roaaar*!#j;jimmy brown;11;14#c;cat student;26;46;humph...|huh...#r;ms langtree;112;104;oh that jimmy brown|i miss him so...#n;the lantern;;76#F;rock fact;215;78#E;edelwood;219;192#y;racoon student;27;194;humph...|huh...#A;achievement get!;;196#C;mr langtree;184;182;these poor animals', '#')) do
   local cdata = split(c, ';')
   add(cchar,{
    id=cdata[1],
    name=cdata[2], 
    mapspridx=cdata[3],
    chrsprdailogueidx=cdata[4],
    idle=split(cdata[5],'|') or {'huh?'},
    scaling=cdata[6] or 1
   })
  end
  return cchar
end)()
function get_char_by_id(id)
 for c in all(characters) do
  if (c.id==id) return c
 end
end

local darkspr = (function()
  local dsdata = split('174,204,218,219,235,236,251#2,3,4,8,9,10,11#0,0,1,1,0,1,1', '#')
  return {
   idxs=split(dsdata[1]),
   clrmp_s=split(dsdata[2]),
   clrmp_d=split(dsdata[3]),
  }
end)()

local maps=(function()
  local cmaps={}
  for m in all(split("exterior,woods1,somewhere in the unknown,0,16#exterior,woods2,somewhere in the unknown,0,0#interior,mill,the old grist mill,64,0,millandriver,226,7,2#exterior,millandriver,the mill and the river,16,0#exterior,woods3,somewhere in the unknown,32,0#interior,barn,harvest party,80,0,pottsfield,224,4,1#interior,home,pottsfield home,32,16,pottsfield,232,10,7#exterior,pottsfield,pottsfield,48,0#exterior,woods4,somewhere in the unknown,96,0,0#interior,school,schoolhouse,16,16,grounds,228,3,3#exterior,grounds,the schoolgrounds,112,0#exterior,woods5,somewhere in the unknown,64,16#interior,secret,the secret room,48,16,woods5,218,9,0", '#')) do
   local mdata = split(m)
   local entry = {
    type=mdata[1],
    id=mdata[2],
    title=mdata[3],
    cellx=mdata[4],
    celly=mdata[5]
   }
   if mdata[1] == 'interior' then
    entry.playmapid=mdata[6]
    entry.playmapspr=mdata[7]
    entry.playmaplocx=mdata[8]
    entry.playmaplocy=mdata[9]
   end
   add(cmaps, entry)
  end
  return cmaps
 end)()
function get_map_by_id(id)
 for m in all(maps) do
  if (m.id == id) return m
 end
end
function get_mapidx_by_id(id)
 for i=1,#maps do
  if (maps[i].id == id) return i
 end
end

npcs = (function()
  local cnpcs = {}
  for n in all(split('t,13,7,woods1#m,6,7,woods2#o,6,12,barn#o,7,4,barn,loop,7|4|10|7#o,7,7,barn,loop,7|4|10|7#i,10,4,barn,loop,7|4|10|7#i,10,7,barn,loop,7|4|10|7#e,8,5,barn#r,8,9,school#u,7,11,school#c,9,11,school#y,9,13,school#z,7,6,home', '#')) do
   local ns = split(n)
   local r = {charid=ns[1],x=ns[2],y=ns[3],mapid=ns[4]}
   if #ns > 4 then
    r.intent = ns[5]
    r.intentdata = ns[6]
   end
   add (cnpcs, r)
  end
  return cnpcs
end)()

local map_trans = (function()
  local cmaptrans = {}
  for m in all(split('woods1;woods2;15,5|15,4;0,14|0,15#woods2;millandriver;14,0|15,0;0,13|0,14|0,15#millandriver;woods3;0,0|1,0;13,15|14,15|15,15#millandriver;mill;7,3;8,14#woods3;pottsfield;7,0|8,0;7,15|8,15#pottsfield;barn;4,2|5,2;7,13|8,13#pottsfield;woods4;9,0|10,0;6,15|7,15#woods4;grounds;7,0|8,0;6,15|7,15#grounds;school;4,4|3,4;7,14|8,14|8,1#pottsfield;home;10,8|11,8;7,12#grounds;woods5;0,7|0,8;15,12|15,13#woods5;secret;9,0;7,14|8,14', '#')) do
   local mdata = split(m, ';')
   add(cmaptrans,{mp_one=mdata[1],mp_two=mdata[2],mp_one_locs=split(mdata[3],'|'),mp_two_locs=split(mdata[4],'|')})
  end
  return cmaptrans
end)()

local dialogs = (function()
  local cdialogs,i = {},1
  for d in all(split("k;led through the mist-k;by the milk light of moon-k;all that was lost is revealed-k;our long bygone burdens-k;mere echoes of the spring-k;but where have we come?-k;and where shall we end?-k;if dreams can't come true-k;then why not pretend?-k;how the gentle wind-k;beckons through the leaves-k;as autumn colors fall-k;dancing in a swirl-k;of golden memories-k;the loveliest lies of all+C;the instruments!-C;they've been stolen!;L+w;i dont like this at all-g;its a tree face!+w;is that some sort of deranged lunatic?-w;with an axe waiting for victims?-m;*swings axe and chops tree*;L-w;what is that strange tree?-g;we should ask him for help!-*;5+w;whoa... wait greg...;L-w;... where are we?;L-g;we\'re in the woods!;L-w;no, i mean;L-w;... where are we?!;L-g;i can leave a candy trail from my pants!-g;candytrail. candytrail. candytrail!;L-*;2+g;whoa, what is this place?-w;it looks like something-w;from a world out west!;L+b;help! help!-w;i think its coming from a bush?-*;9+b;help me!;L-g;wow, a talking bush!-b;i\'m not a talking bush! i\'m a bird!-b;and i\'m stuck!-g;wow, a talking bird!-b;if you help me get unstuck, i\'ll-b;owe you one-g;ohhhh! you'll grant me a wish?!-b;no but i can take you to...-b;adalaid, the good woman of the woods!-g;*picks up beatrice out of bush*-w;uh uh! no!+m;these woods are a dangerous place-m;for two kids to be alone-w;we... we know, sir-g;yeah! i\'ve been leaving a trail-g;of candy from my pants!-m;please come inside...;L-w;i don\'t like the look of this-k;ribbit.-g;haha, yeah!-*;13+w;oh! terribly sorry to have-w;disturbed you sir!-z;gobble. gobble. gobble.;L+g;wow, look at this turtle!-w;well thats strange-g;i bet he wants some candy!-t;*stares blankly*-*;3+?;*glares at you, panting*;L-g;you have beautiful eyes!-g;ahhhh!-*;18+w;wow this place is dingey-g;yeah! crazy axe person!-w;we should find a way to take him out-w;before he gets a chance to hurt us-g;i can handle it!-*;21+w;i dont think we should-w;go back the way we came+UNUSED+m;i work as a woodsman in these woods-n;keeping the light in this lantern lit;L-m;by processing oil of the edelwood trees-m;you boys are welcome to stay here-m;ill be in the workshop-g;okey dokey!+g;this bird art sculpture is perfect!-*;22+g;there! this little guy wanted a snack-t;*stares blankly*;L+m;ow! *falls onto ground*-g;haha yeah, i did it!-w;greg! what have you done!-w;hey greg... where did your frog go?-g;where is that frog o mine?-*;14+g;ahhh! the beast!-w;quick, greg, to the workshop!-w;we should be able to make it-w;out through a window out back!-w;leave candy to distract him!-?;*crashes through the wall*;L-*;23+UNUSED+g;we made it out!-?;*gets stuck in the window*;L-?;*spits out turtle with a candy*-m;what have you boys done?!-m;the mill is destroyed-w;but we solved your beast problem!-m;you foolish boys-m;that silly dog was not the beast-d;*bark! bark!*;L-m;he just swallowed that turtle-t;*stares blankly*;L-w;he must have followed the candy trail!-m;go now and continue your journey-w;we\'re sorry sir-m;beware the beast!;L+g;oh wow! i stepped on a pumpkin!;L-w;huh oh that's strange-w;i did too-g;haha i have a pumpkin shoe!-k;ribbit.+w;wow, greg, look!-w;a home! maybe they have a phone;L-b;oh this is just great-*;15+o;hey -o;who are you?;L-w;uh hello! we're just passing through-o;folks dont just pass through here-b;nope, i dont like this!-*;28+e;well, well, well,...-e;what do we have here?;L-b;nothing sir!-o;they trampled our crops!-i;look at their shoes!-e;for this you are sentenced-e;to...-e;a few hours of manual labour-w;oh uh okay?-e;come outside with me-*;31+e;you must collect 5 pumpkins-e;and 5 bundles of wheat-e;go now, and pay your dues!-*;29-*;30+e;now for your final act-e;you must dig a hole-e;6 feet deep, at the flower-e;take these shovels and-e;start digging-b;oh god!-*;32+r;and that children-r;is how you do addition-r;well hi there children!;L-r;please, take your seats-w;oh ok sure!-b;no wirt! ugh!-g;school? no way-g;lets go play outside-k;ribbit!-y;hmph!-*;34+g;i know, lets play 2 old cat!-g;come on lets grab the cats!-k;ribbit.-y;hmph!-*;35+g;we did it!-g;isnt 2 old cat great?-l;*roaaar!*;L-g;aaaah! run!-y;*scatters*-*;38+g;phew, we made it!-r;how i do miss that-r;*jimmy brown*-r;time for lunch children;L-w;oh, ok!-b;ugh wirt please!-g;haha yay!-*;39+g;whats the matter rac?-y;*looks sad at food*;L-g;*takes a bite*-g;kinda bland-g;i got an idea!-*;40+g;here play like this!-g;*smashes piano keys*-r;like this?-g;good enough!+g;Oh, potatoes and molasses-g;If you want some, oh, just ask us-g;They're warm and soft like puppies in socks-g;Filled with cream and candy rocks+g;Oh, potatoes and molasses-g;They're so much sweeter than-g;Algebra class-g;If you're stomach is grumblin'-g;And your mouth starts mumblin'-g;There's only only one thing to -g;keep your brain from crumblin'-g;Oh, potatoes and molasses-g;If you can't see 'em put on your glasses-g;They're shiny and large-g;like a fisherman's barge-g;You know you eat enough when-g;you start seeing stars-g;Oh, potatoes and molasses-g;It's the only thing left -g;on your task list-g;They're short and stout,-g;They'll make everyone shout-g;For potatoes and molasses-g;For potatoes and+C;thats enough!;L-C;give me those instruments-r;father!-C;this is a school-C;not a marching band;L-C;we cant be losing money-C;goodbye!-r;oh father!+r;oh the poor school!-r;who could help finance us?-r;if only that no good-r;two timin *jimmy brown* were here;L-y;*rolls eyes*;L-g;i have an idea!;L-*;45+C;oof those poor animals-C;i have no funds left;L-C;to teach them proper math-C;all i have are these instruments+C;...zzz;L-g;nows my chance!-*;47+g;here ms langtree!-g;*hands over instruments*-g;*whispers*;L-r;come children-r;to the town plaza!;L-c;*meow*!-u;*bark*!+l;*roaar*!;L-g;hya! *chops*-l;*hit on the head*-j;oh my word!;L-j;this boy saved me-r;oh *jimmy*!-j;darlin...+u;*grabs instrument*-c;*begins playing*-y;*joins with tune*-r;*passes donations*-r;my my were saved!;L-C;what excellent news!-j;oh darlin!;L-k;ribbit!-w;nice job greg;L+s;hey!;L-s;thanks for digging me up-o;hey is that frank?-i;someone hand him a pumpkin!+o;here ya go!-p;hey thanks!-p;lets party!;L-e;what a wonderful havest;L",'+')) do
   local dlg_objs = split(d, '-')
   add(cdialogs,{})
   for g in all(dlg_objs) do 
     local s=split(g,';')
     local txt=s[2]
     local tnt=tonum(txt)
     if tnt!=nil then
       txt='\f9['..split(maplocking[tnt])[2]..']'
     end
     add(cdialogs[i],{speakerid=s[1],text=txt,large=ternary(#s>2,s[3]=='L',false)})
   end
   i+=1
  end
  return cdialogs
end)()

function _init()
 poke(0x5F5C, 255)
 palt(0,false)
 -- init main menu chars
 repeat
  local choice=get_rand_idx(get_chars_w_dialog())
  if not is_element_in(menuchars,choice) then
   add(menuchars,choice)
  end
 until #menuchars==4
 -- choose random frog name
 get_char_by_id('k').name=frog_names[get_rand_idx(frog_names)]
end

function _update()
 if not stat'57' and repeatedmusic then
  if act_stagetype=='playmap' then 
   if repeatedmusic=='23' then
    set_repeat_music'0'
   elseif repeatedmusic=='0' then
    set_repeat_music'23'
   end
  end
  music(repeatedmusic)
 end
 if (is_element_in(split'intro,playmap',act_stagetype)) numticks+=1
 get_stage_by_type(act_stagetype).update()
end

function _draw()
 get_stage_by_type(act_stagetype).draw()
end
-->8
-- update & draw fns
function update_scene()
  if (btn'5') act_stagetype='mainmenu'
end

function draw_scene()
 cls()
 ?"⁶-b⁶x8⁶y8       ᶜ4⁶.\0\0\0\0\0\0\0◝⁶.\0\0\0\0\0\0\0◝⁶.\0\0\0\0\0\0\0◝⁶-#⁶.\0\0\0\0\0\0\0³⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0ュ⁶-#⁶.\0\0\0\0\0\0\0◝⁶-#ᶜ4⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0○⁶-#ᶜ4⁶.\0\0\0\0\0\0\0◝⁶.\0\0\0\0\0\0\0◝⁶-#⁶.\0\0\0\0\0\0\0◆⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0p\n⁶-#   ᶜ4⁶.\0\0\0\0\0\0ナヲ⁶.\0\0\0ナヲュ◝◝⁶.\0◝◝◝◝◝◝◝⁶-#⁶.ヲ◝◝◝⁷³¹¹⁸⁶-#ᶜa⁶.\0\0\0\0ヲュ◜◜²4⁶.\0\0\0\0◝◝◝◝⁶.\0\0\0\0◝◝◝◝⁶.\0\0\0◝◝◝◝◝⁶.ヲ\0\0³◝◝◝◝⁶.◝\0\0\0◝◝◝◝⁶.◝ュナ\0⁷ᶠᶠ○⁶.\0¹¹⁷⁷⁷⁴\0 ⁶.ユナナナナナナら\n⁶-# ᶜ4⁶.\0\0\0\0\0\0ヲヲ⁶.\0\0\0\0\0\0゜か⁶-#⁶.ヲヲュュᶜᵉ³¹⁸⁶-#ᶜa⁶.\0\0\0\0ユユュ◜²4⁶.\0\0\0\0゜゜◝◝⁶.\0\0\0\0\0\0█ら⁶.◜◜◜◜◜◜◝◝²a      ⁶-#ᶜ4⁶.◝◝ヒろ▤0ユユ⁸⁶-#ᶜa⁶.\0\0¹³⁷ᶠᶠᶠ⁶-#ᶜ4⁶.◝◝◝◝◝◜ュン²4ᶜa⁶.███████\0\n⁶-#ᶜ4⁶.\0\0\0\0█ナナナ⁶.ヲ◜◝◝◝◝◝◝⁶-#⁶.ト○?゜゜ᶠ⁷⁷⁸⁶-#ᶜa⁶.\0█らナナユヲヲ²4⁶.◝◝◝ャリニ▒\0⁶.ユニト◝◝○◝◝²a        ᶜ4⁶.ナナナナナナナナ⁶-#⁶.ネフヤヤエ゜゜゜²4 \n⁶-#⁶.ナナナナナナ██²4ᶜa⁶.\0█\0\0\0\0\0\0⁶.ヲx○○~~~|⁶.²⁶テ◜◜◜ュヲ⁶.ヲ█¹³³³゜?⁶.◝◝◜◜◜◜>◜⁶.◝◝◝◝◝◝よ◜⁶.◝◝◝◝◝◝フo⁶.◝◝◝◝◝◝○ナ⁶.◝◝◝◝◝◝◝●⁶.◝◝◝◝◝◝◝○⁶.◝◝◝◝◝◝◝\0⁶.◝◝◝◝◝◝◝\0⁶.゜゜゜゜゜゜゜゛⁶-#ᶜ4⁶.????????⁶.゜゜゜゜゜ᶠᵉ⁶\n⁶.█らフ◝◝◝◝◝²4 ᶜa⁶.||||xヲヲユ⁶.ユユヲ<<、\0¹⁶.◝か\0\0██らら²a ᶜ4⁶.AA²²\" ⁴⁴⁶.▮▮▮▮▮…▮▮⁶.▮ \0\0\0¹¹\0⁶.AA¹¹¹yA▒⁶.\0@\0\0\0\0█\0⁶.\0%!く! c\0⁶.²リ\"#b²ワ\0⁶.ナナニナユヲ◝ヲ⁶-#⁶.○○○○○◝◝◝⁶.²²²\0\0\0\0¹\n²4ᶜa⁶.\0\0\0\0らユx8⁶.\0\0\0⁶?○ら█⁶.ナナら█\0²³³⁶.¹³⁷?◝◜ユ\0⁶.ユユヲ◝◝゜'`⁶.◝◝◝◝◝トトヤ⁶.ャワワワ◝◝◝◝⁶.ヤヤヤヤ?◝◝◝⁶.ヤヤヤヤュ◝◝◝⁶.◜◜◝◝◝ヲリワ⁶.○◜◜ョャ⁷◝◝⁶.゜◝◝◝◝◝かよ⁶.□◝◝◝◝◝◝◝⁶.⁶⁷⁷⁷⁷⁷⁷⁷⁶-#ᶜ4⁶.◝◝◝◝○゜゜゜⁶.¹¹¹¹\0\0\0\0\n²4ᶜa⁶.、゛ᵉᵉᵉᵉᵉᵉ⁶.\0\0\0\0\0\0ユユ⁶.³²🐱\0██エれ⁶.\0²⁷⁷ᶠᶠᶠ゜⁶.ラ◜ュてムムュュ⁶.ワンはヨヨヨルル⁶.◝ヤエ◜ュメメメ⁶.◝◝○`◝○○○⁶.◝トよよよャリフ⁶.ヤトトよよよ○○⁶.◝◝トト◝ヤo○⁶.◝◝トト◝ヤ◝ワ⁶.◝◝◝ャ◝ョワ◜⁶.7○7??733⁶-#ᶜ4⁶.○゜??○○○○⁸⁶-#ᶜa⁶.\0ナらら████⁶-#ᶜ4⁶.\0\0¹¹¹¹¹¹⁸⁶-#ᶜa⁶.\0¹\0\0\0\0\0\0\n⁶-#ᶜ4⁶.ニナるろ\0⁸8ヲ⁸⁶-#ᶜa⁶.゛゛<8ヲユら\0²4⁶.…███ユ◝゜\0⁶.れCc#{³⁶\0⁶.、880x\0\0\0⁶.ろ░ささ🅾️pxx⁶.ルレワワ◝³◝◜⁶.oメヤヤ◝ᵉ◝◝⁶.|○○○◝ ◝◝⁶.ヤトトよ○|◝◝⁶.◝◝◝◝◝◜◝◝⁶.vv◜ョョョョャ⁶.◝◝◝◜テ゛◜ョ⁶.ヒヤトト◝ᶜ◝◝⁶.3#ckャ\0\0\0⁶.██☉☉エ\0\0\0⁶-#ᶜ4⁶.\0\0²⁶\0⁷⁷⁷⁸⁶-#ᶜa⁶.¹¹AA○\0\0\0\n⁶-#ᶜ4⁶.ヲヲヲヲヲュ◜◝²4   ᶜa⁶.ヲヲヲユららュ◜⁶.ュね◝◝◝◝◝◝²a      ᶜ4⁶.\0\0\0\0\0███²4  ⁶-#⁶.⁷⁷⁷ᶠᶠᶠᶠᶠ\n²4    ²a  ⁶.\0\0\0\0\0\0⁸8     ⁶.████████²4  ⁶-#⁶.ᶠᶠ゜゜゜゜゜゜\n⁶.◝◝◝ヲら\0\0\0⁶.◝◝◝◝◝◜◜◜²4  ²a  ⁶.8pユユユナナナ⁶.\0\0\0¹³³⁷³⁶.…` \0\0\0\0\0   ⁶.ナナナナナナナナ²4  ⁶-#⁶.゜゜゜゜????\n ⁶.◜◜◜◜◜◜◜◜²4  ᶜa⁶.◝◝◝◝◜◜◜◜²a ᶜ4⁶.ららナナナユユユ⁶.▒▒れれネ♥♥♥⁶.ᶠᶠ゜゜゜゜゜゜   ⁶.ナナナナナナナナ²4  ⁶-#⁶.○○○○○○◝◝\n²4    ᶜa⁶.◜◜ュユら███²a ᶜ4⁶.ユユユヲららら@⁶.⁷ᶠᶠ◆³¹³³⁶.゜??゜゜⁸\n゜  ⁶.\0\0\0\0█ららユ⁶.ナユヲ◝◝◝◝◝²4   \n    ᶜa⁶.█\0\0\0\0\0\0\0⁶.◝◝ユユ\0\0\0\0⁶.゜よ◝◝\0\0\0\0⁶.ュ◝◝◝◝\0\0\0⁶.◝◝◝◝◝\0\0\0⁶.◝◝◝◝◝\0\0\0⁶.◝◝◝◝゜\0\0\0⁶.³³³³\0\0\0\0  ⁶-#ᶜ4⁶.◝◝◝◝◝◝゜\0⁶.◝◝○゜ᶠ\0\0\0\n⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.○○\0\0\0\0\0\0  "
 ?'\t \f0press \151 to\nenter the unknown',34,68
 ?'\t \f9press \151 to\n\f2enter the unknown',34,67
end

function update_controls()
 if btnp'4' then
  act_stagetype="mainmenu"
 end
end

function update_main_menu()
 if btnp'2' then
  act_y = (act_y+2)%3
  sfx'0'
 elseif btnp'3' then
  act_y = (act_y+1)%3
  sfx'0'
 end
 if btnp'5' then
  if act_y==0 then
   pal(14,128,1)
   pal(15,133,1)
   pal(12,130,1)
   pal(1,132,1)
   pal(8,139,1)
   act_stagetype="intro"
   queue_dialog_by_idx'1'
   set_repeat_music'0'
  elseif act_y==1 then
   act_stagetype="controls"
  else
   stop()
  end
 end
end

function draw_end_game()
 draw_bg_menu()
 local na,nt=#achievs,flr(numticks/30)
 local sa,st=na*1000,flr(1/((nt/100)+1)*10000)
 ?'\fa\147 time\f7   '..nt..'\n\f9  +'..st..'\n\fa\146 achievements\f7   '..na..'/7\n\f9  +'..sa..'\n\n\fa\143 total score \f9'..(sa+st),16,68
end

function update_intro()
 if btnp'5' then
  local curprogressdlg=get_first_active_dlg()[act_dialogspeakidx]
  if curprogressdlg != nil then
   local txtlen=#curprogressdlg.text
   if curprogressdlg.time < txtlen then
    curprogressdlg.time = txtlen
   else
    act_dialogspeakidx+=1
   end
  end
  sfx'0'
 end
 if act_dialogspeakidx>#dialogs[1] then
  transition_to_playmap()
 end
end

function is_loc_available(mapid, x, y, qcharid)
 for n in all(get_npcs_for_map(mapid)) do
  if (n.charid != qcharid and n.x == x and n.y == y) return false
 end
 return is_walkable(x, y, mapid) and not (act_mapsid == mapid and x == act_x and y == act_y) and get_dest_for_loc(mapid, x, y)==nil
end

function get_available_loc(mapid, x, y, qcharid)
 local tgts={}
 for i=-1,1 do 
  for j=-1,1 do 
   if (is_loc_available(mapid, x+i, y+j, qcharid) and not (i+j==0)) add(tgts,{x+i, y+j}) 
  end
 end
 if (#tgts==0) return x,y
 local r=tgts[get_rand_idx(tgts)]
 return r[1],r[2]
end

function add_npcs(chardatas,is_party)
  for chardata in all(split(chardatas, '|')) do
   chardata=split(chardata)
   add(ternary(is_party or false,party,npcs),{charid=chardata[1],mapid=chardata[2],x=chardata[3],y=chardata[4]}) 
  end
end

function add_world_item(itemdata)
  itemdata=split(itemdata)
  add(act_wrld_items,{spridx=itemdata[1],mapid=itemdata[2],x=itemdata[3],y=itemdata[4],cldwn=1})
end

function remove_world_items(spridx)
  for i in all(act_wrld_items) do 
    if (i.spridx==tonum(spridx)) del(act_wrld_items, i)
  end
end

function set_repeat_music(musicidx)
 music'-1'
 repeatedmusic=musicidx
end

function update_play_map()
 local initialdialoglen=#act_text_dialog
 -- check for dialog progress
 local x_consumed=false
 if btnp'5' and initialdialoglen > 0 then
  x_consumed=true
  sfx'0'
  local curprogressdlg=get_first_active_dlg()[act_dialogspeakidx]
  if curprogressdlg != nil and curprogressdlg.time != nil then
   if curprogressdlg.time < #curprogressdlg.text then
    curprogressdlg.time = #curprogressdlg.text
   else
    act_dialogspeakidx+=1
   end
  end
  if act_dialogspeakidx != nil and act_dialogspeakidx > #get_first_active_dlg() then
   if type(act_text_dialog[1])=='number' then
    add(compltdlgs,act_text_dialog[1])
   end
   act_text_dialog=drop_lead_elems(act_text_dialog)
   act_dialogspeakidx=1
  end
 end
 -- check selection direction
 if btn'5' then
  act_lookingdir=nil
  for i=0,3 do
   if btn(i) then
    act_lookingdir=i
   end
  end
 else
  act_lookingdir=nil
 end
 -- world does not progress during dialog
 if (initialdialoglen>0)return
 -- check for triggers
 for i=1,#triggers,2 do
  local divi=ceil(i/2)
  if not is_element_in(complete_trigs,divi) and triggers[i]() then
   add(complete_trigs,divi)
   triggers[i+1]()
   x_consumed=true
  end
 end
 -- check active movement
 if act_lookingdir == nil and initialdialoglen == 0 then
  local m=get_map_by_id(act_mapsid)
  for i=0,3 do
   if btnp(i) then
    maybe_queue_party_move(act_x, act_y)
    break
   end
  end
  if btnp'2' and act_y > 0 and is_walkable(act_x, act_y-1) then
   act_y = act_y - 1
  elseif btnp'1' and act_x < 15 and is_walkable(act_x+1, act_y) then
   act_x = act_x + 1
   act_fliph=false
  elseif btnp'3' and act_y < 15 and is_walkable(act_x, act_y+1) then
   act_y = act_y + 1
  elseif btnp'0' and act_x > 0 and is_walkable(act_x-1, act_y) then
   act_x = act_x - 1
   act_fliph=true
  end
 end
 -- check for player switch
 if btnp'4' and initialdialoglen == 0 then
  perform_active_party_swap()
  set_display_name()
 end
 -- check for map switch
 local i,maplocked=1
 for m in all(maplocking) do
  local mdata=split(m)
  if mdata[1]==act_mapsid and not is_element_in(complete_trigs,i) and trigger_is_complete(ternary(#mdata>2,mdata[3],nil)) then 
    maplocked=mdata[2]
    break
  end
  i+=1
 end
 local to_map_id,to_x,to_y=get_dest_for_loc(act_mapsid, act_x, act_y)
 if to_map_id != nil and not is_on_trans_loc then
  is_on_trans_loc=true
  if get_mapidx_by_id(to_map_id)<get_mapidx_by_id(act_mapsid) then
    transition_to_map(to_map_id,to_x,to_y)
  elseif maplocked != nil then
    if initialdialoglen == 0 then
      queue_dialog_by_txt"we aren't done here yet... we should"
      queue_sys_text(maplocked)
    end
  else
    transition_to_map(to_map_id,to_x,to_y)
  end
 elseif to_map_id == nil then
  is_on_trans_loc=false
 end
 -- check for item usage
 if btnp'5' and act_item!=nil and is_element_in(inv_items[act_item].charids,act_charid) and not x_consumed then
  sfx'0'
  act_useitem=act_item
  -- candy
  if act_item==1 then
   add_world_item(join_all{'255',act_mapsid,act_x,act_y})
  -- bird art
  elseif act_item==2 then
   local wmnpc = get_npc_by_charid'm'
   if distance(wmnpc.x, wmnpc.y) < 2.0 and not dialog_is_complete'19' then
    queue_dialog_by_idx'19'
    wmnpc.flipv=true
   end
  -- shovel
  elseif act_item==4 then
    local m=get_map_by_id(act_mapsid)
    local x,y=act_x+m.cellx,act_y+m.celly
    if mget(x,y)==110 then 
      digcount+=1
      if digcount<4 then
        queue_dialog_by_txt(split('oh this is bad!,we\'re digging our own graves!,is that a bone?!')[digcount])
        queue_sys_text(digcount..' of 4 shovel-fulls done')
      end
      if digcount==4 then 
        mset(x,y,127)
        add_npcs(join_all{'s',act_mapsid,act_x+1,act_y})
        act_y-=1
        act_item=nil
        get_char_by_id('e').idle={'what a wonderful harvest'}
      end
    end
  end
 else
  act_useitem=nil
 end
 -- check for talk w/ npcs
 if initialdialoglen == 0 and not x_consumed then
  for npc in all(get_npcs_for_map(act_mapsid)) do
   for i=-1,1 do
    for j=-1,1 do
     if i!=j and npc.x+i==act_x and npc.y+j==act_y then
      if player_sel_location(npc.x,npc.y,npc.mapid) then
       local idles=get_char_by_id(npc.charid).idle
       queue_dialog_by_txt(ternary(npc.flipv or false,'owww...',idles[get_rand_idx(idles)]),npc.charid)
       x_consumed=true
      end
     end
    end
   end
  end
 end
 -- tick npc mvmt
 for n in all(get_all_npcs()) do
  exec_npc_intent(n)
 end
 -- check for obj selection
 for i=-1,1 do
  for j=-1,1 do
   local x=act_x+i
   local y=act_y+j
   if player_sel_location(x,y,act_mapsid) and not x_consumed then
    for descpt in all(split("122,123,138,139;what a nice old wagon#124,125,140,141;the poor old mill...#158;look at these pumpkins!#159;it says pottsfield \148#220;a stump of some weird tree?#219;a creepy tree with a face on it#224,225,240,241;pottsfield old barn#226,227,242,243;the old grist mill#228,229,244,245;the animal schoolhouse#110;the ground is higher here#127;a deep hole in the ground#42;what a nice view out this window#58;its a large cabinet#59;its a comfortable chair#74;its a small desk#75;its a school desk#90;its a lounge chair#91;its a bundle of logs#143;its a piano!#177;its the mill\'s grinder!#178;its a jar of thick oil#179;its a broken jar of oil#200;its a chalk board#215;i found a rock fact!#216;its warm by the fireplace#217;a bundle of black oily sticks#180,181;a cafeteria bench and table#230,231,246,247;the town gazebo#232,233,248,249;pottsfield home",'#')) do
     local splt = split(descpt, ';')
     local selspr=mget(x+get_map_by_id(act_mapsid).cellx,y+get_map_by_id(act_mapsid).celly)
     if is_element_in(split(splt[1]),selspr) and initialdialoglen==0 then
      queue_dialog_by_txt(splt[2])
      x_consumed=true
      if (selspr==219) do_edelwood_select()
      if selspr==215 then
       if(not is_element_in(rockfact_sels, act_mapsid)) add(rockfact_sels, act_mapsid)
       queue_dialog_by_txt(split('put raisins in grape juice to get grapes!,dinosaurs had big ears but we forgot!,I was stolen from old lady daniels yard!')[#rockfact_sels], 'F', true)
       queue_dialog_by_txt(#rockfact_sels..' of 3 rock facts collected!', 'F')
       mset(x+get_map_by_id(act_mapsid).cellx,y+get_map_by_id(act_mapsid).celly,202)
       if (#rockfact_sels==3) queue_achievement_text('you found all 3 rock facts!')
      end
      break
     end
    end
   end
  end
 end
 -- play sound if new dialog triggered
 if #act_text_dialog>initialdialoglen or act_lookingdir!= nil then
  sfx'2'
 end
end

function equip_item(itemidx)
  act_item=tonum(itemidx)
  set_display_name()
end

function set_display_name()
  act_text_charsel={txt=get_char_by_id(act_charid).name,frmcnt=32}
end

function queue_sys_text(txt,large)
  queue_dialog_by_txt('\f9['..txt..']',act_charid,large or false)
end

function queue_achievement_text(text)
  queue_dialog_by_txt('\f9\146 '..text..' \146','A',true)
  if not is_element_in(achievs, text) then 
    add(achievs, text) 
    if #achievs==5 then
      mset(73,16,202)
      get_map_by_id('secret').playmapspr=202
    elseif #achievs==6 then
      queue_achievement_text'all achievements obtained!'
    end
  end
end

function join_all(blob)
  local r=''
  for i,b in ipairs(blob) do
    r=r..b
    if (i!=#blob)r=r..','
  end
  return r
end

menuitem(1,'achievements',function() 
  if (act_stagetype!='playmap') return
  for a in all(achievs) do 
    queue_achievement_text(a)
  end
  queue_dialog_by_txt(#achievs..' of 7 achievements gotten!')
end)

function trigger_is_complete(idx)
  return idx==nil or is_element_in(complete_trigs,tonum(idx)) or false
end

function do_edelwood_select()
 if(not is_element_in(edelwood_sels, act_mapsid)) add(edelwood_sels, act_mapsid)
 queue_dialog_by_txt('*eerily howls in the cool fall wind*', 'E', true)
 queue_dialog_by_txt(#edelwood_sels..' of 7 edelwoods found!', 'E')
 if (#edelwood_sels==7) queue_achievement_text('you found all 7 edelwoods!')
end

function queue_dialog_by_txt(text,speakerid,large)
  add(act_text_dialog,{{speakerid=speakerid or act_charid,text=text,large=large or false}})
end

function nearest_old_cat()
  return dist_to_closest_item('grounds',act_x,act_y,254)
end

function get_trans_loc_for_ids(primmapid, trgtmapid)
  for trans in all(map_trans) do 
    if trans.mp_one == primmapid and trans.mp_two == trgtmapid then 
      return split(trans.mp_one_locs[1])
    elseif trans.mp_one == trgtmapid and trans.mp_two == primmapid then 
      return split(trans.mp_two_locs[1])
    end
  end
end

function get_dest_for_loc(mapid, x, y)
  for trans in all(map_trans) do 
    if trans.mp_one == mapid then 
      for loc in all(trans.mp_one_locs) do
        local locsplit,two_loc = split(loc),split(trans.mp_two_locs[1])
        if (0+locsplit[1] == x and 0+locsplit[2] == y) return trans.mp_two, two_loc[1], two_loc[2]
      end
    elseif trans.mp_two == mapid then 
      for loc in all(trans.mp_two_locs) do
        local locsplit,two_loc = split(loc),split(trans.mp_one_locs[1])
        if (0+locsplit[1] == x and 0+locsplit[2] == y) return trans.mp_one, two_loc[1], two_loc[2]
      end
    end
  end
  return nil,nil,nil
end

function enoch_in_pottsfield()
  return get_npc_by_charid('e').mapid=='pottsfield'
end

function maybe_queue_collect_text()
  if wheatcount>4 and pumpkincount>4 then 
    queue_dialog_by_idx'28'
    equip_item'4'
  end
end

function exec_npc_intent(npc)
 if npc.cldwn == nil then
  npc.cldwn=1
 end
 npc.cldwn-=1
 if npc.cldwn==0 then
  npc.cldwn=16
 else
  return
 end
 -- move npcs off others/player
 local isparty=false
 for p in all(party) do 
   if (p.charid == npc.charid) isparty=true
   if isparty and p.intent == nil and not is_loc_available(p.mapid, p.x, p.y, p.charid) then 
    npc.x,npc.y=get_available_loc(p.mapid, p.x, p.y, p.charid)
   end
 end
 -- do npc movement
 local intent=npc.intent
 local intentdata=npc.intentdata
 if intent=='chase_candy_and_player' then 
  local m=get_map_by_id(npc.mapid)
  local qx,qy=m.cellx+npc.x,m.celly+npc.y
  local mgetr=mget(qx,qy)
  if (mgetr==191) mset(qx,qy,185)
  if (mgetr==142 or mgetr==175) mset(qx,qy,201)
  if (mgetr==178) mset(qx,qy,179)
  intent='walk'
  local candy,disttocandy=dist_to_closest_item(act_mapsid,npc.x,npc.y,inv_items[1].spridx)
  local newdata=npc.intentdata
  if npc.mapid!=act_mapsid then 
    local dst=get_trans_loc_for_ids(npc.mapid,act_mapsid)
    if (dst != nil and #dst>1) newdata=dst[1]..'|'..dst[2]
  elseif candy != nil and distance(npc.x,npc.y,candy.x,candy.y) < distance(npc.x,npc.y,act_x,act_y) then
    newdata=candy.x..'|'..candy.y
  else
    newdata=act_x..'|'..act_y
  end
  npc.intentdata=newdata
 end
 if intent == 'walk' then
  local npcmapid=npc.mapid
  local intentdatasplit = split(npc.intentdata, '|')
  -- do local mvmt
  local offx=intentdatasplit[1]-npc.x != 0
  local offy=intentdatasplit[2]-npc.y != 0
  if offx then
   npc.x+=sgn(intentdatasplit[1]-npc.x)
  end
  if offy then
   npc.y+=sgn(intentdatasplit[2]-npc.y)
  end
  if #intentdatasplit==2 and not(offx or offy) then 
   if npc.intent=='walk' then
    npc.intent=nil
   elseif npc.intent=='chase_candy_and_player' then
    for i in all(act_wrld_items) do
     if (i.mapid==npc.mapid and i.spridx==inv_items[1].spridx and i.x==npc.x and i.y==npc.y) del(act_wrld_items,i)
    end
   end
  end 
  -- do map switch
  local to_map_id,to_x,to_y=get_dest_for_loc(npcmapid, npc.x, npc.y)
  if not isparty and to_map_id!=nil then 
    transition_npc_to_map(npc, to_map_id, to_x, to_y)
  end
 end
 if intent == 'loop' then
  local id = split(npc.intentdata, '|')
  if npc.x==id[3] and npc.y!=id[2] then
   npc.y-=1
  elseif npc.y==id[2] and npc.x!=id[1] then
   npc.x-=1
  elseif npc.x==id[1] and npc.y!=id[4] then
   npc.y+=1
  elseif npc.y==id[4] then
   npc.x+=1
  end
 end
end

function dist_to_closest_item(mapid,x,y,itemspridx)
 local closest,clostdist=nil,1000
 for i in all(act_wrld_items) do
  local idist=distance(x,y,i.x,i.y)
  if i.mapid==mapid and i.spridx==itemspridx and idist<clostdist then 
   clostdist=idist
   closest=i
  end
 end
 return closest,clostdist
end

function transfer_npc_to_party(charid)
  add(party,get_npc_by_charid(charid))
  for n in all(npcs) do
   if (n.charid==charid) del(npcs, n)
  end
end

function remove_charids_in_party(charids)
  charids=split(charids)
  while is_element_in(charids,act_charid) do 
    perform_active_party_swap()
  end
  for c in all(charids) do 
    add(npcs,get_npc_by_charid(c))
  end
  for p in all(party) do 
    if (is_element_in(charids,p.charid)) del(party,p)
  end
end

function perform_active_party_swap()
 add_npcs(join_all{act_charid,act_mapsid,act_x,act_y},true)
 act_charid = party[1].charid
 act_x = party[1].x
 act_y = party[1].y
 party=drop_lead_elems(party)
end

local boot_age = 0
local boot_title = 'pepjebs'
local boot_subtitle = 'studios'
local boot_letters = {}

function update_boot()
 if boot_age % 5 == 0 and flr(boot_age / 5) <= #boot_title then
  local idx = flr(boot_age / 5) + 1
  boot_letter_add = sub(boot_title, idx, idx)
  add(boot_letters,{letter = boot_letter_add, x = 10 + (12 * idx), y = 45, age = 0})
 end
 boot_age += 1
 if boot_age > 220 then
  act_stagetype = "scene"
  pal(13,132,1)
  set_repeat_music'23'
 end
end

function draw_boot()
 cls'7'
 if boot_age == 1 then
  sfx'3'
 elseif boot_age == 135 then
  sfx'4'
 end
 local subtitle_x = 58
 local subtitle_y = 72
 local subtitle_color = 1
 if boot_age < 60 then
  subtitle_color = 7
 elseif boot_age < 120 then
  subtitle_color = 6
 end
 ?'\^i'..boot_subtitle, subtitle_x - #boot_subtitle, subtitle_y, subtitle_color
 if boot_age > 130 and boot_age < 160 then
  line(subtitle_x - #boot_subtitle + (boot_age - 135), subtitle_y - 8, subtitle_x - #boot_subtitle + (boot_age - 130) + 4, subtitle_y  + 16, 7)
  line(subtitle_x - #boot_subtitle + (boot_age - 135) + 1, subtitle_y - 8, subtitle_x - #boot_subtitle + (boot_age - 130) + 5, subtitle_y  + 16, 7)
 end
 for l in all(boot_letters) do
  local eff_y_age = l.age
  local cur_color = flr(eff_y_age / 9) % 7 + 8
  local cur_scale = 3
  local cur_x = l.x
  local printbigshadow = false
  if eff_y_age > 100 then
   printbigshadow = true
   if eff_y_age > 130 and eff_y_age < 140 then
    cur_color = 12
   else 
    cur_color = 1
   end
  elseif eff_y_age < 100 then
   cur_scale = 8 - flr(eff_y_age / 18)
   if eff_y_age < 85 and eff_y_age > 75 then
    eff_y_age -= 3
    cur_x += 3
   elseif eff_y_age > 85 and eff_y_age < 95 then
    eff_y_age += 3
   end
  end
  if eff_y_age > 100 then
   eff_y_age = 100
  end
  local cur_y = l.y + (100 - eff_y_age)
  if printbigshadow then
   print_big(l.letter, cur_x+1, cur_y+1, 6, cur_scale)
  end
  print_big(l.letter, cur_x, cur_y, cur_color, cur_scale)
  if l.age < 200 then
   l.age += 1
  end
 end
end

function draw_controls()
 cls'0'
 ?"\fa\148\131\139\145\f7 move",16,20
 ?"\fa\151\f7 progress dialog or\n use item",16,40
 ?"\fa\142\f7 switch characters",16,60
 ?"\fa\151+\148\131\139\145\f7 select object\n or npc",16,80
 ?"\fa\142\f7 back to menu",8,118
end

function draw_bg_menu()
 cls'0'
 -- draw logo
 local anchrx,anchry=24,4
 for n=1,60 do
  local i,j,ln=ceil(n/10),(n-1)%10,split(split('128#129#130#131#132#132,#131,#130,#129,#128,#144#0#133#134#135#136#137#145#0#144,#144#0#146#147#148#149#150#151#0#144,#144#0#152#153#160#161#162#163#0#144,#144#0#0#164#165#166#167#0#0#144,#168#169#176#176#176#176#176#176#169,#168,', '#')[n])
  local lno,tgtx,tgty=ln[1],j*8+anchrx,i*8+anchry
  if (lno != 0) spr(lno,tgtx,tgty,1,1,#ln > 1)
 end
 -- draw 4 random chars
 drawchoices = get_chars_w_dialog()
 for i,s in ipairs(split('4,4|108,4|4,108|108,108', '|')) do
  local is=split(s)
  local tgtx,tgty=is[1],is[2]
  draw_fancy_box(tgtx,tgty,17,17,2,10,9)
  spr(drawchoices[menuchars[i]].chrsprdailogueidx, tgtx+1, tgty+1, 2, 2)
 end
end

function draw_main_menu()
 draw_bg_menu()
 -- draw buttons
 draw_fancy_text_box("start",48,65,act_y==0)
 draw_fancy_text_box("controls",42,85,act_y==1)
 draw_fancy_text_box("quit",50,105,act_y==2)
 -- draw selection chevrons
 local sel_y=65+(act_y*20)
 palt(5,true)
 pal(12,9)
 spr(234,24,sel_y,1,1)
 spr(234,96,sel_y,1,1,true,false)
 pal(12,12)
 palt(5,false)
end

function draw_introduction()
 local anchrx,anchry=32,16
 cls'0'
 -- draw bg
 draw_fancy_box(anchrx,anchry,66,52,0,4,5)
 -- draw frog
 sspr(80,72,32,24,anchrx+1,anchry+4,64,48)
 -- draw frog dialog box
 draw_dialog_if_needed()
end

function draw_dialog_if_needed()
 if #act_text_dialog > 0 then
  local curprogressdlg=get_first_active_dlg()[act_dialogspeakidx]
  if curprogressdlg != nil then
   draw_character_dialog_box(curprogressdlg)
  end
 end
end

function draw_play_map()
 local activemap=get_map_by_id(act_mapsid)
 -- color handling
 palt(0,false)
 palt(13,true)
 cls'139'
 -- draw map
 map(activemap.cellx, activemap.celly)
  -- draw ring around new active char
 if act_text_charsel != nil and act_text_charsel.frmcnt>0 and flr(act_text_charsel.frmcnt/5)%2==0 then
  local x,y=act_x*8,act_y*8
  pset(x,y+9,12)
  pset(x+7,y+9,12)
  line(x+1,y+8,x+6,y+8,12)
  line(x+1,y+10,x+6,y+10,12)
  pset(x,y+10,1)
  pset(x+7,y+10,1)
  line(x+1,y+11,x+6,y+11,1)
 end
 -- draw player
 draw_spr_w_outline(0, get_char_by_id(act_charid).mapspridx, act_x, act_y, 1, act_fliph, false)
 -- draw npcs
 for npc in all(get_npcs_for_map(act_mapsid)) do
  if npc.x != nil and npc.y != nil then
   local c=get_char_by_id(npc.charid)
   local scaling=1.0
   if (c.scaling != nil) scaling=c.scaling
   local flipv=false
   if (npc.flipv) flipv=true
   local fliph=false
   if (act_x < npc.x and not flipv) fliph=true
   draw_spr_w_outline(0, c.mapspridx, npc.x, npc.y, scaling, fliph, flipv)
  end
 end
 -- draw items
 for i in all(act_wrld_items) do
  local ix,iy=i.x,i.y
  local ofst=ternary(is_loc_available(i.mapid,ix,iy),0,-0.5)
  if (i.mapid==act_mapsid) draw_spr_w_outline(0, i.spridx, ix+ofst,iy, 1, false, false)
 end
 -- draw selection direction
 if act_lookingdir != nil then
  local lkdr=act_lookingdir
  local selspr,selx,sely=get_sel_info_btn(lkdr)
  palt(5,true)
  spr(selspr,8*(act_x+selx),8*(act_y+sely),1,1,selx==-1,sely==1)
  palt(5,false)
 end
 -- draw fog of war
 if activemap.type=='exterior' or activemap.id=='barn' then
  local dark={}
  for i=0,15 do
   for j=0,15 do
    local nearforone=false
    for member in all(union_arrs(party,{{x=act_x,y=act_y}})) do
     if distance(i, j, member.x, member.y) < 2.7 then
      nearforone=true
     end
    end
    local idtfr=tostr(i)..'|'..tostr(j)
    if not activemap.discvrdtiles then
     activemap.discvrdtiles={}
    end
    if not nearforone and not is_element_in(activemap.discvrdtiles, idtfr) then
     add(dark,{i,j})
     local mspr=mget(i+get_map_by_id(act_mapsid).cellx, j+get_map_by_id(act_mapsid).celly)
     if (is_element_in(darkspr.idxs,mspr)) then
      -- draw "dark" sprite
      for i=1,#darkspr.clrmp_s do
       pal(darkspr.clrmp_s[i],darkspr.clrmp_d[i])
      end
      spr(mspr,8*i, 8*j)
      for i=1,#darkspr.clrmp_s do
       pal(darkspr.clrmp_s[i],darkspr.clrmp_s[i])
      end
     else
      if #darkanims==0 and flr(rnd'30000')==0 then
       add(darkanims,{frmcnt=35,type='eyes',x=i,y=j})
      end
      rectfill(8*i, 8*j,(8*i)+7, (8*j)+7,0)
     end
    elseif not is_element_in(activemap.discvrdtiles, idtfr) then
     add(activemap.discvrdtiles,idtfr)
    end
   end
  end
 end
 -- draw dark animations
 for d in all(darkanims) do
  local idtfr=tostr(d.x)..'|'..tostr(d.y)
  if d.frmcnt>0 and not is_element_in(activemap.discvrdtiles, idtfr) then
   if d.type=='eyes' then
    local pcol,dx,dy=7,d.x*8,d.y*8
    if d.frmcnt<8 or d.frmcnt>27 then
     pcol=1
    else
     pset(dx+1,dy+4,6)
     pset(dx+3,dy+4,6)
     pset(dx+2,dy+3,6)
     pset(dx+2,dy+5,6)
     pset(dx+4,dy+4,6)
     pset(dx+6,dy+4,6)
     pset(dx+5,dy+3,6)
     pset(dx+5,dy+5,6)
    end
    pset(dx+2,dy+4,pcol)
    pset(dx+5,dy+4,pcol)
   end
   d.frmcnt-=1
  else
    del(darkanims,d)
  end
 end
 -- draw active char & item hud
 local has_item=act_item!=nil and is_element_in(inv_items[act_item].charids,act_charid)
 local char_name=nil
 if act_text_charsel != nil and act_text_charsel.frmcnt>0 then
  char_name=act_text_charsel.txt
  act_text_charsel.frmcnt-=1
 else
 end
 draw_fancy_spr_box(1,get_char_by_id(act_charid).mapspridx,char_name)
 if has_item then
  local i=inv_items[act_item]
  draw_fancy_spr_box(16,i.spridx,ternary(char_name!=nil,i.name,nil))
 end
 -- draw map title
 txtobj=act_text_maptitle
 if txtobj != nil and txtobj.frmcnt > 0 then
  draw_fancy_box(txtobj.x, txtobj.y, #txtobj.txt*4+4, 8, 4,10, 9)
  printsp(txtobj.txt, txtobj.x+3, txtobj.y+3, 2)
  printsp(txtobj.txt, txtobj.x+2, txtobj.y+2, 9)
  txtobj.frmcnt = txtobj.frmcnt-1
 end
 -- draw dialog if necessary
 palt(13,false)
 draw_dialog_if_needed()
end

function draw_fancy_spr_box(y,spridx,title)
 local xanchor,is_close=1,distance(1,y/8) < 3
 if (is_close) xanchor=114
 if title != nil then
  if (is_close) xanchor=90
  draw_fancy_box(xanchor,y,#title*4+12, 11, 4,10, 9)
  printsp(title, xanchor+12, y+5, 2)
  printsp(title, xanchor+11, y+4, 9)
 else
  draw_fancy_box(xanchor,y,11,11,4,10,9)
 end
 spr(spridx, xanchor+2, y+2)
end

-->8
-- utilities
function draw_spr_w_outline(outline_color, spr_idx, x, y, scaling, fliph, flipv,dim)
 dim = dim or 8
 local sx,sy=(spr_idx%16)*8,(spr_idx\16)*8
 for i=0,15 do
  pal(i, outline_color)
 end
 scaling = scaling or 1
 scaling *= dim
 sspr(sx,sy,dim,dim,x*8,y*8+1,scaling,scaling,fliph,flipv)
 sspr(sx,sy,dim,dim,x*8+1,y*8,scaling,scaling,fliph,flipv)
 sspr(sx,sy,dim,dim,x*8+1,y*8+1,scaling,scaling,fliph,flipv)
 for i=0,15 do
  pal(i, i)
 end
 sspr(sx,sy,dim,dim,x*8,y*8,scaling,scaling,fliph,flipv)
end

function get_npc_by_charid(qcharid)
 for n in all(get_all_npcs()) do
  if (n.charid==qcharid) return n
 end
end

function get_first_active_dlg()
 local curprogressdlg=act_text_dialog[1]
 if type(curprogressdlg)=='number' then
  curprogressdlg=dialogs[curprogressdlg]
 end
 return curprogressdlg
end

function player_location_match(locquery)
 local locqsplit=split(locquery)
 if (locqsplit[1]!=act_mapsid) return false
 for i=2,#locqsplit,2 do 
  local ione,itwo=locqsplit[i],tonum(locqsplit[i+1])
  if ione=='on' then 
   local ithree=tonum(locqsplit[i+2])
   if (act_x!=itwo or act_y!=ithree) return false
   i+=1
  end
  if ((ione=='above'and act_y<=itwo) or (ione=='right_of'and act_x<=itwo) or (ione=='below'and act_y>=itwo) or (ione=='left_of'and act_x>=itwo)) return false
 end
 return true
end

function player_sel_location(x,y,mapid)
 local selspr,selx,sely=get_sel_info_btn(act_lookingdir)
 return selspr!=nil and mapid==act_mapsid and act_x+selx == x and act_y+sely == y
end

function player_sel_spr(mapid,sprid)
 local selspr,selx,sely=get_sel_info_btn(act_lookingdir)
 local m=get_map_by_id(act_mapsid)
 return mapid==act_mapsid and selspr!=nil and mget(m.cellx+act_x+selx,m.celly+act_y+sely)==sprid
end

function replace_player_sel(sprid)
 local selspr,selx,sely=get_sel_info_btn(act_lookingdir)
 local m=get_map_by_id(act_mapsid)
 mset(m.cellx+act_x+selx,m.celly+act_y+sely,sprid)
end

function player_use_item(itemidx,mapid,x_idx,y_idx)
 return act_useitem==itemidx and act_mapsid==mapid and (x_idx == nil or (x_idx == act_x and y_idx == act_y))
end

function playmap_npc_visible(mapidcharid)
 local mcs=split(mapidcharid)
 if act_mapsid != mcs[1] then
  return false
 end
 for n in all(get_npcs_for_map(act_mapsid)) do
  local idtfr=n.x..'|'..n.y
  if is_element_in(get_map_by_id(act_mapsid).discvrdtiles,idtfr) and n.charid==mcs[2] then
   return true
  end
 end
 return false
end

function dialog_is_complete(dialogi)
 return is_element_in(compltdlgs,tonum(dialogi))
end

function queue_dialog_by_idx(dialogi)
 add(act_text_dialog,tonum(dialogi))
end

function maybe_queue_party_move(destx, desty)
 for p in all(party) do
  if flr(rnd'2') == 0 and p.intent==nil then
    set_walk_intent(p,destx..'|'..desty)
  end
 end
end

function queue_move_npcs(chars_and_intents)
  local s,sk,sc=split(chars_and_intents)
  for i=1,#s,2 do 
    if sc!=s[i] then 
      sc=s[i]
      sk=1
    else
      sk+=1
    end
    local ns={}
    for n in all(get_all_npcs()) do
      if sc==n.charid then 
        add(ns,n)
      end
    end
    set_walk_intent(ns[sk],s[i+1]) 
  end
end

function set_walk_intent(npc,intentdata)
 npc.intent = "walk"
 npc.intentdata = intentdata
end

function transition_to_playmap()
 act_stagetype = "playmap"
 act_charid='g'
 act_dialogspeakidx=1
 equip_item'1'
 act_text_dialog = {}
 transition_to_map('woods1',8,8)
 party={{charid='w',mapid='woods1',x=act_x,y=act_y},{charid='k',mapid='woods1',x=act_x,y=act_y}}
 pal(14,14,1)
 pal(15,15,1)
 pal(12,12,1)
 pal(1,1,1)
 pal(8,8,1)
 ismusicdlg=false
end

function transition_npc_to_map(npc, dest_mapid, dest_x, dest_y)
 npc.x = dest_x
 npc.y = dest_y
 npc.mapid = dest_mapid
 local id = split(npc.intentdata,'|')
 if npc.intent == 'walk' and #id>2 then
   npc.intentdata = id[3]..'|'..id[4]
 end
end

function is_walkable(mapx, mapy, mapid)
  local m = get_map_by_id(mapid or act_mapsid)
  local s = mget(mapx+m.cellx, mapy+m.celly)
  return is_element_in(walkable,s) and (m.type!='interior' or not is_element_in({207,223,239},s)) 
end

function transition_to_map(dest_mp,dest_x,dest_y)
 act_mapsid = dest_mp
 local m = get_map_by_id(act_mapsid)
 act_x = dest_x
 act_y = dest_y
 if (m.type=='interior')act_y-=1
 -- update party loc
 for p in all(party) do
  p.mapid=act_mapsid
  p.x=act_x
  p.y=act_y
  p.intent=nil
  p.intentdata=nil
 end
 local titlex=63-(2*#m.title)
 act_text_maptitle={x=titlex,y=12,txt=m.title,frmcnt=45}
 -- check alt tiles
 local amcx,amcy=m.cellx,m.celly
 if not is_element_in(altsset, act_mapsid) then
  local srctiles=get_sourceidxs()
  for i=0,15 do
   for j=0,15 do
    local tilspr=mget(i+amcx, j+amcy)
    if (is_element_in(srctiles,tilspr)) then
     local dsts=get_dsts_by_source(tilspr)
     local randsel=get_rand_idx(dsts)
     mset(i+amcx, j+amcy, dsts[randsel])
    end
   end
  end
  add(altsset,act_mapsid)
 end
 -- add buildings
 for m in all(maps) do
  if m.type=='interior' and m.playmapid==act_mapsid then
   local x,y,spridx=m.playmaplocx+amcx,m.playmaplocy+amcy,m.playmapspr
   mset(x,y,spridx)
   if not is_element_in({202,218},spridx) then 
    mset(x+1,y,spridx+1)
    mset(x,y+1,spridx+16)
    mset(x+1,y+1,spridx+17)
   end
  end
 end
end

function distance(x1, y1, x2, y2)
 return sqrt(((x2 or act_x) - x1)^2 + ((y2 or act_y) - y1)^2)
end

function get_stage_by_type(stagetype)
 local sns=split('boot,scene,mainmenu,controls,intro,playmap,endgame')
 for i=1,#sns do
  if (sns[i]==stagetype) return {update=stagefns[i*2-1],draw=stagefns[i*2]}
 end
end

function get_rand_idx(arr)
 return flr(rnd(#arr))+1
end

function get_chars_w_dialog()
 chars={}
 for char in all(characters) do
  if not is_element_in({-1,196}, char.chrsprdailogueidx) then
   add(chars,char)
  end
 end
 return chars
end

function draw_fancy_text_box(text,x,y,active)
 draw_fancy_box(x,y,#text*4+8, 12, 4, 10, 9)
 local txtclr=0
 if active then
  txtclr=10
  printsp(text, x+5, y+5, 2)
 end
 printsp(text, x+4, y+4, txtclr)
end

function get_all_npcs()
 return union_arrs(party, npcs)
end

function union_arrs(arr1, arr2)
 local newarr={}
 for i in all(arr1) do
  add(newarr,i)
 end
 for i in all(arr2) do
  add(newarr,i)
 end
 return newarr
end

function draw_character_dialog_box(dialogobj)
 if dialogobj.time == nil then
  dialogobj.time = 1;
 end
 draw_fancy_box(8,100,112,24,4,10,9)
 local speakerid=dialogobj.speakerid
 local c = get_char_by_id(ternary(speakerid=='*',act_charid,speakerid))
 local cname,dialogtxt,dlgtime=c.name,dialogobj.text,dialogobj.time
 ?cname, 30, 104, 2
 ?cname, 29, 103, 9
 if (ismusicdlg) dialogtxt='\141'..dialogtxt..'\141'
 local partial = dialogtxt
 if (speakerid=='A'and dlgtime==1) sfx'4'
 if dlgtime < #dialogtxt then
  partial=sub(dialogtxt,1,dlgtime)
  dialogobj.time += 1
 end
 if #partial<=22 then
  printsp(partial, 29, 110, 0)
 else
  local chi=-1
  for i=23,1,-1 do
   if is_element_in(split(",.? ",""),sub(partial,i,i)) then
    chi=i
    break
   end
  end
  printsp(sub(partial,1,chi).."\n"..sub(partial,chi+1), 29, 110, 0)
 end
 draw_fancy_box(10,103,17,17,1,6,5)
 spr(c.chrsprdailogueidx, 11, 104, 2, 2)
 if dialogobj.large then
  draw_fancy_box(30,22,68,68,1,6,5)
  draw_spr_w_outline(0, c.chrsprdailogueidx, 4, 3, 4, false, false, 16)
 end
 local y,col=117,2
 if (#dialogtxt == #partial) y,col=117,10
 if (btn'5') y,col=118,9
 if (y==117) ?"\151",112,118,0
 ?"\151",112,y,col
end

function get_sel_info_btn(lkdrbtn)
 if (lkdrbtn==nil)return nil
 local spri,selx,sely=234,0,2*lkdrbtn-5
 if lkdrbtn==2 or lkdrbtn==3 then
  spri=250
 else
  selx=2*lkdrbtn-1
  sely=0
 end
 return spri,selx,sely
end

function drop_lead_elems(arr, count)
 newarr={}
 for i=(count or 1)+1,#arr do
  add(newarr, arr[i])
 end
 return newarr
end

function get_npcs_for_map(mapid)
 local r = {}
 for n in all(get_all_npcs()) do
  if (n.mapid == mapid) add(r,n)
 end
 return r
end

function draw_fancy_box(x,y,w,h,fg,otlntl,otlnbr)
 local xone,yone,xwid,yhei=x+1,y+1,x+w,y+h
 rectfill(xone,yone,xwid-1,yhei-1,fg)
 line(xone,y,xwid-1,y,otlntl) -- top line
 line(xone,yhei,xwid-1,yhei,otlnbr) -- bottom line
 line(x,yone,x,yhei-1,otlntl) -- left line
 line(xwid,yone,xwid,yhei-1,otlnbr) -- right line
 pset(x,yhei,0) -- left black dot
 pset(xwid,yhei,0) -- right black dot
 line(xone,yhei+1,xwid-1,yhei+1,0) -- bottom black line
end

local alttiles = split("206;206,221,237#238;222,238#207;207,223,239#235;235,251,218#205;202,203,205#236;204,236", '#')
function get_dsts_by_source(source)
 for altstr in all(alttiles) do
  local alt = split(altstr, ';')
  if source==alt[1] then
   return split(alt[2])
  end
 end
 return nil
end

function get_sourceidxs()
 local sources={}
 for altobj in all(alttiles) do
  local srcidx = split(altobj, ';')[1]
  add(sources,srcidx)
 end
 return sources
end

-->8 from our friends
-- print small and pretty
function printsp(s,...)
 print(smallcaps('^'..s),...)
end

-- thanks felice of lexaloffle.com
function smallcaps(s)
  local d=""
  local l,c,t=false,false
  for i=1,#s do
    local a=sub(s,i,i)
    if a=="^" then
      if(c) d=d..a
      c=not c
    elseif a=="~" then
      if(t) d=d..a
      t,l=not t,not l
    else 
      if c==l and a>="a" and a<="z" then
        for j=1,26 do
          if a==sub("abcdefghijklmnopqrstuvwxyz",j,j) then
            a=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",j,j)
            break
          end
        end
      end
      d=d..a
      c,t=false,false
    end
  end
  return d
end

-- thanks jwinslow23#6531 on discord!
function mcpy(dest,src)
 for i=0,319,4 do
  poke4(dest+i,peek4(src+i))
 end
end

-- thanks jwinslow23#6531 on discord!
function print_big(text,x,y,col,factor)
 poke(0x4580,peek(0x5f00+col))
 poke2(0x4581,peek2(0x5f00))
 poke4(0x4583,peek4(0x5f28))
 poke2(0x4587,peek2(0x5f31))
 poke(0x4589,peek(0x5f33))
 poke(0x5f00+col,col)
 poke2(0x5f00,col==0 and 0x1100 or 0x0110)
 mcpy(0x4440,0x0)
 mcpy(0x0,0x6000)
 camera()
 fillp'0'
 rectfill(0,0,127,4,(16-peek(0x5f00))*0x0.1)
 ?text,0,0,col
 mcpy(0x4300,0x6000)
 mcpy(0x6000,0x0)
 mcpy(0x0,0x4300)
 camera(peek2(0x4583),peek2(0x4585))
 sspr(0,0,128,5,x,y,128*factor,5*factor)
 mcpy(0x0,0x4440)
 poke(0x5f00+col,peek(0x4580))
 poke2(0x5f00,peek2(0x4581))
 fillp(peek2(0x4587)+peek(0x4589)*0x0.8)
end

__gfx__
dd6666dd88888ddd6d66666666666666dddd88888888888ddddddddddddddddddddddddddddddddddddddddddd9aa9dddddddddddddddddddddddda999addddd
d666666dd88888ddd6666666666666d6ddd888888888888ddddddd6666dddddddddddddddddddddddd4dd4dddd2fffddddddddddddddddddddddaaaa99addddd
6d4444d6d84444dddd666666666666ddddd888888888888ddddd66666666dddddddddddddddddddddd1111dddd20f0dddddddd0000ddddddddd999909099addd
d6f0f0ddddf0f0ddddd6444444446dddddd88888888888ddddd6666666666dddddddbbddddbbdddddd41111d0d2aaad0dddd00000000dddddda9f00fff009add
ddffffddd1ffff1dddd4444444444ddddd888844444888ddddd6666666666ddddddbbbbddbbbbddddd4040dd00000000ddd0000000000ddddd9ff777f777f9dd
d737737dd697796ddd44774ff47744dddd8877ffff7748dddd667766667766ddddb3773bb3773bddd744447dd000000dddd0100111001ddddddff077f077fddd
d733337dd677776dddf7607ff7607fdddd47607ff76074dddd676076676076ddddb7607bb7607bddd477774dd000000dddd109a010a90ddddddfffffeffffddd
dd0dd0ddd202202dddf7007ff7007fddddf7007ff7007fdddd670076670076dddd370073370073ddddcddcdddd0dd0ddddd10a01110a0ddddddff9feefaffddd
ddddddddddddddddddff77ffff77ffddddff77ffff77ffdddd667766667766dddd337733337733ddddddddddddddddddddd0100010001ddddddff09aaa0ffddd
dddddddddddddddddddff0ffff0ffddddddff0ffff0ffdddddd6666556666ddddd3b03333330b3dddd4dd4dddd5dd5ddddd0002222000dddddddff0000ffdddd
ddddd60ddddddddddddff000000ffddddddfff0000fffdddddd6665555666ddddd3bb000000bb3ddddaaaeddddccccddddd0227676220ddddddddffffffddddd
dccce665ddd3d3ddddddff0000ffddddddddffffffffdddddddd66655666ddddddd3bbbbbbbb3ddddd47777ddd55cccdddd2670000672dddddddd22222dddddd
ddcceeddddd030ddddd733ffff337dddddddd1ffff1dddddddddee6666eedddddddd33333333dddddd4040dddd0000dddd002267672200dddd51cfffffc150dd
dd9c77dddd3333dddd773377773377ddd11111177111111dddd7eeeeeeee7dddddd3333333333ddddd4444ddd5c7775d0000002222000000d0001ccfcc10000d
ddddddddd3333dddd77733777733777d1111197777911111ddc77eeeeee77cddddb3333333333bddd4aaaa4dd5cccc5d00110110100011000000011111000000
ddddddddd3b3bdddd77333333333377d1197777777777911dcc7777777777ccddbb3333333333bbdddaaaadddd0dd0dd00001001011100000000000000000000
51dddd15dd0000dd1d5d5ddddddd5d15dd655555555555ddd00ddd0000ddd00ddddddddddddddddd0020202000000000ddddddddddddddddddddd4ddddd4dddd
15161651dd0000dd11d5ddddddd5511dd65555555555552dd00d00000000d00dddd4444444444ddd0004740029000020ddddddddddddddddddddd44dddd44ddd
51676765d000000dd115dd1111d51155d66666666666622dd000c00000c0000dd44477444477444d0004440004444400dddd4dddddd4dddddddd444dde4e4ddd
d516165dddf0f0dd5511d6611665155dd65555555555552ddd0cac000cac00dd44476074476074440004740024555422ddd44dddccd44ddddddd99999eee9ddd
ddd11dddd54ff44add51677667761ddddd666666666662ddddcaeac0caeac0dd44470074470074440004740004444400ddd4411111144dddddd99977997999dd
d111111d460000a9d5dd67766776d5ddddff760ff760ffdddcaeeea0aeeeacdd44447744447744440004440029000020ddd44ccc11144dddddd27744774774dd
1d1111d1d6000060dddd16611661ddddddff700ff700ffddddcaeac0caeac0dd4d444440044444440004740000000000ddd441cccc144dddddd24aa444aa44dd
dd1dd1dddd5dd5dddddd11111111ddddddfff7799f77ffdddd0cac000cac00dd4d44f700007744d40020202000000000dddd4aa444aaddddddd24a0444a044dd
ddddddddddddddddddddd111111ddddddddfff9999fffdddd050c00000c00ddddd47f770077774dd4444444444444444ddd4a0092a009dddddd26444444446dd
dddcacacdddddddddddddd1111dddddddddffff99f0ffdddd050e00000e00dddddd77ff777777ddd4425244444333344ddd4a0092a009dddddd24644004464dd
dddaeaeadddddddddddd11111111ddddddddff0000ffdddd00557eeeee70dddddd57777ffff74ddd4225224443bbbb34ddd4299555994ddddddd446044064ddd
dd0cacacdddddddddddd11111111ddddddd222ffff220ddd000567676765ddddd54577777444dddd4255524443bbbb34ddd4455000554ddddddd464444446ddd
d0070700ddddd474ddd1111111111ddddd040000000044dd000556565655ddddd54455777455dddd422522443b3bb3b3ddd44544ee454ddddddd62222222d6dd
00007070dd474070ddd1111111111dddd55200000000255d00005555555ddddd544444555545dddd4625264443333334dd111111111111ddddd7777747777ddd
0d000005d47744e4ddd1111111111ddd0005000000099000000000000ddddddd44477775775ddddd4066644449a44a94d77777777777777dddaaaaaaaaaaaadd
dd0d50d54d7dd7ddddd1111111111ddd00050000009aa900000000000ddddddd77777775775ddddd205054422a4444a21111111111111111da99aaaaaaaa99ad
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd4444444444444444dddddddddddddddddddddddddddddddd
ddddddddddd0c0dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd4444444444444444dddddd0000dddddddddddddddddddddd
dddddddddd44ccdddddddddddd000ddddddddddddddddddddddddd7777dddddddddddddddddddddd4444444444444484ddddd0dddd0ddddddddddddd666ddddd
ddddddddd444844ddddddd0dd05000ddddddddddddddddddddddd777777ddddddddd99999999dddd44522544499999a4dddd0dd11dd0dddddddd66666666dddd
dd0000ddd400804ddddddd00d00050dddddddddccccddddddddd77777777ddddddd9999999999ddd4225524499999972ddddd011110dddddddd6666666666ddd
d0000050dd0000dddddddd00d00000dddddddddccccddddddddd777a07a0dddddd99aaa999aaa9dd4222224445555224ddddd0d55d0dddddddd66777677766dd
d0000000dd0000dddddd555555000ddddddddddc00ccdddddddd77700700dddddd9a000a9a000add4454454444544544ddd6dd0550dd6ddddd6661776771666d
dd0dd0ddddd99dddddd5000000555dddddddddcc00ccdddddddd77777077dddddd9a000a9a000add2454454224544542dddd6d5aa5d6ddddd56667766677666d
ddd999ddddd77dddddd5000000005dddddddddcc11cc1ddddddd5077000ddddddd99aaa949aaa9dda888888444222224ddddd6a97a6ddddd556666666666666d
dd90909ddd7070ddd00500000005000ddddddd1ccccc1fdddddd5607777ddddddd999994949999dd8222284442452452dd66dda79add66dd555666aaaaaa666d
dd99999ddd7777dd00050000005000dddddd558111c1ffdddddd6670505dddddddd9976767699ddd8888844442452452ddddd65aa56dddddd55666a0880a665d
dd90009dddd700dddddd555555ddddddddd5558882110fdddd77566777dddddddddd96767679dddd8282884442452452dddd6dd11dd6ddddd55566aa88aa55dd
daf999addd767dddddddd00ddddddddddd555588822f0fdd77dd56ddd677ddddddddababbabadddd8222284425502022ddd6dd1111dd6ddddd55566688655ddd
daafffaad7d6d7ddddddd00dddddddddd555558882220f5d776666666d677dddddddababbab9dddd8282884454450445ddddddddddddddddddd5555666555ddd
dffffffddd767dddddddd0dddddddddd555544888225555577dd56ddd6d77ddddddabbab39339ddd8222284454450445dddddddddddddddddddd55555555dddd
ddaddadddd6d6ddddddddddddddddddd5554448882445555d77776666ddd77dddddabab333939ddda888844445544554ddddddddddddddddddddddd5555ddddd
dd999ddddd9999dddddddddd44ddddddddddddd444dddddddddd22244422ddddd44444444422244d4424444244244244333332333333433338333333ddddd666
d90909ddd944944ddddddd94444ddddddddddd99444ddddddd333333333333dd4444424444444444442224424442244433332433334494438a833333dddd6665
d99999ddd999999ddddd99999999dddddddd99999999dddddddd99999999ddddd44224442222244d44244222444244443332323333399333282bbb33dddd4655
d90009dddd9777ddddd9900999009dddddd9900999009dddddd9900999009dddd42444444444424d42224424444244443323234333399333323bbbb3dddd445d
dd999dddd3a3a3adddd9000090000dddddd9000090000dddddd9000090000ddddd444774447744dd42442224444424443342333333332333b3bbbb3bddd44ddd
d7d6d7ddd3a3a3addd9a0000a0000adddd9a0000a0000adddd9a0000a0000addddd47607f7607ddd4224442444442444332333333444244333bbbb33dd44dddd
dd767dddd3a3a3addd99a00a9a00a9dddd99a00a9a00a9dddd99a00a4a00a9dddddd7007f7007ddd224222444442244434343333334444333b3333b3444ddddd
dd6d6dddd3a3a3addd999aa999aa99dddd999aa900aa99dddd999aa444aa99dddddde77fff77eddd24444244442442443333333333333333b333333bd4dddddd
dd4444ddddd00ddddd999888888999dddd99999a00a999dddd999899498999ddddddff8fff8ffddd33333333333333333333333333333333dddddd9434444433
d44444dddd0a0addddd9876676789dddddd99999aa999dddddd9878888789ddddddddff888ffdddd33333333333333333335333333333333ddddd94d44444443
ddf0f0dddd0000ddddd9867767689dddddd9a0000000adddddd9867767689dddddddddfffffddddd33333333334433333555333333333333ddddd9ad44222243
ddeffedd0d0676d0dddd98888889dddddddd9aaaaaaadddddddd98888889dddddddddd6fff6ddddd33333333442333335555533333333333dddd9a4d34220243
d776677d00000000ddddff9999ffdddddddddd9999ddddddddddff9999ffddddddddd656f656dddd33333344992333333557733333333333ddaa94dd34200243
df7777fdd000000dddaaffffffffaaddddd7777777777dddddaaffffffffaadddd777656665677dd33334432399233333570003733333333da94addd44000043
d555555dd000000daaaaffffffffaaaad77dd777777dd77daaaaffffffffaaaa777776556556777733443232939233333560007533333333da99addd33444b3b
d54dd45ddd0dd0ddaaffffffffffffaa7dd77dd77dd77dd7aaffffffffffffaa777777667667777734323233294433333775005553355333ddaadddd333333b3
00000000000000009090000000000000000000000000000000000000000000000000000000000000329233234434222337755057535555552202220222222244
00099900000000990900009009000004444000000000000000000000000000000000000000000000329323442499233337777577366556630000000046666644
00900090000000000900090000900040000402200aaaa00a0000a0aaaaa0aaaa000aaaaaaa0a000a323944242929933337777667755570730222022246907944
0900200900000090900900999900000000000220a9999a0a0000a0a99990a999a00a99a99a0a000a32442422299b9b3334740077550700030000000045970944
0902420900009009009000000000004444400000a0000a09a00a90a00000a000a00900a0090a000a343992233399b33335444077500600032202220220202044
0900200900090009090900999900000990040020a0000a00a00a00aaaaa0aaaa900000a0000a000a339929333333333334544074000705730000000027676744
0090000090009990000009000090009009000002a0000a00a00a00a99990aa99000000a0000aaaaa3b9b99333333333355454476007557630222022242555244
0000000944444444444444444444444444444444a0000a00a00a00a00000a9aa000000a0000a999a33b993333333333344544974475557660000000042444244
0000090400000000a0000a009aa900a000a0a099a00000a0000a000a0a000a0000000a00aaaa00a0000004444444444400000000000000004244444433333333
00000094000000009aaaa9000aa000aaaaa0a000a0000aaa000a000a0aaaaa0000000a0099a900aa0000004eeeeeeeee44444444444000004244424434444443
004400940aaaaa0009999000099000999990900090000999000900090999990000000a0000a00a990000004eeeeeeeeeeeeeeeeee4fe00004444424434222243
044440940a999900000000000000000000000000000000000000000000000000000009aaaa900a000000004eeccccccceeeeeeeee4ffe0004aaaaaa434422443
024420940a000000000000aaaa00000aa000aaaa00aaaa000aaaaa0aa00a000000000099990009000000004eeccbcc77cccccccee4ffe000aa9999aa34444443
002200940aaaaa0000000a9999a0000aa000a999a09a99a00a99990aa00a000000000000000000000000004e3cb7766777cccccee4ffe000a9aaaa9a33b22333
000000940a99990000000a00009000a99a00a000a00a009a0a00000a9a0a00000000000000a000a00000004333307b777666cccee4ffe000a999999a333b2333
000009040a00000000000a00000000a00a00aaaa900a000a0aaaaa0a0a0a00000000000000a000a000000033333bbbb77777cccee4ffe0004a9999a433333333
0a00aa99000a000a0a99990a0a0a0000009a009a00a00a99a00a00000a000000009000004444444400000033333b8bb47667cccee4ffe000a9a9a9a920202020
aa00a9aa000a000a0a00000a0a0a0000000a00aa00a00a00a00a00000a0000000009040009000000000004333333b88e4444444444ffe0009a999a9900200020
99a0a099a00a00a90a000a0a09aa0000000a00aa0a900a00a00a00000a00000000090420900440900000433333333bbeeeeeeeee44ffe000a9a9a9a920202020
00a0a000a0aaaa900aaaaa0a00aa0000000a00aa0a000aaaa00a00000a0000000090040000444409000473333333bbbebbeeeee4c4ffe0009a999a9920002000
009090009099990009999909009900000009aa99aa00a9999a0a000a0a000a000900002090244200000463333333bbbb70770774c4ffe0009a999a9920202020
000000000000000000000000000000000000aa00aa00a0000a0aaaaa0aaaaa0000900000000220090000443333333b4666666664c4ffe0009a999a9900200020
00a000aa000a00000a00000000000000000099009900900009099999099999000009009090000900000000433333bbb44444444444ffe0009a999a9920202020
00a000aa000a00000a000000000000000000000000000000000000000000000000009900090000990000004e3333b22eeeeeeeefe4ffe0004a944a9420002000
444444444444404444444444444444444447744454445444ddd0555555550ddddd5555dd124414440000004e12ccccc2eeeeeee1e4ffe0004244444444444444
000000004444424044222224444444444467774400000000dd006555555600dddd6666dd41112244000004eefe22222eeeeeeee1e4fe00004343424444442244
090440904444424244455544424444444466774444444444d05066666666050dd555555d4444444400000044444118a8eeeeeeefe4e000004234424444444444
904444094442242444547754452444444446644444477444dd050666666050dddd7070dd11411141000000000001188a44444444400000004244424411111111
002442004672267444500754452444444444444444677744ddf0500000050fddddffefdd4441241400000000001111a000000000000000004243434444444444
900220097662266544500054454244440000000044667744ddf0555555550fddd000000d42144114000000000104001000000000000000004244324442244444
009009004656565444500054450005045444544444466444ddff00000000ffddd000000d44441444000000000104001000000000000000004244424444444444
990000994442244444455544445550000540054044444444df0ffffffffff0fddd5dd5dd11111111000000000000000000000000000000004444424411111111
d4444444444444d0dddddddddddddddddddddddddddddddddff0777007770ffd444444442020202033333333333333333333333333333333cccccccc44444444
d2444444444444d4dddddddddddddddddddddddddddddddddff5777f5777fffd4222222402002022333333333b3b33333333333333333333cccccccc44444444
dd44444949444442ddddddddddddddddddddaaaaaaaaddddddd5777e5777fddd42333324000000003333333333b33333333bbb3333333333cccccccc44444444
d44449904099444dddddddddddddddddddda99999999addddddfffeefffffddd4237732400000000333333333333333333bbbbb333333333cccccccc44444444
0244900040009444d5dddddc1ddddd5ddda4999999994adddddff666666ffddd42333324000002003b3b33333333b3b33bbbbbb333333333cccccccc44444444
dd24000292000944d75dccc1ccccd57ddd9a44444444a9ddd00f6ffffff6f00d427733242020002033b3333333333b333bbbbbb333333333cccccccc44444444
ddd4002904200042d75c11111111c57ddda9aaaaaaaa9add0555ffffffff5550425555240220202033333333333333333bbbbbb333333333cccccccc44444444
04d420400440204dd755c11ccccc557ddaaa99999999aaad0005555500055000424444242000200033333333333333333333333333333333cccccccc44444444
d24404499444440dd5555cc11115555daddaaaaaaaaaaddadddd4ccc333333334288682444444444333333330343433033333333ccc7cc7ccccc7ccc44464446
ddd044900994040ddd7007700077007dadddaa4999aadddadcdd47c73366663342666824444424444332483434334444333333337ccc7cc7c56667cc45646564
dd4499000009444ddd7076070760707ddadda49a9a9addadcccd4474360767032288662244425524343443430433442333333333c7cc7cc75666667c44544454
dd4900022000944ddd7070070700707dddada499a99adadd7c744442366666634222222444655254243423433343040333333333c7cc7c7c5666667c44446464
dd4000244000042dd770077005770077dddaa49a9a9aadddd7444224366aaa63442aa244425625543844443233344423333333337cc7cccc5666667c44644654
dd420244042024ddddd70000500507ddddddda4999addddddd442dcc356686534429924440526522332243333333002333333333ccccc7ccc566667c44644464
d4404444044404dddd7777775007777dddddddaaaaddddddd442dd7c305555034429824445252644334443333330420333344233cccccc7cc56667cc56545664
d4004440444042dddddc1c55055555ddddddddaaaadddddd442dddd7330000334222222440504444344422333044222330442243ccccc7cccccc7ccc45444554
333333333333333333333333333333333333333663333333335777777777753333333332233333335555555533399933333333337ccccccccccccccc44444466
333333355000333333355533333333333333336aa6553333677777777777777633333388883333335c55c55533999a9333333333c7ccc7cccccc7ccc46454454
3333335445000333355555553333333333333379a75553335756733333576575333333377333333355c55c55399aa999333333337ccccc7cccc657cc45456644
33333544445000335555555553333333333366666666553337675333333576733333333882223333555c55c5a99999a933bbb333cc7ccc7ccc66657c45445644
33335440044500033677776633333333333622222222655337753333333357733333338778222333555c55c53a9aaa933bbbbb33ccc7c7cccc66657c44445554
3335444004445000377000773333333333622227722226233753333333333573333338777782223355c55c55334242333bbbbbb3ccc7ccccc66657cc46644444
335444400444450036600077333333333338877777788223373366666666337333338777777822235c55c5553a2422333bbbbbb3ccc7cccccccc7ccc45645666
35444444444444503770007655555333333777777777722337663633336366733338777777778223555555559444422333333333cc7ccccccccccccc44444554
334444444444442237700077555555553337222222227223373677777777637333877777777778235555555543343434ddddddddddddd766dddddddddddddd2d
3344444444444422447777776666666333378877787c722337677777777776733337777777777663555cc55543439343dddddddddddd7666dd5d5d6ddddd8d22
334444444444442255777667777777733337887778c772233777777777777773333700766700766355c55c5544333443dddddddddddd6965dd959dd6ddd888dd
3345522222554422447444777007007333378877987c7223676777777777767633370076670076635c5555c534434232daadaaaddddd925ddd5557d6dd88888d
33442442442444225574447770060063333788777888722377766666666667773337777667777663555cc55593442323aa9a99aaddd92ddddd666676d88888dd
3344244244244422446449744007007333378877788872235767777777777675333777766777766355c55c5533424233a9a9aa9add92ddddd6d65567dd888ddd
334424424424442255744476677777733337444444447233357666666666675333377755557776635c5555c533242233a99a999a992dddddddd5d66622d8dddd
334424424424442344744474477667733332222222222333335777777777753333377666666776335555555594444229da9999add2ddddddddddd5ddd2dddddd
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000044444444444444444444444444aaaaaaaaaaaaaaaaaaaaa444444444444444444444aaa4
00000000000000000000000000000000000000000000000000044444444444444444444444444444444aaaaaaaaaaaaaaaaaaaaa44444444444444444444aaaa
00000000000000000000000000000000000000004444444444444444444444444444444444444444444444444444444444aaaaaaa44444444444444444444aaa
00000000000000000000000000000000000000004444444444444444444444444444444444444444444444444444444444444aaaa44444444444444444444aaa
000000000000000000000000000000000000044444444444444444444444444444444444aaaaaaaaaa4444444444444444444444aaa444444444444444444aaa
000000000000000000000000000000000004444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444aaa444444444444444444aaa
00000000000000000000000000000000004444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444aaa444444444444444444aaa
0000000000000000000000000000044444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444a444444444444444444aaa
0000000000000000000000000004444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444aa
0000000000000000000000000004444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444a
0000000000000000000000000004444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444a
0000000000000000000000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4400444444444444444444a
0000000000000000000000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa400044444444444444444a
0000000000000000000000000044aaaaaaaaa444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44004444444444444444a
0000000000000000000000000444aaaaaaaaa444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4400044444444444444a
00000000000444444444400044aaaaaaaaaaaaaa4444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444004444444444444a
0000000000044444444440044aaaaaaaaaaaaaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444004444444444444
000000000004444444444044aaaaaaaa4444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444400044444444444
00000000044444444444444aaaaaaaaaa4444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444440044444444444
0000000044444444444444aaaaaaaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444044444444444
000000004444444444444aaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444044444444444
000000044444444444444aaaaa44aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444004444444444
00000444444444444444aaaaa4444aaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444400044444444
0000044444444444444aaaaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444400044444444
0000044444444444444aaaaa44444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444400044444444
0000044444444444444aaaaa4a444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444440044444000
000004444444444a444aaaa44aa444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444440044444000
0000044444444444aaaaaaa44aaaa4aaa44444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444440044444000
0000044444444444aaaaaaa44aaaaaaaaa4444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444440044444000
00000444444444444aaaaaa44aaaaaaaaa4444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444440044444000
00000444444444444aaaaaa44aaaaaaaaa4444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444440044440000
00000004444444444aaaaaa444aaaaaaaaaaa4444aaaaa44aaaaaa4aaaa44aaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444440004440000
000000044444444444aaaaa4444aaaaaaaaaaa444aaaaaaa4aaaaaaaaaaa4aa444444aaa4aa4444aaaaaaaa444444444444444444aaaa4444444440004400000
000000044444444444aaaaa44444aaaaaaaaaaaaaaaaaaaa4aaaaa4aaaaa4aaaaaaa4aaa4aaaaa4aaaaaaaaaaaaaaaaaa4aaaaaaaaaaa4444444444004000000
000000444444444444aaaaa44444aaaaaaaaa44aaaaaaaaa4aaaaa4aaaaa4aaaaaaaa4aa4aaaaa4aaaaaaa4a4a4aa4aa44aa4444aaaaa4444444444004000000
444004444444444444aaaaa4444aaaaa44444444aaaaaaaaa4aaaaaaaaaa4aaaaaaaaaaa4aaaaaaaaaaaaaaa4aaaa4aaa4aaa4aa4aaaa4444444444004000000
444444444444444444aaaaa444aaaa4444444444aaaaaaaaa4aaaaaaaaaa4aaaaaaaaaaa4aaaaaaaaaaaaaaa4aaaa4a444aaa4aaaaaaa4444444444000000000
4444444444444444444aaaa444aaaa444444444aaaaaaaaaa4aaa4aaaaaa4aaaaaaaaaaa4aaaaaaaaaaaaaaa4aaaa4aaa4aaa44aaaaa44444444444000000000
4444444444444444444aaaaa44aaa4444444444aaaaaaaaaaaaaa4aaaaaa4aa44aaaaaaa4aa4444aaaaaaaaaaaaaa4aaa4aaaaaaaaa444444444444400000000
4444444444444444444aaaaa44444444444444aaaaaaaaaaaa4aaaaaaaaa4aaa4aaaaaaa4aaaaa4aaaaaaaa444aaa44a444a4444444444444444444400000000
44444444444444444444aaaaa4444444444444aaaaaaaaaaaa4aaaaaaaaa4aaaaaaaaaaa4aaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444440000000
444444444444444444444aaaa44444444444aaaaaaaaaaaaaa4aaaaaaaaa4aaaaaaa4aaa4aaaaaaaaaaaaaa4aaaaa4444a44a4444aa444444444444440000000
444444444444444444444aaaaa4444444444aaaaaaaaaaaaaaa4aaaaaaaa4aaaaaaa4aaa4aaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaa444444444444440000000
4444444444444444444444aaaaa44444444aaaaaaaaaaaaaaaa4aaaaaaaa4aaaaaaa4aaaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaa444444444444440000000
444444444aa444444444444aaaaaaa44aaaaaaaaaaaaaaaaaaa4aaaaaaaa4aaaaaaa4aaaaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaa444444444444440000000
444444aaaaaaaa4444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444aaaaaaaaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaa444444444444000000000
4444aaaaaaaaaaa44a4444444aaaaaaaaaaaa444aaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaa444aaaaaaaa44444aaaaaaaaaaaaaaaaaaa444444444400000000000
444aaaa4444444aaaa4444444444aaaaaaa44a44aaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaa44aaaaaaaaaaaaaaaaa44aaaaaaaaaaaa444444444400000000000
444aaa444444444aaa4444444444444444444aa4aaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4aaaaaaaaaaaaaaaaaa4aaaaaaaaaaaa444444444400000000000
44aaa44444444444aa444444444444444a44aaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4aa444444444000000000
4aaaa444444444444a4444444a4444444aaaaaaaa44aaaaaaaaa4aaaaaaaaaaaaaaaa4aaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444aaaa0000000
4aaa4444444444444a44444aaaa4444444aaaaaaaa44aa4aaaaa44aaaaaaaaa4aaaaaa4aaaaaa4aaaaaaa4aaaaaaa4aaaaaaaaaaaaa4aa44444444aa40000000
4aaa44444444444444444444aaa4444444aa4a4aa444aaaa4aaaaaaa44444aa4aaaaaa4aaaaaaa4aaaaaa4aaaaaaa4aaaa4aaaaaaaaaaa44444444aa40000000
4aaa4444444444444444444aaaaa444444aa4aaaa444aaaa44aaaaaaaaaaaaaaaaaaaa4aaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444a40000000
4aaa4444444444444444444aaaaa444444aa4aaaa444aaaaa4aa4aaaaaaaaaa4aa4aaaaaaaaaaa4aaaaa4aaaaaaa4aaaa4aaaaaaaaa4aa444444444a40000000
4aaa44444444aaaaaaaa44aaaaaa444444aaaaaa44a4aaaaa4aa4aaaaaaaaaa4aa44aaaaaaaaaaa4aaaa4aa4aaaaaaaaaaa4aaaaaa44aa444444444a40000000
4aaa44444444aaaaaa4444aaaaaaa44444aaaaaa44a4aaaaa4aa4aaaaaaaaaa4aaa44aaaaaaaaaa4aaaaaaa4aaa4aaaa4aaaaaaaaa44aa444444444a40000000
4aaaa4444444a44aaa4444aa44aaa44444a444aa44a4aaaaaaaa4aa444aaaaa4aaaa4aaaaaaaaaaa4aa4aaa4aaaaaaaa4aa44aaaaa44aa444444444aa0000000
0aaaa4444444444aaa4444a4444aaa4444a4444aa4a4aaaaa4aa4aaaaaaaaaa4aaaaa4aaaaaaaaaa4aa4aaa4aaaaaaaaaaaa4aaaaa444a444444444aa0000000
04aaaa444444444aaa444aa4444aaa4444a44a4aaaa4aaaaaaaa4aaaaaaaaaa4aaaaa4aaaaaaaaaa4aaaaaaaaaaaaaaaaaaaa4aaaa444aa4444a444aa40000a0
004aaa444444444aaa444a444444aa4444a44a4aaaa4aaaaaaaa4aaaaaaaaaa4aaaaaa4aaaaaaaaaa4aaaaaa4aaaaaaaaaaaa4aaaa4a4aa4444a444aa44000a0
000aaaaa4444aaaaaa4aaaa4444aaaa44aaa444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4aaaaaaaaa4aaaaaa4aaaa4aaaaaaaaaaaa4aaaaaaaaa44aaaaaaaaa0
0004aaaaaaaaaaaaaa444444444444444444aaa4aa4444444aaa444444444a4444aaaaa44aaaaaaaa4aaaaaa4aaaa44444aa4444444444444444444444400000
000444aaaaaaa4444aa4444444444444444aaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4aaaaaa4aaaaaaaaaaaaaaa444444444444444444400000
00044444444444444444444444444444444aaaa44aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4aaaaaa4aaaaaaaaaaaaaa444444444444444444400000
00044444444444444444444444444444444aaaaa44aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444400000
00044444444444444444444444444444444aaaaaa444aa4aaaaa999a999a999aa99aa99aaaaaa99999aaaaaa999aa99aaaaaaaaa444444444444444444400000
00044444444444444444444444444444444aaaaaaaaaaaaaaaaa909a909a900a900a900aaaaa9909099aaaaa090a909aaaaaaaaa444444444444444444400000
000444444444444444444444444444444444aaaaaaaaaaaaaaaa999a990a99aa999a999aaaaa9990999aaaaaa9aa9a9aaaaaaaaa444444444444444444440000
00044444444444444444444444444444444444aaaaaaaaaaaaaa900a909a90aa009a009aaaaa9909099aaaaaa9aa9a9aaaaaaaaa444444444444444444440000
00444444444444444444444444444444444444aaaaaaaaaaaaaa9aaa9a9a999a990a990aaaaa0999990aaaaaa9aa990aaaaaaaa4444444444444444444440000
0444444444444444444444444444444444aaaaaaaaaaaaaaaaaa0aaa0a0a000a00aa00aaaaaaa00000aaaaaaa0aa00aaaaaaaaa4444444444444444444440000
444444444444444444444444444444444a222a22aa222a222a222aaaaa222a2a2a222aaaaa2a2a22aa2a2a22aaa22a2a2a22aaa4444444444444444444440000
44444444444444444444444444444444aa200a202a020a200a202aaaaa020a2a2a200aaaaa2a2a202a2a2a202a202a2a2a202aa4444444444444444444440000
44444444444444444444444444444444aa22aa2a2aa2aa22aa220aaaaaa2aa222a22aaaaaa2a2a2a2a220a2a2a2a2a2a2a2a2aa4444444444444444444440000
44444444444444444444444444444444aa20aa2a2aa2aa20aa202aaaaaa2aa202a20aaaaaa2a2a2a2a202a2a2a2a2a222a2a2aa4444444444444444444444000
44444444444444444444444444444444aa222a2a2aa2aa222a2a2aaaaaa2aa2a2a222aaaaa022a2a2a2a2a2a2a220a222a2a2aa4444444444444444444444000
44444444444444444444444444444444aa000a0a0aa0aa000a0a0aaaaaa0aa0a0a000aaaaaa00a0a0a0a0a0a0a00aa000a0a0aa4444444444444444444444000
44444444444444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444444444444444444000
44444444444444444444444444444444aaaaaaaaaaaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444444444444444444000
44444444444444444444444444444444aaaaaaaaaaaaaaaaaaa444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444444444444444444000
44444444444444444444444444444444aaaaaaaaaaaaaaaaaaa444aaaaaaaaaaaaaa4aa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444000
44444444444444444444444444444444aaaaaaaaaaaaaaaaaaaa444aaaaaaaaaaaaaa44aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444000
44444444444444444444444444444444aaaaaaaaaaaaaaaaaaaa4444aaaaaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444000
00044444444444444444444444444444aaaaaaaaaaaaaaaaaaaa44444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444000
00000044444444444444444444444444aaaaaaaaaaaaaaaaaaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444400
00000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaa44444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444400
00000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444400
00000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaa44444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444400
00000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaaa444aaaaaa44444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444440
00000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaaa444aaaaaa44444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444440
00000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaa44444aaaa4444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444440
00000000044444444444444444444444aaaaaaaaaaaaaaaaaaaaa44444aaaa4444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444440
000000000444444444444444444444444aaaaaaaaaaaaaaaaaaaa44444aaa44444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444440
000000000444444444444444444444444aaaaaaaaaaaaaaaaaaa4444444aaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444440
000000000444444444444444444444444aaaaaaaaaaaaaaaaaaa4444444aaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444444
000000000444444444444444444444444aaaaaaaaaaaaaaaaaaa4444444aaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444444
444444444444444444444444444444444aaaaaaaaaaaaaaaaaaa4444444aaaaa44444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444444
444444444444444444444444444444444aaaaaaaaaaaaaaaaaaa44444444aaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444444444444444444444444
4444444444444444444444444444444444aaaaaaaaaaaaaaaaaa44444444aaaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444444444
444444444444444444444444444444444444aaaaaaaaaaaaaaa444444444aaa444444aaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444444444444
44444444444444444444444444444444444444aaaaaaaaaaaaaaaa4444aaaaaa44444aaaaaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444444444444
444444444444444444444444444444444444444aaaaaaaaaaaaaaa444aaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaa4444444444444444444444444444444444
444444444444444444444444444444444444444aaaaaaaaaaaaaaa4444aaaaaaa4a4aaaaaaaaaaaaaaaaaaaaaaaaaa4444444444444444444444444444444444
444444444444444444444444444444444444444aaaaaaaaaaaaaaa4a44aaaaaa44444aaaaaaaaaaaaaaaaaaaaaaa444444444444444444444444444444444444
444444444444444444444444444444444444444aaaaaaaaaaaaaa44444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444444444444444444
4444444444444444444444444444444444444444aaaaaaaaaaaaaa4aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444444444444444444
44444444444444444444444444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444444444444444440
44444444444444444444444444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444444444444444000
44444444444444444444444444444444444444444444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaa4444444444444444444444444444444444444440000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444400000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444400000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444440000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444400000000000000000
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444400000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
ebebebebebebebebebebebebebcfcfcfcfcfcfebcececeebebebebebebebebebcdececbe9ebecfcfbebe9ecdcdcdcdebebebebebebebebebebcfcfcfebebebebebebcdcdcdcdcdcdcdcdcdebebebebebcdcd6ccdcdcdcdcdcdcdcdebebebebebebebebebebebebcfcfebebebebebebebebebebebebebebebebebebebebebebeb
ebcdebcdebdccdeccdcdcdebcdcfcfcfcfcfcfecebcececdcdecebebebebebebcdcdcdbebe9ecfbebe9ecfcdcdcdceceebebebcdcdcdcdcdcdcfcfcdcdcdcdebebaf8e8e8e8e8e8e8e8e8e8e8e8eafebeb6ccdcdcdcdcdcdcdcdcdcdcdcdcdebebebd7cdcdcdcdcfcfcdcdcdcdcdcdebebebebebcdcdcdcdebebebebebebebeb
ebcdeccdcdeccdcdcdcdececcfcfcfcfebcfcfcfcecececdcdcdcdebebebebebcdcdebcdbebe9e9eecbe9ecdebcececeebebcd6ccdcdcdcdcdcfcfcdbe9ecddcebafbf6bd9bfd9b1bfb2b2bfbfb2afebebcdaf8e8e8e8e8e8e8e8e8e8eafcdebebcdcdeccdebcdcfcfcdcdcdeccdcdebebebcdcdcdcdebcdebebcdcdcdebebeb
ebcdcdebcdcdcdebcdeccfcfcfcfcfebebebcfcfeecececdcdcdcdcdcdebebebcdebebcdebcdbecfcdcdcdebcecececdebcd6ccfcfcfcf6ccfcfcfcd9e9ecdebcdafbf6bbfbfbfb2bfbfbfbfbfbfafcdebcdaf5b5b5bbfbfbfbfbf6abfafcdebebebcdcdcdcdcdcfcfcdebcdcdcdcdebebebcdcdcdcdcdcdebcdcdcfcfcdebeb
ebcdcdcdecececececcfcfcfcfcfcdebebebceceeeeecfcfcfebececcddcebebcdcdcdcdebcdcfcfcdcdebebcececdebeb6ccfcfcfcfcfcfcfcfcd6d9e9ecdebcd2abf6abfbfbfbfbfbfbfbfd9bfafcdebcd2ab9bfbfbfbfbfbfbfbfbf2acdcdebcdcdebcdcd6ccfcfcdebebcdcdcdebebebcdcdcdcdcdcdcdcdcfcfcfcdebeb
ebebcdeccfcfcfcfcfcfcfcfeccdcdebcecececeeecfcfcfcfcfcfcfcfcdebebcdebebcdebcdcfcf9fcdcdebceceebcdebcdcdcdcdcfcfcfcfcfcd9ebe9ecdebcdafbf6bbfbfbfbfbfbfbfbfbfbfafcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdebcdeccdcdebcfcfcfcdebcdcdcdcdebebcdcdcfcfcdebcdcdcfcfcfcdebebeb
ebcdcdcfcfcfcfcfcfcfcfcfeccdebebcececeebcfcfcfcfcfcfcfcfcfcfebebcdcdcdcdcdcdcfcfcfcdcdcdcecececdebebecececcfcfcfcfcfcdcdbe9ecdebcdafbf6bbfbfb2bfbfbfb2bfbfbfafcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdebcdcdcdebcdcfcfcdebcdcdcdeccdebebcdcdcfcfcdcd6ccfcfcfcdebcdcdeb
ebcdcdcfcddbcdcfcfcfececcdcdecebceceebebebcfcfcfcfcfcfcfcfcfebebebcdcdcdcdeccfcfcfcfcdcdcfcececeebcdcdcdcd6dcfcfcfcfcdcdececcdcdcdaf8e8e8e8e8e2b2b8e8e8e8e8eafcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdebcdcdcdebcdcfcfeccdebcdcdcdcdebcfcfcfcfcfcfcfcfcfcfcdcdcdcdcdeb
ebebcdcfcdcdcfcfcfeccdcdcdcdcdebebebebebeb6ccfcfcfcfcfcfcfcdebebcdcdebebcdcdeccfcfcfcdcfcfcfceceebcd9ebe9ecdeccfcfcfcdcdcdcdcdbecdafbfbfd8bfbfbfbf5b5bbfbf5bafcdcdcdafbfbfbfbfbfbfbfbfbfb9afcdcdebcdcdcdcdebcfcfcfecebebcdcdcdebcfcfcfcfcfcfcfcfcfcfcde6e7cdcdeb
ebcddccfcfcfcfcfeccdebcdcdebcdebebebebeb6ccfcfcfcfcfcfebeccdebebd7ebcdcdcdcdeccfcfcfcfcfcfcdcdcdebcd9e9e9ebecdeccfcfcfcdcdaeaebecdaf5abfbfbf3bbfbfbfbfbfbfbfafcdcdcdaf3abfbfbfbfbfbfbfbfbfafcdcdebcdcdcdcdcdcdcfcfcdebcdcdcdcdebebcdcdcdeccfcfcfcfcfcdf6f7cdcdeb
ebcdcdcfcfcfcfeccdcdcdcdeccdebebebebeb6ccfcfcfcfcfebebebcdcdebebcdcdcdcdebcdcdeccfcfcfcfcdcdebebebcdbe9ebe9ecdcdcfcfcdcdbebeaeaecdafbfbf3bbfbfbfbfbfbfbfbfbfafcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdebcdcdcdcdcdcdcfcfcdcdcdcdcddbebebcdcdeccd6ccfcfcfcfcfcfcfcfcdeb
ebcdcfcfcfcfeccdcdcdcdcdcdcdebebebeb6ccfcfcfcfebebebebebcdcdebebebcdcdcdebebcdcdeccfcfcfcfcdcdebebcd9e9ebecdcd6ecfcfcdcdaebeaeaecd2abfbfbfbfbfbfbfbfbfbfbfbf2acdcdcd2abfbfbfbfbfbfbfbfbfbf2acdebebcdeccdcdcdcdcfcfcdebcdcdcdcdebebcdcdcdcdcdcfcfcfcfcfcfcfcfcdeb
ebcfcfcfcfcdcdcdcdeccdebcdcdebebeb6ccfcfcfcdcdcdcdebdbcdcdcdebebebcdcddccdebcdcdcdcdcfcfcfcfcdebebcdcdcdcdcdcfcfcfcfeccdaeaeaeaecdafbfbfbfbfbfbfbfbfbfbfbfbfafcdaecdafbfbfbfbfbfbfbfbfbfbfafcdebebcdcdcdcdcdeccfcfcdebcdcdcd9eebebebebcdcdcdcfcfcfcfcfcfcfcdcdeb
cfcfcfcfcdcdebcdebcdcdcdcdeccdebebcfcfcfcdcdcdcdcdcdcdcdcdcdebebebcdcdcdcdcdcdcdcdcdcdcfcfcfcfcfebcdbeaebecdcfcfcfcf7a7baebebebecdaf4abfbfbf3abfbfbfbfbfbf4aafcdaecdaf8e8e8e8e2b2b8e8e8e8eafcdebebcdaeaeaeeccfcfcfcdebcdcd9eebebebebebcdcdcdcfcfeccdcdcdcdcdebeb
cfcfcfcdcdcdeccdcdcdcdebcdcdcdebcfcfcfcfcdcdcdecdccdcdcdcdcdebebebdbcdcdcdcdcdcdcdcdcdcdcdcfcfcfebcdaeaeaecdcdcfcfcf8a8baeaeaebeccaf8e8e8e8e8e8e2b8e8e8e8e8eafccaeaecdeccdcdcfcfcfcfcdcdeccdcdebebaeaeaeaeaecfcfcdcdcdcd9eebebebebebebebcdcdcfcfcdcdcdcdebebebeb
cfcfebebebebebebebebebebebebebebcfcfcfebebebebebebebebebebebebebebebebebebebebebebebebebebcfcfcfdbcdbeaeaeaecdcfcfcdcdcdcdaeaeaecdcdcccdcdcfcfcfcfcfcfcdcdcccdcdaeaeeccdcdcdcfcfcfcfcfcdcdeccdcdebaeaeaeaeaecfcfebebebebebebebebebebebebebebcfcfebebebebebebebeb
ebebebebebebebebebebebebebebebebebebebcdcdcdcdcdcdcdcdebebebebebebebebebebcdcdcdcdcdcdcdcdebebebebebebebcdcdebebebebebebebebebebebebebebebebebebebebebebebebebeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdcdcdcdcdcdcdcdcdebebebebebaf8e8e8e8e8e8e2b8e8e8e8e8eafebebebebcdcdcdcdcdcdcdcdcdcdcdebebeb8e8e8e8e8e8e8e8e8e8e8e8e8e8eebebebebcdcdcdcdcdcdcfcdcdcdcdebeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdebcdcdcdcdcdcdcdcdcdebebeb2a5bbfbfbfbfbfbfbfbfbfbfbf2acdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdebcdafbfbfbfbfbfbfbfbfbfbfbfbfafebebebcdcdebcdcdcdcdcfcdebcdcdcdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdebebd7ebcdcdcdebebcdcdebebcdafbfbfbfb5b5b5b5b5b5b5b5b5afcdcdcdcdaf8e8e8e8e8e8e8e8eafcdcdebcd2abfbfbfbfbfbfbfbfbfbfbfbf2acdebcdcdcdcdcd7a7bcdcfcdcdcdeccdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdebebecebebcdebcdecebebcdebcfcdafd8bfbfb4b4b4b4b4b4b4b4b4afcdcdcdcdafbfbfbfbfbfbfb9bfafcdcdebcdafbfbfbfbfbfbfbfbfbfbfbfbfafebebcdcdebcdcd8a8bcdcfcdcdcdcdcdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdebeccdebcdcdebebcdcdebcdcfcfcd2abfbfbfbfbfbfbfbfbfbfbfbf2acdcdcdcd2abfb9bfbfbfbfbfbf2acdcdcdebafbfbfbfbfbfbfbfbfbfbfbfbfafebebcdcdcdeccdcdcdcfcfcdebcdebcdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdcdcfcfcfcfcfcfcdcdcdcfcfcdafbf8fbfbfbfbfbfbfbfbfbfbfafcdcdcdcdafbfbfbf3bbfbfbfbfafcdcdcdebafbfbfbfbfbfbfbfbfbfbfbfbfafebcfcfcfcfcfcfcfcfcfcdcdcdcdcdcdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cfcfcfcfcfcfcfcfcfcfcfcdcfcfcfcfcdaf8e8e8e8e8ebfbf8e8e8e8e8eafcdcdcdcdafbfbfbf4abfbfb9bfafcdcdcdeb2abfbfbfbfbfbfbfbfbfbfbfbf2acdcfcfcfcfcfcfcfcf6ccdcdebcdcdcdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcdaf4a3bbf3abfbfbfc8bfbfbf5bafcdcdcdcdafbfbfbfbfbfbfbfbfafcdcdcdebafbfbfbfbfbfbfbfbfbfbfbfbfafcdebcdcdebcfcfcfcfcfcdcdcdcdeccdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcfcfcfcfcfcfcfcfcfcfcfcdebcdafbfbfbfbfbfbfbfbfbfbfbfbfafcdcdcdcdafbfb9bfbfbfbfbfbfafcdcdcdebafbfbfbfbfbfbfbfbfbfbfbfbfafcdebcdcdcd6ccfcfcfcfcfcdbebecdcdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdcdcfcfcfcfcfcfcdcdcdcdebcd2abfbfbf4bbf4bbf4bbf4bbf4b2acdcdcdcd2abfbfbfbfbfbfbfbf2acdcdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfafcdebcdcdeccdcdcfcfcfcfcf6dbeebcdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdebeccdcdcdcdcdcdcdcdcdcdebebafbfbfbfbfbfbfbfbfbfbfbfbfafcdcdcdcdafbfbfbfbfbfbfb9bfafcdcdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfafcdebcdcdcdcdcdcdcfcfcfcfcfcdcdcdeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdebebebcdcdcdebebcdcdebebebeb2abfbfbf4bbfbfbfbfbf4bbf4b2acdcdcdcdaf8e8e8e2b8e8e8e8eafcdcdcdeb2abfbfbfbfbfbfbfbfbfbfbfbf2acdebcdcdcdcdcdbecdcdcfcfcfcfcfcfcf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebebebcdcdcdcdcdcdcdecebebebebebebaf4abfbfbfbfbfbfbfbfbfbfbfafcdebcdcdcdcdcdcfcfcfcdcdcdcdcdcdebebafbfbfbfbfbfbfbfbfbfbfbfbfafebebcddbcdcdebbe6dcdcdcfcfcfcfcfcf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebebebebcdcdcdcdcdebebebcddbebebebaf8e8e8e8e8e2b2b8e8e8e8e8eafebebebcdcdcdcfcfcfcfcdcdcdcdcdebebeb8e8e8e8e8e8e2b2b8e8e8e8e8e8eebebcdcdcdcdcdcdbecdcdcdcdcdcdebeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebebebebebcdcdcdcdcdcdcdcdcdebebebebcdcdcdcdcfcfcfcfcdcdcdcdebebebebebcdcdcdcfcfcfcfcdcdcdcdebebebebebebebebebcfcfebebebebebebebebebebebebebebebebebebebebebebeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200001a7201b7201d7201f72000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
9114000020552205522355221552205521e552205522c552245522a5522d5522c5522a5522c5522c5522a5522a5521c5521c5521c55230552305522a5001c5000050200502005020050200002000020000000000
00060000277502a7502c7500070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
091000000b753097530975308753087530975309753097530a7530b7530c7530d7530f7531075312753137531475316753197531b7531e7532175325753297532b7532d753077530775307753077530c7530c753
99100000000053c0453c0453c0453e0453e0453e04535005380053b0053e005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
001200002c0302c0302c0302f0302d0302d0302c0302c0302b0302b0302c0302c0303803038030310303103034030340303903039030380303803039030390303803038030380303803033030330303303033030
001200003003030030300303003031030310303103031030310303103031030310303103031030310303103031030310303103031030310303103031030310303103031030310303103020030200302003020030
001200002003020030200302003020030200302003020030000000000000000000000000000000000000000020030200301f0301f0301f0301f0301e0301e0301e0301e0301e0301e0301e0301e0301e0301e030
001200001e0301e0301e0301e0301e0301e0301e0301e0301e0301e0301e0301e0301c0301c0301c0301c0301c0301c0301c0301c0301b0301b0301c0301c0301b0301b0301b0301b0301b0301b0301b0301b030
0012000000000000001c0301b030010300103008030080300d0300d03010030100301403014030190301903008030080300f0300f030120301203014030140301803018030200302003020030200302003020030
001200000d0300d0300d0300d03014030140301403014030170301703000000000000000000000000000000020030200302003020030250302503025030250301503015030150301503025030250302703027030
00120000170301703017030000001203012030120301203014030140301403014030210302103021030210302103021030210302103019030190301c0301c0302003020030200302003020030200302003020030
001200001403014030140301403015030150301503015030150301503015030150301a0301a0301e0301e03020030200302003020030200302003020030200300000000000200302003019030190301903019030
00120000190301903015030150301503015030100301003010030100300803008030080300803014030140301403014030100301003010030100301e0301e0301e0301e030190301903019030190301903019030
001200001e0301e0301b0301b0301b0301b0301903019030190301903016030160301603016030180301803018030180301803018030180301803020030200302003020030200302003020030200302003020030
0012000022030220301c0301c0301d0301d03020030200302003020030200302003020030200302003020030200302003020030200301e0301e0301e0301e0301e0301e0301e0301e03018030180301d0301d030
001200001d0301d0301d0301d0301d0301d030140301403014030140301b0301b0301903019030190301903019030190300d0300d0300d0300d03018030180301803018030180301803018030180301103011030
001200001103011030060300603006030060300a0300a0300d0300d030120301203016030160301603016030160301603016030160301603016030160301603016030160301e0301e0301e0301e0301e0301e030
001200001e0301e0301d0301d0301b0301b0301e0301e0301e0301e0301e0301e0301e0301e03000000000001d0301d0301e0301e0301e0301e0301d0301d0301d0301d0301c0301c0301e0301e0301d0301d030
001200001d0301d0301d0301d0301d0301d03000000000001d0301d0301d0301d03000000000000a0300a0300a0300a03000000000000000000000080300803008030080300f0300f0300f0300f0301403014030
0012000014030140301d0301d030010300103008030080300d0300d030110301103014030140301903019030160301603016030160301b0301b0301b0301b0301903019030190301903019030190301d0301d030
00121400250302503029030290302c0302c0300000031030310303103031030310303103031030310303103031030310303103031030014000140001400014000140001400014000140001400014000140001400
001210000000000000000003103031030310303103031030310303103031030310303103031030310303103001400014000140001400014000140001400014000140001400014000140001400014000140001400
001400002803028030290302b0302b0302b0302b0302b0302b030000002b0302b0302903028030280300000024030240300000030030300303003030030300300000030030300300000032030320300000030030
0014000030030000002f0302f030000002d0302d030000002d0302d0302d030000002d0302d030000002b0302b0300000029030290302d0302d0302d0302d0302d030000002b0302b03000000000002b0302b030
00140000000002b0302b030000002b0302b030000002b0302b030000002f0302f030000002f0302f030000002f0302f03000000000002803028030290302b0302b0302b0302b0302b0302b030000002b0302b030
001400002903028030280300000024030240300000030030300303003030030000000000030030300303003030030000003203032030320303003030030000002f0302f0302d0302d0300000000000000002d030
001400002d0302d0302d0302d0302d0302d0302d0302d0302d030000002b0302b0302b0302b03000000290302903029030290302d0302d0302d0302d0302b0302b0302b0302b0300000029030290302b0302b030
0014070000000000000000000000000002d0302d03001400014000140001400014000140001400014000140001400014000140001400014000140001400014000140001400014000140001400014000140001400
00141500000002b0302b0302b0302b0302b0302b0302b0302b0302b0302b0302b0302b0302f0302f0302f0302f0302f0302f0302f0302f0300140001400014000140001400014000140001400014000140001400
0019000021040210402004020040210402104026040260402604026040240402404024040240402404024040210402104021040210401f0401f0401d0401d0401f0401f0401a0401a0401a0401a0401a0401a040
0019000005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040000000a0400a0400a0400a0400a0400a0400a0400a0400a0400a0400a0400a040
001900000c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c040000000e0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e040
001900001104011040110401104011040110401104011040110401104011040110401104011040110400000011040110401104011040110401104011040110401104011040110401104011040110401104011040
001900001a0401a0401a0400000018040180401a0401a0401d0401d040210402104021040210401d0401d0401d0401d0401d0401d040210402104021040210401f0401f0401e0401e04021040210401f0401f040
001900000a0400a0400a0400000005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040000001304013040130401304013040130401304013040
001900000e0400e0400e040000000c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c040000001704017040170401704017040170401704017040
00190000110401104011040000001a0401a0401a0401a0401a0401a0401a0401a0401004010040100401004010040100401004010040110401104011040110401104011040110401104011040110401104011040
001900001f0401f0401f0401f0401f0401f0401f04000000210402104020040200402104021040260402604026040260402404024040240402404021040210401f0401f0401d0401d0401f0401f0401904019040
001900000a0400a0400a0400a0400a0400a0400a0400a040050400504005040050400504005040050400504005040050400504005040050400504005040000000a0400a0400a0400a0400a0400a0400a0400a040
001900000c0400c0400c0400c0400c0400c0400c0400c0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e040000001604016040160401604016040160401604016040
00190000110401104011040000000e0400e0400e0400e0400e0400e0400e0400e0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001900001904019040190401904019040190401904000000180401804021040210402004020040210402104021040210401d0401d0401d0401d04021040210401f0401f0401d0401d0401f0401f0401d0401d040
001900000a0400a0400a0400a0400a0400a0400a0400a0400d0400d0400d0400d0400d0400d0400d0400d04005040050400504005040050400504005040050400504005040050400504005040050400504000000
0019000016040160401604016040160401604016040160400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c040000001804018040180401804018040180401804018040
001900001d0401d0401d0401d0401d0401d0401d0400000021040210402004020040210402104026040260402604026040240402404024040240402404024040210402104021040210401f0401f0401d0401d040
001900000c0400c0400c0400c0400c0400c0400c0400c040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040050400504005040
00190000180401804018040180401804018040180400000011040110401104011040110401104011040110401104011040110401104011040110401104011040110401104011040000000e0400e0400e0400e040
001900000000000000000000000000000000000000000000110401104011040110401104011040110401104011040110401104011040110401104011040000001104011040110401104011040110401104011040
001900001f0401f0401a0401a0401a0401a0401a0401a0401a0401a0401a0400000018040180401a0401a0401d0401d040210402104021040210401d0401d040210402104021040210401f0401f0401e0401e040
001900000504005040050400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c040000000a0400a0400a0400a0400a0400a0400a0400a0400a040
001900000e0400e0400e0400e0400e0400e0400e0400e0400e0400e0400e040000000c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c0400c040000000b0400b0400b0400b040
0019000011040110401104011040110401104011040000000e0400e0400e0400e0400e0400e0400e0400e04013040130401304013040130401304013040130400904009040090400904009040090400904009040
0019000021040210401f0401f0401f0401f0401f0401f0401f0401f0401f040000001504015040140401404015050150501a0501a0501a0501a0501d0501d0501d0501d050200502005021050210502005020050
001900000a0400a0400a0400a0400a0400a040000000504005040050400504005040050400504005040050400504005040050400504005040050400000007040070400704007040070400704007040070400a040
001900000b0400b0400b0400b04010040100401004010040100401004010040100400c0400c0400c0400c0400c0400c0400c0400c0400e0500e0500e0500e0500e0500e0500e0500e05015050150501505015050
001900000904009040090400904009040090400904000000180501805018050180501805018050180501805015050150501505015050150501505015050150500000000000000000000000000000000000000000
00190000210502105026050260502605026050290502905029050290502605026050290502905026050260502605026050240502405024050240502105021050210502105021040210401f0401f0401e0401e040
001900000a0400a0400a0400a0400a0400a0400a040040400404004040040400404004040040400404005050050500505005050050500505005050050500c0500c0500c0500c0500c0500c0500c0500c0500e050
001900001505015050150501505011050110501105011050110501105011050110501605016050160501605017050170501705017050180501805018050180501805018050180501805017040170401704017040
0019000000000000000000000000000000000000000000001a0401a0401a0401a0401a0401a0401a0401a04016030160301603016030160301603016030160300000000000000000000000000000000000000000
0019000021040210401f0401f0401f0401f0401f0401f0401f0401f0402603026030290302903026030260302603026030240302403024030240302103021030210302103021030210301f0301f0301d0301d030
001900000e0500e0500e0500e0500e0500e0500e0500e0500e0500e0500e05011050110501105011050110501105011050110501105011050110501105013040130401304013040130401304013040130400c030
001900001704017040170401704010030100301003010030100301003010030100301603016030160301603017030170301703017030110301103011030110301103011030110301103013030130301303013030
__music__
00 05404040
00 06404040
00 07404040
00 08404040
00 09404040
00 0a404040
00 0b404040
00 0c404040
00 0d404040
00 0e404040
00 0f404040
00 10404040
00 11404040
00 12404040
00 13404040
00 14404040
04 15164040
00 17404040
00 18404040
00 19404040
00 1a404040
00 1b1c4040
04 1d404040
00 1e1f2021
00 22232425
00 26272829
00 2a2b2c40
00 2d2e2f30
00 31323334
00 35363738
00 393a3b3c
04 3d3e3f80
00 80808080
00 80808040
04 40804040


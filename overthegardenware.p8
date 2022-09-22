pico-8 cartridge // http://www.pico-8.com
version 33
__lua__

-- configs, state vars & core fns
local walkable="43,185,191,202,203,205,207,222,223,238,239,240,241,242"
local alttiles={
 {srcidx=206,dsts="206,221,237"},
 {srcidx=238,dsts="222,238"},
 {srcidx=207,dsts="207,223,239"},
 {srcidx=235,dsts="235,251,218"},
 {srcidx=205,dsts="202,203,205"},
 {srcidx=236,dsts="204,236"}
}
local altsset={}
local objdescripts={
 {spridxs="122,123,138,139",descr="what a nice old wagon"},
 {spridxs="124,125,140,141",descr="the poor old mill..."},
 {spridxs="158",descr="look at these pumpkins!"},
 {spridxs="159",descr="it says pottsfield \148"},
 {spridxs="174",descr="looks like its harvest time!"},
 {spridxs="190",descr="this pumpkin is missing"},
 {spridxs="204,236",descr="its just a bush..."},
 {spridxs="218,235,251",descr="this tree sure is tall"},
 {spridxs="220",descr="a stump of some weird tree?"},
 {spridxs="219",descr="a creepy tree with a face on it"},
 {spridxs="224,225,240,241",descr="pottsfield old barn"},
 {spridxs="226,227,242,243",descr="the old grist mill"},
 {spridxs="228,229,244,245",descr="the animal schoolhouse"},
 {spridxs="230,231,246,247",descr="the inn"},
 {spridxs="232,233,248,249",descr="pottsfield old church"},
 {spridxs="108",descr="a rickety old fence"},
 {spridxs="109",descr="a scarecrow of sorts"},
 {spridxs="110",descr="the ground is higher here"},
 {spridxs="127",descr="a deep hole in the ground"},
}
local inv_items={
 {spridx=255,name='candy',charidxs={1}},
 {spridx=254,name='old cat',charidxs={1,4}},
 {spridx=253,name='shovel',charidxs={1,2}}
}
local last_mapidx_mov=nil
local act_item=nil
local act_useitem=nil
local act_wrld_items={}
local act_x=0
local act_y=0
local act_charidx=nil
local act_lookingdir=nil
local act_flipv=false
local act_text={maptitle=nil,dialog={},charsel=nil}
local act_stagetype="mainmenu"
local act_dialogspeakidx=1
local act_mapsidx=nil
local party={}
local characters={
 {name='greg', mapidx=0, chrsprdailogueidx=2, idle={'where is that frog o\' mine!','wanna hear a rock fact?'}}, 
 {name='wirt', mapidx=1, chrsprdailogueidx=4, idle={'uh, hi...','oh sorry, just thinking'}}, 
 {name='beatrice', mapidx=16, chrsprdailogueidx=6, idle={'yes, i can talk...','lets get out of here!'}}, 
 {
  name={'kitty','wirt','wirt jr.','george washington','mr. president','benjamin franklin','doctor cucumber','greg jr.','skipper','ronald','jason funderburker'}, 
  mapidx=17, 
  chrsprdailogueidx=8,
  idle={'ribbit'}
 }, 
 {name='the beast', mapidx=32, chrsprdailogueidx=34, idle={}}, 
 {name='the woodsman', mapidx=33, chrsprdailogueidx=36, idle={'i need more oil','beware these woods'}}, 
 {name={'the beast?','dog'}, mapidx=48, chrsprdailogueidx=38, idle={}},
 {name='dog', mapidx=49, chrsprdailogueidx=40, idle={}},
 {name='black turtle', mapidx=64, chrsprdailogueidx=66, idle={}},
 {name='turkey', mapidx=65, chrsprdailogueidx=68, idle={}},
 {name='pottsfield citizen', mapidx=80, chrsprdailogueidx=98, idle={'you\'re too early'}},
 {name='pottsfield citizen', mapidx=80, chrsprdailogueidx=102, idle={'are you new here?'}},
 {name='pottsfield harvest', mapidx=81, chrsprdailogueidx=70, idle={}},
 {name='pottsfield partier', mapidx=96, chrsprdailogueidx=100, idle={}},
 {name='enoch', mapidx=97, chrsprdailogueidx=72, scaling=2, idle={'what a wonderful harvest','you don\'t look like you belong here'}},
 {name='dog student', mapidx=10, chrsprdailogueidx=44, idle={}},
 {name='gorilla', mapidx=113, chrsprdailogueidx=12, idle={}},
 {name='jimmy brown', mapidx=11, chrsprdailogueidx=14, idle={}},
 {name='cat student', mapidx=26, chrsprdailogueidx=46, idle={}},
 {name='ms langtree', mapidx=112, chrsprdailogueidx=104, idle={}},
 {name='the lantern', mapidx=nil, chrsprdailogueidx=76, idle={}},
 {name='rock fact', mapidx=nil, chrsprdailogueidx=78, idle={}},
 {name='edelwood', mapidx=nil, chrsprdailogueidx=192, idle={}},
 {name='racoon student', mapidx=27, chrsprdailogueidx=194, idle={}},
}
local map_trans = {
 {mp_one=1,mp_two=2,mp_one_locs={'15,4', '15,5'},mp_two_locs={'0,14', '0,15'}},
 {mp_one=2,mp_two=3,mp_one_locs={'13,0', '14,0', '15,0'},mp_two_locs={'0,13', '0,14', '0,15'}},
 {mp_one=3,mp_two=4,mp_one_locs={'0,0', '1,0'},mp_two_locs={'13,15', '14,15', '15,15'}},
 {mp_one=3,mp_two=6,mp_one_locs={'7,3'},mp_two_locs={'0,5'}},
 {mp_one=4,mp_two=5,mp_one_locs={'7,0', '8,0'},mp_two_locs={'7,15', '8,15'}},
 {mp_one=5,mp_two=7,mp_one_locs={'4,2','5,2'},mp_two_locs={'7,15','8,15'}},
 {mp_one=5,mp_two=8,mp_one_locs={'9,0','10,0'},mp_two_locs={'6,15','7,15'}},
 {mp_one=8,mp_two=9,mp_one_locs={'7,0','8,0'},mp_two_locs={'7,15','8,15'}},
}
local maps={
 {
  type='exterior',
  title='somewhere in the unknown',
  cellx=0,
  celly=16,
  npcs={},
  discvrdtiles={},
  undisc_cnt=0,
 },
 {
  type='exterior',
  title='somewhere in the unknown',
  cellx=0,
  celly=0,
  npcs={{charidx=6,x=6,y=7,cldwn=1}},
  discvrdtiles={},
  undisc_cnt=14,
 },
 {
  type='exterior',
  title='the mill and the river',
  cellx=16,
  celly=0,
  npcs={},
  discvrdtiles={},
  undisc_cnt=0,
 },
 {
  type='exterior',
  title='somewhere in the unknown',
  cellx=32,
  celly=0,
  npcs={},
  discvrdtiles={},
  undisc_cnt=0,
 },
 {
  type='exterior',
  title='pottsfield',
  cellx=48,
  celly=0,
  npcs={},
  discvrdtiles={},
  undisc_cnt=0,
 },
 {
  type='interior',
  title='the old grist mill',
  cellx=64,
  celly=0,
  npcs={},
  playmapidx=3,
  playmapspr=226,
  playmaploc={x=7,y=2}
 },
 {
  type='interior',
  title='harvest party',
  cellx=80,
  celly=0,
  npcs={
   {charidx=11,x=7,y=7,cldwn=1,intent="loop",intentdata={tl={x=7,y=7},br={x=10,y=10}}},
   {charidx=11,x=7,y=10,cldwn=1,intent="loop",intentdata={tl={x=7,y=7},br={x=10,y=10}}},
   {charidx=12,x=10,y=7,cldwn=1,intent="loop",intentdata={tl={x=7,y=7},br={x=10,y=10}}},
   {charidx=12,x=10,y=10,cldwn=1,intent="loop",intentdata={tl={x=7,y=7},br={x=10,y=10}}},
   {charidx=15,x=8,y=8,cldwn=1}
  },
  playmapidx=5,
  playmapspr=224,
  playmaploc={x=4,y=1}
 },
 {
  type='exterior',
  title='somewhere in the unknown',
  cellx=96,
  celly=0,
  npcs={},
  discvrdtiles={},
  undisc_cnt=0,
 },
 {
  type='exterior',
  title='the schoolgrounds',
  cellx=112,
  celly=0,
  npcs={},
  discvrdtiles={},
  undisc_cnt=0,
 }
}
local darkspr={
 idxs="174,204,218,219,235,236,251",
 clrmp={{s=2,d=0},{s=3,d=0},{s=4,d=1},{s=8,d=1},{s=9,d=0},{s=10,d=1},{s=11,d=1}}
}
local darkanims={}
local nonrptdialog={x=nil,y=nil}
local compltdlgs={}
local dialogs={
 {
  {speakeridx=4,nameidx=nil,text="led through the mist"},
  {speakeridx=4,nameidx=nil,text="by the milk-light of moon"},
  {speakeridx=4,nameidx=nil,text="all that was lost is revealed"},
  {speakeridx=4,nameidx=nil,text="our long bygone burdens"},
  {speakeridx=4,nameidx=nil,text="mere echoes of the spring"},
  {speakeridx=4,nameidx=nil,text="but where have we come?"},
  {speakeridx=4,nameidx=nil,text="and where shall we end?"},
  {speakeridx=4,nameidx=nil,text="if dreams can't come true"},
  {speakeridx=4,nameidx=nil,text="then why not pretend?"}
 },
 {
  {speakeridx=1,text="i sure do love my frog!"},
  {speakeridx=2,text="greg, please stop..."},
  {speakeridx=4,nameidx=4,text="ribbit."},
  {speakeridx=1,text="haha, yeah!"}
 },
 {
  {speakeridx=2,text="i dont like this at all"},
  {speakeridx=1,text="its a tree face!"},
  {speakeridx=23,text="*howls in the wind*"}
 },
 {
  {speakeridx=2,text="is that some sort of deranged lunatic?"},
  {speakeridx=2,text="with an ax waiting for victims?"},
  {speakeridx=6,text="*swings axe and chops tree*"},
  {speakeridx=1,text="we should ask him for help!"}
 },
 {
  {speakeridx=2,text="whoa... wait greg..."},
  {speakeridx=2,text="... where are we?"},
  {speakeridx=1,text="we\'re in the woods!"},
  {speakeridx=2,text="no, i mean"},
  {speakeridx=2,text="... where are we?!"},
 },
 {
  {speakeridx=2,text="we're really lost greg..."},
  {speakeridx=1,text="i can leave a trail of candy from my pants!"},
  {speakeridx=1,text="candytrail. candytrail. candytrail!"}
 },
 {
  {speakeridx=3,text="help! help!"},
  {speakeridx=2,text="i think its coming from a bush?"}
 },
 {
  {speakeridx=3,text="help me!"},
  {speakeridx=1,text="wow, a talking bush!"},
  {speakeridx=3,text="i\'m not a talking bush! i\'m a bird!"},
  {speakeridx=3,text="and i\'m stuck!"},
  {speakeridx=1,text="wow, a talking bird!"},
  {speakeridx=3,text="if you help me get unstuck, i\'ll"},
  {speakeridx=3,text="grant you a wish"},
  {speakeridx=1,text="ohhhh!"},
  {speakeridx=1,text="*picks up beatrice out of bush*"},
  {speakeridx=2,text="uh-uh! no!"},
 }
}
local triggers={
 {
  trig=function(self)
   return act_mapsidx==1 and (act_x!=8 or act_y!=8)
  end,
  action=function(self)queue_dialog(5)end,
  complete=false,
  maplocking=1,
  title="introduce ourselves",
 },
 {
  trig=function(self)return player_use_item(1,1)end,
  action=function(self)queue_dialog(6)end,
  complete=false,
  maplocking=1,
  title="leave a trail of candy",
 },
 {
  trig=function(self)return player_use_item(1,2)end,
  action=function(self)end,
  complete=false,
  maplocking=2,
  title="leave a trail of candy",
 },
 {
  trig=function(self)return player_sel_location({x=5,y=7})end,
  action=function(self)queue_dialog(3)end,
  complete=false,
  maplocking=2,
  title="find the tree with the face",
 },
 {
  trig=function(self)return playmap_spr_visible(33)end,
  action=function(self)queue_dialog(4)end,
  complete=false,
  maplocking=2,
  title="meet someone new"
 },
 {
  trig=function(self)return dialog_is_complete(4)end,
  action=function(self)queue_move_npc(6,{x=16,y=-1},3,{x=7,y=7})end,
  complete=false,
  maplocking=2,
  title="finish the conversation"
 },
 {
  trig=function(self)return player_on_location({x=10,y=4}) or player_on_location({x=11,y=4})end,
  action=function(self)queue_dialog(7)end,
  complete=false,
  maplocking=2,
  title="find a friend"
 },
 {
  trig=function(self)return player_sel_location({x=8,y=4})end,
  action=function(self)queue_dialog(8)end,
  complete=false,
  maplocking=2,
  title="search the bushes"
 },
 {
  trig=function(self)return dialog_is_complete(8)end,
  action=function(self)
   party[#party+1] = {charidx=3,x=act_x-1,y=act_y+1,cldwn=1}
  end,
  complete=false,
  maplocking=2,
  title="join your new friend"
 }
}
local menuchars={}
local stagetypes={
 {
  title="mainmenu",
  update=function(self)update_main_menu()end,
  draw=function(self)draw_main_menu()end
 },
 {
  title="controls",
  update=function(self)update_controls()end,
  draw=function(self)draw_controls()end
 },
 {
  title="intro",
  update=function(self)update_intro()end,
  draw=function(self)draw_introduction()end
 },
 {
  title="playmap",
  update=function(self)update_play_map()end,
  draw=function(self)draw_play_map()end
 }
}
local title_lines={
 {{sp=128},{sp=129},{sp=130},{sp=131},{sp=132},{sp=132,fh=true},{sp=131,fh=true},{sp=130,fh=true},{sp=129,fh=true},{sp=128,fh=true}},
 {{sp=144},{f=0},{sp=133},{sp=134},{sp=135},{sp=136},{sp=137},{sp=145},{f=0},{sp=144,fh=true}},
 {{sp=144},{f=0},{sp=146},{sp=147},{sp=148},{sp=149},{sp=150},{sp=151},{f=0},{sp=144,fh=true}},
 {{sp=144},{f=0},{sp=152},{sp=153},{sp=160},{sp=161},{sp=162},{sp=163},{f=0},{sp=144,fh=true}},
 {{sp=144},{f=0},{f=0},{sp=164},{sp=165},{sp=166},{sp=167},{f=0},{f=0},{sp=144,fh=true}},
 {{sp=168},{sp=169},{sp=176},{sp=176},{sp=176},{sp=176},{sp=176},{sp=176},{sp=169,fh=true},{sp=168,fh=true}}
}

-- base functions
function _init()
-- init main menu chars
 local genrandcnt=4
 repeat
  local choice=get_rand_idx(get_chars_w_dialog())
  if not is_element_in(menuchars,choice) then
   menuchars[#menuchars+1]=choice
  end
 until #menuchars==genrandcnt

 -- init frog intro name
 local randomname=get_rand_idx(characters[4].name)
 for i=1,#dialogs[1] do
  dialogs[1][i].nameidx=randomname
 end

 -- init object member fns
 for char in all(characters) do
  char.get_name_at_idx = function(this, idx)
   if type(this.name) == 'string' then
    return this.name
   elseif type(this.name) == 'table' then
    return this.name[idx]
   end
  end 
 end
end

function _update()
 get_stage_by_type(act_stagetype).update()
end

function _draw()
 get_stage_by_type(act_stagetype).draw()
end
-->8
-- update & draw fns
function update_controls()
 if btnp(4) then
  act_stagetype="mainmenu"
 end
end

function update_main_menu()
 if btnp(2) then
  act_y = act_y-1
  if (act_y==-1)act_y=2
  sfx(0)
 elseif btnp(3) then
  act_y = act_y+1
  if (act_y==3)act_y=0
  sfx(0)
 end
 if btnp(4) or btnp(5) then
  if act_y==0 then
   act_stagetype="intro"
   sfx(1)
  elseif act_y==1 then
   act_stagetype="controls"
  else
   stop()
  end
 end
end

function update_intro()
 if btnp(5) then
  act_dialogspeakidx+=1
  sfx(0)
 end
 if act_dialogspeakidx>#dialogs[1] then
  transition_to_playmap()
 end
end

function update_play_map()
 local initialdialoglen=#act_text.dialog
 -- check selection direction
 if btn(5) then
  pressed=nil
  for i=0,3 do
   if btn(i) then
    pressed=i
   end
  end
  if pressed != nil then
   act_lookingdir=pressed
  end
 else
  act_lookingdir=nil
 end
 -- check active movement
 if act_lookingdir == nil and #act_text.dialog == 0 then
  local ax,ay,mdx=act_x,act_y,act_mapsidx
  for i=0,3 do
   if btnp(i) then
    maybe_queue_party_move(act_x, act_y)
    break
   end
  end
  if btnp(2) and ay > 0 and is_element_in(split(walkable), mget(ax+maps[mdx].cellx, ay - 1+maps[mdx].celly)) then
   act_y = ay - 1
   last_mapidx_mov=act_mapsidx
  elseif btnp(1) and ax < 15 and is_element_in(split(walkable), mget(ax + 1+maps[mdx].cellx, ay+maps[mdx].celly)) then
   act_x = ax + 1
   act_flipv=false
   last_mapidx_mov=act_mapsidx
  elseif btnp(3) and ay < 15 and is_element_in(split(walkable), mget(ax+maps[mdx].cellx, ay + 1+maps[mdx].celly)) then
   act_y = ay + 1
   last_mapidx_mov=act_mapsidx
  elseif btnp(0) and ax > 0 and is_element_in(split(walkable), mget(ax - 1+maps[mdx].cellx, ay+maps[mdx].celly)) then
   act_x = ax - 1
   act_flipv=true
   last_mapidx_mov=act_mapsidx
  end
 end
 -- check for player switch
 if btnp(4) and #act_text.dialog == 0 then
  party[#party+1] = {charidx=act_charidx,x=act_x,y=act_y,cldwn=1}
  act_charidx = party[1].charidx
  act_x = party[1].x
  act_y = party[1].y
  party=drop_first_elem(party)
  local charname = tostr(characters[act_charidx].get_name_at_idx(characters[act_charidx],1))
  act_text.charsel={txt=charname,frmcnt=32}
 end
 -- check for dialog progress
 local x_consumed=false
 if btnp(5) and #act_text.dialog > 0 then
  x_consumed=true
  sfx(0)
  act_dialogspeakidx+=1
  if act_dialogspeakidx > #get_first_active_dlg() then
   if type(act_text.dialog[1])=='number' then
    compltdlgs[#compltdlgs+1]=act_text.dialog[1]
   end
   act_text.dialog=drop_first_elem(act_text.dialog)
   act_dialogspeakidx=1
  end
 end
 -- check for map switch
 local activemap = maps[act_mapsidx]
 local initmapidx = act_mapsidx
 local maplocked={}
 for t in all(triggers) do
  if t.maplocking != nil and t.maplocking == act_mapsidx and not t.complete then
   maplocked[#maplocked+1]=t.title
   break
  end
 end
 for transition in all(map_trans) do
  local to_map_idx,to_map_loc = nil,nil
  if transition.mp_one == act_mapsidx and last_mapidx_mov == act_mapsidx then
   for loc in all(transition.mp_one_locs) do
    loc = split(loc)
    if loc[1] == act_x and loc[2] == act_y then
     to_map_idx = transition.mp_two
     to_map_loc = split(transition.mp_two_locs[1])
    end
   end
  elseif transition.mp_two == act_mapsidx and last_mapidx_mov == act_mapsidx then
   for loc in all(transition.mp_two_locs) do
    loc = split(loc)
    if loc[1] == act_x and loc[2] == act_y then
     to_map_idx = transition.mp_one
     to_map_loc = split(transition.mp_one_locs[1])
    end
   end
  end
  if to_map_idx != nil and to_map_loc != nil then
   if to_map_idx<act_mapsidx then
    transition_to_map({mp=to_map_idx,loc={x=to_map_loc[1],y=to_map_loc[2]}})
   elseif #maplocked > 0  then
    if #act_text.dialog == 0 and not (nonrptdialog.x==act_x and nonrptdialog.y==act_y) then
     act_text.dialog[#act_text.dialog+1]={{speakeridx=act_charidx,text="we aren't done here yet... we should"}}
     act_text.dialog[#act_text.dialog+1]={{speakeridx=act_charidx,text=maplocked[1]}}
     nonrptdialog={x=act_x,y=act_y}
    end
   else
    transition_to_map({mp=to_map_idx,loc={x=to_map_loc[1],y=to_map_loc[2]}})
   end
   break
  end
  if act_mapsidx != initmapidx then
   break
  end
 end
 -- check for triggers
 for t in all(triggers) do
  if not t.complete and t.trig() then
   t.action()
   t.complete=true
  end
 end
 -- check for talk w/ npcs
 if #act_text.dialog == 0 then
  for npc in all(get_all_npcs()) do
   for i=-1,1 do
    for j=-1,1 do
     if i!=j and npc.x+i==act_x and npc.y+j==act_y then
      if player_sel_location({x=npc.x,y=npc.y}) then
       local idles=get_char_idle_dialog(npc.charidx)
       act_text.dialog[#act_text.dialog+1]=idles[get_rand_idx(idles)]
       x_consumed=true
      end
     end
    end
   end
  end
 end
 for m in all(maps) do
  for npc in all(m.npcs) do
   exec_npc_intent(npc)
  end
 end
 for p in all(party) do
  exec_npc_intent(p)
 end
 -- check for obj selection
 for i=-1,1 do
  for j=-1,1 do
   local x=act_x+i
   local y=act_y+j
   if player_sel_location({x=x,y=y}) then
    for descpt in all(objdescripts) do
     if is_element_in(split(descpt.spridxs),mget(x+maps[act_mapsidx].cellx,y+maps[act_mapsidx].celly)) and #act_text.dialog==0 then
      act_text.dialog[#act_text.dialog+1] = {{speakeridx=act_charidx,text=descpt.descr}}
      x_consumed=true
      break
     end
    end
   end
  end
 end
 -- check for item usage
 if btnp(5) and act_item!=nil and is_element_in(inv_items[act_item].charidxs,act_charidx) and not x_consumed then
  sfx(0)
  act_useitem=act_item
  if act_item==1 then
   act_wrld_items[#act_wrld_items+1]={spridx=inv_items[act_item].spridx,x=act_x,y=act_y}
  elseif act_item==2 then
   -- unimpl
  elseif act_item==3 then
   -- unimpl
  end
 end
 -- play sound if new dialog triggered
 if #act_text.dialog>initialdialoglen or act_lookingdir!= nil then
  sfx(2)
 end
end

function exec_npc_intent(npc)
 -- do npc movement
 if npc.intent == 'walk' then
  local npcmapidx=get_mapidx_by_charidx(npc.charidx)
  local intentdata = npc.intentdata
  -- goto dest if active map is not npc cur map
  if npcmapidx != act_mapsidx and npcmapidx!=nil then
   npc.x=-1
  end
  -- do local mvmt
  npc.cldwn-=1
  if npc.cldwn==0 then
   npc.cldwn=16
   if abs(intentdata.destcurmaploc.x-npc.x) > abs(intentdata.destcurmaploc.y-npc.y) then
    npc.x+=sgn(intentdata.destcurmaploc.x-npc.x)
   else
    npc.y+=sgn(intentdata.destcurmaploc.y-npc.y)
   end
  end
  -- do map switch
  if (npc.x < 0 or npc.x > 15 or npc.y < 0 or npc.y > 15) and npcmapidx != nil  then
   local newnpcs={}
   for i=1,#maps[npcmapidx].npcs do
    if maps[npcmapidx].npcs[i].charidx!=intentdata.charidx then
     newnpcs[#newnpcs+1]=maps[npcmapidx].npcs[i]
    end
   end
   maps[npcmapidx].npcs=newnpcs
   maps[intentdata.destnextmap].npcs[#maps[intentdata.destnextmap].npcs+1]={
    charidx=intentdata.charidx,
    x=intentdata.destnextmaploc.x,
    y=intentdata.destnextmaploc.y,
    cldwn=1,
   }
  end
  if (npcmapidx==nil and npc.x==intentdata.destcurmaploc.x and npc.y==intentdata.destcurmaploc.y) npc.intent=nil
 end
 if npc.intent == 'loop' then
  npc.cldwn+=1
  if npc.cldwn==1 then
   if npc.x==npc.intentdata.br.x and npc.y!=npc.intentdata.tl.y then
    npc.y-=1
   elseif npc.y==npc.intentdata.tl.y and npc.x!=npc.intentdata.tl.x then
    npc.x-=1
   elseif npc.x==npc.intentdata.tl.x and npc.y!=npc.intentdata.br.y then
    npc.y+=1
   elseif npc.y==npc.intentdata.br.y then
    npc.x+=1
   end
  elseif npc.cldwn==30 then
   npc.cldwn=0
  end
 end
end

function draw_controls()
 cls(0)
 draw_two_colored("\148\131\139\145, move",16,20)
 draw_two_colored("\151, progress dialog or\n use item",16,40)
 draw_two_colored("\142, switch characters",16,60)
 draw_two_colored("\148\131\139\145+\151, select object\n or npc",16,80)
 draw_two_colored("\142, back to menu",8,118)
end

function draw_main_menu()
 cls(0)
 -- draw logo
 local anchrx,anchry=16,4
 for i=1,#title_lines do
  local ln=title_lines[i]
  for j=1,#ln do
   local section=ln[j]
   local fliph=false
   if section.sp != nil then
    if section.fh != nil and section.fh then
     fliph=section.fh
    end
    spr(section.sp,anchrx+(j*8),anchry+(i*8),1,1,fliph,false)
   else
    rectfill(anchrx+(j*8),anchry+(i*8),anchrx+(j*8)+8,anchry+(i*8)+8,section.f)
   end
  end
 end
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
 -- draw 4 random chars
 drawchoices = get_chars_w_dialog()
 local icon_locs={{x=4,y=4},{x=108,y=4},{x=4,y=108},{x=108,y=108}}
 palt(0,false)
 for i=1,#icon_locs do
  draw_fancy_box(icon_locs[i].x,icon_locs[i].y,17,17,2,10,9)
  spr(drawchoices[menuchars[i]].chrsprdailogueidx, icon_locs[i].x+1, icon_locs[i].y+1, 2, 2)
 end
 palt(0,true)
end

function draw_introduction()
 local anchrx,anchry=32,16
 cls(0)
 -- draw bg
 draw_fancy_box(anchrx,anchry,64,52,0,4,5)
 -- draw frog
 pal(14,128,1)
 pal(5,133,1)
 pal(12,130,1)
 pal(1,132,1)
 pal(13,139,1)
 sspr(80,72,32,24,anchrx,anchry+4,64,48)
 pal(14,14)
 pal(5,5)
 pal(12,12)
 pal(1,1)
 pal(13,13)
 -- draw frog dialog box
 local currentprog=dialogs[1][act_dialogspeakidx]
 draw_character_dialog_box(currentprog)
end

function draw_play_map()
 local activemap=maps[act_mapsidx]
 -- color handling
 palt(0,false)
 palt(13,true)
 cls(139)
 -- draw map
 map(activemap.cellx, activemap.celly)
  -- draw ring around new active char
 if act_text.charsel != nil and act_text.charsel.frmcnt>0 and flr(act_text.charsel.frmcnt/5)%2==0 then
  pset(act_x*8,act_y*8+7,12)
  pset(act_x*8+7,act_y*8+7,12)
  line(act_x*8+1,act_y*8+6,act_x*8+6,act_y*8+6,12)
  line(act_x*8+1,act_y*8+8,act_x*8+6,act_y*8+8,12)
  pset(act_x*8,act_y*8+8,1)
  pset(act_x*8+7,act_y*8+8,1)
  line(act_x*8+1,act_y*8+9,act_x*8+6,act_y*8+9,1)
 end
 -- draw items
 for i in all(act_wrld_items) do
  spr(i.spridx,i.x*8,i.y*8)
 end
 -- draw player
 spr(characters[act_charidx].mapidx,act_x*8,act_y*8,1,1,act_flipv,false)
 -- draw npcs
 draw_chars_from_array(get_all_npcs())
 -- draw selection direction
 if act_lookingdir != nil then
  local lkdr=act_lookingdir
  local sel=get_sel_info_btn(lkdr)
  palt(5,true)
  spr(sel.i,8*(act_x+sel.x),8*(act_y+sel.y),1,1,sel.x==-1,sel.y==1)
  palt(5,false)
 end
 -- draw fog of war
 if activemap.type=='exterior' then
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
    if not nearforone and not is_element_in(activemap.discvrdtiles, idtfr) then
     dark[#dark+1]={i,j}
     local mspr=mget(i+maps[act_mapsidx].cellx, j+maps[act_mapsidx].celly)
     if (is_element_in(split(darkspr.idxs),mspr)) then
      -- draw "dark" sprite
      for e in all(darkspr.clrmp) do
       pal(e.s,e.d)
      end
      spr(mspr,8*i, 8*j)
      for e in all(darkspr.clrmp) do
       pal(e.s,e.s)
      end
     else
      if #darkanims<4 and flr(rnd(30000))==0 then
       darkanims[#darkanims+1]={frmcnt=35,type='eyes',x=i,y=j}
      end
      rectfill(8*i, 8*j,(8*i)+7, (8*j)+7,0)
     end
    elseif not is_element_in(activemap.discvrdtiles, idtfr) then
     activemap.discvrdtiles[#activemap.discvrdtiles+1]=idtfr
    end
   end
  end
  -- discover all undiscoverable tiles
  if #dark==activemap.undisc_cnt then
   for d in all(dark) do
    activemap.discvrdtiles[#activemap.discvrdtiles+1]=tostr(d[1])..'|'..tostr(d[2])
    sfx(2)
   end
  end
 end
 -- draw dark animations
 local ndas={}
 for d in all(darkanims) do
  local idtfr=tostr(d.x)..'|'..tostr(d.y)
  if d.frmcnt>0 and not is_element_in(activemap.discvrdtiles, idtfr) then
   ndas[#ndas+1]=d
   if d.type=='eyes' then
    local pcol=10
    if d.frmcnt<8 or d.frmcnt>27 then
     pcol=1
    end
    pset(d.x*8+2,d.y*8+4,pcol)
    pset(d.x*8+5,d.y*8+4,pcol)
   end
  d.frmcnt-=1
  end
 end
 darkanims=ndas
 -- draw active item hud
 if act_item!=nil and is_element_in(inv_items[act_item].charidxs,act_charidx) then
  draw_fancy_box(115,115,11,11,4,10,9)
  spr(inv_items[act_item].spridx,117,117)
 end
 -- draw active char hud
 local xanchor=1
 if act_x<=3 and act_y<=2 then
  xanchor=114
 end
 if act_text.charsel != nil and act_text.charsel.frmcnt>0 then
  if act_x<=3 and act_y<=2 then
   xanchor=90
  end
  local charname=act_text.charsel.txt
  draw_fancy_box(xanchor,1,#charname*4+11, 11, 4,10, 9)
  printsp(charname, xanchor+11, 6, 2)
  printsp(charname, xanchor+10, 5, 9)
  act_text.charsel.frmcnt-=1
 else
  draw_fancy_box(xanchor,1,11,11,4,10,9)
 end
 spr(characters[act_charidx].mapidx, xanchor+2, 3)
 -- draw map title
 txtobj=act_text.maptitle
 if txtobj != nil and txtobj.frmcnt > 0 then
  draw_fancy_box(txtobj.x, txtobj.y, #txtobj.txt*4+4, 8, 4,10, 9)
  printsp(txtobj.txt, txtobj.x+3, txtobj.y+3, 2)
  printsp(txtobj.txt, txtobj.x+2, txtobj.y+2, 9)
  txtobj.frmcnt = txtobj.frmcnt-1
 end
 -- draw dialog if necessary
 palt(13,false)
 if #act_text.dialog > 0 then
  local curprogressdlg=get_first_active_dlg()[act_dialogspeakidx]
  if curprogressdlg != nil then
   draw_character_dialog_box(curprogressdlg)
  end
 end
end

-->8
-- utilities
function get_npc_by_charidx(npcs,qcharidx)
 for n in all(npcs) do
  if n.charidx==qcharidx then
   return n
  end
 end
 return nil
end

function get_mapidx_by_charidx(charidx)
 for i=1,#maps do
  local m=maps[i]
  for n in all(m.npcs) do
   if n.charidx==charidx then
    return i
   end
  end
 end
 return nil
end

function get_first_active_dlg()
 local curprogressdlg=act_text.dialog[1]
 if type(curprogressdlg)=='number' then
  curprogressdlg=dialogs[curprogressdlg]
 end
 return curprogressdlg
end

function player_on_location(loc)
 return act_x+maps[act_mapsidx].cellx==loc.x and act_y+maps[act_mapsidx].celly==loc.y
end

function player_sel_location(loc)
 local lkdr=act_lookingdir
 if lkdr == nil then
  return false
 end
 local sel=get_sel_info_btn(lkdr)
 return act_x+sel.x == loc.x and act_y+sel.y == loc.y
end

function player_use_item(itemidx,mapidx)
 if act_useitem==itemidx and act_mapsidx==mapidx then
  act_useitem=nil
  return true
 end
 return false
end

function playmap_spr_visible(spri)
 local mapspr=sget(act_x+maps[act_mapsidx].cellx,act_y+maps[act_mapsidx].celly)==spri
 local npcspr=false
 for n in all(maps[act_mapsidx].npcs) do
  local idtfr=tostr(n.x+maps[act_mapsidx].cellx)..'|'..tostr(n.y+maps[act_mapsidx].celly)
  if is_element_in(maps[act_mapsidx].discvrdtiles,idtfr) and characters[n.charidx].mapidx==spri then
   npcspr=true
   break
  end
 end
 return mapspr or npcspr
end

function dialog_is_complete(dialogi)
 return is_element_in(compltdlgs,dialogi)
end

function trigger_complete(trigi)
 return triggers[trigi].complete
end

function queue_dialog(dialogi)
 act_text.dialog[#act_text.dialog+1]=dialogi
end

function maybe_queue_party_move(destx, desty)
 for p in all(party) do
  if flr(rnd(2)) == 0 and p.intent==nil then
   queue_move_npc(p.charidx,{x=destx,y=desty},nil,nil)
  end
 end
end

function queue_move_npc(charidx,destcurmaploc,destnextmap,destnextmaploc)
 for m in all(maps) do
  for npc in all(m.npcs) do
   if npc.charidx == charidx then
    set_walk_intent(npc,destcurmaploc,destnextmap,destnextmaploc)
   end
  end
 end
 for p in all(party) do
  if p.charidx == charidx then
   set_walk_intent(p,destcurmaploc,destnextmap,destnextmaploc)
  end
 end
end

function set_walk_intent(npc,destcurmaploc,destnextmap,destnextmaploc)
 npc.intent = "walk"
 npc.intentdata = {charidx=npc.charidx,destcurmaploc=destcurmaploc,destnextmap=destnextmap,destnextmaploc=destnextmaploc,mvmtcldwn=1}
end

function transition_to_playmap()
 act_stagetype = "playmap"
 act_charidx=2
 act_dialogspeakidx=1
 act_item=1
 party={{charidx=1,x=nil,y=nil,cldwn=1},{charidx=4,x=nil,y=nil,cldwn=1}}
 transition_to_map({mp=1,loc={x=8, y=8}})
 pal(14,14,1)
 pal(5,5,1)
 pal(12,12,1)
 pal(1,1,1)
 pal(13,13,1)
end

function transition_to_map(dest)
 act_mapsidx = dest.mp
 act_x = dest.loc.x
 act_y = dest.loc.y
 act_wrld_items={}
 for i=1,#party do
  didadd=false
  repeat
   x=act_x + flr(rnd(3) - 1) * 1
   y=act_y + flr(rnd(3) - 1) * 1
   if is_element_in(split(walkable), mget(x+maps[act_mapsidx].cellx, y+maps[act_mapsidx].celly)) then
    didadd = true
    party[i].x=x
    party[i].y=y
    party[i].intent=nil
    party[i].intentdata=nil
   end
  until didadd
 end
 local titlex=63-(2*#maps[act_mapsidx].title)
 act_text.maptitle={x=titlex,y=56,txt=maps[act_mapsidx].title,frmcnt=60}
 -- check alt tiles
 local amcx,amcy=maps[act_mapsidx].cellx,maps[act_mapsidx].celly
 if not is_element_in(altsset, act_mapsidx) then
  local srctiles=get_sourceidxs()
  for i=0,15 do
   for j=0,15 do
    local tilspr=mget(i+amcx, j+amcy)
    if (is_element_in(srctiles,tilspr)) then
     local dsts=split(get_by_source(tilspr).dsts)
     local randsel=get_rand_idx(dsts)
     mset(i+amcx, j+amcy, dsts[randsel])
    end
   end
  end
  altsset[#altsset+1]=act_mapsidx
 end
 -- add buildings
 for m in all(maps) do
  if m.type=='interior' and m.playmapidx==act_mapsidx then
   mset(m.playmaploc.x+amcx,m.playmaploc.y+amcy,m.playmapspr)
   mset(m.playmaploc.x+amcx+1,m.playmaploc.y+amcy,m.playmapspr+1)
   mset(m.playmaploc.x+amcx,m.playmaploc.y+1+amcy,m.playmapspr+16)
   mset(m.playmaploc.x+amcx+1,m.playmaploc.y+1+amcy,m.playmapspr+17)
  end
 end
end

function distance(x1, y1, x2, y2)
 return sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function get_stage_by_type(stagetype)
 for i=1,#stagetypes do
  if stagetypes[i].title==stagetype then
   return stagetypes[i]
  end
 end
 return nil
end

function get_rand_idx(arr)
 return flr(rnd(#arr))+1
end

function get_char_idle_dialog(charidx)
 local idle_dialogs={}
 local idles=characters[charidx].idle
 for idle in all(idles) do
  idle_dialogs[#idle_dialogs+1]={{speakeridx=charidx,text=idle}}
 end
 return idle_dialogs
end

function get_chars_w_dialog()
 chars={}
 for char in all(characters) do
  if char.chrsprdailogueidx != -1 then
   chars[#chars+1] = char
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
 return union_arrs(party, maps[act_mapsidx].npcs)
end

function union_arrs(arr1, arr2)
 local newarr={}
 for i in all(arr1) do
  newarr[#newarr+1]=i
 end
 for i in all(arr2) do
  newarr[#newarr+1]=i
 end
 return newarr
end

function draw_chars_from_array(npcs)
 for npc in all(npcs) do
  if npc.x != nil and npc.y != nil then
   local sp=characters[npc.charidx].mapidx
   local sx,sy=(sp%16)*8,(sp\16)*8
   local scaling=1.0
   if characters[npc.charidx].scaling != nil then
    scaling=characters[npc.charidx].scaling
   end
   sspr(sx,sy,8,8,npc.x*8,npc.y*8,8*scaling,8*scaling)
  end
 end
end

function draw_character_dialog_box(dialogobj)
 local nameidx=1
 if dialogobj.nameidx != nil then
  nameidx=dialogobj.nameidx
 end
 draw_fancy_box(8,100,112,24,4,10,9)
 print(characters[dialogobj.speakeridx].get_name_at_idx(characters[dialogobj.speakeridx],nameidx), 30, 104, 2)
 print(characters[dialogobj.speakeridx].get_name_at_idx(characters[dialogobj.speakeridx],nameidx), 29, 103, 9)
 if #dialogobj.text<=22 then
  printsp(dialogobj.text, 29, 110, 0)
 else
  local chi=-1
  for i=23,1,-1 do
   if is_element_in(split(",.? ",""),sub(dialogobj.text,i,i)) then
    chi=i
    break
   end
  end
  printsp(sub(dialogobj.text,1,chi).."\n"..sub(dialogobj.text,chi+1), 29, 110, 0)
 end
 draw_fancy_box(10,103,17,17,0,6,5)
 spr(characters[dialogobj.speakeridx].chrsprdailogueidx, 11, 104, 2, 2)
 print("\151",105,118,0)
 palt(5,true)
 pal(12,0)
 spr(234, 112, 116)
 palt(5,false)
 pal(12,12)
end

function get_sel_info_btn(lkdrbtn)
 local spri,selx,sely=234,0,2*lkdrbtn-5
 if lkdrbtn==2 or lkdrbtn==3 then
  spri=250
 else
  selx=2*lkdrbtn-1
  sely=0
 end
 return {i=spri,x=selx,y=sely}
end

function drop_first_elem(arr)
 newarr={}
 for i=2,#arr do
  newarr[#newarr + 1]=arr[i]
 end
 return newarr
end

function draw_fancy_box(x,y,w,h,fg,otlntl,otlnbr)
 rectfill(x+1,y+1,x+w-1,y+h-1,fg)
 line(x+1,y,x+w-1,y,otlntl) -- top line
 line(x+1,y+h,x+w-1,y+h,otlnbr) -- bottom line
 line(x,y+1,x,y+h-1,otlntl) -- left line
 line(x+w,y+1,x+w,y+h-1,otlnbr) -- right line
 pset(x,y+h,0) -- left black dot
 pset(x+w,y+h,0) -- right black dot
 line(x+1,y+h+1,x+w-1,y+h+1,0) -- bottom black line
end

function draw_two_colored(s,x,y)
 local st=split(s)
 print(st[1],x,y,10)
 print(st[2],x+(#st[1]*8),y,7)
end

function get_by_source(source)
 for altobj in all(alttiles) do
  if altobj.srcidx==source then
   return altobj
  end
 end
 return nil
end

function get_sourceidxs()
 local sources={}
 for altobj in all(alttiles) do
  sources[#sources+1]=altobj.srcidx
 end
 return sources
end

function is_element_in(array, k)
 local match = false
 for elem in all(array) do
  if k == elem then
   match = true
   break
  end
 end
 return match
end

function string_n_inst(hs, n, inst)
 local match = nil
 local mcount = 0
 for i=1,#hs do
  if sub(hs,i,i) == n then
   mcount = mcount + 1
   if mcount == inst then
    match = i
    break
   end
  end
 end
 return match
end

-->8 from our friends
-- print small and pretty
function printsp(s,...)
 print(smallcaps('^'..s),...)
end

-- thanks http://lua-users.org/wiki/copytable
function deepcopy(orig)
 local orig_type = type(orig)
 local copy
 if orig_type == 'table' then
  copy = {}
  for orig_key, orig_value in next, orig, nil do
   copy[deepcopy(orig_key)] = deepcopy(orig_value)
  end
  setmetatable(copy, deepcopy(getmetatable(orig)))
 else -- number, string, boolean, etc
  copy = orig
 end
 return copy
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

__gfx__
dd6666dd88888ddd6d66666666666666dddd88888888888ddddddddddddddddddddddddddddddddddddddddddd9aa9dddddddddddddddddddddddda999addddd
d666666dd88888ddd6666666666666d6ddd888888888888ddddddd6666dddddddddddddddddddddddd4dd4dddd2fffddddddddddddddddddddddaaaa99addddd
6d4444d6d84444dddd666666666666ddddd888888888888ddddd66666666dddddddddddddddddddddd1111dddd20f0dddddddd0000ddddddddd999909099addd
d6f0f0ddddf0f0ddddd6444444446dddddd88888888888ddddd6666666666dddddddbbddddbbdddddd41111d0d2aaad0dddd00000000dddddda9f00fff009add
ddffffddd1ffff1dddd4444444444ddddd888844444888ddddd6666666666ddddddbbbbddbbbbddddd4040dd00000000ddd0000000000ddddd9ff777f777f9dd
d737737dd697796ddd44774ff47744dddd8877ffff7748dddd667766667766ddddb3773bb3773bddd744447dd000000dddd0100111001ddddddff077f077fddd
d733337dd677776dddf7607ff7607fdddd47607ff76074dddd676076676076ddddb7607bb7607bddd477774dd000000dddd10aa010aa0ddddddfffffeffffddd
dd0dd0ddd202202dddf7007ff7007fddddf7007ff7007fdddd670076670076dddd370073370073ddddcddcdddd0dd0ddddd10a0111a00ddddddff9feefaffddd
ddddddddddddddddddff77ffff77ffddddff77ffff77ffdddd667766667766dddd337733337733dddddddddddddddddd1dd0100111001dd1dddff09aaa0ffddd
dddddddddddddddddddff0ffff0ffddddddff0ffff0ffdddddd6666556666ddddd3b03333330b3dddd4dd4dddd5dd5dd01d0008888000d10ddddff0000ffdddd
ddddd60ddddddddddddff000000ffddddddfff0000fffdddddd6665555666ddddd3bb000000bb3ddddaaaeddddccccdd00d0887676880d00dddddffffffddddd
dccce665ddd3d3ddddddff0000ffddddddddffffffffdddddddd66655666ddddddd3bbbbbbbb3ddddd47777ddd55cccd0dd8670000678dd0ddddd22222dddddd
ddcceeddddd030ddddd733ffff337dddddddd1ffff1dddddddddee6666eedddddddd33333333dddddd4040dddd0000dd0d008867678800d0dd51cfffffc150dd
dd9c77dddd3333dddd773377773377ddd11111177111111dddd7eeeeeeee7dddddd3333333333ddddd4444ddd5c7775d0d000088880000d0d0001ccfcc10000d
ddddddddd3333dddd77733777733777d1111197777911111ddc77eeeeee77cddddb3333333333bddd4aaaa4dd5cccc5d00110110100011000000011111000000
ddddddddd3b3bdddd77333333333377d1197777777777911dcc7777777777ccddbb3333333333bbdddaaaadddd0dd0dd00001001011100000000000000000000
51dddd15dd0000dd1d5d5ddddddd5d15dd655555555555ddd00ddd0000ddd00ddddddddddddddddd0020202000202020ddddddddddddddddddddd4ddddd4dddd
15111151dd0000dd11d5ddddddd5511dd65555555555552dd00d00000000d00dddd4444444444ddd0004740000944490ddddddddddddddddddddd44dddd44ddd
51161615d000000dd115dd1111d51155d66666666666622dd000c00000c0000dd44477444477444d0004440000045400dddd4dddddd4dddddddd444dde4e4ddd
d511115dddf0f0dd5511d6611665155dd65555555555552ddd0cac000cac00dd44476074476074440004740000045400ddd44dddccd44ddddddd99999eee9ddd
ddd11dddd54ff44add51677667761ddddd666666666662ddddcaeac0caeac0dd44470074470074440004740000045400ddd4411111144dddddd99977997999dd
d111111d460000a9d5dd67766776d5ddddff760ff760ffdddcaeeea0aeeeacdd44447744447744440004440000044400ddd44ccc11144dddddd27744774774dd
d111111dd6000060dddd16611661ddddddff700ff700ffddddcaeac0caeac0dd4d444440044444440004740000202020ddd441cccc144dddddd24aa444aa44dd
1d1dd1d1dd5dd5dddddd11111111ddddddfff7799f77ffdddd0cac000cac00dd4d44f700007744d40020202000002000dddd4aa444aaddddddd24a0444a044dd
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
dd999ddddd9999dddddddddd44ddddddddddddd444dddddddddd22244422ddddd44444444422244d4424444244244244333332333333433333333333ddddd666
d90909ddd944944ddddddd94444ddddddddddd99444ddddddd333333333333dd44444244444444444422244244422444333324333344944333bbbb33dddd6665
d99999ddd999999ddddd99999999dddddddd99999999dddddddd99999999ddddd44224442222244d442442224442444433323233333993333bbbbbb3dddd4655
d90009dddd9777ddddd9900999009dddddd9900999009dddddd9900999009dddd42444444444424d4222442444424444332323433339933333bbbb33dddd445d
dd999dddd3a3a3adddd9000090000dddddd9000090000dddddd9000090000ddddd444774447744dd4244222444442444334233333333233333bbbb33ddd44ddd
d7d6d7ddd3a3a3addd9a0000a0000adddd9a0000a0000adddd9a0000a0000addddd47607f7607ddd4224442444442444332333333444244333bbbb33dd44dddd
dd767dddd3a3a3addd99a00a9a00a9dddd99a00a9a00a9dddd99a00a4a00a9dddddd7007f7007ddd224222444442244434343333334444333b3333b3444ddddd
dd6d6dddd3a3a3addd999aa999aa99dddd999aa900aa99dddd999aa444aa99dddddde77fff77eddd2444424444244244333333333333333333333333d4dddddd
dd4444ddddd00ddddd999888888999dddd99999a00a999dddd999899498999ddddddff8fff8ffddd333333333333333333333333333333330222202234444433
d44444dddd0a0addddd9876676789dddddd99999aa999dddddd9878888789ddddddddff888ffdddd333333333333333333353333333333332020002044444443
ddf0f0dddd0000ddddd9867767689dddddd9a0000000adddddd9867767689dddddddddfffffddddd333333333344333335553335333333332020202044222243
ddeffedd0d0220d0dddd98888889dddddddd9aaaaaaadddddddd98888889dddddddddd6fff6ddddd333333334423333355555355533333332000200034220243
d776677d00000000ddddff9999ffdddddddddd9999ddddddddddff9999ffddddddddd656f656dddd333333449923333335577765333333332020202034200243
df7777fdd000000dddaaffffffffaaddddd7777777777dddddaaffffffffaadddd777656665677dd333344323992333335700077333333330020002044000043
d555555dd000000daaaaffffffffaaaad77dd777777dd77daaaaffffffffaaaa7777765565567777334432329392333335600077333333332020202033444b3b
d54dd45ddd0dd0ddaaffffffffffffaa7dd77dd77dd77dd7aaffffffffffffaa77777766766777773432323329443333377500763335533320002000333333b3
00000000000000009090000000000000000000000000000000000000000000000000000000000000329233234434222337755077335555552202220222222244
00099900000000990900009009000004444000000000000000000000000000000000000000000000329323442499233337777777366556630000000046666644
00900090000000000900090000900040000402200aaaa00a0000a0aaaaa0aaaa000aaaaaaa0a000a323944242929933337777667755577730222022246907944
0900200900000090900900999900000000000220a9999a0a0000a0a99990a999a00a99a99a0a000a32442422299b9b3334740077550700730000000045970944
0902420900009009009000000000004444400000a0000a09a00a90a00000a000a00900a0090a000a343992233399b33335444077500600632202220220202044
0900200900090009090900999900000990040020a0000a00a00a00aaaaa0aaaa900000a0000a000a339929333333333334544074400705730000000027676744
0090000090009990000009000090009009000002a0000a00a00a00a99990aa99000000a0000aaaaa3b9b99333333333355454476677557730222022242555244
0000000944444444444444444444444444444444a0000a00a00a00a00000a9aa000000a0000a999a33b993333333333344544974475557730000000042444244
0000090400000000a0000a009aa900a000a0a099a00000a0000a000a0a000a0000000a00aaaa00a0000004444444444400000000000000004244444433333333
00000094000000009aaaa9000aa000aaaaa0a000a0000aaa000a000a0aaaaa0000000a0099a900aa0000004eeeeeeeee44444444444000004244424434444443
004400940aaaaa0009999000099000999990900090000999000900090999990000000a0000a00a990000004eeeeeeeeeeeeeeeeee45e00004444424434222243
044440940a999900000000000000000000000000000000000000000000000000000009aaaa900a000000004eeccccccceeeeeeeee455e0004aaaaaa434422443
024420940a000000000000aaaa00000aa000aaaa00aaaa000aaaaa0aa00a000000000099990009000000004eeccbcc77cccccccee455e000aa9999aa34444443
002200940aaaaa0000000a9999a0000aa000a999a09a99a00a99990aa00a000000000000000000000000004e3cb7766777cccccee455e000a9aaaa9a33b22333
000000940a99990000000a00009000a99a00a000a00a009a0a00000a9a0a00000000000000a000a00000004333307b777666cccee455e000a999999a333b2333
000009040a00000000000a00000000a00a00aaaa900a000a0aaaaa0a0a0a00000000000000a000a000000033333bbbb77777cccee455e0004a9999a433333333
0a00aa99000a000a0a99990a0a0a0000009a009a00a00a99a00a00000a000000009000004444444400000033333bdbb47667cccee455e000a9a9a9a920202020
aa00a9aa000a000a0a00000a0a0a0000000a00aa00a00a00a00a00000a0000000009040009000000000004333333bdde444444444455e0009a999a9900200020
99a0a099a00a00a90a000a0a09aa0000000a00aa0a900a00a00a00000a00000000090420900440900000433333333bbeeeeeeeee4455e000a9a9a9a920202020
00a0a000a0aaaa900aaaaa0a00aa0000000a00aa0a000aaaa00a00000a0000000090040000444409000473333333bbbebbeeeee4c455e0009a999a9920002000
009090009099990009999909009900000009aa99aa00a9999a0a000a0a000a000900002090244200000463333333bbbb70770774c455e0009a999a9920202020
000000000000000000000000000000000000aa00aa00a0000a0aaaaa0aaaaa0000900000000220090000443333333b4666666664c455e0009a999a9900200020
00a000aa000a00000a00000000000000000099009900900009099999099999000009009090000900000000433333bbb4444444444455e0009a999a9920202020
00a000aa000a00000a000000000000000000000000000000000000000000000000009900090000990000004e3333b22eeeeeeee5e455e0004a944a9420002000
444444444444404444444444444444444444444488888888ddd0555555550ddddd5555dd124414440000004e12ccccc2eeeeeee1e455e0004244444444444444
000000004444424044222224444444444444444488888888dd006555555600dddd6666dd41112244000004ee5e22222eeeeeeee1e45e00004343424444442244
090440904444424244455544424444444444444488888888d05066666666050dd555555d444444440000004444411dadeeeeeee5e4e000004234424444444444
904444094442242444547754452444444444444488888888dd050666666050dddd7070dd114111410000000000011dda44444444400000004244424411111111
002442004672267444500754452444444444444488888888ddf0500000050fddddffefdd4441241400000000001111a000000000000000004243434444444444
900220097662266544500054454244444444444488888888ddf0555555550fddd000000d42144114000000000104001000000000000000004244324442244444
009009004656565444500054450005044444444488888888ddff00000000ffddd000000d44441444000000000104001000000000000000004244424444444444
990000994442244444455544445550004444444488888888df0ffffffffff0fddd5dd5dd11111111000000000000000000000000000000004444424411111111
d4444444444444d0dddddddddddddddd8888888888888888dff0777007770ffd444444442020202033333333333333333333333333333333cccccccc44444444
d2444444444444d4dddddddddddddddd8888888888888888dff5777f5777fffd4222222402002022333333333b3b33333333333333333333cccccccc44444444
dd44444949444442dddddddddddddddd8888888888888888ddd5777e5777fddd42333324000000003333333333b33333333bbb3333333333cccccccc44444444
d44449904099444ddddddddddddddddd8888888888888888dddfffeefffffddd4237732400000000333333333333333333bbbbb333333333cccccccc44444444
0244900040009444d5dddddc1ddddd5d8888888888888888dddff666666ffddd42333324000002003b3b33333333b3b33bbbbbb333333333cccccccc44444444
dd24000292000944d75dccc1ccccd57d8888888888888888d00f6ffffff6f00d427733242020002033b3333333333b333bbbbbb333333333cccccccc44444444
ddd4002904200042d75c11111111c57d88888888888888880555ffffffff5550425555240220202033333333333333333bbbbbb333333333cccccccc44444444
04d420400440204dd755c11ccccc557d88888888888888880005555500055000424444242000200033333333333333333333333333333333cccccccc44444444
d24404499444440dd5555cc11115555d888888888888888888888888888888884288682444444444333333330343433033333333ccc7cc7ccccc7ccc44464446
ddd044900994040ddd7007700077007d8888888888888888888888888888888842666824444424444332483434334444333333337ccc7cc7c56667cc45646564
dd4499000009444ddd7076070760707d888888888888888888888888888888882288662244425524343443430433442333333333c7cc7cc75666667c44544454
dd4900022000944ddd7070070700707d888888888888888888888888888888884222222444655254243423433343040333333333c7cc7c7c5666667c44446464
dd4000244000042dd77007700577007788888888888888888888888888888888442aa244425625543844443233344423333333337cc7cccc5666667c44644654
dd420244042024ddddd70000500507dd888888888888888888888888888888884429924440526522332243333333002333333333ccccc7ccc566667c44644464
d4404444044404dddd7777775007777d888888888888888888888888888888884429824445252644334443333330420333344233cccccc7cc56667cc56545664
d4004440444042dddddc1c55055555dd888888888888888888888888888888884222222440504444344422333044222330442243ccccc7cccccc7ccc45444554
333333333333333333333333333333333333333663333333888888888888888833333332233333335555555533399933333333337ccccccccccccccc44444466
333333355000333333355533333333333333336aa6553333888888888888888833333388883333335c55c55533999a9333333333c7ccc7cccccc7ccc46454454
3333335445000333355555553333333333333379a75553338888888888888888333333377333333355c55c55399aa999333333337ccccc7cccc657cc45456644
33333544445000335555555553333333333366666666553388888888888888883333333882223333555c55c5a99999a933bbb333cc7ccc7ccc66657c45445644
33335440044500033677776633333333333622222222655388888888888888883333338778222333555c55c53a9aaa933bbbbb33ccc7c7cccc66657c44445554
3335444004445000377000773333333333622227722226238888888888888888333338777782223355c55c55334242333bbbbbb3ccc7ccccc66657cc46644444
335444400444450036600077333333333338877777788223888888888888888833338777777822235c55c5553a2422333bbbbbb3ccc7cccccccc7ccc45645666
35444444444444503770007655555333333777777777722388888888888888883338777777778223555555559444422333333333cc7ccccccccccccc44444554
334444444444442237700077555555553337222222227223888888888888888833877777777778235555555543343434ddddddddddddd766dddddddddddddd2d
3344444444444422447777776666666333378877787c722388888888888888883337777777777663555cc55543439343dddddddddddd7666dd5d5d6ddddd8d22
334444444444442255777667777777733337887778c772238888888888888888333700766700766355c55c5544333443dddddddddddd6465dd959dd6ddd888dd
3345522222554422447444777007007333378877987c7223888888888888888833370076670076635c5555c534434232daadaaaddddd445ddd5557d6dd88888d
33442442442444225574447770060063333788777888722388888888888888883337777667777663555cc55593442323aa9a99aaddd44ddddd666676d88888dd
3344244244244422446449744007007333378877788872238888888888888888333777766777766355c55c5533424233a9a9aa9add44ddddd6d65567dd888ddd
334424424424442255744476677777733337444444447233888888888888888833377755557776635c5555c533242233a99a999a444dddddddd5d66622d8dddd
334424424424442344744474477667733332222222222333888888888888888833377666666776335555555594444229da9999add4ddddddddddd5ddd2dddddd
__map__
ebebebebebebebebebebebebebcfcfcfcfcfcfebcececeebebebebebebebebebcdecececcdcdcfcfecececcdcdcdcdebebebebebebebebebebcfcfcfebebebeb7e8e8e8e8e8e8e8e8e8e8e8e8e7e8e7e7e8e8e8e8e8e8e8e8e8e8e8e8e8e8e7eebebebebebebebcfcfebebebebebebebebebebebebebebebebebebebebebebeb
ebcdebcdebdccdeccdcdcdebcdcfcfcfcfcfcfecebcececdcdecebebebebebebcdcdcdcdcdcdcfcfececcdcdcdcdceceebebebcdcdcdcdcdcdcfcfcdcdcdcdebafbfbfd9d9d9bfbfbfd85bbfbfafbfafafbfbfbfbf4abfbfbfbfbfbfbfbfbfafebcdcdcdcdcdcdcfcfcdcdcdcdcdcdebebcdcdcdcdcdcdcdcdcdcdcdcdcdcdeb
ebcdeccdcdeccdcdcdcdececcfcfcfcfebcfcfcfcecececdcdcdcdebdbebebebcdcdebcdcdcdcfcfeccdcdcdebcececeebebcd6ccdcdcdcdcdcfcfcdbe9ecddc2abfbfbfbfbfbf5abfbfbf3bbfafbf2aafbfbfbfbfbfbfbfbfbfbfbfb9b9bfafebcdcdeccdcdcdcfcfcdcdcdeccdcdebebcdcdcdcdcdcdcdcdcdcdcdcdcdcdeb
ebcdcdebcdcdcdebcdeccfcfcfcfcfebebebcfcfeecececdcdcdcdcdcdebebebcdebebcdebcdcfcfcdcdcdcdcecececdebcd6ccfcfcfcf6ccfcfcfcd9e9ecdebafbfbfbfbfbfbfbfbf3bbfbfbfafbfaf2abfbfbfbfbfbfbfbfbfbfbfbfbfbf2aebcdcdcdcdcdcdcfcfcdebcdcdcdcdebebcdcdcdcdcdcdcdcdcdcdcdcdcdcdeb
ebcdcdcdecececececcfcfcfcfcfcdebebebceceeeeecfcfcfebeccdcddcebebcdcdcdcdebcdcfcfcdcdececcececdebeb6ccfcfcfcfcfcfcfcfcd6d9e9ecdebafbfbfbfbfbfbfbfbfbfbfbfbfafbfafafbfb9b9bfbfbfbfbfbfbfbfbfbfbfafebcdcdcdcdcd6ccfcfcdebebcdcdcdebebcdcdcdcdcdcdcdcdcdcdcdcdcdcdeb
ebebcdeccfcfcfcfcfcfcfcfeccdcdebcecececeeecfcfcfcfcfcfeccdcdebebcdebebcdebcdcfcf9fcdcdecceceebcdebcdcdcdcdcfcfcfcfcfcd9ebe9ecdeb2bbfbfbfbfbfbfbfbfbfbfbfbf2bbf2aafbfbfbfbfbfbfbfbfbfbfbfbfbf5bafebcdeccdcdebcfcfcfcdebcdcdcdcdebebcdcdcdcdcdcdcdcdcdcdcdcdcdcdeb
ebcdcdcfcfcfcfcfcfcfcfcfeccdebebcececeebcfcfcfcfcfcfcfcdcdcdebebcdcdcdcdcdcdcfcfcfcdcdcdcecececdebebececcdcfcfcfcfcfcdcdbe9ecdebafbfbfbf4abfbfbfbf3abfbfbfafbfafafbfbfbfbfbfbfbfbfbfbfbfbfbf5bafebcdcdcdebcdcfcfcdebcdcdcdeccdebebcdcdcdcdcdcdcdcdcdcdcdcdcdcdeb
ebcdcdcfcddbcdcfcfcfececcdcdecebceceebebebcfcfcfcfcfebebcdcdebebebcdcdcdcdeccfcfcfcfcdcdcdcececeebcdcdcdcd6dcfcfcfcfe8e9ececcdcd7e8e8e8e8e8e8e8e8e8e8e8e8e7ebfafafbfbfbfbfbfbfbfbfbfbfbfbfbf5bafebcdcdcdebcdcfcfeccdebcdcdcdcdebebcdcdcdcdcdcdcdcdcdcdcdcdcdcdeb
ebebcdcfcdcdcfcfcfeccdcdcdcdcdebebebebebeb6ccfcfcfcfecebebcdebebcdcdebebcdcdeccfcfcfcdcdcdcdceceebcd9ebe9ecdcdcfcfcff8f9cdcdcdaeafd9d96bbfbf4ab2bfbf3abfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfb9b9bfafebcdcdcdcdebcfcfcfecebebcdcdcdebebcdcdcdcdcdcdcdcfcdcdcdcdcdcdeb
ebcddccfcfcfcfcfeccdebcdcdebcdebebebebeb6ccfcfcfececebebeccdebebcdebcdcdcdcdeccfcfcfcfcdcdcdcdcdebcd9e9e9ebecdcdcfcfcfcdcdaeaeaeafbfbf6bbfbfbfbfbfbfbfbfbfbfbfafaf5bbfbfbfbfbfbfbfbfbfbfbfbfbfafebcdcdcdcdcdcdcfcfcdebcdcdcdcdebebcdcdcdcdcdcdcfcfcdcdcdcdcdcdeb
ebcdcdcfcfcfcfeccdcdcdcdeccdebebebebeb6ccfcfcfecebebebebcdcdebebcdcdcdcdebcdcdeccfcfcfcfcdcdebebebcdbe9ebe9e6e6ecfcfeccdaeaeaeae2abfbf6bbfbfbfbfbfbfbfbfbfbfbfafaf5bbfbfbfbfbfbfbfbfbfbfbfbfbfafebcdcdcdcdcdcdcfcfcdcdcdcdcddbebebcdcdcdcdcdcdcfcfcfcfcfcdcdcdeb
ebcdcfcfcfcfeccdcdcdcdcdcdcdebebebeb6ccfcfcfcdebcdcdebebcdcdebebebcdcdcdebebcdcdeccfcfcfcfcdcdebebcd9e9ebecdcd6ccfcfeccdaeaeaeaeafbfbf6bbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfafebcdeccdcdcdcdcfcfcdebcdcdcdcdebebcdcdcdcdcdcdcfcfcfcfcdcdcdcdeb
ebcfcfcfcfcdcdcdcdeccdebcdcdebebeb6ccfcfcfcdcdcdcdcddceccdcdebebebcdcddccdebcdcdcdcdcfcfcfcfcdebebcdcdcdcdcdcfcfcfcfeccdaeaeaeae2abfbf6bbfbfbfbfbfbfbfbfbfbfbfaf2abfbfbfbfbfbfbfbfbfbfbfbfbfbf2aebcdcdcdcdcdeccfcfcdebcdcdcd9eebebcdcdcdcdcdcfcfcfcdcdcdcdcdcdeb
cfcfcfcfcdcdebcdebcdcdcdcdeccdebebcfcfcfcdcdcdcdcdcdcdcdcdcdebebebcdcdcdcdcdcdcdcdcdcdcfcfcfcfcfebcdaeaeaecdcfcfcfcf7a7baeaeaeaeafbfbf6abfbfbfbfbfbfbfbfbfbfbfafafb9b9bfbfbfbfbfbfbfbfbfbfbfbfafebcdaeaeaeeccfcfcfcdebcdcd9eebebebcdcdcdcdcdcfcfcdcdcdcdcdcdcdeb
cfcfcfcdcdcdeccdcdcdcdebcdcdcdebcfcfcfcfcdcdcdecdccdcdcdcdcdebebebdbcdcdcdcdcdcdcdcdcdcdcdcfcfcfebcdaeaeaecdcdcfcfcf8a8baeaeaeaeafbfbf6bbfbfbfb1bfb2bfb25b5bbfafafbfbfbfbfbfbfbfbfbfbfbfbfbf4aafebaeaeaeaeaecfcfcdcdcdcd9eebebebebcdcdcdcdcdcfcfcdcdcdcdcdcdcdeb
cfcfebebebebebebebebebebebebebebcfcfcfebebebebebebebebebebebebebebebebebebebebebebebebebebcfcfcfdbcdaeaeaeaecdcfcfcdcdcdcdaeaeae7eafafafafafafafafafafafafafaf7e7e8e8e8e8e8e8e2b2b8e8e8e8e8e8e7eebaeaeaeaeaecfcfebebebebebebebebebebebebebebcfcfebebebebebebebeb
ebebebebebebebebebebebebebebebeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdcdcdcdcdcdcdcdcdebebebeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdebcdcdcdcdcdcdcdcdcdebeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdebebcdebcdcdcdebebcdcdebeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdebebecebebcdebcdecebebcdebcf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdebeccdebcdcdebebcdcdebcdcfcf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdcdcfcfcfcfcfcfcdcdcdcfcf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cfcfcfcfcfcfcfcfcfcfcfcdcfcfcfcf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcfcfcfcfcfcfcfcfcfcfcfcdeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdcdcfcfcfcfcfcfcdcdcdcdeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdebeccdcdcdcdcdcdcdcdcdcdeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdebebebcdcdcdebebcdcdebebeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebebebcdcdcdcdcdcdcdecebebebebeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebebebebcdcdcdcdcdebebebcdcdebeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebebebebebcdcdcdcdcdcdcdcdcddbeb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200001a7201b7201d7201f72000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
9114000020552205522355221552205521e552205522c552245522a5522d5522c5522a5522c5522c5522a5522a5521c5521c5521c55230552305522a5001c5000050200502005020050200002000020000000000
00060000277502a7502c7500070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
001000000110002100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100

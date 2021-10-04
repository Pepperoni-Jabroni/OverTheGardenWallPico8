pico-8 cartridge // http://www.pico-8.com
version 33
__lua__

-- configs, state vars & core fns
local walkable={202,203,205,207,222,223,238,239}
local alttiles={
 {srcidx=206,dsts={206,221,237}},
 {srcidx=238,dsts={222,238}},
 {srcidx=207,dsts={207,223,239}},
 {srcidx=235,dsts={235,251,218}},
 {srcidx=205,dsts={202,203,205}},
 {srcidx=236,dsts={204,236}}
}
local altsset={}
local objdescripts={
 {spridxs={122,123,138,139},descr="what a nice old wagon"},
 {spridxs={124,125,140,141},descr="the poor old mill..."},
 {spridxs={158},descr="look at these pumpkins!"},
 {spridxs={159},descr="it says pottsfield \148"},
 {spridxs={174},descr="looks like its harvest \ntime!"},
 {spridxs={190},descr="this pumpkin is missing"},
 {spridxs={204,236},descr="its just a bush..."},
 {spridxs={218,235,251},descr="this tree sure is tall"},
 {spridxs={220},descr="a stump of some weird\ntree?"},
 {spridxs={219},descr="a creepy tree with a \nface on it"},
 {spridxs={224,225,240,241},descr="pottsfield old barn"},
 {spridxs={226,227,242,243},descr="the old grist mill"},
 {spridxs={228,229,244,245},descr="the animal schoolhouse"},
 {spridxs={230,231,246,247},descr="the inn"},
 {spridxs={232,233,248,249},descr="pottsfield old\nchurch"},
 {spridxs={108},descr="a rickety old fence"},
 {spridxs={109},descr="a scarecrow of sorts"},
 {spridxs={110},descr="the ground is higher\nhere"},
 {spridxs={127},descr="a deep hole in the \nground"},
}
local text_to_display={maptitle=nil,dialogue={}}
local active={x=0,y=0,charidx=nil,lookingdir=nil,flipv=false}
local party={}
local characters={
 {name='greg', mapidx=0, chrsprdailogueidx=2, idle={'oh frog o mine!','oh potatoes and...'}}, 
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
 {name='pottsfield citizen #1', mapidx=80, chrsprdailogueidx=98, idle={}},
 {name='pottsfield citizen #2', mapidx=80, chrsprdailogueidx=102, idle={}},
 {name='pottsfield harvest', mapidx=81, chrsprdailogueidx=70, idle={}},
 {name='pottsfield partier', mapidx=96, chrsprdailogueidx=100, idle={}},
 {name='enoch', mapidx=97, chrsprdailogueidx=72, idle={}},
 {name='dog student', mapidx=10, chrsprdailogueidx=44, idle={}},
 {name='gorilla', mapidx=113, chrsprdailogueidx=12, idle={}},
 {name='jimmy brown', mapidx=11, chrsprdailogueidx=14, idle={}},
 {name='cat student', mapidx=26, chrsprdailogueidx=46, idle={}},
 {name='ms langtree', mapidx=112, chrsprdailogueidx=104, idle={}},
 {name='the lantern', mapidx=nil, chrsprdailogueidx=76, idle={}},
 {name='rock fact', mapidx=nil, chrsprdailogueidx=78, idle={}},
 {name='edelwood', mapidx=nil, chrsprdailogueidx=192, idle={}},
}
local mapscurrentidx
local maps={
 {
  title='somewhere in the unknown',
  cellx=0,
  celly=0,
  trans={{dest={mp=2,loc={x=1, y=14}},locs={{x=13,y=0},{x=14,y=0},{x=15,y=0}}}},
  npcs={{charidx=6,x=6,y=7},{charidx=3,x=9,y=4}},
  discvrdtiles={}
 },
 {
  title='the old grist mill',
  cellx=16,
  celly=0,
  trans={
   {dest={mp=1,loc={x=14, y=1}},locs={{x=0,y=13},{x=0,y=14},{x=0,y=15}}},
   {dest={mp=3,loc={x=14, y=14}},locs={{x=0,y=0},{x=1,y=0},{x=2,y=0},{x=0,y=1}}}
  },
  discvrdtiles={}
 },
 {
  title='deeper into the unknown',
  cellx=32,
  celly=0,
  trans={
   {dest={mp=2,loc={x=1, y=1}},locs={{x=13,y=15},{x=14,y=15},{x=15,y=15}}},
   {dest={mp=4,loc={x=8, y=14}},locs={{x=7,y=0},{x=8,y=0}}}
  },
  discvrdtiles={}
 },
 {
  title='pottsfield',
  cellx=48,
  celly=0,
  trans={{dest={mp=3,loc={x=7, y=1}},locs={{x=8,y=15},{x=14,y=15},{x=15,y=15}}}},
  discvrdtiles={}
 }
}
local intro_dialogue={
 progress=1,
 dialogue={
  {speakeridx=4,nameidx=nil,text="led through the mist"},
  {speakeridx=4,nameidx=nil,text="by the milk-light of \nmoon"},
  {speakeridx=4,nameidx=nil,text="all that was lost is \nrevealed"},
  {speakeridx=4,nameidx=nil,text="our long bygone burdens"},
  {speakeridx=4,nameidx=nil,text="mere echoes of the \nspring"},
  {speakeridx=4,nameidx=nil,text="but where have we come?"},
  {speakeridx=4,nameidx=nil,text="and where shall we end?"},
  {speakeridx=4,nameidx=nil,text="if dreams can't come \ntrue"},
  {speakeridx=4,nameidx=nil,text="then why not pretend?"}
 } 
}
local dialogues={
 {mapidx=1,trig_locs={{x=10,y=4},{x=11,y=4}},dialogue={
   {speakeridx=1,text="i sure do love my frog!"},
   {speakeridx=2,text="greg, please stop..."},
   {speakeridx=4,text="ribbit."},
   {speakeridx=1,text="haha, yeah!"}
  },repeatable=false,progress=nil,triggertype="walk"
 },
 {mapidx=1,trig_locs={{x=5,y=7}},dialogue={
   {speakeridx=2,text="i dont like this at all"},
   {speakeridx=1,text="its a tree face!"},
   {speakeridx=23,text="*howls in the wind*"}
  },repeatable=false,progress=nil,triggertype="select"
 }
}
local lookingdirselmap={
 {i=234,x=-1,y=0,fliph=false,flipv=true},--left
 {i=234,x=1,y=0,fliph=false,flipv=false},--right
 {i=250,x=0,y=-1,fliph=false,flipv=false},--up
 {i=250,x=0,y=1,fliph=true,flipv=false}--down
}
local stagetype="mainmenu"
local menuchars={}
local stagetypes={
 {
  title="mainmenu",
  update=function(self)update_main_menu()end,
  draw=function(self)draw_main_menu()end
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
 for i=1,#intro_dialogue.dialogue do
  intro_dialogue.dialogue[i].nameidx=randomname
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
 get_stage_by_type(stagetype).update()
end

function _draw()
 get_stage_by_type(stagetype).draw()
end
-->8
-- update & draw fns
function update_main_menu()
 if btn(2) and active.y == 1 then
  active.y = 0
  sfx(0)
 elseif btn(3) and active.y == 0 then
  active.y = 1
  sfx(0)
 end
 if btn(4) or btn(5) then
  if active.y==0 then
   stagetype="intro"
   sfx(1)
  else
   stop()
  end
 end
end

function update_intro()
 if btnp(4) then
  intro_dialogue.progress+=1
  sfx(0)
 end
 if intro_dialogue.progress>#intro_dialogue.dialogue then
  transition_to_playmap()
 end
end

function update_play_map()
 local initialdialoguelen=#text_to_display.dialogue
 -- check selection direction
 if btn(4) and #text_to_display.dialogue==0 then
  pressed=nil
  for i=0,3 do
   if btn(i) then
    pressed=i
   end
  end
  if pressed != nil then
   active.lookingdir=pressed
  end
 else
  active.lookingdir=nil
 end
 -- check active movement
 if active.lookingdir == nil and #text_to_display.dialogue == 0 then
  if btnp(2) and active.y > 0 and is_element_in(walkable, mget(active.x+maps[mapscurrentidx].cellx, active.y - 1+maps[mapscurrentidx].celly)) then
   active.y = active.y - 1
  elseif btnp(1) and active.x < 15 and is_element_in(walkable, mget(active.x + 1+maps[mapscurrentidx].cellx, active.y+maps[mapscurrentidx].celly)) then
   active.x = active.x + 1
   active.flipv=false
  elseif btnp(3) and active.y < 15 and is_element_in(walkable, mget(active.x+maps[mapscurrentidx].cellx, active.y + 1+maps[mapscurrentidx].celly)) then
   active.y = active.y + 1
  elseif btnp(0) and active.x > 0 and is_element_in(walkable, mget(active.x - 1+maps[mapscurrentidx].cellx, active.y+maps[mapscurrentidx].celly)) then
   active.x = active.x - 1
   active.flipv=true
  end
 end
 -- check for player switch
 if btnp(5) and #text_to_display.dialogue == 0 then
  party[#party+1] = active
  active = party[1]
  party=drop_first_elem(party)
 end
 -- check for dialogue progress
 if btnp(4) and #text_to_display.dialogue > 0 then
  sfx(0)
  text_to_display.dialogue[1].progress+=1
  if text_to_display.dialogue[1].progress > #text_to_display.dialogue[1].dialogue then
   text_to_display.dialogue=drop_first_elem(text_to_display.dialogue)
  end
 end
 -- check for map switch
 local activemap = maps[mapscurrentidx]
 local initmapidx = mapscurrentidx
 for transition in all(activemap.trans) do
  for location in all(transition.locs) do
   if active.x == location.x and active.y == location.y then
    transition_to_map(transition.dest)
    break
   end
  end
  if mapscurrentidx != initmapidx then
   break
  end
 end
 -- check for talk w/ npcs
 if #text_to_display.dialogue == 0 then
  for npc in all(get_all_npcs()) do
   for i=-1,1 do
    for j=-1,1 do
     if i!=j and npc.x+i==active.x and npc.y+j==active.y then
      if selection_is_on_location({x=npc.x,y=npc.y}) then
       local idles=get_char_idle_dialogue(npc.charidx)
       text_to_display.dialogue[#text_to_display.dialogue+1]=idles[get_rand_idx(idles)]
      end
     end
    end
   end
  end
 end
 -- check for dialogue triggers
 for trig in all(dialogues) do
  if trig.mapidx == mapscurrentidx then
   for location in all(trig.trig_locs) do
    if (trig.triggertype == "walk" and active.x == location.x and active.y == location.y) or selection_is_on_location(location) then
     alreadyactive=false
     for i=1,#text_to_display.dialogue do
      if text_to_display.dialogue[i].dialogue[1].text==trig.dialogue[1].text then
       alreadyactive=true
      end
     end
     if alreadyactive then
      break
     end
     if trig.repeatable == false and trig.progress != nil then
      break
     end
     trig.progress = 1
     text_to_display.dialogue[#text_to_display.dialogue+1] = trig
     break
    end
   end
  end
 end
 -- check for obj selection
 for i=-1,1 do
  for j=-1,1 do
   local x=active.x+i
   local y=active.y+j
   if selection_is_on_location({x=x,y=y}) then
    for descpt in all(objdescripts) do
     if is_element_in(descpt.spridxs,mget(x+maps[mapscurrentidx].cellx,y+maps[mapscurrentidx].celly)) and #text_to_display.dialogue==0 then
      text_to_display.dialogue[#text_to_display.dialogue+1] = {
       dialogue={{speakeridx=active.charidx,text=descpt.descr}},
       progress=1
      }
      break
     end
    end
   end
  end
 end
 -- play sound if new dialogue triggered
 if #text_to_display.dialogue>initialdialoguelen or active.lookingdir!= nil then
  sfx(2)
 end
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
 draw_fancy_text_box("start",48,65,active.y==0)
 draw_fancy_text_box("quit",50,85,active.y==1)
 -- draw selection chevrons
 local sel_y=65
 if active.y==1 then
  sel_y=85
 end
 palt(5,true)
 pal(12,9)
 spr(234,24,sel_y,1,1)
 spr(234,96,sel_y,1,1,true,false)
 -- draw 4 random chars
 drawchoices = get_chars_w_dialog()
 local icon_locs={{x=4,y=4},{x=108,y=4},{x=4,y=108},{x=108,y=108}}
 pal(12,12)
 palt(5,false)
 palt(13,true)
 palt(0,false)
 for i=1,#icon_locs do
  draw_fancy_box(icon_locs[i].x,icon_locs[i].y,17,17,2,10,9)
  spr(drawchoices[menuchars[i]].chrsprdailogueidx, icon_locs[i].x+1, icon_locs[i].y+1, 2, 2)
 end
 palt(13,false)
 palt(0,true)
end

function draw_introduction()
 cls(0)
 -- draw bg
 draw_fancy_box(32,5,64,52,0,4,5)
 -- draw frog
 pal(14,128,1)
 pal(5,133,1)
 pal(12,130,1)
 pal(1,132,1)
 pal(13,139,1)
 sspr(80,72,32,24,32,8,64,48)
 pal(14,14)
 pal(5,5)
 pal(12,12)
 pal(1,1)
 pal(13,13)
 -- draw frog dialogue box
 local currentprog=intro_dialogue.dialogue[intro_dialogue.progress]
 draw_character_dialogue_box(currentprog)
end

function draw_play_map()
 local activemap=maps[mapscurrentidx]
 -- color handling
 pal(13,139)
 palt(0,false)
 palt(5,false) 
 cls(139)
 -- draw map
 map(activemap.cellx, activemap.celly)
 -- draw sprites and characters
 palt(139,false)
 palt(13,true)
 -- draw player
 spr(characters[active.charidx].mapidx,active.x*8,active.y*8,1,1,active.flipv,false)
 -- draw npcs
 draw_chars_from_array(get_all_npcs())
 -- draw selection direction
 if active.lookingdir != nil then
  local selection=lookingdirselmap[active.lookingdir+1]
  palt(5,true)
  spr(selection.i,8*(active.x+selection.x),8*(active.y+selection.y),1,1,selection.flipv,selection.fliph)
 end
 -- draw fog of war
 for i=0,15 do
  for j=0,15 do
   local nearforone=false
   for member in all(union_arrs(party,{active})) do
    if distance(i, j, member.x, member.y) < 2.7 then
     nearforone=true
    end
   end
   if not nearforone and not is_element_in(activemap.discvrdtiles, tostr(i)..'|'..tostr(j)) then
    rectfill(8*i, 8*j,(8*i)+8, (8*j)+8,0)
   elseif not is_element_in(activemap.discvrdtiles, tostr(i)..'|'..tostr(j)) then
    activemap.discvrdtiles[#activemap.discvrdtiles+1]= tostr(i)..'|'..tostr(j)
   end
  end
 end
 -- draw active char hud
 local xanchor=1
 if active.x<=3 and active.y<=2 then
  xanchor=90
 end
 local charname = tostr(characters[active.charidx].get_name_at_idx(characters[active.charidx],1))
 draw_fancy_box(xanchor,1,#charname*4+12, 12, 4,10, 9)
 printsp(charname, xanchor+10, 5, 0)
 spr(characters[active.charidx].mapidx, xanchor+2, 3)
 -- draw map title
 txtobj=text_to_display.maptitle
 if txtobj != nil and txtobj.frmcnt > 0 then
  draw_fancy_box(txtobj.x, txtobj.y, #txtobj.txt*4+4, 8, 4,10, 9)
  printsp(txtobj.txt, txtobj.x+2, txtobj.y+2, 0)
  txtobj.frmcnt = txtobj.frmcnt-1
 end
 -- draw dialogue if necessary
 if text_to_display != nil and text_to_display.dialogue != nil and #text_to_display.dialogue > 0 then
  dlg=text_to_display.dialogue[1]
  curprogressdlg=dlg.dialogue[dlg.progress]
  if curprogressdlg != nil then
   draw_character_dialogue_box(curprogressdlg)
  end
 end
end

-->8
-- utilities
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

function transition_to_playmap()
 stagetype = "playmap"
 party={{charidx=1,x=nil,y=nil},{charidx=4,x=nil,y=nil}}
 transition_to_map({mp=1,loc={x=1, y=14}})
 active={x=3,y=13,charidx=2,lookingdir=nil}
 pal(14,14,1)
 pal(5,5,1)
 pal(12,12,1)
 pal(1,1,1)
 pal(13,13,1)
end

function get_rand_idx(arr)
 return flr(rnd(#arr))+1
end

function get_char_idle_dialogue(charidx)
 local idle_dialogues={}
 local idles=characters[charidx].idle
 for idle in all(idles) do
  idle_dialogues[#idle_dialogues+1]={
   dialogue={{speakeridx=charidx,text=idle}},
   progress=1,
   repeatable=true
  }
 end
 return idle_dialogues
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
 end
 printsp(text, x+4, y+4, txtclr)
end

function get_all_npcs()
 return union_arrs(party, maps[mapscurrentidx].npcs)
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
   spr(characters[npc.charidx].mapidx, npc.x*8, npc.y*8)
  end
 end
end

function draw_character_dialogue_box(dialogueobj)
 local nameidx=1
 if dialogueobj.nameidx != nil then
  nameidx=dialogueobj.nameidx
 end
 draw_fancy_box(8,100,112,24,4,10,9)
 printsp(characters[dialogueobj.speakeridx].get_name_at_idx(characters[dialogueobj.speakeridx],nameidx), 29, 104, 1)
 printsp(dialogueobj.text, 29, 110, 0)
 draw_fancy_box(10,103,17,17,0,6,5)
 spr(characters[dialogueobj.speakeridx].chrsprdailogueidx, 11, 104, 2, 2)
 print("\142",105,118,0)
 palt(5,true)
 pal(12,0)
 spr(234, 112, 116)
 palt(5,false)
 pal(12,12)
end

function selection_is_on_location(location)
 if active.lookingdir == nil then
  return false
 end
 local selection=lookingdirselmap[active.lookingdir+1]
 return active.x+selection.x == location.x and active.y+selection.y == location.y
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
end

function transition_to_map(dest)
 mapscurrentidx = dest.mp
 active.x = dest.loc.x
 active.y = dest.loc.y
 for i=1,#party do
  didadd=false
  repeat
   x=flr(rnd(3))+active.x-1
   y=flr(rnd(3))+active.y-1
   if is_element_in(walkable, mget(x+maps[mapscurrentidx].cellx, y+maps[mapscurrentidx].celly)) then
    didadd = true
    party[i].x=x
    party[i].y=y
   end
  until didadd
 end
 text_to_display.maptitle={x=16,y=64,txt=maps[mapscurrentidx].title,frmcnt=60}
 -- check alt tiles
 if not is_element_in(altsset, mapscurrentidx) then
  local srctiles=get_sourceidxs()
  for i=0,15 do
   for j=0,15 do
    local tilspr=mget(i+maps[mapscurrentidx].cellx, j+maps[mapscurrentidx].celly)
    if (is_element_in(srctiles,tilspr)) then
     local dsts=get_by_source(tilspr).dsts
     local randsel=get_rand_idx(dsts)
     mset(i+maps[mapscurrentidx].cellx, j+maps[mapscurrentidx].celly, dsts[randsel])
    end
   end
  end
  altsset[#altsset+1]=mapscurrentidx
 end
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
ddddddddddddddddddff77ffff77ffddddff77ffff77ffdddd667766667766dddd337733337733dddddddddd888888881dd0100111001dd1dddff09aaa0ffddd
dddddddddddddddddddff0ffff0ffddddddff0ffff0ffdddddd6666556666ddddd3b03333330b3dddd4dd4dd8888888801d0008888000d10ddddff0000ffdddd
ddddd60ddddddddddddff000000ffddddddfff0000fffdddddd6665555666ddddd3bb000000bb3ddddaaaedd8888888800d0887676880d00dddddffffffddddd
dccce665ddd3d3ddddddff0000ffddddddddffffffffdddddddd66655666ddddddd3bbbbbbbb3ddddd47777d888888880dd8670000678dd0ddddd22222dddddd
ddcceeddddd030ddddd733ffff337dddddddd1ffff1dddddddddee6666eedddddddd33333333dddddd4040dd888888880d008867678800d0dd51cfffffc150dd
dd9c77dddd3333dddd773377773377ddd11111177111111dddd7eeeeeeee7dddddd3333333333ddddd4444dd888888880d000088880000d0d0001ccfcc10000d
ddddddddd3333dddd77733777733777d1111197777911111ddc77eeeeee77cddddb3333333333bddd4aaaa4d8888888800110110100011000000011111000000
ddddddddd3b3bdddd77333333333377d1197777777777911dcc7777777777ccddbb3333333333bbdddaaaadd8888888800001001011100000000000000000000
51dddd15dd0000dd1d5d5ddddddd5d15dd655555555555ddd00ddd0000ddd00ddddddddddddddddd8888888800202020ddddddddddddddddddddd4ddddd4dddd
15111151dd0000dd11d5ddddddd5511dd65555555555552dd00d00000000d00dddd4444444444ddd8888888800944490ddddddddddddddddddddd44dddd44ddd
51161615d000000dd115dd1111d51155d66666666666622dd000c00000c0000dd44477444477444d8888888800045400dddd4dddddd4dddddddd444dde4e4ddd
d511115dddf0f0dd5511d6611665155dd65555555555552ddd0cac000cac00dd44476074476074448888888800045400ddd44dddccd44ddddddd99999eee9ddd
ddd11dddd54ff44add51677667761ddddd666666666662ddddcaeac0caeac0dd44470074470074448888888800045400ddd4411111144dddddd99977997999dd
d111111d460000a9d5dd67766776d5ddddff760ff760ffdddcaeeea0aeeeacdd44447744447744448888888800044400ddd44ccc11144dddddd27744774774dd
d111111dd6000060dddd16611661ddddddff700ff700ffddddcaeac0caeac0dd4d444440044444448888888800202020ddd441cccc144dddddd24aa444aa44dd
1d1dd1d1dd5dd5dddddd11111111ddddddfff7799f77ffdddd0cac000cac00dd4d44f700007744d48888888800002000dddd4aa444aaddddddd24a0444a044dd
ddddddddddddddddddddd111111ddddddddfff9999fffdddd050c00000c00ddddd47f770077774dd0020202044444444ddd4a0092a009dddddd26444444446dd
dddcacacdddddddddddddd1111dddddddddffff99f0ffdddd050e00000e00dddddd77ff777777ddd0004740042222224ddd4a0092a009dddddd24644004464dd
dddaeaeadddddddddddd11111111ddddddddff0000ffdddd00557eeeee70dddddd57777ffff74ddd0004440042333324ddd4299555994ddddddd446044064ddd
dd0cacacdddddddddddd11111111ddddddd222ffff220ddd000567676765ddddd54577777444dddd0004740042377324ddd4455000554ddddddd464444446ddd
d0070700ddddd474ddd1111111111ddddd040000000044dd000556565655ddddd54455777455dddd0004740042333324ddd44544ee454ddddddd62222222d6dd
00007070dd474070ddd1111111111dddd55200000000255d00005555555ddddd544444555545dddd0004440042773324dd111111111111ddddd7777747777ddd
0d000005d47744e4ddd1111111111ddd0005000000099000000000000ddddddd44477775775ddddd0004740042555524d77777777777777dddaaaaaaaaaaaadd
dd0d50d54d7dd7ddddd1111111111ddd00050000009aa900000000000ddddddd77777775775ddddd00202020424444241111111111111111da99aaaaaaaa99ad
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd4444444442886824dddddddddddddddddddddddddddddddd
ddddddddddd0c0dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd4444244442666824dddddd0000dddddddddddddddddddddd
dddddddddd44ccdddddddddddd000ddddddddddddddddddddddddd7777dddddddddddddddddddddd4442552422886622ddddd0dddd0ddddddddddddd666ddddd
ddddddddd444844ddddddd0dd05000ddddddddddddddddddddddd777777ddddddddd99999999dddd4465525442222224dddd0dd11dd0dddddddd66666666dddd
dd0000ddd400804ddddddd00d00050dddddddddccccddddddddd77777777ddddddd9999999999ddd42562554442aa244ddddd011110dddddddd6666666666ddd
d0000050dd0000dddddddd00d00000dddddddddccccddddddddd777a07a0dddddd99aaa999aaa9dd4052652244299244ddddd0d55d0dddddddd66777677766dd
d0000000dd0000dddddd555555000ddddddddddc00ccdddddddd77700700dddddd9a000a9a000add4525264444298244ddd6dd0550dd6ddddd6661776771666d
dd0dd0ddddd99dddddd5000000555dddddddddcc00ccdddddddd77777077dddddd9a000a9a000add4050444442222224dddd6d5aa5d6ddddd56667766677666d
ddd999ddddd77dddddd5000000005dddddddddcc11cc1ddddddd5077000ddddddd99aaa949aaa9dd4444444444444444ddddd6a97a6ddddd556666666666666d
dd90909ddd7070ddd00500000005000ddddddd1ccccc1fdddddd5607777ddddddd999994949999dd4455544444433444dd66dda79add66dd555666aaaaaa666d
dd99999ddd7777dd00050000005000dddddd558111c1ffdddddd6670505dddddddd9976767699ddd45555544443bb344ddddd65aa56dddddd55666a0880a665d
dd90009dddd700dddddd555555ddddddddd5558882110fdddd77566777dddddddddd96767679dddd4555554443bbbb34dddd6dd11dd6ddddd55566aa88aa55dd
daf999addd767dddddddd00ddddddddddd555588822f0fdd77dd56ddd677ddddddddababbabadddd455555443b3bb3b3ddd6dd1111dd6ddddd55566688655ddd
daafffaad7d6d7ddddddd00dddddddddd555558882220f5d776666666d677dddddddababbab9dddd4655564443333334ddddddddddddddddddd5555666555ddd
dffffffddd767dddddddd0dddddddddd555544888225555577dd56ddd6d77ddddddabbab39339ddd4066644449a44a94dddddddddddddddddddd55555555dddd
ddaddadddd6d6ddddddddddddddddddd5554448882445555d77776666ddd77dddddabab333939ddd405054444a4444a4ddddddddddddddddddddddd5555ddddd
dd999ddddd9999dddddddddd44ddddddddddddd444dddddddddd22244422ddddd44444444422244d4444444444444444333332333333433333333333ddddd666
d90909ddd944944ddddddd94444ddddddddddd99444ddddddd333333333333dd44444244444444444444444444444444333324333344944333bbbb33dddd6665
d99999ddd999999ddddd99999999dddddddd99999999dddddddd99999999ddddd44224442222244d444444444444444433323233333993333bbbbbb3dddd4655
d90009dddd9777ddddd9900999009dddddd9900999009dddddd9900999009dddd42444444444424d4446674446666674332323433339933333bbbb33dddd445d
dd999dddd3a3a3adddd9000090000dddddd9000090000dddddd9000090000ddddd444774447744dd4665564466666666334233333333233333bbbb33ddd44ddd
d7d6d7ddd3a3a3addd9a0000a0000adddd9a0000a0000adddd9a0000a0000addddd47607f7607ddd4666664446666664332333333444244333bbbb33dd44dddd
dd767dddd3a3a3addd99a00a9a00a9dddd99a00a9a00a9dddd99a00a4a00a9dddddd7007f7007ddd445445444454454434343333334444333b3333b3444ddddd
dd6d6dddd3a3a3addd999aa999aa99dddd999aa900aa99dddd999aa444aa99dddddde77fff77eddd2454454224544542333333333333333333333333d4dddddd
dd4444ddddd00ddddd999888888999dddd99999a00a999dddd999899498999ddddddff8fff8ffddd333333333333333333333333333333330222202234444433
d44444dddd0a0addddd9876676789dddddd99999aa999dddddd9878888789ddddddddff888ffdddd333333333333333333353333333333332020002044444443
ddf0f0dddd0000ddddd9867767689dddddd9a0000000adddddd9867767689dddddddddfffffddddd333333333344333335553335333333332020202044222243
ddeffedd0d0220d0dddd98888889dddddddd9aaaaaaadddddddd98888889dddddddddd6fff6ddddd333333334423333355555355533333332000200034220243
d776677d00000000ddddff9999ffdddddddddd9999ddddddddddff9999ffddddddddd656f656dddd333333449923333335577765333333332020202034200243
df7777fdd000000dddaaffffffffaaddddd7777777777dddddaaffffffffaadddd777656665677dd333344323992333335700077333333330020002044000043
d555555dd000000daaaaffffffffaaaad77dd777777dd77daaaaffffffffaaaa7777765565567777334432329392333335600077333333332020202033444b3b
d54dd45ddd0dd0ddaaffffffffffffaa7dd77dd77dd77dd7aaffffffffffffaa77777766766777773432323329443333377500763335533320002000333333b3
00000000000000009090000000000000000000000000000000000000000000000000000000000000329233234434222337755077335555552202220222222244
00099900000000990900009009000004444000000000000000000000000000000000000000000000329323442499233337777777366556630000000045555544
00900090000000000900090000900040000402200aaaa00a0000a0aaaaa0aaaa000aaaaaaa0a000a323944242929933337777667755577730222022245555544
0900200900000090900900999900000000000220a9999a0a0000a0a99990a999a00a99a99a0a000a32442422299b9b3334740077550700730000000045555544
0902420900009009009000000000004444400000a0000a09a00a90a00000a000a00900a0090a000a343992233399b33335444077500600632202220220505044
0900200900090009090900999900000990040020a0000a00a00a00aaaaa0aaaa900000a0000a000a339929333333333334544074400705730000000027777744
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
444444448888888888888888888888888888888888888888888888888888888888888888888888880000004e12ccccc2eeeeeee1e455e0004244444444444444
00000000888888888888888888888888888888888888888888888888888888888888888888888888000004ee5e22222eeeeeeee1e45e00004343424444442244
090440908888888888888888888888888888888888888888888888888888888888888888888888880000004444411dadeeeeeee5e4e000004234424444444444
904444098888888888888888888888888888888888888888888888888888888888888888888888880000000000011dda44444444400000004244424411111111
0024420088888888888888888888888888888888888888888888888888888888888888888888888800000000001111a000000000000000004243434444444444
90022009888888888888888888888888888888888888888888888888888888888888888888888888000000000104001000000000000000004244324442244444
00900900888888888888888888888888888888888888888888888888888888888888888888888888000000000104001000000000000000004244424444444444
99000099888888888888888888888888888888888888888888888888888888888888888888888888000000000000000000000000000000004444424411111111
d4444444444444d0888888888888888888888888888888888888888888888888888888888888888833333333333333333333333333333333cccccccc44444444
d2444444444444d48888888888888888888888888888888888888888888888888888888888888888333333333b3b33333333333333333333cccccccc44444444
dd4444494944444288888888888888888888888888888888888888888888888888888888888888883333333333b33333333bbb3333333333cccccccc44444444
d44449904099444d8888888888888888888888888888888888888888888888888888888888888888333333333333333333bbbbb333333333cccccccc44444444
024490004000944488888888888888888888888888888888888888888888888888888888888888883b3b33333333b3b33bbbbbb333333333cccccccc44444444
dd24000292000944888888888888888888888888888888888888888888888888888888888888888833b3333333333b333bbbbbb333333333cccccccc44444444
ddd4002904200042888888888888888888888888888888888888888888888888888888888888888833333333333333333bbbbbb333333333cccccccc44444444
04d420400440204d888888888888888888888888888888888888888888888888888888888888888833333333333333333333333333333333cccccccc44444444
d24404499444440d8888888888888888888888888888888888888888888888888888888888888888333333330343433033333333ccc7cc7ccccc7ccc44464446
ddd044900994040d88888888888888888888888888888888888888888888888888888888888888884332483434334444333333337ccc7cc7c56667cc45646564
dd4499000009444d8888888888888888888888888888888888888888888888888888888888888888343443430433442333333333c7cc7cc75666667c44544454
dd4900022000944d8888888888888888888888888888888888888888888888888888888888888888243423433343040333333333c7cc7c7c5666667c44446464
dd4000244000042d88888888888888888888888888888888888888888888888888888888888888883844443233344423333333337cc7cccc5666667c44644654
dd420244042024dd8888888888888888888888888888888888888888888888888888888888888888332243333333002333333333ccccc7ccc566667c44644464
d4404444044404dd8888888888888888888888888888888888888888888888888888888888888888334443333330420333344233cccccc7cc56667cc56545664
d4004440444042dd8888888888888888888888888888888888888888888888888888888888888888344422333044222330442243ccccc7cccccc7ccc45444554
333333333333333333333333333333333333333663333333888888888888888833333332233333335555555533399933333333337ccccccccccccccc44444466
333333355000333333355533333333333333336aa6553333888888888888888833333388883333335c55c55533999a9333333333c7ccc7cccccc7ccc46454454
3333335445000333355555553333333333333379a75553338888888888888888333333377333333355c55c55399aa999333333337ccccc7cccc657cc45456644
33333544445000335555555553333333333366666666553388888888888888883333333882223333555c55c5a99999a933bbb333cc7ccc7ccc66657c45445644
33335440044500033677776633333333333622222222655388888888888888883333338778222333555c55c53a9aaa933bbbbb33ccc7c7cccc66657c44445554
3335444004445000377000773333333333622227722226238888888888888888333338777782223355c55c55334242333bbbbbb3ccc7ccccc66657cc46644444
335444400444450036600077333333333338877777788223888888888888888833338777777822235c55c5553a2422333bbbbbb3ccc7cccccccc7ccc45645666
35444444444444503770007655555333333777777777722388888888888888883338777777778223555555559444422333333333cc7ccccccccccccc44444554
334444444444442237700077555555553337222222227223888888888888888833877777777778235555555543343434ddddddddddddd55ddddddddddddddd2d
3344444444444422447777776666666333378877787c722388888888888888883337777777777663555cc55543439343dddddddddddd4225dd2cdddddddd8d22
334444444444442255777667777777733337887778c772238888888888888888333700766700766355c55c5544333443ddddddddddd42225dc2d44ddddd888dd
3345522222554422447444777007007333378877987c7223888888888888888833370076670076635c5555c534434232daadaaaddd42225ddd2444cddd88888d
33442442442444225574447770060063333788777888722388888888888888883337777667777663555cc55593442323aa9a99aad42224dddd44422dd88888dd
3344244244244422446449744007007333378877788872238888888888888888333777766777766355c55c5533424233a9a9aa9a44424ddd244422dddd888ddd
334424424424442255744476677777733337444444447233888888888888888833377755557776635c5555c533242233a99a999a5444dddd224ddddd22d8dddd
334424424424442344744474477667733332222222222333888888888888888833377666666776335555555594444229da9999add55dddddd22dddddd2dddddd
__map__
ebebebebebebebebebebebebebcfcfcfcfcfcfebcececeebebebebebebebebebcdecececcdcdcfcfecececcdcdcdcdebebebebebebebebebebcfcfcfebebebeb7e8e8e8e8e8e8e8e8e8e8e8e8e7e8e7e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdebcdebdccdeccdcdcdebcdcfcfcfcfcfcfecebcececdcdecebebebebebebcdcdcdcdcdcdcfcfececcdcdcdcdceceebebebcde0e1cdcdcdcfcfcdcdcdcdebafbfbf4a4a4abfbfbf4bbfbfbfafbfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdeccdcdeccdcdcdcdececcfcfcfcfebcfcfcfcececee2e3cdcdebdbebebebcdcdebcdcdcdcfcfeccdcdcdebcececeebebcd6cf0f1cdcdcdcfcfcdbe9ecddc3abfbfbfbfbfbf5bbfbfbf5bbfafbf3a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdebcdcdcdebcdeccfcfcfcfcfebebebcfcfeececef2f3cdcdcdcdebebebcdebebcdebcdcfcfcdcdcdcdcecececdebcd6ccfcfcfcf6ccfcfcfcd9e9ecdebafbfbfbfbfbfbfbfbf5bbfbfbfafbfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcdecececececcfcfcfcfcfcdebebebceceeeeecfcfcfebeccdcddcebebcdcdcdcdebcdcfcfcdcdececcececdebeb6ccfcfcfcfcfcfcfcfcd6d9e9ecdebafbfbfbfbfbfbfbfbfbfbfbfbfafbfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebebcdeccfcfcfcfcfcfcfcfeccdcdebcecececeeecfcfcfcfcfcfeccdcdebebcdebebcdebcdcfcf9fcdcdecceceebcdebcdcdcdcdcfcfcfcfcfcd9ebe9ecdeb2bbfbfbfbfbfbfbfbfbfbfbfbf2bbf3a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcfcfcfcfcfcfcfcfcfeccdebebcececeebcfcfcfcfcfcfcfcdcdcdebebcdcdcdcdcdcdcfcfcfcdcdcdcecececdebebececcdcfcfcfcfcfcdcdbe9ecdebafbfbfbf6abfbfbfbf6bbfbfbfafbfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcfcddbcdcfcfcfececcdcdecebceceebebebcfcfcfcfcfebebcdcdebebebcdcdcdcdeccfcfcfcfcdcdcdcececeebcdcdcdcd6dcfcfcfcfe8e9ececcdcd7e8e8e8e8e8e8e8e8e8e8e8e8e7ebfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebebcdcfcdcdcfcfcfeccdcdcdcdcdebebebebebeb6ccfcfcfcfecebebcdebebcdcdebebcdcdeccfcfcfcdcdcdcdceceebcd9ebe9ecdcdcfcfcff8f9cdcdcdaeaf4abfbf6a6abfbfbfbfbf6bbfbfbfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcddccfcfcfcfcfeccdebcdcdebcdebebebebeb6ccfcfcfececebebeccdebebcdebcdcdcdcdeccfcfcfcfcdcdcdcdcdebcd9e9e9ebecdcdcfcfcfcdcdaeaeaeaf4abfbfbfbfbfbfbfbfbfbfbfbfbfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcdcfcfcfcfeccdcdcdcdeccdebebebebeb6ccfcfcfecebebebebcdcdebebcdcdcdcdebcdcdeccfcfcfcfcdcdebebebcdbe9ebe9e6e6ecfcfeccdaeaeaeaeafbfbf4abfbfbfbfbfbf6bbfbfbfbfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcdcfcfcfcfeccdcdcdcdcdcdcdebebebeb6ccfcfcfcdebcdcdebebcdcdebebebcdcdcdebebcdcdeccfcfcfcfcdcdebebcd9e9ebecdcd6ccfcfeccdaeaeaeaeafbf4a5abfbfbfbfbfbfbfbfbfbfbfaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebcfcfcfcfcdcdcdcdeccdebcdcdebebeb6ccfcfcfcdcdcdcdcddceccdcdebebebcdcddccdebcdcdcdcdcfcfcfcfcdebebcdcdcdcdcdcfcfcfcfeccdaeaeaeaeafbfbfbfbfbfbfbfbfbf6bbfbfbf4aaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cfcfcfcfcdcdebcdebcdcdcdcdeccdebebcfcfcfcdcdcdcdcdcdcdcdcdcdebebebcdcdcdcdcdcdcdcdcdcdcfcfcfcfcfebcdaeaeaecdcfcfcfcf7a7baeaeaeaeafbfbfbfbfbfbfbfbfbfbfbfbfbf4aaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cfcfcfcdcdcdeccdcdcdcdebcdcdcdebcfcfcfcfcdcdcdecdccdcdcdcdcdebebebdbcdcdcdcdcdcdcdcdcdcdcdcfcfcfebcdaeaeaecdcdcfcfcf8a8baeaeaeaeafbfbfbf6a6abfbfbfbfbf6bbfbf4aaf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cfcfebebebebebebebebebebebebebebcfcfcfebebebebebebebebebebebebebebebebebebebebebebebebebebcfcfcfdbcdaeaeaeaecdcfcfcdcdcdcdaeaeae7eafafafafafafafafafafafafafaf7e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200001a7201b7201d7201f72000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
9114000020552205522355221552205521e552205522c552245522a5522d5522c5522a5522c5522c5522a5522a5521c5521c5521c55230552305522a5001c5000050200502005020050200002000020000000000
00060000277502a7502c7500070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
001000000110002100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100

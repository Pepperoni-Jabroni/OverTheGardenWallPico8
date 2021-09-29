pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

-- accessors
local walkable={220,238,239,223}
local text_to_display={maptitle=nil,dialogue={}}
local active={x=0,y=0,charidx=nil,lookingdir=nil}
local party={{charidx=1,x=nil,y=nil},{charidx=4,x=nil,y=nil}}
local characters={
 {name='greg', mapidx=0, chrsprdailogueidx=2}, 
 {name='wirt', mapidx=1, chrsprdailogueidx=4}, 
 {name='beatrice', mapidx=16, chrsprdailogueidx=6}, 
 {name={'kitty','wirt','wirt jr.','george washington','mr. president','benjamin franklin','doctor cucumber','greg jr.','skipper','ronald','jason funderburker'}, mapidx=17, chrsprdailogueidx=8}, 
 {name='the beast', mapidx=32, chrsprdailogueidx=34}, 
 {name='the woodsman', mapidx=33, chrsprdailogueidx=36}, 
 {name={'the beast?','dog'}, mapidx=48, chrsprdailogueidx=38},
 {name='dog', mapidx=49, chrsprdailogueidx=40},
 {name='black turtle', mapidx=64, chrsprdailogueidx=66},
 {name='turkey', mapidx=65, chrsprdailogueidx=68},
 {name='pottsfield citizen #1', mapidx=80, chrsprdailogueidx=98},
 {name='pottsfield citizen #2', mapidx=80, chrsprdailogueidx=102},
 {name='pottsfield harvest', mapidx=81, chrsprdailogueidx=70},
 {name='pottsfield partier', mapidx=96, chrsprdailogueidx=100},
 {name='enoch', mapidx=97, chrsprdailogueidx=72}  
}
local mapscurrentidx
local maps={
 {title='somewhere in the unknown',cellx=0,celly=0,trans={{dest={mp=2,loc={x=1, y=14}},locs={{x=13,y=0},{x=14,y=0},{x=15,y=0}}}}},
 {title='the old grist mill',cellx=16,celly=0,trans={{dest={mp=1,loc={x=14, y=1}},locs={{x=0,y=13},{x=0,y=14},{x=0,y=15}}}}}
}
local dialogues={
 {mapidx=1,trig_locs={{x=10,y=4},{x=11,y=4}},dialogue={
   {speakeridx=1,text="i sure do love my frog!"},
   {speakeridx=2,text="greg, please stop..."},
   {speakeridx=4,text="ribbit."},
   {speakeridx=1,text="haha, yeah!"}
  },repeatable=false,progress=nil,triggertype="walk"
 },
 {mapidx=1,trig_locs={{x=2,y=1}},dialogue={
   {speakeridx=2,text="i dont like this at all"},
   {speakeridx=1,text="its a tree face!"}
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

-- base functions
function _init()
-- init game state
 local genrandcnt=4
 repeat
  local choice=flr(rnd(#get_chars_w_dialog()))+1
  if not is_element_in(menuchars,choice) then
   menuchars[#menuchars+1]=choice
  end
 until #menuchars==genrandcnt

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
 if stagetype == "mainmenu" then
  if btn(2) and active.y == 1 then
   active.y = 0
  elseif btn(3) and active.y == 0 then
   active.y = 1
  end
  if btn(4) or btn(5) then
   if active.y==0 then
    stagetype = "playmap"
    transition_to_map({mp=1,loc={x=1, y=14}})
    active={x=3,y=13,charidx=2,lookingdir=nil}
   else
    stop()
   end
  end
 elseif stagetype == "playmap" then
  update_play_map()
 end
end

function _draw()
 if stagetype == "mainmenu" then
  draw_main_menu()
 elseif stagetype == "playmap" then
  draw_play_map()
 end
end

-->8
function draw_main_menu()
  cls(0)
  -- draw logo
  spr(128,24,8,10,6)
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
  -- draw_fancy_box(1,69,17,17,2,10,9)
  -- draw_fancy_box(107,69,17,17,2,10,9)
  -- spr(drawchoices[first].chrsprdailogueidx, 2, 70, 2, 2)
  -- spr(drawchoices[second].chrsprdailogueidx, 108, 70, 2, 2)
  palt(13,false)
  palt(0,true)
  palt(5,true)
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

function update_play_map()
 -- check selection direction
 if btn(5) then
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
 if active.lookingdir == nil then
  if btnp(2) and active.y > 0 and is_element_in(walkable, mget(active.x+maps[mapscurrentidx].cellx, active.y - 1+maps[mapscurrentidx].celly)) then
   active.y = active.y - 1
  elseif btnp(1) and active.x < 15 and is_element_in(walkable, mget(active.x + 1+maps[mapscurrentidx].cellx, active.y+maps[mapscurrentidx].celly)) then
   active.x = active.x + 1
  elseif btnp(3) and active.y < 15 and is_element_in(walkable, mget(active.x+maps[mapscurrentidx].cellx, active.y + 1+maps[mapscurrentidx].celly)) then
   active.y = active.y + 1
  elseif btnp(0) and active.x > 0 and is_element_in(walkable, mget(active.x - 1+maps[mapscurrentidx].cellx, active.y+maps[mapscurrentidx].celly)) then
   active.x = active.x - 1
  end
 end
 -- check for player switch
 if btnp(4) and #text_to_display.dialogue == 0 then
  party[#party+1] = active
  active = party[1]
  party=drop_first_elem(party)
 end
 -- check for dialogue progress
 if btnp(4) and #text_to_display.dialogue > 0 then
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
end

function draw_play_map()
-- color handling
 pal(13,139)
 palt(0,false)
 palt(139,true)
 palt(5,false) 
 cls(139)
 -- draw map
 map(maps[mapscurrentidx].cellx, maps[mapscurrentidx].celly)
 -- draw sprites and characters
 palt(139,false)
 palt(13,true)
 -- draw player
 spr(characters[active.charidx].mapidx, active.x*8, active.y*8)
 -- draw npcs
 for npc in all(party) do
  if npc.x != nil and npc.y != nil then
   spr(characters[npc.charidx].mapidx, npc.x*8, npc.y*8)
  end
 -- draw active char, spr and name
 local charname = tostr(characters[active.charidx].get_name_at_idx(characters[active.charidx],1))
 draw_fancy_box(1,1,#charname*4+12, 12, 4,10, 9)
 printsp(charname, 11, 5, 0)
 spr(characters[active.charidx].mapidx, 3, 3)
 end
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
   draw_fancy_box(8,100,112,24,4,10,9)
   printsp(characters[curprogressdlg.speakeridx].get_name_at_idx(characters[curprogressdlg.speakeridx],1), 28, 104, 1)
   printsp(curprogressdlg.text, 28, 110, 0)
   spr(characters[curprogressdlg.speakeridx].chrsprdailogueidx, 10, 104, 2, 2)
  end
 end
 -- draw selection direction
 if active.lookingdir != nil then
  local selection=lookingdirselmap[active.lookingdir+1]
  palt(5,true)
  spr(selection.i,8*(active.x+selection.x),8*(active.y+selection.y),1,1,selection.flipv,selection.fliph)
 end
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
dd6666dd88888ddd6d66666666666666dddd88888888888ddddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000
d666666dd88888ddd6666666666666d6ddd888888888888ddddddd6666dddddddddddddddddddddd000000000000000000000000000000000000000000000000
6d4444d6d84444dddd666666666666ddddd888888888888ddddd66666666dddddddddddddddddddd000000000000000000000000000000000000000000000000
d6ffffddddffffddddd6444444446dddddd88888888888ddddd6666666666dddddddbbddddbbdddd000000000000000000000000000000000000000000000000
ddffffddd1ffff1dddd4444444444ddddd888844444888ddddd6666666666ddddddbbbbddbbbbddd000000000000000000000000000000000000000000000000
d737737dd697796ddd44774ff47744dddd8877ffff7748dddd667766667766ddddb3773bb3773bdd000000000000000000000000000000000000000000000000
d733337dd677776dddf7607ff7607fdddd47607ff76074dddd676076676076ddddb7607bb7607bdd000000000000000000000000000000000000000000000000
dd0dd0ddd202202dddf7007ff7007fddddf7007ff7007fdddd670076670076dddd370073370073dd000000000000000000000000000000000000000000000000
ddddddddddddddddddff77ffff77ffddddff77ffff77ffdddd667766667766dddd337733337733dd000000000000000000000000000000000000000000000000
dddddddddddddddddddff0ffff0ffddddddff0ffff0ffdddddd6666556666ddddd3b03333330b3dd000000000000000000000000000000000000000000000000
ddddd66ddddddddddddff000000ffddddddfff0000fffdddddd6665555666ddddd3bb000000bb3dd000000000000000000000000000000000000000000000000
dccce665ddd3d3ddddddff0000ffddddddddffffffffdddddddd66655666ddddddd3bbbbbbbb3ddd000000000000000000000000000000000000000000000000
ddcceeddddd333ddddd733ffff337dddddddd1ffff1dddddddddee6666eedddddddd33333333dddd000000000000000000000000000000000000000000000000
dd9c77dddd3333dddd773377773377ddd11111177111111dddd7eeeeeeee7dddddd3333333333ddd000000000000000000000000000000000000000000000000
ddddddddd3333dddd77733777733777d1111197777911111ddc77eeeeee77cddddb3333333333bdd000000000000000000000000000000000000000000000000
ddddddddd3b3bdddd77333333333377d1197777777777911dcc7777777777ccddbb3333333333bbd000000000000000000000000000000000000000000000000
51dddd15dd0000dd1d5d5ddddddd5d15dd655555555555ddd00ddd0000ddd00ddddddddddddddddd000000000000000000000000000000000000000000000000
15111151dd0000dd11d5ddddddd5511dd65555555555552dd00d00000000d00dddd4444444444ddd000000000000000000000000000000000000000000000000
51161615d000000dd115dd1111d51155d66666666666622dd000c00000c0000dd44477444477444d000000000000000000000000000000000000000000000000
d511115dddffffdd5511d6611665155dd65555555555552ddd0cac000cac00dd4447607447607444000000000000000000000000000000000000000000000000
ddd11dddd54ff44add51677667761ddddd666666666662ddddcaeac0caeac0dd4447007447007444000000000000000000000000000000000000000000000000
d111111d460000a9d5dd67766776d5ddddff760ff760ffdddcaeeea0aeeeacdd4444774444774444000000000000000000000000000000000000000000000000
d111111dd6000060dddd16611661ddddddff700ff700ffddddcaeac0caeac0dd4d44444004444444000000000000000000000000000000000000000000000000
1d1dd1d1dd5dd5dddddd11111111ddddddfff7799f77ffdddd0cac000cac00dd4d44f700007744d4000000000000000000000000000000000000000000000000
ddddddddddddddddddddd111111ddddddddfff9999fffdddd050c00000c00ddddd47f770077774dd000000000000000000000000000000000000000000000000
dddcacacdddddddddddddd1111dddddddddffff99f0ffdddd050e00000e00dddddd77ff777777ddd000000000000000000000000000000000000000000000000
dddaeaeadddddddddddd11111111ddddddddff0000ffdddd00557eeeee70dddddd57777ffff74ddd000000000000000000000000000000000000000000000000
dd0cacacdddddddddddd11111111ddddddd222ffff220ddd000567676765ddddd54577777444dddd000000000000000000000000000000000000000000000000
d0070700ddddd474ddd1111111111ddddd040000000044dd000556565655ddddd54455777455dddd000000000000000000000000000000000000000000000000
00007070dd474070ddd1111111111dddd55200000000255d00005555555ddddd544444555545dddd000000000000000000000000000000000000000000000000
0d000005d47744e4ddd1111111111ddd0005000000099000000000000ddddddd44477775775ddddd000000000000000000000000000000000000000000000000
dd0d50d54d7dd7ddddd1111111111ddd00050000009aa900000000000ddddddd77777775775ddddd000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000
ddddddddddddcddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000
dddddddddd44ccdddddddddddd000ddddddddddddddddddddddddd7777dddddddddddddddddddddd000000000000000000000000000000000000000000000000
ddddddddd444844ddddddd0dd05000ddddddddddddddddddddddd777777ddddddddd99999999dddd000000000000000000000000000000000000000000000000
dd0000ddd400804ddddddd00d00050dddddddddccccddddddddd77777777ddddddd9999999999ddd000000000000000000000000000000000000000000000000
d0000000dd0000dddddddd00d00000dddddddddccccddddddddd777a07a0dddddd99aaa999aaa9dd000000000000000000000000000000000000000000000000
d0000000dd0000dddddd555555000ddddddddddc00ccdddddddd77700700dddddd9a000a9a000add000000000000000000000000000000000000000000000000
dd0dd0ddddd99dddddd5000000555dddddddddcc00ccdddddddd77777077dddddd9a000a9a000add000000000000000000000000000000000000000000000000
ddd999ddddd77dddddd5000000005dddddddddcc11cc1ddddddd5077000ddddddd99aaa949aaa9dd000000000000000000000000000000000000000000000000
dd90909ddd7070ddd00500000005000ddddddd1ccccc1fdddddd5607777ddddddd999994949999dd000000000000000000000000000000000000000000000000
dd99999ddd7777dd00050000005000dddddd558111c1ffdddddd6670505dddddddd9976767699ddd000000000000000000000000000000000000000000000000
dd90009dddd700dddddd555555ddddddddd5558882110fdddd77566777dddddddddd96767679dddd000000000000000000000000000000000000000000000000
daf999addd767dddddddd00ddddddddddd555588822f0fdd77dd56ddd677ddddddddababbabadddd000000000000000000000000000000000000000000000000
daafffaad7d6d7ddddddd00dddddddddd555558882220f5d776666666d677dddddddababbab9dddd000000000000000000000000000000000000000000000000
dffffffddd767dddddddd0dddddddddd555544888225555577dd56ddd6d77ddddddabbab39339ddd000000000000000000000000000000000000000000000000
ddaddadddd6d6ddddddddddddddddddd5554448882445555d77776666ddd77dddddabab333939ddd000000000000000000000000000000000000000000000000
dd999ddddd9999dddddddddd44ddddddddddddd444dddddddddd22244422dddd0000000000000000000000000000000000000000000000000000000000000000
d90909ddd944944ddddddd94444ddddddddddd99444ddddddd333333333333dd0000000000000000000000000000000000000000000000000000000000000000
d99999ddd999999ddddd99999999dddddddd99999999dddddddd99999999dddd0000000000000000000000000000000000000000000000000000000000000000
d90009dddd9777ddddd9900999009dddddd9900999009dddddd9900999009ddd0000000000000000000000000000000000000000000000000000000000000000
dd999dddd3a3a3adddd9000090000dddddd9000090000dddddd9000090000ddd0000000000000000000000000000000000000000000000000000000000000000
d7d6d7ddd3a3a3addd9a0000a0000adddd9a0000a0000adddd9a0000a0000add0000000000000000000000000000000000000000000000000000000000000000
dd767dddd3a3a3addd99a00a9a00a9dddd99a00a9a00a9dddd99a00a4a00a9dd0000000000000000000000000000000000000000000000000000000000000000
dd6d6dddd3a3a3addd999aa999aa99dddd999aa900aa99dddd999aa444aa99dd0000000000000000000000000000000000000000000000000000000000000000
0000000000000000dd999888888999dddd99999a00a999dddd999899498999dd0000000000000000000000000000000000000000000000000000000000000000
0000000000000000ddd9876676789dddddd99999aa999dddddd9878888789ddd0000000000000000000000000000000000000000000000000000000000000000
0000000000000000ddd9867767689dddddd9a0000000adddddd9867767689ddd0000000000000000000000000000000000000000000000000000000000000000
0000000000000000dddd98888889dddddddd9aaaaaaadddddddd98888889dddd0000000000000000000000000000000000000000000000000000000000000000
0000000000000000ddddff9999ffdddddddddd9999ddddddddddff9999ffdddd0000000000000000000000000000000000000000000000000000000000000000
0000000000000000ddaaffffffffaaddddd7777777777dddddaaffffffffaadd0000000000000000000000000000000000000000000000000000000000000000
0000000000000000aaaaffffffffaaaad77dd777777dd77daaaaffffffffaaaa0000000000000000000000000000000000000000000000000000000000000000
0000000000000000aaffffffffffffaa7dd77dd77dd77dd7aaffffffffffffaa0000000000000000000000000000000000000000000000000000000000000000
00000000000000009090000000000000000000000000000000000000000009090000000000000000000000000000000000000000000000000000000000000000
00099900000000990900009009000004444000000000044440000090090000909900000000999000000000000000000000000000000000000000000000000000
00900090000000000900090000900040000402200220400004000900009000900000000009000900000000000000000000000000000000000000000000000000
09002009000000909009009999000000000002200220000000000099990090090900000090020090000000000000000000000000000000000000000000000000
09024209000090090090000000000044444000000000044444000000000009009009000090242090000000000000000000000000000000000000000000000000
09002009000900090909009999000009900400202000400990000099990090909000900090020090000000000000000000000000000000000000000000000000
00900000900099900000090000900090090000020200009009000900009000000999000900000900000000000000000000000000000000000000000000000000
00000009444444444444444444444444444444444444444444444444444444444444444490000000000000000000000000000000000000000000000000000000
00000004000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000
00000904000000000000000000000000000000000000000000000000000000000000000040900000000000000000000000000000000000000000000000000000
00440094000000000aaaa00a0000a0aaaaa0aaaa000aaaaaaa0a000a0aaaaa000000000049004400000000000000000000000000000000000000000000000000
0444409400000000a9999a0a0000a0a999a0a999a00a99a99a0a000a0a999a000000000049044440000000000000000000000000000000000000000000000000
0244209400000000a0000a09a00a90a00090a000a00900a0090a000a0a0009000000000049024420000000000000000000000000000000000000000000000000
0022009400000000a0000a00a00a00aaaaa0aaaa900000a0000a000a0aaaaa000000000049002200000000000000000000000000000000000000000000000000
0000009400000000a0000a00a00a00a99990aa99000000a0000aaaaa0a9999000000000049000000000000000000000000000000000000000000000000000000
0000090400000000a0000a00a00a00a00000a9aa000000a0000a999a0a0000000000000040900000000000000000000000000000000000000000000000000000
0000090400000000a0000a009aa900a000a0a099a00000a0000a000a0a000a000000000040900000000000000000000000000000000000000000000000000000
00000094000000009aaaa9000aa000aaaaa0a000a0000aaa000a000a0aaaaa000000000049000000000000000000000000000000000000000000000000000000
00440094000000000999900009900099999090009000099900090009099999000000000049004400000000000000000000000000000000000000000000000000
04444094000000000000000000000000000000000000000000000000000000000000000049044440000000000000000000000000000000000000000000000000
0244209400000000000000aaaa00000aa000aaaa00aaaa000aaaaa0aa00a00000000000049024420000000000000000000000000000000000000000000000000
002200940000000000000a9999a0000aa000a999a09a99a00a999a0aa00a00000000000049002200000000000000000000000000000000000000000000000000
000000940000000000000a00009000a99a00a000a00a009a0a00090a9a0a00000000000049000000000000000000000000000000000000000000000000000000
000009040000000000000a00000000a00a00aaaa900a000a0aaaaa0a0a0a00000000000040900000000000000000000000000000000000000000000000000000
000009040000000000000a00aaaa00a00a00aa99000a000a0a99990a0a0a00000000000040900000000000000000000000000000000000000000000000000000
000000940000000000000a0000a000aaaa00a9aa000a000a0a00000a0a0a00000000000049000000000000000000000000000000000000000000000000000000
004400940000000000000a0000a00a9999a0a099a00a00a90a000a0a09aa00000000000049004400000000000000000000000000000000000000000000000000
0444409400000000000009aaaa900a0000a0a000a0aaaa900aaaaa0a00aa00000000000049044440000000000000000000000000000000000000000000000000
02442094000000000000009999000900009090009099990009999909009900000000000049024420000000000000000000000000000000000000000000000000
00220094000000000000000000000000000000000000000000000000000000000000000049002200000000000000000000000000000000000000000000000000
00000094000000000000000000a000a000a000aa000a00000a000000000000000000000049000000000000000000000000000000000000000000000000000000
00000904000000000000000000a000a000a000aa000a00000a000000000000000000000040900000000000000000000000000000000000000000000000000000
000009040000000000000000009a009a00a00a99a00a00000a000000000000000000000040900000000000000000000000000000000000000000000000000000
000000940000000000000000000a00aa00a00a00a00a00000a000000000000000000000049000000000000000000000000000000000000000000000000000000
004400940000000000000000000a00aa0a900a00a00a00000a000000000000000000000049004400000000000000000000000000000000000000000000000000
044440940000000000000000000a00aa0a000aaaa00a00000a000000000000000000000049044440000000000000000000000000000000000000000000000000
0244209400000000000000000009aa99aa00a9999a0a000a0a000a00000000000000000049024420000000000000000000000000000000000000000000000000
0022009400000000000000000000aa00aa00a0000a0aaaaa0aaaaa00000000000000000049002200000000000000000000000000000000000000000000000000
00000904000000000000000000009900990090000909999909999900000000000000000040900000000000000000000000000000000000000000000000000000
00000004000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000
00900000444444444444444444444444444444444444444444444444444444444444444400000900333333330343433033333333ccc7cc7ccccc7ccc44464446
000904000900000000000000000000000000000000000000000000000000000000000090004090007335793734334444333333337ccc7cc7c56667cc45646564
00090420900440900904409009044090090440900904409009044090090440900904400902409000373773730433442333333333c7cc7cc75666667c44544454
00900400004444099044440990444409904444099044440990444409904444099044440000400900973753733343040333333333c7cc7c7c5666667c44446464
090000209024420000244200002442000024420000244200002442000024420000244209020000903977773933344423333333337cc7cccc5666667c44644654
00900000000220099002200990022009900220099002200990022009900220099002200000000900335573333333002333333333ccccc7ccc566667c44644464
00090090900009000090090000900900009009000090090000900900009009000090000909009000337773333330420333344233cccccc7cc56667cc56545664
00009900090000999900009999000099990000999900009999000099990000999900009000990000377755333044222330442243ccccc7cccccc7ccc45444554
333333333365666333333333333333333333333663333333333333333333333333334033333949495555555533399933333333337ccccccccccccccc44444466
333333333659566633355533333333333333336aa6333333333333333333333333404303339494945c55c55533999a9333333333c7ccc7cccccc7ccc46454454
3666333366767668355555553333333333333379a73333333353333333533333334340333949494955c55c55399aa999333333337ccccc7cccc657cc45456644
65553333878888785555555553333333333366666666333333555555555333334040333333349494555c55c5a99999a933333333cc7ccc7ccc66657c45445644
47076663777878c83677776633333333333622222222633333666666666333334303833333334943555c55c53a9aaa9333bbb333ccc7c7cccc66657c44445554
477755567478c878377000773333333333622227722226333666666666663333403388333333343355c55c55334242333bbbbbb3ccc7ccccc66657cc46644444
477707037478788836600077333333333338877777788333335555555553333333388883333333335c55c5553a242233bbbbbbbbccc7cccccccc7ccc45645666
4707777344488883377000765555533333377777777773333355555999533333333377333333333355555555944442233bbbbbb3cc7ccccccccccccc44444554
45665433333929293770007755555555333722222222733333555559095333333333773333333333555555554334343411111111111115511111111111111121
4666643333392929447777776666666333378877787c733333555550005333333332773333333222555cc555434393431111111111114225112c111111118122
666666333839292955777667777777733337887778c773333355666665555553332822263332222255c55c554433344311111111111422251c21441111188811
4444445337383333447444777007007333378877987c7333335554445556666632878226532442255c5555c5344342321aa1aaa111422251112444c111888881
44449455878863445574447770060063333788777888733333555444555303343877786653404455555cc55593442323aa9a99aa142224111144422118888811
4444443387863444446449744007007333378877788873333355544055530034377777653345545555c55c5533424233a9a9aa9a444241112444221111888111
454444557773444555744476677777733337444444447333335554445554444437707765334554535c5555c533242233a99a999a544411112241111122181111
4544445533334453447444744776677333322222222223333355544455544444377077533333333355555555944442291a9999a1155111111221111112111111
__map__
dbdbebebdbebebebdbdbdbebebefdfdfdfefefebedededebebebebebebebebeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdddcebdcdcecdcdcdcebdcdfdfefefdfefecdcededebdcdcdcdcebdcdbeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcecdcdcecdcdcdcdcececefefdfefebdfdfdfededede2e3dbdcdcdcdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbdcdcdbdcdcdcdedcecefdfdfdfefdbebdcdfefeeededf2f3dcdcebdcdcdbdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbdcdcdcecececececefefdfdfefdcebebdcededeeeeefdfdfdcecdcdcebdceb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbebdcecefdfefefdfdfdfefecdcdcebededededeeefefdfdfefefecdcdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdcefdfdfdfefdfdfefefecdcebebedededdcefdfdfdfefdfefdcdcdcdbdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbdcdcdfefdfdfefdfefececdcdcecebededdcdbdcdfefdfdfdfdcdcdcebdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbebdcdfdfdfefdfdfecdcdcdcdcdcdbebdcdcdcdcdcdfdfefefecdcdcdcebeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdcefdfefefdfecdcebdcdcebdcdbebebdcdcecefdfefececdcdcdcecdceb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdcefdfdfefecdcdcdcdcecdcdbebebdeebecdfefefecdcdcdcdcdcdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdfdfdfefecdcdcdcdcdcdcdcdeebdbdcecdfdfefdcdcdcdcdcdcdbdcdddb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebefdfdfefdcdcdcdcecdcebdcdcebdbebdcefdfefdcdcdcdcdbdcebdcdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dfefdfefdcdcebdcdbdcdcdcdcecdcebebefefefdcdcdcdcdcdcecdcdcdbdceb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dfdfefdcdcdcecdcdcdcdcdbdcdcdcdbdfdfdfefdcdbdedcebdcdcdcdcdcdceb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dfefdbdbebdbebdbebebdbdbebebdbdbdfdfefebdbdbebdbebebdbdbebebdbeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

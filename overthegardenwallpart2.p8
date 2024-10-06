pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- over the garden wall
-- made by pepperoni-jabroni
-- configs, state vars & core fns
local walkable=split("43,110,158,185,106,190,191,202,203,205,207,222,223,238,239,240,241,242,244,245,246,247,248,249")
local altsset={}
local inv_items=(function()
  local items={}
  for i in all(split('', '#')) do
    local idata=split(i)
    add(items,{spridx=idata[1],name=idata[2]})
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
},split('', '|')
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
  for c in all(split('g;greg;0;2;where is that frog o\' mine!|wanna hear a rock fact?#w;wirt;1;4;uh, hi...|oh sorry, just thinking#b;beatrice;16;6;yes, i can talk...|lets get out of here!#k;;17;8;ribbit#a;the beast;32;34#m;the woodsman;33;36;i need more oil|beware these woods#?;the innkeeper;48;38;keep that bird out!#d;the highwayman;49;40;i\'m the highwayman#t;band frog;64;66;ribbit#z;band frog?;65;68#o;mr. frog;80;70;ribbit#i;ms. frog;81;72;ribbit#s;the midwife;96;98;well look at you!#p;the butcher;97;100;i\'m the butchah#e;the baker;112;102;i\'m the baker!#u;the whistler;113;104;*whistles*#l;the toymaker;10;12;hehe|oh hahaha#j;fred;11;14;*neighs*|*whinnies*#c;quincy endicott;26;44;oh dear nephew#r;marguerite grey;27;46;oh that quincy!#n;the lantern;;76#F;rock fact;215;78#E;edelwood;219;192#y;adelaide;184;182;i need a child!#A;achievement get!;;196#C;golden scissors;;194', '#')) do
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
  for m in all(split("exterior,woods1,somewhere in the unknown,0,0#exterior,woodsinn,the old inn,16,0#interior,inn,the inn,32,0,woodsinn,224,4,2#exterior,woods2,somewhere in the unknown,48,0#exterior,woodsmanor,the endicott manor,64,0#interior,manor1,the endicott manor,80,0,woodsmanor,227,6,6#interior,manor2,the endicott manor,96,0,woodsmanor,227,6,6#interior,manor3,the endicott manor,112,0,woodsmanor,227,6,6#exterior,woodsboat,the riverboat port,0,16#interior,riverboat,the riverboat,16,16,woodsboat,230,1,7#interior,riverboat2,the riverboat,16,16,woodsboat2,230,13,6#exterior,woodsboat2,the riverboat port,32,16#exterior,woodsadel,somewhere in the unknown,48,16#interior,adel,adelaide\'s home,64,16,woodsadel,232,12,4", '#')) do
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
  for n in all(split('m,8,9,woods2#?,8,12,inn#d,5,7,inn#t,6,7,riverboat#t,8,7,riverboat#o,3,8,riverboat#i,4,8,riverboat#o,10,3,riverboat#i,9,3,riverboat#s,10,7,inn#p,11,7,inn#e,4,12,inn#u,4,7,inn#l,7,5,inn#j,14,9,inn#c,7,11,manor1#r,8,8,manor3#y,5,5,adel', '#')) do
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
  for m in all(split('woods1;woodsinn;0,11|0,12|0,13;15,11|15,12|15,13#woodsinn;inn;4,3|5,3;7,14#woodsinn;woods2;0,5|0,6|0,7;15,6|15,7|15,8#woods2;woodsmanor;0,13|0,14|0,15;15,13|15,14|15,15#woodsmanor;manor1;6,7|7,7;5,14|7,14#manor1;manor2;15,5|15,6|15,7;0,5|0,6|0,7#manor2;manor3;15,9|15,10;0,9|0,10#woodsmanor;woodsboat;0,9|0,10|0,11;15,9|15,10|15,11#woodsboat;riverboat;2,7|2,8;8,12|8,13#riverboat;woodsboat2;3,11|3,12;12,6|12,7#woodsboat2;woodsadel;0,13|0,14;15,13|15,14#woodsadel;adel;12,5|13,5;7,13', '#')) do
   local mdata = split(m, ';')
   add(cmaptrans,{mp_one=mdata[1],mp_two=mdata[2],mp_one_locs=split(mdata[3],'|'),mp_two_locs=split(mdata[4],'|')})
  end
  return cmaptrans
end)()

local dialogs = (function()
  local cdialogs,i = {},1
  for d in all(split("k;led through the mist-k;by the milk light of moon-k;all that was lost is revealed-k;our long bygone burdens-k;mere echoes of the spring-k;but where have we come?-k;and where shall we end?-k;if dreams can't come true-k;then why not pretend?-k;how the gentle wind-k;beckons through the leaves-k;as autumn colors fall-k;dancing in a swirl-k;of golden memories-k;the loveliest lies of all",'+')) do
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
 if (is_element_in(split'intro,playmap',act_stagetype)) numticks+=0.03
 get_stage_by_type(act_stagetype).update()
end

function _draw()
 get_stage_by_type(act_stagetype).draw()
 -- draw framerate
--  print(stat(7),4,5,1)
--  print(stat(7),4,4,12)
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
 ?'v1.1.0',100,120,9
end

function update_controls()
 if btnp'4' then
  act_stagetype="mainmenu"
 end
end

function update_main_menu()
 if btnp'2' then
  act_y = (act_y+2)%3
 elseif btnp'3' then
  act_y = (act_y+1)%3
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
 local na,nt=#achievs,flr(numticks)
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
 if btn'4' then
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
   compute_darktiles(false)
  elseif btnp'1' and act_x < 15 and is_walkable(act_x+1, act_y) then
   act_x = act_x + 1
   act_fliph=false
   compute_darktiles(false)
  elseif btnp'3' and act_y < 15 and is_walkable(act_x, act_y+1) then
   act_y = act_y + 1
   compute_darktiles(false)
  elseif btnp'0' and act_x > 0 and is_walkable(act_x-1, act_y) then
   act_x = act_x - 1
   act_fliph=true
   compute_darktiles(false)
  end
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
 if btnp'5' and act_item!=nil and not x_consumed then
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
  for c in all(charids) do 
    add(npcs,get_npc_by_charid(c))
  end
  for p in all(party) do 
    if (is_element_in(charids,p.charid)) del(party,p)
  end
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
 ?"\fa\142+\148\131\139\145\f7 select object\n or npc",16,80
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

local darktiles={}
function compute_darktiles(full)
  local activemap=get_map_by_id(act_mapsid)
  if(full)darktiles={}
  for i=ternary(full,0,act_x-2),ternary(full,15,act_x+2) do
   for j=ternary(full,0,act_y-2),ternary(full,15,act_y+2) do
    local nearforplayer=distance(i, j, act_x, act_y) < 2.7
    local idtfr=tostr(i)..'|'..tostr(j)
    if not activemap.discvrdtiles then
     activemap.discvrdtiles={}
    end
    if not nearforplayer and not is_element_in(activemap.discvrdtiles, idtfr) then
     if(full and not is_element_in(darktiles,idtfr))add(darktiles,idtfr)
    elseif not is_element_in(activemap.discvrdtiles, idtfr) then
     add(activemap.discvrdtiles,idtfr)
    end
    if not full and nearforplayer then 
     del(darktiles, idtfr)
    end
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
  for dts in all(darktiles) do 
   local dt = split(dts,'|')
   local tgtx,tgty=tonum(dt[1]),tonum(dt[2])
   local mspr=mget(tgtx+get_map_by_id(act_mapsid).cellx, tgty+get_map_by_id(act_mapsid).celly)
   if is_element_in(darkspr.idxs,mspr) then
    -- draw "dark" sprite
    for i=1,#darkspr.clrmp_s do
     pal(darkspr.clrmp_s[i],darkspr.clrmp_d[i])
    end
    spr(mspr,8*tgtx, 8*tgty)
    for i=1,#darkspr.clrmp_s do
     pal(darkspr.clrmp_s[i],darkspr.clrmp_s[i])
    end
   else
    if #darkanims==0 and flr(rnd'30000')==0 then
     add(darkanims,{frmcnt=35,type='eyes',x=tgtx,y=tgty})
    end
    rectfill(8*tgtx, 8*tgty,(8*tgtx)+7, (8*tgty)+7,0)
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
 local char_name=nil
 if act_text_charsel != nil and act_text_charsel.frmcnt>0 then
  char_name=act_text_charsel.txt
  act_text_charsel.frmcnt-=1
 else
 end
 draw_fancy_spr_box(1,get_char_by_id(act_charid).mapspridx,char_name)
 if act_item!=nil then
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
 act_text_maptitle={x=titlex,y=64,txt=m.title,frmcnt=45}
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
 compute_darktiles(true)
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
dd6666dd88888ddd6d66666666666666dddd88888888888dddddddddddddddddddddddddddddddddd88ddddddddddddddd888888888ddddddddddddddddddddd
d666666dd88888ddd6666666666666d6ddd888888888888ddddddd6666ddddddddddddddddddddddd2888dddddddd4dddd8882222228dddddddddddddddddddd
6d4444d6d84444dddd666666666666ddddd888888888888ddddd66666666dddddddddddddddddddddd2888dddddd4606d5522ffffff2855ddddddddddddddddd
d6f0f0ddddf0f0ddddd6444444446dddddd84888888488ddddd6666666666dddddddbbddddbbddddd5f0f05ddddd4965d52fffffffff255ddddd444554dddddd
ddffffddd1ffff1dddd4444444444ddddd842844444248ddddd6666666666ddddddbbbbddbbbbdddddf555dd464466ddd55f77ffff77f55ddddd445544666ddd
d737737dd697796ddd44774ff47744dddd8277ffff7728dddd667766667766ddddb3773bb3773bddd767767d46116dddd5f7607ff7607f5dddd554566666666d
d733337dd677776dddf7607ff7607fdddd47607ff76074dddd676076676076ddddb7607bb7607bdddf3333fdd6565dddddf7007ff7007fddddd4996677666666
dd0dd0ddd202202dddf7007ff7007fddddf7007ff7007fdddd670076670076dddd370073370073dddd5dd5ddd6565dddddff77feff77ffdddd44996670666665
ddddddddddddddddddff77ffff77ffddddff77ffff77ffdddd667766667766dddd337733337733dddddddddddd4447ddddff555e555fffddd444455666666666
dddddddddddddddddddff0ffff0ffddddddffffffffffdddddd6666556666ddddd3b03333330b3dddd6565ddd44c444ddddf50fff05ffddd4444665566660666
ddddd60ddddddddddddff000000ffddddddfff0000fffdddddd6665555666ddddd3bb000000bb3ddd6f0e06ddd4444ddddddff000fffdddd444666655566600d
dccce665ddd3dbddddddff0000ffddddddddffffffffdddddddd66655666ddddddd3bbbbbbbb3dddddffefddddf0f0dddddddffffffddddd446666665ddddddd
ddcceeddddd0b0ddddd733ffff337dddddddd1ffff1dddddddddee6666eedddddddd33333333dddddd7ff7ddddffffdddddd46666664dddd66666666dddddddd
dd9c77dddd33bbdddd773377773377ddd11111177111111dddd7eeeeeeee7dddddd3333333333dddd276672dd66cc66dddd7477767747ddd66666666dddddddd
ddddddddd33bbdddd77733777733777d1111197777911111ddc77eeeeee77cddddb3333333333bdddf2292fddfc11cfddd774777577477dd66666666dddddddd
ddddddddd3b3bdddd77333333333377d1197777777777911dcc7777777777ccddbb3333333333bbddd0dd0ddd666666dd77747776774777d6666666ddddddddd
51dddd15dd0000dd1d5d5ddddddd5d15dd655555555555dddd777777777777ddd4444444444ddddd0020202000000000dddddd6666dddddddddd474c4474dddd
15161651dd0000dd11d5ddddddd5511dd65555555555552dd77555555555577d442444444444dddd0004740029000020ddddd666666dddddddd47ac6c7a74ddd
51676765d000000dd115dd1111d51155d66666666666622d775577676767557742d4444444444ddd0004440004444400dddd66ffff66ddddddd4474c44744ddd
d516165dddf0f0dd5511d6611665155dd65555555555552d75577676767675572d422222222224dd0004740024555422ddd66ffffff66ddddddd55555555dddd
ddd11dddd54ff44add51677667761ddddd666666666662dd5576000fff006755dd266666666662dd0004740004444400dd66f5fffff566dddddd44444444dddd
d111111d460000a9d5dd67766776d5ddddff760ff760ffdd5760f77ff77f0675dd600000000006dd0004440029000020d66f577fff77566dddd4444ff4444ddd
1d1111d1d6000060dddd16611661ddddddff700ff700ffdd567f76077607f765dd000aa00aa000dd0004740000000000dd6f7760f77606ddddd44ffffff44ddd
dd1dd1dddd5dd5dddddd11111111ddddddfff7799f77ffdd576f70077007f675dd000a500a5000dd0020202000000000d66f7700f770066dddd4f77ff77f4ddd
ddddddddd444ddddddddd111111ddddddddfff9999fffddd567ff77ff77ff765dd500000000005dd4444444444444444dddff77fee77fddddddf76077607fddd
dd6776dd42444ddddddddd1111dddddddddffff99ffffdddd76fffffeffff67ddd655552255556dd4425244444333344dddfffffeefffdddddd6700770076ddd
d654446d2d2444dddddd11111111ddddddddff0000ffdddddd7fe0ffff0ef7ddddd6666226666ddd4225224443bbbb34ddd77fffeef77dddddddf77ff77fdddd
d740f07ddd5050dddddd11111111ddddddd222ffff220dddddddff0000ffdddddddd66575766dddd4255524443bbbb34ddd77f0000f77ddddddddf0000fddddd
d6ffff6ddd6626ddddd1111111111ddddd040000000044dddddd5ffffff5ddddddddd675756ddddd422522443b3bb3b3ddd777ffff777dddddddddf00fdddddd
d055550dd888888dddd1111111111dddd55200000000255dddd055ffff550ddddddd88822288dddd4625264443333334dd277556655772dddddddc1ff1cddddd
df0770fdd644a46dddd1111111111ddd0005000000099000dd00055ff55000ddddd8888828888ddd4066644449a44a94d22225566552922ddddd66f11f66dddd
dd0770dddd2dd2ddddd1111111111ddd00050000009aa900d00000566500000ddd888888288888dd205054422a4444a2d22222290229a92ddddcc6ff5f6ccddd
dd8888dddd8888dddddd88888888dddddddd88888888dddddddd44444444ddddddddccccc676dddd4444444444444444dddddddddddddddddddddddddddddddd
dd8aa8dddd8aa8dddddd88888888dddddddd88888888dddddddd44422444ddddddddcccc676cdddd4444444444444444dddddd0000dddddddddddddddddddddd
dd0000dddd0000dddddda9a9a9a9dddddddda9a9a9a9dddddddd22222222dddddddd11116761ccdd4444444444444444ddddd0dddd0ddddddddddddd666ddddd
dd3030dddd3030dddddd22222222dddddddd22222222ddddd42244444444224dddddccccc6cc11dd4452254444444444dddd0dd11dd0dddddddd66666666dddd
dd3333dddd3333dddddd03000030dddddddd3bb333bbdddddd440300003044ddddcc13111131dddd4225524444444444ddddd011110dddddddd6666666666ddd
d880a88ddd01a0dddddd37333373ddddddddb77bbb77dddddddd37333373dddddd1137333373dddd4222224444444444ddddd0d55d0dddddddd66777677766dd
db8008bdd111111ddddd70733707dddddddd7607b7607ddddddd70733707dddddddd70733707dddd4454454444444444ddd6dd0550dd6ddddd6661776771666d
dd0dd0ddd111a11dddd3373333733dddddd3700737007dddddd3373333733dddddd3373333733ddd2454454244444444dddd6d5aa5d6ddddd56667766677666d
dd444ddddd6d6ddddddb33333333bdddddd0377333770ddddddb33333333bddddddb33333333bddda888888444222224ddddd6a97a6ddddd556666666666666d
dd999ddddcd6cdcdddd3bbbbbbbb3ddddddb00000000bdddddd3bbbbbbbb3dddddd3bbbbbbbb3ddd8222284442452452dd66dda79add66dd555666aaaaaa666d
d444444ddd6cccdddd053333333350dddd05bbbbbbbb50dddd053333333350dddd053333333350dd8888844442452452ddddd65aa56dddddd55666a0880a665d
dd3030dddd3030ddd82055555555028dd11055555555011dd42055555555024ddc105555555501cd8282884442452452dddd6dd11dd6ddddd55566aa88aa55dd
dd3333dddd3333ddd8820a9009a0288dd11100000000111dd42200000000224ddc1c000000001ccd8222284425502022ddd6dd1111dd6ddddd55566688655ddd
d22aa22ddccccccdd88828099082888dd1111a5555a1111dd44222676722244ddcc1ccc1ccc1cccd8282884454450445ddddddddddddddddddd5555666555ddd
db2222b0db1cc1bdd8888a9009a8888dd11111110111111dd44444722644444ddccc1c101c1ccccd8222284454450445dddddddddddddddddddd55555555dddd
dd0dd0d0d1c11c1dd88888099088888dd1111a5555a1111dd44244422444244ddcc1c1c0c1cc1ccda888844445544554ddddddddddddddddddddddd5555ddddd
ddddddddddddddddddb3333333333bddddddddddddddddddddddddd11dddddddddddd244444ddddd4444444444444444333332333333433333333333dddddddd
dbbbbddddddddddddddb33333333bdddddddddddddddddddd7cccccccccccc7ddd244444444444dd4444444444444444333324333344944333333333dddddddd
db3333dddd6666ddddd3333333333dddd56dddddddddddddccc1111111111cccd24444444444444d4444444444444444333232333339933333333333dddddddd
dd40f0ddd6f0f0ddddbbbbbbbbbbbbdd5556ddddddddddddd11111111111111dddd999ffff999ddd4444444444444444332323433339933333333333dddddddd
ddffefddddffefdddd333333333333dd65666666666667ddd10000000000051ddddaffffffffaddd4444444444444444334233333333233333333333dddddddd
d333333dd117711ddb3b44ffff44b3bd566666ffff66667dd00ffffffffff05dddaaf66ff66faadd4444444444444444332333333444244333333333dddddddd
df3bb3fddf5775fdd344ffffffff443dd6665555f555566dd00f000ff000f00ddaaaf00ff00faaad4444444444444444343433333344443333333333dddddddd
dd3bb3dddd0dd0ddd4ff7607f7607f4dd6ff7607f7607f6dd0ff7607f7607f0ddaadeeffffeedaad4444444444444444333333333333333333333333dddddddd
dddddddddd2444dddff77007770077fddfff7007f7007ffddfff7007f7007ffdddddeeff0fee000033333333333333333333333333333333dddddd9433333333
ddddddddd244444ddfff7777e7777ffddfff7777e7777ffddfff777ee777fffddddddff00ffd0dd033333333333333333333333333333333ddddd94d33333333
dd111ddddaf0f0addffffffeeffffffddffffffeeffffffddffffffeef0ffffdddddd99ff9900d0033333333334433333333333333333333ddddd9ad33333333
d111111dddeffeddddff767ff676ffddddffff0000ffffddddffff0000ffffdddd889991199988dd33333333442333333333333333333333dddd9a4d33333333
ddf0f0ddd881088dddddff6767ffddddddddffffffffddddddddffffffffddddd88899616190080033333344992333333333333333333333ddaa94dd33333333
ddffefdd8d8118d8dd3bb333333bb3dddd177111111771dddd776777777677dd888882165620880833334432399233333333333333333333da94addd33333333
d777677ddf6666fdd333bb3bb3bb333dd11177777777111dd77776677667777d88d821115100800833443232939233333333333333333333da99addd33333333
df5665fddd0dd0ddd3333bb33bb3333dd11117777771111dd77700766700777d8dd8211151128dd834323233294433333333333333333333ddaadddd33333333
00000000000000009090000000000000000000000000000000000000000000000000000000000000329233234434222333333333333333332202220222222244
00099900000000990900009009000004444000000000000000000000000000000000000000000000329323442499233333333333333333330000000046666644
00900090000000000900090000900040000402200aaaa00a0000a0aaaaa0aaaa000aaaaaaa0a000a323944242929933333333333333333330222022246907944
0900200900000090900900999900000000000220a9999a0a0000a0a99990a999a00a99a99a0a000a32442422299b9b3333333333333333330000000045970944
0902420900009009009000000000004444400000a0000a09a00a90a00000a000a00900a0090a000a343992233399b33333333333333333332202220220202044
0900200900090009090900999900000990040020a0000a00a00a00aaaaa0aaaa900000a0000a000a339929333333333333333333333333330000000027676744
0090000090009990000009000090009009000002a0000a00a00a00a99990aa99000000a0000aaaaa3b9b99333333333333333333333333330222022242555244
0000000944444444444444444444444444444444a0000a00a00a00a00000a9aa000000a0000a999a33b993333333333333333333333333330000000042444244
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
444444444444444444444444444444444447744454445444ddddddd118ddddddddd11ddd444444440000004e12ccccc2eeeeeee1e4ffe0004244444444444444
000000004444444444444444444444444467774400000000dddddd118216dddddd8816dd44444444000004eefe22222eeeeeeee1e4fe00004343424444442244
090440904444444444444444444444444466774444444444ddddd18821676dddd111221d4444444400000044444118a8eeeeeeefe4e000004234424444444444
904444094444444444444444444444444446644444477444dddd00220006dddddd2060dd44444444000000000001188a44444444400000004244424411111111
002442004444444444444444444444444444444444677744ddd0111111110ddddd26e6dd4444444400000000001111a000000000000000004243434444444444
900220094444444444444444444444440000000044667744d11116565651111dd288482d44444444000000000104001000000000000000004244324442244444
009009004444444444444444444444445444544444466444dd005556655650ddd682286d44444444000000000104001000000000000000004244424444444444
990000994444444444444444444444440540054044444444dddd67766776dddddd2222dd44444444000000000000000000000000000000004444424411111111
d4444444444444d0dddddddddddddddddddddddddddddddddddd67066706dddd444444444444444433333333333333333333333333333333cccccccc44444444
d2444444444444d4dddddddddddddddddddddddddddddddddddd6556e556dddd4444444444444444333333333b3b33333333333333333333cccccccc44444444
dd44444949444442dddddddddddd99ddddddaaaaaaaadddddddd6666e666dddd44444444444444443333333333b33333333bbb3333333333cccccccc44444444
d44449904099444ddddddddddda99aadddda99999999adddddddd660066ddddd4444444444444444333333333333333333bbbbb333333333cccccccc44444444
0244900040009444dddddddddd99aa0ddda4999999994adddddd88600688dddd44444444444444443b3b33333333b3b33bbbbbb333333333cccccccc44444444
dd24000292000944dddddddaa99aa9dddd9a44444444a9ddddd8828668288ddd444444444444444433b3333333333b333bbbbbb333333333cccccccc44444444
ddd4002904200042ddddddda99aaa0dddda9aaaaaaaa9adddd882824428288dd444444444444444433333333333333333bbbbbb333333333cccccccc44444444
04d420400440204dddd9999a9a99addddaaa99999999aaaddd882222222288dd444444444444444433333333333333333333333333333333cccccccc44444444
d24404499444440ddd990099aa9a0dddaddaaaaaaaaaaddadddddddd333333334288682444444444333333330343433033333333ccc7cc7ccccc7ccc44464446
ddd044900994040dd990aaaaaa90ddddadddaa4999aadddadddddddd3366663342666824444444444332483434334444333333337ccc7cc7c56667cc45646564
dd4499000009444dd99da00aa00ddddddadda49a9a9addaddddddddd360767032288662244444444343443430433442333333333c7cc7cc75666667c44544454
dd4900022000944dd09aadd0adddddddddada499a99adadddddddddd366666634222222444444444243423433343040333333333c7cc7c7c5666667c44446464
dd4000244000042ddd0a0dddaddddddddddaa49a9a9aaddddddddddd366aaa63442aa244444444443844443233344423333333337cc7cccc5666667c44644654
dd420244042024dddddaaddaadddddddddddda4999addddddddddddd356686534429924444444444332243333333002333333333ccccc7ccc566667c44644464
d4404444044404ddddd0aaaa0dddddddddddddaaaadddddddddddddd305555034429824444444444334443333330420333344233cccccc7cc56667cc56545664
d4004440444042dddddd0000ddddddddddddddaaaadddddddddddddd330000334222222444444444344422333044222330442243ccccc7cccccc7ccc45444554
333333333333333333331133333333111133333333113333cccc0c0ccccccccc33333333333300335555555533399933333333337ccccccccccccccc44444466
3330333330333333333111133333311cc113333331111333ccc0c55c0ccccccc33333333333555335c55c55533999a9333333333c7ccc7cccccc7ccc46454454
33000000000333333331cc111111ccc76ccc111111cc1333cccc0966cccccccc333300022255533355c55c55399aa999333333337ccccc7cccc657cc45456644
3000000000003333333c76c1111c76c77c76c1111c76c333cccc05aacccccccc333033b333552333555c55c5a99999a933bbb333cc7ccc7ccc66657c45445644
335555595953333333317711111177177177111111771333ccccc5667778174c3303b333b33b3233555c55c53a9aaa933bbbbb33ccc7c7cccc66657c44445554
3366559aaa53000333317711111111111111111111771333cccc99dddd99cc4c303b33b33b33332355c55c55334242333bbbbbb3ccc7ccccc66657cc46644444
3355555a0a9000003336ffffffffff6ff6ffffffffff6333c4819ddddd77777c03333333b33b3b325c55c5553a2422333bbbbbb3ccc7cccccccc7ccc45645666
33555660005555553336ffffffffff6ff6ffffffffff6333c4c78dddd777777c03b3b3b335566552555555559444422333333333cc7ccccccccccccc44444554
3300666655595566333576ff76ff765ff576ff76ff765333c7787777777777cc0b5b5b6b556666625555555543343434dddddddddddddddddddddddddddddddd
34245445555a9555333577ff77ff775ff577ff77ff775333c888889a98888ccc0666966666655552555cc55543439343dddddddddddddddddddddddddddddddd
3242540566597667333577ff77ff775ff577ff77ff775333788889111988c6cc0559a4644555665255c55c5544333443dddddddddddddddddddddddddddddddd
33555445555665563335ffffffffff5445ffffffffff53336688911a11967c6c06654a94065555325c5555c534434232dddddddddddddddddddddddddddddddd
3333322333333333333676ff76ff76640676ff76ff766333c76767677767cccc3335595446633333555cc55593442323dddddddddddddddddddddddddddddddd
3333444444443333333677ff77ff77644677ff77ff7763337c6cc67ccc7cc6c6333444422443333355c55c5533424233dddddddddddddddddddddddddddddddd
444444444444433333367676767676767676767676767333ccc6cccccccccccc34444444444444445c5555c533242233dddddddddddddddddddddddddddddddd
444444444444444433376767676767676767676767676333cccccc6ccccccccc44444444444444445555555594444229dddddddddddddddddddddddddddddddd
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
cdcdcdcdcdcdcdcdcdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdebcdebcdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcddbcdcdebcdebcdcdcdcdcdebcdcdebcdcdcdcdcdebcdcdcdcdcdcdcdcddbebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd
cdebcdebcdcdebcdcdcdcdcdebcdebcdcdcdcdcdcdcdcdcdcdcdcddbebcdebcdcdcdaf8e8e8e8e8e8e8e8e8e8eafcdcdebcdcdcdcdcdcdcdcfcfcfcccdcdebcdcdebcdcdcdcdcdcdcdcdcdebcdcdcdcdcdaf8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8eafcd
cdcdcdcdcdcdcdcdebebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdebebcdebcdcdafbfbfbfbfbfbfbfbf3abfafcdcdcdebcdebcdcccfcfcfcfcfcfcfcdcdcdcdcde0cdcdcdcdcdcdcdcdcdcdcdcdcdccafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
ebebcdcdcdcddbebcdcdebcdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdebebcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdcdcdcdcdcccfcfcfcdebcdcfcfcfcdebcdcdebcdcdcdcdcdcdcdcdcdcdcdebcdcdafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cdcdcdcdebcdebcdebcdcdcdcdcdebcdcdcdcdcdcfcfcdcdcdcdcdcdcdcdcdebcdcd2ab5b5b5b5b5bfbfbfbfbfafcdcdcdcdcdcccfcfcfcdcdcdcdcdcfcfcdcdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cdcdebcdebebcdcdcdcdcdcdcdcdcdcdcfcfcdcfcfcfcfcdcdcdcdcdcdebebebcdcdafbfbfbfbfbfbfbfbfbfbfaf8e8eebcdcdcfcfcfebcdcdebcdcdebcfcfcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cdebcdebcdcdcdcdcdeccfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcdcdcdcdcdebcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdcdebcdcfcfcdcdebcdcdcdcdcdcfcfcfcdcdcdcdcde2cdcde5cdcdcdcdcdcdebcdafbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cdcdcdcdcdcdcdcfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcfcf6ccdcdcdebcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdcdcdcfcfcfebcdcdcdcdcdebcdcdcfcfcdcdcccdcdf2cdcdf5cdcdcdcdcdcdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cdebcdcdcdcfcfcfcfcfcfcfcfeccdcdcdcdcdcdcdcdcd6ccfcfcfcf6ccdcdcdcdcdafbfbfbfbfbfbfb4b4b4bf2acdcdcdcdcfcfcdcdcdcdebcdcdcdcdcdcccfcdcdcdcdcdcdcfcfcdcdcdcdcdcdcdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
ebcdcdeccfcfcfcfcfcfcfcdcdcdebcdcdcdcdcdcdcdcdcd6ccfcfcfcfcdcdcdcdcdafbfbfbfbfbfbfb5b5b5bfafcdcdebcfcfcfebcdcdcdcdcdcdcdebcdcdcdcfcfcfcfcfcfcfcfcfcfcdcdcdcccdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cdcdcfcfcfcfcfcfcdcdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcfcfcfcdcdcdcdafbfb5b5b5bfbfbfbfbfbfafcdcdcdcfcfcdebcdcdebcdcdebcdcdebcdebcfcfcfcfcfcfcfcfcfcfcfcdcdcdcdcccdafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cfcfcfcfcfcfeccdcdcdcdcdebebcdcdaeaeaeaeaecdcdcdcd6dcdcdcfcfcfcfcdcd2abfb4b4b4bfbfbfbfbfbfafafcdcdcfcfcdcdcdcdcdcdcdcdcdcdcdcdcdcfcfcfcfcfcfcfcfcfcfcfcfcfcdcdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cfcfcfcfcdcdcdcdebcdebcdcdebebcdaeaeaeaeaeaecdcdcdcdcdcdcdcfcfcfcdcdafbfbfbfbfbfbfbfbfbfd8afcdcdcccfcfcdcdcdebcdcdebcdcdcdcdebcdcdcdcdcdcccdcdcdcdcfcfcfcfcfcdcdcdafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cfcfeccdcdcdcdebcdebcdebcdcdcdcdaeaeaeaeaeaeaecd9e9e9e9ecdcdcfcfcdcdafbfbfbfbfbfbfbfbfbf5bafcdcdcfcfcfccebcdcdcdcdcdcdcdcdcdcdcdcdebcdcdcdebcdcdcdcdcdcfcfcfcfcfcdafbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfbfafafbfbfbfbfbfbfbfbfbfbfbfbfbfafcd
cdcdcdebcdebebebcdcdcdcdcdcdcdcdaeaeaeaeaeaecdcdcdcdcdcdcdcdcdcdcdcdaf8e8e8e8e2b8e8e8e8e8eafcdcdcfcfcccdcdcdcdcdcdebcdcdcdebcdcdcdcdebcdcdcdcdebcdcdcdcdcfcfcfcfcdaf8e8e8e8e2b2b8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8eafcd
cdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdaeaeaeaeaeaecdcd9e9e9e9ecdcdcdcdcdcdcdcdcdcfcfcfcfcfcfcdcdcdcdcdcfcfcdcdcdebcdcdcdcdcdebcdcdcdcdcdebcdcdebcdcdcdcdcdcdcdcdcfcfcfcdcdcdcdcfcfcfcfcfcfcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd
cececececdcdcdcdcdcdcdcdcdcdcdcdcecececececececececececececececedbcdebcdcdebcdcdebcdcdcdcdcecececdcdcdcdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cecececececdebcdcdcdebcdcccdebcdcecececece8e8e8e8e8e8ecececececeebcdcdcdcdcdcdcdcdcdcdcccececececdcdcdcdcdcdcdebcdcdcdebcdcdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cecececedecdebcdcdcdcdcdcdcdcdcdcececece8ebfbfbfbfbfbf8ececececeebcdcfcfcfcfcfcccdebebcdcececececdcddbcdcdcdcdcdcdcdcdcdcdcdcdebcdcdaf8e8e8e8e8e8e8e8e8e8eafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cececedececdcdcdcdcdcdcdebcdcdcdcecece8ebfbfbfbfbfbfbfbf8ececececdcfcfcfcfcfcfcfcdcdcdcdcecececeebcdcdcdebcdcdebcdcdcdcdcdcdcdcdcdcdafbfbfbfbfbfafbfbfbfbfafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cecececececdcdcdebcdebcdcdcdcdcdcecece8ebfbfbfbfbfbfbfbf8ececececdcfcfcfcfcfcfcfcdcdcdcdcdcecececdcdcdcdcdcdcdcdcdcdcdcdcdcdebcdcdcd2abfbfbfbfbfafbfbfbfbf2acdcd00bf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cecececececdcdebcdcdcdcdcdcdebcdcecece8ebfbfbfbfbfbfbfbf8ececececdcdcfcfcfcfcfcdcdcdcdcdcececececdcdcdebcdcdebcdcdcdcdcdcdcdcdcdcdcdafbfbf5abfbfafbfbfbfbfafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cececececdcccdcdcdcdcdcdcdcdcdcdcece8ebfbfbfbfbfbfbfbfbfbf8ecececccdcdcfcfcfcfcfcfbfbfbfbfcecececfcfcdcdcdcdcdcdcdcdcdcfcfcfcdcdcdcdafbfbfbfbfbfafbfbfbfbfafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cececebfbfbfcfcfcfcfcfcfcfcdcdcdcece8ebfbfbfbfbfbfbfbfbfbf8ebfcecdcdcfcfcfcfcfcfcfbfbfbfbfcecececfcfcfcfcdcdcdcdcdcdcfcfcfcfcdebcdcdaf8ebfbfbf8eafbfbfbfbfafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cececebfbfbfcfcfcfcfcfcfcfcfcfcfcece8ebfbfbfbfbfbfbfbfbfbf8ebfcecdcdcdcfcfcfcdcdcdcdcdcdcececececccfcfcfcfcfcccdcdcfcfcfcdcdcdcdcdcd2abfbfbfbfbfbfbfbfbfbf2acdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cecececececdcdcccdcdcfcfcfcfcfcfcece8ebfbfbfbfbfbfbfbfbfbf8ebfcecdcdcdcfcfcdcdcdcdcdcdebcdcecececdcfcfcfcfcfcfcfcfcfcfcdcdebcdcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cecececececdcdcdcdcdcdcdcfcfcfcfcece8ebfbfbfbfd8d8bfbfbfbf8ebfceebcdcdcfcfcdcdcdcdcdcdcdcecececeebcd6ccfcfcfcfcfcfcfcdebcdebcdcdcdcdafd8bfbfbfbfbfbfbfbfbfafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cececececdcdcdcdcdebcdcdcdcdcfcfcece8ebfbfbfbfbfbfbfbfbfbf8ebfcecdcdcdcfcfcdcdebcdcdcdcccececececdcdcdcdcfcfcfcfcfcfcdcdcdcdcdcdcdcdaf5bbfbfbfbfbfbfbfbfbfafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cececececdcdcdebcdcdcdebcdcdcdcdcece8ebfbfbfbfbfbfbfbfbfbf8ecececdcccccfcfcfcdcdcdcdebcdcececececdebcdebcd6ccfcfcfcfcfcfcfcccdebcdcdafbfbfbfbfbfbfbfbfbfbfafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cecececececdcdcdcdcdcdcccdebcdcdcecece8ebfbfbfbfbfbfbfbf8ececececfcfcfcfcfcfcdcdcdcdcdcdcdcecececdcdcdcdcdcdebcdcfcfcfcfcfcfcfcfcdcdaf8e8e8e8e2b8e8e8e8e8eafcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cecececedecdcccdebcdcdcdcdcdcdcdcececece8e8e8e8e8e8e8e8ecececececfcfcfcfcfcfcccdebcdebcdcececececdcdebcdebcdcdcdcdebcdcfcfcfcfcfcdcdcdcdcdcdcfcfcfcdcdcdcdcdcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cececedececdcdcdcdcdcdcdebcddbcdcececececececececececececececececdebcdcdebcdcdebcdcdcdcdcecececeebcdcdcdcdcdcdebcdcdcdcdcdcdcdcdcdcdcdcdcdcdcfcfcfcdcdcdcdcdcdcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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


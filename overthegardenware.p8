pico-8 cartridge // http://www.pico-8.com
version 30
__lua__

-- accesors
local walkable={220,238,239}
local text_to_display={}
-- local charselidx=1
local active={x=3,y=13,charidx=1}
local characters={
 {name='greg', mapidx=0, charidx=2}, 
 {name='wirt', mapidx=1, charidx=4}, 
 {name='beatrice', mapidx=16, charidx=6}, 
 {name={'kitty','wirt','wirt jr.','george washington','mr. president','benjamin franklin','doctor cucumber','greg jr.','skipper','ronald','jason funderburker'}, mapidx=17, charidx=8}, 
 {name='the beast', mapidx=32, charidx=34}, 
 {name='the woodsman', mapidx=33, charidx=36}, 
 {name={'the beast?','dog'}, mapidx=48, charidx=38},
 {name='dog', mapidx=49, charidx=40},
 {name='black turtle', mapidx=64, charidx=-1},
 {name='turkey', mapidx=65, charidx=-1},
 {name='pottsfield citizen', mapidx=80, charidx=-1},
 {name='pottsfield harvest', mapidx=81, charidx=-1},
 {name='pottsfield partier', mapidx=96, charidx=-1}  
}
local mapidx=1
local maps={
 {title='somewhere in the unknown',cellx=0,celly=0,trans={{dest={mp=2,loc={x=1, y=14}},locs={{x=13,y=0},{x=14,y=0},{x=15,y=0}}}}},
 {title='the old grist mill',cellx=16,celly=0,trans={{dest={mp=1,loc={x=14, y=1}},locs={{x=0,y=13},{x=0,y=14},{x=0,y=15}}}}}
}

-- base functions
function _init()
end

function _update()
-- do active movement
 if btnp(2) and active.y > 0 and is_element_in(walkable, mget(active.x+maps[mapidx].cellx, active.y - 1+maps[mapidx].celly)) then
  active.y = active.y - 1
 elseif btnp(1) and active.x < 15 and is_element_in(walkable, mget(active.x + 1+maps[mapidx].cellx, active.y+maps[mapidx].celly)) then
  active.x = active.x + 1
 elseif btnp(3) and active.y < 15 and is_element_in(walkable, mget(active.x+maps[mapidx].cellx, active.y + 1+maps[mapidx].celly)) then
  active.y = active.y + 1
 elseif btnp(0) and active.x > 0 and is_element_in(walkable, mget(active.x - 1+maps[mapidx].cellx, active.y+maps[mapidx].celly)) then
  active.x = active.x - 1
 end
 -- do check for map switch
 local activemap = maps[mapidx]
 local initmapidx = mapidx
 for transition in all(activemap.trans) do
  for location in all(transition.locs) do
   if active.x == location.x and active.y == location.y then
    transition_to_map(transition.dest)
    break
   end
  end
  if mapidx != initmapidx then
   break
  end
 end
 -- clear text requests
 newtxttodisplay = {}
 for txtobj in all(text_to_display) do
  if txtobj.frmcnt != 0 then
   newtxttodisplay[#newtxttodisplay+1]=txtobj
  end
 end
 text_to_display=newtxttodisplay
end

function _draw()
-- color handling
 pal(13,139)
 palt(0,false)
 palt(139,true)
 cls(139)
 -- draw map
 map(maps[mapidx].cellx, maps[mapidx].celly)
 -- draw sprites and characters
 palt(139,false)
 palt(13,true)
 spr(active.charidx, active.x*8, active.y*8)
 -- draw request text
 for txtobj in all(text_to_display) do
  if txtobj.frmcnt > 0 then
   draw_fancy_box(txtobj.x, txtobj.y, #txtobj.txt*4+4, 12, 4, 9)
   printsp(txtobj.txt, txtobj.x+2, txtobj.y+2, 0)
   txtobj.frmcnt = txtobj.frmcnt-1
  end
 end
 -- for i=1,#characters do
 --  spr(characters[i].mapidx, 1, i*8+(i*1))
 --  local name = characters[i].name
 --  local matches = string_n_inst(name, "|", 1)
 --  if matches then
 --   name = sub(name, 1, matches-1)
 --  end
 --  printsp(name, 12, i*8+(i*1)+2, 1)
 -- end
 -- -- draw selection rect
 -- x = 0
 -- y = charselidx*8+(charselidx*1)-1
 -- rect(x,y,x+10, y+10, 8)
 -- -- draw selected character
 -- spr(characters[charselidx].charidx, 80, 8, 2, 2)
end

-->8
function draw_fancy_box(x,y,w,h,fg,otln)
 rectfill(x,y,x+w,y+h,fg)
 line(x+1,y,x+w-1,y,otln)
 line(x+1,y+h,x+w-1,y+h,otln)
 line(x,y+1,x+h-1,y+1,otln)
 line(x+w,y+1,x+h-1,y+1,otln)
end

function transition_to_map(dest)
 mapidx = dest.mp
 active.x = dest.loc.x
 active.y = dest.loc.y
 text_to_display[#text_to_display+1]={x=16,y=16,txt=maps[mapidx].title,frmcnt=80}
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
0d000005d47744e4ddd1111111111ddd0005000000005000000000000ddddddd44477775775ddddd000000000000000000000000000000000000000000000000
dd0d50d54d7dd7ddddd1111111111ddd0005000000005000000000000ddddddd77777775775ddddd000000000000000000000000000000000000000000000000
dddddddddddddddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddddddfddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddddeeffdd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddeeefeed0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd0000ddde44f4ed0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0000000dd4444dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0000000dd4444dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd0dd0ddddd99ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddd999ddddd77ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd90909ddd7070dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd99999ddd7777dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd90009dddd700dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
daf999addd767ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
daafffaad7d6d7dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dffffffddd767ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddaddadddd6d6ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd999ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d90909dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d99999dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d90009dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd999ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d7d6d7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd767ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd6d6ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009090000000000000000000000000000000000000000009090000000000000000000000000000000000000000000000000000000000000000
00099900000000990900009009000002222000000000022220000090090000909900000000999000000000000000000000000000000000000000000000000000
00900090000000000900090000900020000202200220200002000900009000900000000009000900000000000000000000000000000000000000000000000000
09002009000000909009009999000000000002200220000000000099990090090900000090020090000000000000000000000000000000000000000000000000
09022209000090090090000000000022222000000000022222000000000009009009000090222090000000000000000000000000000000000000000000000000
09002009000900090909009999000009900200202000200990000099990090909000900090020090000000000000000000000000000000000000000000000000
00900000900099900000090000900090090000020200009009000900009000000999000900000900000000000000000000000000000000000000000000000000
00000009222222222222222222222222222222222222222222222222222222222222222290000000000000000000000000000000000000000000000000000000
00000002000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000
00000902000000000000000000000000000000000000000000000000000000000000000020900000000000000000000000000000000000000000000000000000
00220092000000000aaaa00a0000a0aaaaa0aaaa000aaaaaaa0a000a0aaaaa000000000029002200000000000000000000000000000000000000000000000000
0222209200000000a0000a0a0000a0a000a0a000a00a00a00a0a000a0a000a000000000029022220000000000000000000000000000000000000000000000000
0222209200000000a0000a00a00a00a00000a000a00000a0000a000a0a0000000000000029022220000000000000000000000000000000000000000000000000
0022009200000000a0000a00a00a00aaaaa0aaaa000000a0000a000a0aaaaa000000000029002200000000000000000000000000000000000000000000000000
0000009200000000a0000a00a00a00a00000aa00000000a0000aaaaa0a0000000000000029000000000000000000000000000000000000000000000000000000
0000090200000000a0000a00a00a00a00000a0aa000000a0000a000a0a0000000000000020900000000000000000000000000000000000000000000000000000
0000090200000000a0000a000aa000a000a0a000a00000a0000a000a0a000a000000000020900000000000000000000000000000000000000000000000000000
00000092000000000aaaa0000aa000aaaaa0a000a0000aaa000a000a0aaaaa000000000029000000000000000000000000000000000000000000000000000000
00220092000000000000000000000000000000000000000000000000000000000000000029002200000000000000000000000000000000000000000000000000
02222092000000000000000000000000000000000000000000000000000000000000000029022220000000000000000000000000000000000000000000000000
0222209200000000000000aaaa00000aa000aaaa00aaaa000aaaaa0aa00a00000000000029022220000000000000000000000000000000000000000000000000
002200920000000000000a0000a0000aa000a000a00a00a00a000a0aa00a00000000000029002200000000000000000000000000000000000000000000000000
000000920000000000000a00000000a00a00a000a00a000a0a00000a0a0a00000000000029000000000000000000000000000000000000000000000000000000
000009020000000000000a00000000a00a00aaaa000a000a0aaaaa0a0a0a00000000000020900000000000000000000000000000000000000000000000000000
000009020000000000000a00aaaa00a00a00aa00000a000a0a00000a0a0a00000000000020900000000000000000000000000000000000000000000000000000
000000920000000000000a0000a000aaaa00a0aa000a000a0a00000a0a0a00000000000029000000000000000000000000000000000000000000000000000000
002200920000000000000a0000a00a0000a0a000a00a00a00a000a0a00aa00000000000029002200000000000000000000000000000000000000000000000000
0222209200000000000000aaaa000a0000a0a000a0aaaa000aaaaa0a00aa00000000000029022220000000000000000000000000000000000000000000000000
02222092000000000000000000000000000000000000000000000000000000000000000029022220000000000000000000000000000000000000000000000000
00220092000000000000000000000000000000000000000000000000000000000000000029002200000000000000000000000000000000000000000000000000
00000092000000000000000000a000a000a000aa000aaaa00aaaaa00000000000000000029000000000000000000000000000000000000000000000000000000
00000902000000000000000000a000a000a000aa000a000a0a000a00000000000000000020900000000000000000000000000000000000000000000000000000
000009020000000000000000000a000a00a00a00a00a000a0a000000000000000000000020900000000000000000000000000000000000000000000000000000
000000920000000000000000000a00aa00a00a00a00aaaa00aaaaa00000000000000000029000000000000000000000000000000000000000000000000000000
002200920000000000000000000a00aa0a000a00a00aa0000a000000000000000000000029002200000000000000000000000000000000000000000000000000
022220920000000000000000000a00aa0a000aaaa00a0aa00a000000000000000000000029022220000000000000000000000000000000000000000000000000
0222209200000000000000000000aa00aa00a0000a0a000a0a000a00000000000000000029022220000000000000000000000000000000000000000000000000
0022009200000000000000000000aa00aa00a0000a0a000a0aaaaa00000000000000000029002200000000000000000000000000000000000000000000000000
00000902000000000000000000000000000000000000000000000000000000000000000020900000000000000000000000000000000000000000000000000000
00000002000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000
00900000222222222222222222222222222222222222222222222222222222222222222200000900000000004334343433333333000000000000000000000000
00090200090000000000000000000000000000000000000000000000000000000000009000209000000000004343934333333333000000000000000000000000
00090220900220900902209009022090090220900902209009022090090220900902200902209000000000004433344333333333000000000000000000000000
00900200002222099022220990222209902222099022220990222209902222099022220000200900000000003443423233333333000000000000000000000000
09000020902222000022220000222200002222000022220000222200002222000022220902000090000000009344232333333333000000000000000000000000
00900000000220099002200990022009900220099002200990022009900220099002200000000900000000003342423333333333000000000000000000000000
00090090900009000090090000900900009009000090090000900900009009000090000909009000000000003324223333333333000000000000000000000000
00009900090000999900009999000099990000999900009999000099990000999900009000990000000000009444422933333333000000000000000000000000
333333333365666333333333333333333333333663333333333333333333333333334033333949490000000033399933333333337ccccccccccccccc44444466
333333333659566633355533333333333333336aa6333333333333333333333333404303339494940000000033999a9333333333c7ccc7cccccc7ccc46454454
3666333366767668355555553333333333333379a73333333353333333533333334340333949494900000000399aa999333333337ccccc7cccc657cc45456644
6555333387888878555555555333333333336666666633333355555555533333404033333334949400000000a99999a933333333cc7ccc7ccc66657c45445644
47076663777878c83677776633333333333622222222633333666666666333334303833333334943000000003a9aaa9333bbb333ccc7c7cccc66657c44445554
477755567478c878377000773333333333622227722226333666666666663333403388333333343300000000334242333bbbbbb3ccc7ccccc6665c7c46644444
47770703747878883660007733333333333887777778833333555555555333333338888333333333000000003a242233bbbbbbbbccc7ccccccccc7cc45645666
4707777344488883377000765555533333377777777773333355555999533333333377333333333300000000944442233bbbbbb3cc7ccccccccccccc44444554
45665433333929293770007755555555333722222222733333555559095333333333773333333333000000001111111111111111111115511111111111111121
4666643333392929447777776666666333378877787c73333355555000533333333277333333322200000000111111111111111111114225112c111111118122
666666333839292955777667777777733337887778c7733333556666655555533328222633322222000000001111111111111111111422251c21441111188811
4444445337383333447444777007007333378877987c73333355544455566666328782265324422500000000111111111aa1aaa111422251112444c111888881
444494558788634455744477700600633337887778887333335554445553033438777866534044550000000011111111aa9a99aa142224111144422118888811
444444338786344444644974400700733337887778887333335554405553003437777765334554550000000011111111a9a9aa9a444241112444221111888111
454444557773444555744476677777733337444444447333335554445554444437707765334554530000000011111111a99a999a544411112241111122181111
4544445533334453447444744776677333322222222223333355544455544444377077533333333300000000111111111a9999a1155111111221111112111111
__map__
dbdbebebdbebebebdbdbdbebebefefefefefefebedededebebebebebebebebeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdbdcebdcdcecdcdcdcebdcefefefefefefecdcededebdcdcdcdcebdcdbeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcecdcdcecdcdcdcdcececefefefefebefefefededede2e3dbdcdcdcdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbdcdcdbdcdcdcdbdcecefefefefefdbebdcefefeeededf2f3dcdcebdcdcdbdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbdcdcdcecececececefefefefefdcebebdcededeeeeefefefdcecdcdcebdceb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbebdcecefefefefefefefefecdcdcebededededeeefefefefefefecdcdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdcefefefefefefefefefecdcebebedededdcefefefefefefefdcdcdcdbdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbdcdcefefefefefefefececdcdcecebededdcdbdcefefefefefdcdcdcebdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbebdcefefefefefefecdcdcdcdcdcdbebdcdcdcdcdcefefefefecdcdcdcebeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdcefefefefefecdcebdcdcebdcdbebebdcdcecefefefececdcdcdcecdceb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcdcefefefefecdcdcdcdcecdcdbebebdcebecefefefecdcdcdcdcdcdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebdcefefefefecdcdcdcdcdcdcdcdcebdbdcecefefefdcdcdcdcdcdcdbdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ebefefefefdcdcdcdcecdcebdcdcebdbebdcefefefdcdcdcdcdbdcebdcdcdcdb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
efefefefdcdcebdcdbdcdcdcdcecdcebebefefefdcdcdcdcdcdcecdcdcdbdceb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
efefefdcdcdcecdcdcdcdcdbdcdcdcdbefefefefdcdbdcdcebdcdcdcdcdcdceb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
efefdbdbebdbebdbebebdbdbebebdbdbefefefebdbdbebdbebebdbdbebebdbeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

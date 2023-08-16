pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--over the garden wall
-- made by pepperoni-jabroni
local ei,n𝘸,n𝘣,n𝘱,n𝘭,n𝘲,nq,nx,t,n𝘤,n𝘢,n𝘳,n_,n𝘵,n𝘧,nv,n𝘨,n𝘥,nj,n𝘩,n𝘫,n𝘻,n𝘴,n𝘶,n𝘬,n𝘺,n𝘦,nz,n𝘪,n𝘹,n𝘰=split"43,110,158,185,106,190,191,202,203,205,207,222,223,238,239,240,241,242,244,245,246,247,248,249",{},(function()local e={}for n in all(split("255,candy,g#214,bird art,g#252,pumpkin shoe,g;w#253,shovel,g;w;b#254,old cat,g;k;y#126,instruments,g","#"))do local n=split(n)add(e,{spridx=n[1],name=n[2],charids=split(n[3],";")})end return e end)(),false,nil,nil,{},0,0,nil,nil,false,{},"boot",1,nil,{},{},{},{},{},{},0,0,0,0,0,{},{}local n𝘷,en,n𝘮,n𝘺,ee,eo={function()return h"woods1,right_of,8"end,function()n"5"end,function()return 𝘥(1,"woods1")and(nx~=8or t~=8)end,function()n"6"end,function()return 𝘥(1,"woods1",13,7)end,function()n"18"end,function()return 𝘥(1,"woods2")end,function()end,function()return b(5,7,"woods2")end,function()n"3"𝘯()end,function()return p"woods2,m"end,function()n"4"end,function()return d"4"end,function()r"m,15|0|7|7"end,function()return#nj==2and h"woods3,below,13"end,function()n"7"end,function()return b(7,10,"woods3")end,function()n"8"end,function()return d"8"end,function()f(s{"b",nv,7,10},true)end,function()return p"millandriver,m"end,function()n"9"end,function()return d"9"end,function()r"m,7|3|7|11"end,function()return nv=="mill"and#nj==2and e"m".mapid=="mill"end,function()n𝘭=nil r"m,7|4"𝘧"k"local e=e"k"e.mapid,e.x,e.y="millandriver",11,12l"millandriver".discvrdtiles={}f"?,millandriver,12,13"n"16"c"214,mill,2,12"end,function()return p"millandriver,?"end,function()n"12"local n=l(nv).discvrdtiles add(n,"12|14")add(n,"13|13")add(n,"13|14")end,function()return nv=="home"end,function()n"10"end,function()return p"woods1,t"end,function()n"11"end,function()return d"12"end,function()e"?".intent="chase_candy_and_player"𝘭"k"end,function()local n=e"?"return h"mill,above,0"and n~=nil and n.mapid=="mill"end,function()𝘭"w"l"mill".playmapspr=124n"20"end,function()return h"woods1,left_of,1"end,function()n"14"end,function()return h"mill,left_of,7"end,function()n"13"end,function()return b(2,12,"mill")end,function()k"2"𝘨"214"n"17"end,function()return d"19"end,function()k"1"𝘧"w"r"w,2|9"end,function()local n=e"?"return b(1,4,"mill")and n~=nil and n.mapid=="mill"end,function()𝘵("millandriver",7,4)del(nz,e"?")del(nz,e"m")f"d,millandriver,5,4|t,millandriver,5,5|m,millandriver,6,5"n"22"g"you completed act 1!"n𝘭=nil end,function()return nv=="woods3"end,function()end,function()local n=l(nv)return nv=="woods3"and mget(n.cellx+nx,n.celly+t)==158end,function()n"23"k"3"end,function()local n=l"home"return nv=="pottsfield"and u(n.playmaplocx,n.playmaplocy)<3end,function()n"24"end,function()return p"barn,o"end,function()n"25"end,function()return p"barn,e"end,function()n"26"n𝘭=nil r"e,7|13|7|5,o,7|13|6|5,o,7|13|5|6,o,7|13|7|7,i,7|13|9|5,i,7|13|10|6"end,function()return 𝘱("pottsfield",174)and 𝘩()end,function()𝘲"190"n𝘴+=1if(n𝘴<5)del(n𝘪,29)
𝘳()end,function()return 𝘱("pottsfield",158)and 𝘩()end,function()𝘲"190"n𝘶+=1if(n𝘶<5)del(n𝘪,30)
𝘳()end,function()return 𝘩()and nv=="pottsfield"end,function()n"27"end,function()return n𝘬==4end,function()n𝘭=nil n"44"r"o,8|10"end,function()return h"school,below,13"end,function()n"29"𝘧"w,b"𝘭"y"r"w,5|11,b,4|11"end,function()return nv=="grounds"and#nj==2end,function()n"30"end,function()if(not v(34))return false
local n,e=𝘤()return n==nil end,function()n𝘺+=1local n,e=0,0while(not 𝘪("grounds",n,e,nil))n,e=flr(rnd(16)),flr(rnd(16))
c(s{"254","grounds",n,e})if(n𝘺<2)del(n𝘪,35)
end,function()local n,e=𝘤()return n~=nil end,function()local n,e=𝘤()if(n.cldwn==15)n.x,n.y=𝘫("grounds",n.x,n.y)n.cldwn=0
n.cldwn+=1del(n𝘪,36)end,function()local e,n=𝘤()return n==0end,function()local o,l=𝘤()n𝘦+=1if(n𝘦<2)i"haha yeah we got one!"k"5"del(n𝘪,37)else n"31"local n,o=𝘫(nv,nx,t)f(s{"l",nv,n,o})e"l".intent="chase_candy_and_player"
del(nq,o)end,function()return n𝘦>1and nv=="school"end,function()n"32"del(nz,e"l")n𝘭=nil 𝘧"y,k"r"r,3|5,w,6|5,b,8|5,u,6|2,c,7|2,y,12|5,k,5|5"end,function()return v(38)and h"school,below,6"end,function()n"33"end,function()local n=e"r"return v(39)and u(n.x,n.y)<=1end,function()n"34"end,function()return d"34"end,function()n"35"music"17"end,function()return d"35"end,function()n"36"c"126,school,6,2"c"126,school,7,2"end,function()return d"36"end,function()n"37"f"𝘤,school,7,6"r"𝘤,7|14|11|4,r,7|9"music"-1"𝘨"126"c"126,grounds,10,4"end,function()local n=e"𝘤"return n~=nil and n.mapid=="grounds"end,function()n"38"end,function()local n=e"𝘤"return n~=nil and n.intent==nil and p"grounds,𝘤"end,function()n"39"end,function()return d"39"end,function()n"40"e"𝘤".flipv=true end,function()return v(46)and b(10,4,"grounds")end,function()k"6"i"we got em!"𝘨"126"end,function()return n𝘭==6and nv=="school"end,function()n𝘭=nil n"41"r"r,7|14|13|10,c,7|14|12|9,u,7|14|11|9,y,7|14|10|10,𝘤,11|11"e"𝘤".flipv=false 𝘭"k"𝘭"w"𝘭"b"end,function()return v(48)and h"grounds,above,8"end,function()f"l,grounds,11,4"e"l".intent="chase_candy_and_player"end,function()local n=e"l"return v(49)and u(n.x,n.y)<1end,function()n"42"local n,o=e"l",e"r"f(s{"j,grounds",n.x,n.y-1})𝘬(e"j","13|11")del(nz,n)end,function()local n=e"j"return n~=nil and n.x==13and n.y==11and u(n.x,n.y)<3end,function()c"126,grounds,12,9"c"126,grounds,11,9"c"126,grounds,10,10"n"43"music"23"g"you completed act 3!"end,function()return nv=="secret"end,function()g"you found the secret room!"local n=1for e in all(n𝘩)do if(e.mapspridx~="")c(s{e.mapspridx,"secret",(n*2+1)%10+3,ceil(n/5)*2+1})n+=1
end end,function()local n=e"o"return s{n.mapid,n.x,n.y}=="pottsfield,8,10"end,function()n"45"local n=e"s"f(s{"p,pottsfield",n.x,n.y})g"you completed act 2!"del(nz,n)end,function()return h"woods5,left_of,1"end,function()i"the road ends here for now"i"ᶜ9thanks for playing!"end},split("|woods1,leave a trail of candy|woods1,give the turtle a candy|woods2,leave a trail of candy|woods2,inspect the strange tree|woods2,meet someone new|||woods3,search the bushes||millandriver,talk with the woodsman||millandriver,enter the mill|millandriver,find the frog!|pottsfield,visit the home|woods1,spot the turtle||millandriver,run back to your brother!|||mill,find a club|mill,use the club!|mill,jump the window to escape!,14||woods3,acquire new shoes||pottsfield,meet the residents|barn,meet the host|pottsfield,collect wheat,28|pottsfield,collect pumpkin,28||pottsfield,dig at the flower,31|school,start the lesson|grounds,go play outside,33|grounds,play 2 old cat,34|||school,run back to school!,37|school,cheer folks up,38|school,talk to the teacher,39|||||||grounds,grab the instruments!,46|school,talk with ms langtree,47||grounds,confront the gorilla,48||||","|"),{},{},{function()nr()end,function()n0()end,function()n1()end,function()nf()end,function()ns()end,function()nc()end,function()nu()end,function()nh()end,function()n2()end,function()n4()end,function()nw()end,function()ng()end},split"kitty,wirt,wirt jr.,george washington,mr. president,benjamin franklin,doctor cucumber,greg jr.,skipper,ronald,jason funderburker"function o(n,e)for n in all(n)do if(e==n)return true
end return false end function x(n,e,o)if(n)return e
return o end n𝘩=(function()local e={}for n in all(split("g;greg;0;2;where is that frog o' mine!|wanna hear a rock fact?#w;wirt;1;4;uh, hi...|oh sorry, just thinking#b;beatrice;16;6;yes, i can talk...|lets get out of here!#k;;17;8;ribbit#a;the beast;32;34#m;the woodsman;33;36;i need more oil|beware these woods#?;the beast?;48;38;*glares at you*;2#d;dog;49;40;*barks*#t;black turtle;64;66;*stares blankly*#z;turkey;65;68;gobble. gobble. gobble.#o;pottsfield citizen 1;80;98;you're too early#i;pottsfield citizen 2;80;102;are you new here?#s;skeleton;81;70;thanks for digging me up!#p;partier;96;100;let's celebrate!#e;enoch;97;72;you don't look like you belong here;2#u;dog student;10;44;humph...|huh...#l;gorilla;113;12;*roaaar*!#j;jimmy brown;11;14#c;cat student;26;46;humph...|huh...#r;ms langtree;112;104;oh that jimmy brown|i miss him so...#n;the lantern;;76#𝘧;rock fact;215;78#𝘦;edelwood;219;192#y;racoon student;27;194;humph...|huh...#𝘢;achievement get!;;196#𝘤;mr langtree;184;182;these poor animals","#"))do local n=split(n,";")add(e,{id=n[1],name=n[2],mapspridx=n[3],chrsprdailogueidx=n[4],idle=split(n[5],"|")or{"huh?"},scaling=n[6]or 1})end return e end)()function m(e)for n in all(n𝘩)do if(n.id==e)return n
end end local n𝘦,n𝘯=(function()local n=split("174,204,218,219,235,236,251#2,3,4,8,9,10,11#0,0,1,1,0,1,1","#")return{idxs=split(n[1]),clrmp_s=split(n[2]),clrmp_d=split(n[3])}end)(),(function()local o={}for n in all(split("exterior,woods1,somewhere in the unknown,0,16#exterior,woods2,somewhere in the unknown,0,0#interior,mill,the old grist mill,64,0,millandriver,226,7,2#exterior,millandriver,the mill and the river,16,0#exterior,woods3,somewhere in the unknown,32,0#interior,barn,harvest party,80,0,pottsfield,224,4,1#interior,home,pottsfield home,32,16,pottsfield,232,10,7#exterior,pottsfield,pottsfield,48,0#exterior,woods4,somewhere in the unknown,96,0,0#interior,school,schoolhouse,16,16,grounds,228,3,3#exterior,grounds,the schoolgrounds,112,0#exterior,woods5,somewhere in the unknown,64,16#interior,secret,the secret room,48,16,woods5,218,9,0","#"))do local n=split(n)local e={type=n[1],id=n[2],title=n[3],cellx=n[4],celly=n[5]}if(n[1]=="interior")e.playmapid=n[6]e.playmapspr=n[7]e.playmaplocx=n[8]e.playmaplocy=n[9]
add(o,e)end return o end)()function l(e)for n in all(n𝘯)do if(n.id==e)return n
end end function 𝘴(e)for n=1,#n𝘯 do if(n𝘯[n].id==e)return n
end end nz=(function()local o={}for n in all(split("t,13,7,woods1#m,6,7,woods2#o,6,12,barn#o,7,4,barn,loop,7|4|10|7#o,7,7,barn,loop,7|4|10|7#i,10,4,barn,loop,7|4|10|7#i,10,7,barn,loop,7|4|10|7#e,8,5,barn#r,8,9,school#u,7,11,school#c,9,11,school#y,9,13,school#z,7,6,home","#"))do local n=split(n)local e={charid=n[1],x=n[2],y=n[3],mapid=n[4]}if(#n>4)e.intent=n[5]e.intentdata=n[6]
add(o,e)end return o end)()local et,el=(function()local e={}for n in all(split("woods1;woods2;15,5|15,4;0,14|0,15#woods2;millandriver;14,0|15,0;0,13|0,14|0,15#millandriver;woods3;0,0|1,0;13,15|14,15|15,15#millandriver;mill;7,3;8,14#woods3;pottsfield;7,0|8,0;7,15|8,15#pottsfield;barn;4,2|5,2;7,13|8,13#pottsfield;woods4;9,0|10,0;6,15|7,15#woods4;grounds;7,0|8,0;6,15|7,15#grounds;school;4,4|3,4;7,14|8,14|11,1#pottsfield;home;10,8|11,8;7,12#grounds;woods5;0,7|0,8;15,12|15,13#woods5;secret;9,0;7,14|8,14","#"))do local n=split(n,";")add(e,{mp_one=n[1],mp_two=n[2],mp_one_locs=split(n[3],"|"),mp_two_locs=split(n[4],"|")})end return e end)(),(function()local e,t={},1for n in all(split("k;led through the mist-k;by the milk light of moon-k;all that was lost is revealed-k;our long bygone burdens-k;mere echoes of the spring-k;but where have we come?-k;and where shall we end?-k;if dreams can't come true-k;then why not pretend?-k;how the gentle wind-k;beckons through the leaves-k;as autumn colors fall-k;dancing in a swirl-k;of golden memories-k;the loveliest lies of all+g;i sure do love my frog!-w;greg, please stop...-k;4;ribbit.-g;haha, yeah!+w;i dont like this at all-g;its a tree face!+w;is that some sort of deranged lunatic?-w;with an axe waiting for victims?-m;*swings axe and chops tree*;𝘭-w;what is that strange tree?-g;we should ask him for help!-*;5+w;whoa... wait greg...;𝘭-w;... where are we?;𝘭-g;we're in the woods!;𝘭-w;no, i mean;𝘭-w;... where are we?!;𝘭+w;we're really lost greg...-g;i can leave a candy trail from my pants!-g;candytrail. candytrail. candytrail!-*;2+b;help! help!-w;i think its coming from a bush?-*;9+b;help me!;𝘭-g;wow, a talking bush!-b;i'm not a talking bush! i'm a bird!-b;and i'm stuck!-g;wow, a talking bird!-b;if you help me get unstuck, i'll-b;owe you one-g;ohhhh! you'll grant me a wish?!-b;no but i can take you to...-b;adalaid, the good woman of the woods!-g;*picks up beatrice out of bush*-w;uh uh! no!+m;these woods are a dangerous place-m;for two kids to be alone-w;we... we know, sir-g;yeah! i've been leaving a trail-g;of candy from my pants!-m;please come inside...;𝘭-w;i don't like the look of this-k;ribbit.-g;haha, yeah!-*;13+w;oh! terribly sorry to have-w;disturbed you sir!-z;gobble. gobble. gobble.;𝘭+g;wow, look at this turtle!-w;well thats strange-g;i bet he wants some candy!-t;*stares blankly*-*;3+?;*glares at you, panting*;𝘭-g;you have beautiful eyes!-g;ahhhh!-*;18+w;wow this place is dingey-g;yeah! crazy axe person!-w;we should find a way to take him out-w;before he gets a chance to hurt us-g;i can handle it!-*;21+w;i dont think we should-w;go back the way we came+m;whats the rucus out here?-w;oh nothing sir!-g;nows my chance!+m;i work as a woodsman in these woods-n;keeping the light in this lantern lit;𝘭-m;by processing oil of the edelwood trees-m;you boys are welcome to stay here-m;ill be in the workshop-g;okey dokey!+g;this bird art sculpture is perfect!-*;22+g;there! this little guy wanted a snack-t;*stares blankly*;𝘭+m;ow! *falls onto ground*-g;haha yeah, i did it!-w;greg! what have you done!-w;hey greg... where did your frog go?-g;where is that frog o mine?-*;14+g;ahhh! the beast!-w;quick, greg, to the workshop!-w;we should be able to make it-w;out through a window out back!-?;*crashes through the wall*;𝘭-*;23+g;we made it!-w;hopefully hes stuck there!-?;*gets stuck in the window*-?;*spits out a candy*-d;*looks at you happily*;𝘭-g;look! hes my best friend now!+m;what have you boys done?!-m;the mill is destroyed-w;but we solved your beast problem!-m;you silly boys-m;that silly dog was not the beast-d;*bark! bark!*;𝘭-m;he just swallowed that turtle-t;*stares blankly*;𝘭-m;go now and continue your journey-w;we're sorry sir-m;beware the beast!+g;oh wow! i stepped on a pumpkin!-w;huh oh that's strange-w;i did too-g;haha i have a pumpkin shoe!-k;ribbit.+w;wow, greg, look!-w;a home! maybe they have a phone-b;oh this is just great-*;15+o;hey -o;who are you?;𝘭-w;uh hello! we're just passing through-o;folks dont just pass through here-b;nope, i dont like this!-*;28+e;well, well, well,...-e;what do we have here?;𝘭-b;nothing sir!-o;they tramped our crops!-i;look at their shoes!-e;for this you are sentenced-e;to...-e;a few hours of manual labour-w;oh uh okay?-e;come outside with me+e;you must collect 5 pumpkins-e;and 5 bundles of wheat-e;go now, and pay your dues!-*;29-*;30+e;now for your final act-e;you must dig a hole-e;6 feet deep, at the flower-e;take these shovels and-e;start digging-b;oh god!-*;32+r;and that children-r;is how you do addition-r;well hi there children!;𝘭-r;please, take your seats-w;oh ok sure!-b;no wirt! ugh!-g;school? no way-g;lets go play outside-k;ribbit!-y;hmph!-*;34+g;i know, lets play 2 old cat-g;come on lets grab the cats!-k;ribbit.-y;hmph!-*;35+g;we did it!-g;isnt 2 old cat great?-l;*roaaar!*;𝘭-g;aaaah! run!-y;*scatters*-*;38+g;phew, we made it!-r;how i do miss that-r;*jimmy brown*-r;time for lunch children;𝘭-w;oh, ok!-b;ugh wirt please!-g;haha yay!+g;whats the matter rac?-y;*looks sad at food*;𝘭-g;*takes a bite*-g;kinda bland-g;i got an idea!+g;here play like this!-g;*smashes piano keys*-r;like this?-g;good enough!+g;𝘰h, potatoes and molasses-g;𝘪f you want some, oh, just ask us-g;𝘵hey're warm and soft like puppies in socks-g;𝘧illed with cream and candy rocks+g;𝘰h, potatoes and molasses -g;𝘵hey're so much sweeter than 𝘢lgebra class-g;𝘪f you're stomach is grumblin'-g;𝘢nd your mouth starts mumblin'-g;𝘵here's only only one thing to -g;keep your brain from crumblin'-g;𝘰h, potatoes and molasses-g;𝘪f you can't see 'em put on your glasses-g;𝘵hey're shiny and large like a fisherman's barge-g;𝘺ou know you eat enough when you start seeing stars-g;𝘰h, potatoes and molasses-g;𝘪t's the only thing left on your task list-g;𝘵hey're short and stout,-g;𝘵hey'll make everyone shout-g;𝘧or potatoes and molasses-g;𝘧or potatoes and+𝘤;thats enough!;𝘭-𝘤;give me those instruments-r;father!-𝘤;this is a school-𝘤;not a marching band;𝘭-𝘤;we cant be losing money-𝘤;goodbye!-r;oh father!+r;oh the poor school!-r;who could help finance us?-r;if only that no good-r;two timin *jimmy brown* were here;𝘭-y;*rolls eyes*;𝘭-g;i have an idea!;𝘭+𝘤;oof those poor animals-𝘤;i have no funds left;𝘭-𝘤;to teach them proper math-𝘤;all i have are these instruments+𝘤;...zzz;𝘭-g;nows our chance!+g;here ms langtree!-g;*hands over instruments*-g;*whispers*;𝘭-r;come children-r;to the town plaza!;𝘭-c;*meow*!-u;*bark*!+l;*roaar*!;𝘭-g;hya! *chops*-l;*hit on the head*-j;oh my word!;𝘭-j;this boy saved me-r;oh *jimmy*!-j;darlin...+u;*grabs instrument*-c;*grabs instrument*-y;*grabs instrument*-r;*passes donations*-r;my my were saved!;𝘭-𝘤;what excellent news!-j;oh darlin!-k;ribbit!-w;nice job greg;𝘭+s;hey!;𝘭-s;thanks for digging me up-o;hey is that frank?-i;someone hand him a pumpkin!+o;here ya go!-p;hey thanks!-p;lets party!;𝘭-e;what a wonderful havest;𝘭","+"))do local n=split(n,"-")add(e,{})for n in all(n)do local n=split(n,";")local o=n[2]local l=tonum(o)if(l~=nil)o="ᶜ9["..split(en[l])[2].."]"
add(e[t],{speakerid=n[1],text=o,large=x(#n>2,n[3]=="𝘭",false)})end t+=1end return e end)()function _init()palt(0,false)repeat local n=z(𝘶())if(not o(n𝘮,n))add(n𝘮,n)
until#n𝘮==4m"k".name=eo[z(eo)]end function _update()𝘷(n𝘵).update()end function _draw()𝘷(n𝘵).draw()end function n1()if(btn"5")n𝘵="mainmenu"
end function nf()cls()?'⁶-b⁶x8⁶y8       ᶜ4⁶.\0\0\0\0\0\0\0◝⁶.\0\0\0\0\0\0\0◝⁶.\0\0\0\0\0\0\0◝⁶-#⁶.\0\0\0\0\0\0\0³⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0ュ⁶-#⁶.\0\0\0\0\0\0\0◝⁶-#ᶜ4⁶.\0\0\0\0\0\0\0█⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0○⁶-#ᶜ4⁶.\0\0\0\0\0\0\0◝⁶.\0\0\0\0\0\0\0◝⁶-#⁶.\0\0\0\0\0\0\0◆⁸⁶-#ᶜa⁶.\0\0\0\0\0\0\0p\n⁶-#   ᶜ4⁶.\0\0\0\0\0\0ナヲ⁶.\0\0\0ナヲュ◝◝⁶.\0◝◝◝◝◝◝◝⁶-#⁶.ヲ◝◝◝⁷³¹¹⁸⁶-#ᶜa⁶.\0\0\0\0ヲュ◜◜²4⁶.\0\0\0\0◝◝◝◝⁶.\0\0\0\0◝◝◝◝⁶.\0\0\0◝◝◝◝◝⁶.ヲ\0\0³◝◝◝◝⁶.◝\0\0\0◝◝◝◝⁶.◝ュナ\0⁷ᶠᶠ○⁶.\0¹¹⁷⁷⁷⁴\0 ⁶.ユナナナナナナら\n⁶-# ᶜ4⁶.\0\0\0\0\0\0ヲヲ⁶.\0\0\0\0\0\0゜か⁶-#⁶.ヲヲュュᶜᵉ³¹⁸⁶-#ᶜa⁶.\0\0\0\0ユユュ◜²4⁶.\0\0\0\0゜゜◝◝⁶.\0\0\0\0\0\0█ら⁶.◜◜◜◜◜◜◝◝²a      ⁶-#ᶜ4⁶.◝◝ヒろ▤0ユユ⁸⁶-#ᶜa⁶.\0\0¹³⁷ᶠᶠᶠ⁶-#ᶜ4⁶.◝◝◝◝◝◜ュン²4ᶜa⁶.███████\0\n⁶-#ᶜ4⁶.\0\0\0\0█ナナナ⁶.ヲ◜◝◝◝◝◝◝⁶-#⁶.ト○?゜゜ᶠ⁷⁷⁸⁶-#ᶜa⁶.\0█らナナユヲヲ²4⁶.◝◝◝ャリニ▒\0⁶.ユニト◝◝○◝◝²a        ᶜ4⁶.ナナナナナナナナ⁶-#⁶.ネフヤヤエ゜゜゜²4 \n⁶-#⁶.ナナナナナナ██²4ᶜa⁶.\0█\0\0\0\0\0\0⁶.ヲx○○~~~|⁶.²⁶テ◜◜◜ュヲ⁶.ヲ█¹³³³゜?⁶.◝◝◜◜◜◜>◜⁶.◝◝◝◝◝◝よ◜⁶.◝◝◝◝◝◝フo⁶.◝◝◝◝◝◝○ナ⁶.◝◝◝◝◝◝◝●⁶.◝◝◝◝◝◝◝○⁶.◝◝◝◝◝◝◝\0⁶.◝◝◝◝◝◝◝\0⁶.゜゜゜゜゜゜゜゛⁶-#ᶜ4⁶.????????⁶.゜゜゜゜゜ᶠᵉ⁶\n⁶.█らフ◝◝◝◝◝²4 ᶜa⁶.||||xヲヲユ⁶.ユユヲ<<、\0¹⁶.◝か\0\0██らら²a ᶜ4⁶.𝘢𝘢²²" ⁴⁴⁶.▮▮▮▮▮…▮▮⁶.▮ \0\0\0¹¹\0⁶.𝘢𝘢¹¹¹y𝘢▒⁶.\0@\0\0\0\0█\0⁶.\0%!く! c\0⁶.²リ"#b²ワ\0⁶.ナナニナユヲ◝ヲ⁶-#⁶.○○○○○◝◝◝⁶.²²²\0\0\0\0¹\n²4ᶜa⁶.\0\0\0\0らユx8⁶.\0\0\0⁶?○ら█⁶.ナナら█\0²³³⁶.¹³⁷?◝◜ユ\0⁶.ユユヲ◝◝゜\'`⁶.◝◝◝◝◝トトヤ⁶.ャワワワ◝◝◝◝⁶.ヤヤヤヤ?◝◝◝⁶.ヤヤヤヤュ◝◝◝⁶.◜◜◝◝◝ヲリワ⁶.○◜◜ョャ⁷◝◝⁶.゜◝◝◝◝◝かよ⁶.□◝◝◝◝◝◝◝⁶.⁶⁷⁷⁷⁷⁷⁷⁷⁶-#ᶜ4⁶.◝◝◝◝○゜゜゜⁶.¹¹¹¹\0\0\0\0\n²4ᶜa⁶.、゛ᵉᵉᵉᵉᵉᵉ⁶.\0\0\0\0\0\0ユユ⁶.³²🐱\0██エれ⁶.\0²⁷⁷ᶠᶠᶠ゜⁶.ラ◜ュてムムュュ⁶.ワンはヨヨヨルル⁶.◝ヤエ◜ュメメメ⁶.◝◝○`◝○○○⁶.◝トよよよャリフ⁶.ヤトトよよよ○○⁶.◝◝トト◝ヤo○⁶.◝◝トト◝ヤ◝ワ⁶.◝◝◝ャ◝ョワ◜⁶.7○7??733⁶-#ᶜ4⁶.○゜??○○○○⁸⁶-#ᶜa⁶.\0ナらら████⁶-#ᶜ4⁶.\0\0¹¹¹¹¹¹⁸⁶-#ᶜa⁶.\0¹\0\0\0\0\0\0\n⁶-#ᶜ4⁶.ニナるろ\0⁸8ヲ⁸⁶-#ᶜa⁶.゛゛<8ヲユら\0²4⁶.…███ユ◝゜\0⁶.れ𝘤c#{³⁶\0⁶.、880x\0\0\0⁶.ろ░ささ🅾️pxx⁶.ルレワワ◝³◝◜⁶.oメヤヤ◝ᵉ◝◝⁶.|○○○◝ ◝◝⁶.ヤトトよ○|◝◝⁶.◝◝◝◝◝◜◝◝⁶.vv◜ョョョョャ⁶.◝◝◝◜テ゛◜ョ⁶.ヒヤトト◝ᶜ◝◝⁶.3#ckャ\0\0\0⁶.██☉☉エ\0\0\0⁶-#ᶜ4⁶.\0\0²⁶\0⁷⁷⁷⁸⁶-#ᶜa⁶.¹¹𝘢𝘢○\0\0\0\n⁶-#ᶜ4⁶.ヲヲヲヲヲュ◜◝²4   ᶜa⁶.ヲヲヲユららュ◜⁶.ュね◝◝◝◝◝◝²a      ᶜ4⁶.\0\0\0\0\0███²4  ⁶-#⁶.⁷⁷⁷ᶠᶠᶠᶠᶠ\n²4    ²a  ⁶.\0\0\0\0\0\0⁸8     ⁶.████████²4  ⁶-#⁶.ᶠᶠ゜゜゜゜゜゜\n⁶.◝◝◝ヲら\0\0\0⁶.◝◝◝◝◝◜◜◜²4  ²a  ⁶.8pユユユナナナ⁶.\0\0\0¹³³⁷³⁶.…` \0\0\0\0\0   ⁶.ナナナナナナナナ²4  ⁶-#⁶.゜゜゜゜????\n ⁶.◜◜◜◜◜◜◜◜²4  ᶜa⁶.◝◝◝◝◜◜◜◜²a ᶜ4⁶.ららナナナユユユ⁶.▒▒れれネ♥♥♥⁶.ᶠᶠ゜゜゜゜゜゜   ⁶.ナナナナナナナナ²4  ⁶-#⁶.○○○○○○◝◝\n²4    ᶜa⁶.◜◜ュユら███²a ᶜ4⁶.ユユユヲららら@⁶.⁷ᶠᶠ◆³¹³³⁶.゜??゜゜⁸\n゜  ⁶.\0\0\0\0█ららユ⁶.ナユヲ◝◝◝◝◝²4   \n    ᶜa⁶.█\0\0\0\0\0\0\0⁶.◝◝ユユ\0\0\0\0⁶.゜よ◝◝\0\0\0\0⁶.ュ◝◝◝◝\0\0\0⁶.◝◝◝◝◝\0\0\0⁶.◝◝◝◝◝\0\0\0⁶.◝◝◝◝゜\0\0\0⁶.³³³³\0\0\0\0  ⁶-#ᶜ4⁶.◝◝◝◝◝◝゜\0⁶.◝◝○゜ᶠ\0\0\0\n⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.◝◝\0\0\0\0\0\0⁶.○○\0\0\0\0\0\0  '
?"	 ᶜ0press ❎ to\nenter the unknown",34,68
?"	 ᶜ9press ❎ to\nᶜ2enter the unknown",34,67
end function nu()if(btnp(4))n𝘵="mainmenu"
end function ns()if btnp(2)then t=t-1if(t==-1)t=2
sfx(0)elseif btnp(3)then t=t+1if(t==3)t=0
sfx(0)end if(btnp(4)or btnp(5))if t==0then pal(14,128,1)pal(15,133,1)pal(12,130,1)pal(1,132,1)pal(8,139,1)n𝘵="intro"n"1"music"0"elseif t==1then n𝘵="controls"else stop()end
end function n2()if btnp(5)then local n=q()[n𝘧]if n~=nil then local e=#n.text if(n.time<e)n.time=e else n𝘧+=1
end sfx(0)end if(n𝘧>#el[1])nm()
end function 𝘪(n,e,o,l)for n in all(𝘰(n))do if(n.charid~=l and n.x==e and n.y==o)return false
end return 𝘢(e,o,n)and not(nv==n and e==nx and o==t)end function 𝘫(i,e,o,a)local n={}for t=-1,1do for l=-1,1do if(𝘪(i,e+t,o+l,a)and not(t+l==0))add(n,{e+t,o+l})
end end if(#n==0)return e,o
local n=n[z(n)]return n[1],n[2]end function f(n,e)for n in all(split(n,"|"))do n=split(n)add(x(e or false,nj,nz),{charid=n[1],mapid=n[2],x=n[3],y=n[4]})end end function c(n)n=split(n)add(nq,{spridx=n[1],mapid=n[2],x=n[3],y=n[4],cldwn=1})end function 𝘨(e)for n in all(nq)do if(n.spridx==tonum(e))del(nq,n)
end end function nw()local a,r=#n_,false if btnp(5)and a>0then r=true sfx(0)local n=q()[n𝘧]if n~=nil and n.time~=nil then if(n.time<#n.text)n.time=#n.text else n𝘧+=1
end if n𝘧~=nil and n𝘧>#q()then if(type(n_[1])=="number")add(n𝘻,n_[1])
n_=𝘸(n_)n𝘧=1end end if btn(5)then n𝘢=nil for n=0,3do if(btn(n))n𝘢=n
end else n𝘢=nil end if(a>0)return
for n=1,#n𝘷,2do local e=ceil(n/2)if(not o(n𝘪,e)and n𝘷[n]())add(n𝘪,e)n𝘷[n+1]()r=true
end if n𝘢==nil and a==0then local n=l(nv)for n=0,3do if(btnp(n))n3(nx,t)break
end if btnp(2)and t>0and 𝘢(nx,t-1)then t=t-1elseif btnp(1)and nx<15and 𝘢(nx+1,t)then nx=nx+1n𝘳=false elseif btnp(3)and t<15and 𝘢(nx,t+1)then t=t+1elseif btnp(0)and nx>0and 𝘢(nx-1,t)then nx=nx-1n𝘳=true end end if(btnp(4)and a==0)𝘹()𝘻()
local h,w=1for n in all(en)do local n=split(n)if(n[1]==nv and not o(n𝘪,h)and v(x(#n>2,n[3],nil)))w=n[2]break
h+=1end local h,y,p=nn(nv,nx,t)if h~=nil and not n𝘱 then n𝘱=true if 𝘴(h)<𝘴(nv)then 𝘵(h,y,p)elseif w~=nil then if(a==0)i"we aren't done here yet... we should"i("ᶜ9["..w.."]")
else 𝘵(h,y,p)end elseif h==nil then n𝘱=false end if btnp(5)and n𝘭~=nil and o(n𝘣[n𝘭].charids,n𝘤)and not r then sfx(0)n𝘲=n𝘭 if n𝘭==1then c(s{"255",nv,nx,t})elseif n𝘭==2then local e=e"m"if(u(e.x,e.y)<2and not d"19")n"19"e.flipv=true
elseif n𝘭==4then local n=l(nv)local n,e=nx+n.cellx,t+n.celly if mget(n,e)==110then n𝘬+=1if(n𝘬==2)i"we're digging our own graves!"
if(n𝘬==4)mset(n,e,127)f(s{"s",nv,nx+1,t})t-=1n𝘭=nil m"e".idle={"what a wonderful harvest"}
end end else n𝘲=nil end if a==0and not r then for n in all(𝘰(nv))do for e=-1,1do for o=-1,1do if e~=o and n.x+e==nx and n.y+o==t then if(b(n.x,n.y,n.mapid))local e=m(n.charid).idle i(x(n.flipv or false,"owww...",e[z(e)]),n.charid)r=true
end end end end end for n in all(𝘦())do n5(n)end for n=-1,1do for e=-1,1do local n,e=nx+n,t+e if b(n,e,nv)and not r then for t in all(split("122,123,138,139;what a nice old wagon#124,125,140,141;the poor old mill...#158;look at these pumpkins!#159;it says pottsfield ⬆️#220;a stump of some weird tree?#219;a creepy tree with a face on it#224,225,240,241;pottsfield old barn#226,227,242,243;the old grist mill#228,229,244,245;the animal schoolhouse#110;the ground is higher here#127;a deep hole in the ground#42;what a nice view out this window#58;its a large cabinet#59;its a comfortable chair#74;its a small desk#75;its a school desk#90;its a lounge chair#91;its a bundle of logs#143;its a piano!#177;its the mill's grinder!#178;its a jar of thick oil#179;its a broken jar of oil#200;its a chalk board#215;i found a rock fact!#216;its warm by the fireplace#217;a bundle of black oily sticks#180,181;a cafeteria bench and table#230,231,246,247;the town gazebo#232,233,248,249;pottsfield home","#"))do local d,t=split(t,";"),mget(n+l(nv).cellx,e+l(nv).celly)if o(split(d[1]),t)and a==0then i(d[2])r=true if(t==219)𝘯()
if t==215then if(not o(n𝘥,nv))add(n𝘥,nv)
i(split"put raisins in grape juice to get grapes!,dinosaurs had big ears but we forgot!,𝘪 was stolen from old lady daniels yard!"[#n𝘥],"𝘧",true)i(#n𝘥.." of 3 rock facts collected!","𝘧")mset(n+l(nv).cellx,e+l(nv).celly,202)if(#n𝘥==3)g"you found all 3 rock facts!"
end break end end end end end if(#n_>a or n𝘢~=nil)sfx(2)
end function k(n)n𝘭=tonum(n)𝘻()end function 𝘻()n𝘰={txt=m(n𝘤).name,frmcnt=32}end function g(n)i("ᶜ9★ "..n.." ★","𝘢",true)if(not o(n𝘺,n))add(n𝘺,n)if#n𝘺==5then mset(73,16,202)l"secret".playmapspr=202elseif#n𝘺==6then g"all achievements obtained!"end
end function s(e)local n=""for o,t in ipairs(e)do n=n..t if(o~=#e)n=n..","
end return n end menuitem(1,"achievements",function()if(n𝘵~="playmap")return
for n in all(n𝘺)do g(n)end i(#n𝘺.." of 7 achievements gotten!")end)function v(n)return n==nil or o(n𝘪,n)or false end function 𝘯()if(not o(n𝘨,nv))add(n𝘨,nv)
i("*eerily howls in the cool fall wind*","𝘦",true)i(#n𝘨.." of 7 edelwoods found!","𝘦")if(#n𝘨==7)g"you found all 7 edelwoods!"
end function i(n,e,o)add(n_,{{speakerid=e or n𝘤,text=n,large=o or false}})end function 𝘤()return ne("grounds",nx,t,254)end function ny(e,o)for n in all(et)do if n.mp_one==e and n.mp_two==o then return split(n.mp_one_locs[1])elseif n.mp_one==o and n.mp_two==e then return split(n.mp_two_locs[1])end end end function nn(e,o,t)for n in all(et)do if n.mp_one==e then for e in all(n.mp_one_locs)do local e,l=split(e),split(n.mp_two_locs[1])if(0+e[1]==o and 0+e[2]==t)return n.mp_two,l[1],l[2]
end elseif n.mp_two==e then for e in all(n.mp_two_locs)do local e,l=split(e),split(n.mp_one_locs[1])if(0+e[1]==o and 0+e[2]==t)return n.mp_one,l[1],l[2]
end end end return nil,nil,nil end function 𝘩()return e"e".mapid=="pottsfield"end function 𝘳()if(n𝘴>4and n𝘶>4)n"28"k"4"
end function n5(n)if(n.cldwn==nil)n.cldwn=1
n.cldwn-=1if(n.cldwn==0)n.cldwn=16else return
local o=false for e in all(nj)do if(e.charid==n.charid)o=true
if(o and e.intent==nil and not 𝘪(e.mapid,e.x,e.y,e.charid))n.x,n.y=𝘫(e.mapid,e.x,e.y,e.charid)
end local e,i=n.intent,n.intentdata if e=="chase_candy_and_player"then local o=l(n.mapid)local o,l=o.cellx+n.x,o.celly+n.y local i=mget(o,l)if(i==191)mset(o,l,185)
if(i==142or i==175)mset(o,l,201)
if(i==178)mset(o,l,179)
e="walk"local e,o=ne(nv,n.x,n.y,n𝘣[1].spridx)local o=n.intentdata if n.mapid~=nv then local n=ny(n.mapid,nv)if(n~=nil and#n>1)o=n[1].."|"..n[2]
elseif e~=nil and u(n.x,n.y,e.x,e.y)<u(n.x,n.y,nx,t)then o=e.x.."|"..e.y else o=nx.."|"..t end n.intentdata=o end if e=="walk"then local i,e=n.mapid,split(n.intentdata,"|")local t,l=e[1]-n.x~=0,e[2]-n.y~=0if(t)n.x+=sgn(e[1]-n.x)
if(l)n.y+=sgn(e[2]-n.y)
if#e==2and not(t or l)then if n.intent=="walk"then n.intent=nil elseif n.intent=="chase_candy_and_player"then for e in all(nq)do if(e.mapid==n.mapid and e.spridx==n𝘣[1].spridx and e.x==n.x and e.y==n.y)del(nq,e)
end end end local e,t,l=nn(i,n.x,n.y)if(not o and e~=nil)nb(n,e,t,l)
end if(e=="loop")local e=split(n.intentdata,"|")if n.x==e[3]and n.y~=e[2]then n.y-=1elseif n.y==e[2]and n.x~=e[1]then n.x-=1elseif n.x==e[1]and n.y~=e[4]then n.y+=1elseif n.y==e[4]then n.x+=1end
end function ne(l,t,i,a)local o,e=nil,1000for n in all(nq)do local t=u(t,i,n.x,n.y)if(n.mapid==l and n.spridx==a and t<e)e=t o=n
end return o,e end function 𝘭(n)add(nj,e(n))for e in all(nz)do if(e.charid==n)del(nz,e)
end end function 𝘧(n)n=split(n)while(o(n,n𝘤))𝘹()
for n in all(n)do add(nz,e(n))end for e in all(nj)do if(o(n,e.charid))del(nj,e)
end end function 𝘹()f(s{n𝘤,nv,nx,t},true)n𝘤=nj[1].charid nx=nj[1].x t=nj[1].y nj=𝘸(nj)end local i,s,f,c=0,"pepjebs","studios",{}function nr()if(i%5==0and flr(i/5)<=#s)local n=flr(i/5)+1n8=sub(s,n,n)add(c,{letter=n8,x=10+12*n,y=45,age=0})
i+=1if(i>220)n𝘵="scene"pal(13,132,1)music"23"
end function n0()cls(7)if i==1then sfx(3)elseif i==135then sfx(4)end local n,e,o=58,72,1if i<60then o=7elseif i<120then o=6end?"⁶i"..f,n-#f,e,o
if(i>130and i<160)line(n-#f+(i-135),e-8,n-#f+(i-130)+4,e+16,7)line(n-#f+(i-135)+1,e-8,n-#f+(i-130)+5,e+16,7)
for e in all(c)do local n=e.age local o,t,l,i=flr(n/9)%7+8,3,e.x,false if n>100then i=true if(n>130and n<140)o=12else o=1
elseif n<100then t=8-flr(n/18)if n<85and n>75then n-=3l+=3elseif n>85and n<95then n+=3end end if(n>100)n=100
local n=e.y+(100-n)if(i)no(e.letter,l+1,n+1,6,t)
no(e.letter,l,n,o,t)if(e.age<200)e.age+=1
end end function nh()cls(0)?"ᶜa⬆️⬇️⬅️➡️ᶜ7 move",16,20
?"ᶜa❎ᶜ7 progress dialog or\n use item",16,40
?"ᶜa🅾️ᶜ7 switch characters",16,60
?"ᶜa❎+⬆️⬇️⬅️➡️ᶜ7 select object\n or npc",16,80
?"ᶜa🅾️ᶜ7 back to menu",8,118
end function nc()cls(0)local e,o=24,4for n=1,60do local t,l,n=ceil(n/10),(n-1)%10,split(split("128#129#130#131#132#132,#131,#130,#129,#128,#144#0#133#134#135#136#137#145#0#144,#144#0#146#147#148#149#150#151#0#144,#144#0#152#153#160#161#162#163#0#144,#144#0#0#164#165#166#167#0#0#144,#168#169#176#176#176#176#176#176#169,#168,","#")[n])local e,o,t=n[1],l*8+e,t*8+o if(e~=0)spr(e,o,t,1,1,#n>1)
end 𝘮("start",48,65,t==0)𝘮("controls",42,85,t==1)𝘮("quit",50,105,t==2)local n=65+t*20palt(5,true)pal(12,9)spr(234,24,n,1,1)spr(234,96,n,1,1,true,false)pal(12,12)palt(5,false)np=𝘶()for o,n in ipairs(split("4,4|108,4|4,108|108,108","|"))do local n=split(n)local n,e=n[1],n[2]w(n,e,17,17,2,10,9)spr(np[n𝘮[o]].chrsprdailogueidx,n+1,e+1,2,2)end end function n4()local n,e=32,16cls(0)w(n,e,66,52,0,4,5)sspr(80,72,32,24,n+1,e+4,64,48)nt()end function nt()if#n_>0then local n=q()[n𝘧]if(n~=nil)nk(n)
end end function ng()local n=l(nv)palt(0,false)palt(13,true)cls(139)map(n.cellx,n.celly)if(n𝘰~=nil and n𝘰.frmcnt>0and flr(n𝘰.frmcnt/5)%2==0)local n,e=nx*8,t*8pset(n,e+9,12)pset(n+7,e+9,12)line(n+1,e+8,n+6,e+8,12)line(n+1,e+10,n+6,e+10,12)pset(n,e+10,1)pset(n+7,e+10,1)line(n+1,e+11,n+6,e+11,1)
𝘺(0,m(n𝘤).mapspridx,nx,t,1,n𝘳,false)for n in all(𝘰(nv))do if n.x~=nil and n.y~=nil then local e,t=m(n.charid),1if(e.scaling~=nil)t=e.scaling
local o=false if(n.flipv)o=true
local l=false if(nx<n.x and not o)l=true
𝘺(0,e.mapspridx,n.x,n.y,t,l,o)end end for n in all(nq)do local e,o=n.x,n.y local t=x(𝘪(n.mapid,e,o),0,-.5)if(n.mapid==nv)𝘺(0,n.spridx,e+t,o,1,false,false)
end if(n𝘢~=nil)local n=n𝘢 local o,n,e=𝘣(n)palt(5,true)spr(o,8*(nx+n),8*(t+e),1,1,n==-1,e==1)palt(5,false)
if n.type=="exterior"or n.id=="barn"then local d={}for e=0,15do for i=0,15do local a=false for n in all(nl(nj,{{x=nx,y=t}}))do if(u(e,i,n.x,n.y)<2.7)a=true
end local t=tostr(e).."|"..tostr(i)if(not n.discvrdtiles)n.discvrdtiles={}
if not a and not o(n.discvrdtiles,t)then add(d,{e,i})local n=mget(e+l(nv).cellx,i+l(nv).celly)if o(n𝘦.idxs,n)then for n=1,#n𝘦.clrmp_s do pal(n𝘦.clrmp_s[n],n𝘦.clrmp_d[n])end spr(n,8*e,8*i)for n=1,#n𝘦.clrmp_s do pal(n𝘦.clrmp_s[n],n𝘦.clrmp_s[n])end else if(#n𝘫==0and flr(rnd(30000))==0)add(n𝘫,{frmcnt=35,type="eyes",x=e,y=i})
rectfill(8*e,8*i,8*e+7,8*i+7,0)end elseif not o(n.discvrdtiles,t)then add(n.discvrdtiles,t)end end end end for e in all(n𝘫)do local t=tostr(e.x).."|"..tostr(e.y)if e.frmcnt>0and not o(n.discvrdtiles,t)then if e.type=="eyes"then local t,n,o=7,e.x*8,e.y*8if(e.frmcnt<8or e.frmcnt>27)t=1else pset(n+1,o+4,6)pset(n+3,o+4,6)pset(n+2,o+3,6)pset(n+2,o+5,6)pset(n+4,o+4,6)pset(n+6,o+4,6)pset(n+5,o+3,6)pset(n+5,o+5,6)
pset(n+2,o+4,t)pset(n+5,o+4,t)end e.frmcnt-=1else del(n𝘫,e)end end local e,n=n𝘭~=nil and o(n𝘣[n𝘭].charids,n𝘤),nil if n𝘰~=nil and n𝘰.frmcnt>0then n=n𝘰.txt n𝘰.frmcnt-=1else end ni(1,m(n𝘤).mapspridx,n)if(e)local e=n𝘣[n𝘭]ni(114,e.spridx,x(n~=nil,e.name,nil))
a=n𝘹 if(a~=nil and a.frmcnt>0)w(a.x,a.y,#a.txt*4+4,8,4,10,9)y(a.txt,a.x+3,a.y+3,2)y(a.txt,a.x+2,a.y+2,9)a.frmcnt=a.frmcnt-1
palt(13,false)nt()end function ni(e,l,o)local n,t=1,u(1,e/8)<3if(t)n=114
if o~=nil then if(t)n=90
w(n,e,#o*4+12,11,4,10,9)y(o,n+12,e+5,2)y(o,n+11,e+4,9)else w(n,e,11,11,4,10,9)end spr(l,n+2,e+2)end function 𝘺(r,a,o,t,n,l,i,e)e=e or 8local a,d=a%16*8,a\16*8for n=0,15do pal(n,r)end n=n or 1n*=e sspr(a,d,e,e,o*8,t*8+1,n,n,l,i)sspr(a,d,e,e,o*8+1,t*8,n,n,l,i)sspr(a,d,e,e,o*8+1,t*8+1,n,n,l,i)for n=0,15do pal(n,n)end sspr(a,d,e,e,o*8,t*8,n,n,l,i)end function e(e)for n in all(𝘦())do if(n.charid==e)return n
end end function q()local n=n_[1]if(type(n)=="number")n=el[n]
return n end function h(n)local n=split(n)if(n[1]~=nv)return false
for l=2,#n,2do local e,o=n[l],tonum(n[l+1])if e=="on"then local n=tonum(n[l+2])if(nx~=o or t~=n)return false
l+=1end if(e=="above"and t<=o or e=="right_of"and nx<=o or e=="below"and t>=o or e=="left_of"and nx>=o)return false
end return true end function b(n,e,o)local l,i,a=𝘣(n𝘢)return l~=nil and o==nv and nx+i==n and t+a==e end function 𝘱(e,o)local i,a,d=𝘣(n𝘢)local n=l(nv)return e==nv and i~=nil and mget(n.cellx+nx+a,n.celly+t+d)==o end function 𝘲(e)local n,o,i=𝘣(n𝘢)local n=l(nv)mset(n.cellx+nx+o,n.celly+t+i,e)end function 𝘥(e,o,n,l)return n𝘲==e and nv==o and(n==nil or n==nx and l==t)end function p(n)local e=split(n)if(nv~=e[1])return false
for n in all(𝘰(nv))do local t=n.x.."|"..n.y if(o(l(nv).discvrdtiles,t)and n.charid==e[2])return true
end return false end function d(n)return o(n𝘻,tonum(n))end function n(n)add(n_,tonum(n))end function n3(e,o)for n in all(nj)do if(flr(rnd(2))==0and n.intent==nil)𝘬(n,e.."|"..o)
end end function r(n)local n,e,o=split(n)for t=1,#n,2do if(o~=n[t])o=n[t]e=1else e+=1
local l={}for n in all(𝘦())do if(o==n.charid)add(l,n)
end 𝘬(l[e],n[t+1])end end function 𝘬(n,e)n.intent="walk"n.intentdata=e end function nm()music"-1"n𝘵="playmap"n𝘤="g"n𝘧=1k"1"n_={}𝘵("woods1",8,8)nj={{charid="w",mapid="woods1",x=nx,y=t},{charid="k",mapid="woods1",x=nx,y=t}}pal(14,14,1)pal(15,15,1)pal(12,12,1)pal(1,1,1)pal(8,8,1)end function nb(n,e,o,t)n.x=o n.y=t n.mapid=e local e=split(n.intentdata,"|")if(n.intent=="walk"and#e>2)n.intentdata=e[3].."|"..e[4]
end function 𝘢(e,t,n)local n=l(n or nv)local e=mget(e+n.cellx,t+n.celly)return o(ei,e)and(n.type~="interior"or not o({207,223,239},e))end function 𝘵(n,e,i)nv=n nx=e t=i for n in all(nj)do n.mapid=nv n.x=nx n.y=t n.intent=nil n.intentdata=nil end local n=l(nv)if(n.type=="interior")t-=1
local e=63-2*#n.title n𝘹={x=e,y=12,txt=n.title,frmcnt=45}local e,t=n.cellx,n.celly if not o(n𝘸,nv)then local a=n7()for n=0,15do for l=0,15do local i=mget(n+e,l+t)if(o(a,i))local o=n6(i)local i=z(o)mset(n+e,l+t,o[i])
end end add(n𝘸,nv)end for n in all(n𝘯)do if n.type=="interior"and n.playmapid==nv then local e,t,n=n.playmaplocx+e,n.playmaplocy+t,n.playmapspr mset(e,t,n)if(not o({202,218},n))mset(e+1,t,n+1)mset(e,t+1,n+16)mset(e+1,t+1,n+17)
end end end function u(n,e,o,l)return sqrt(((o or nx)-n)^2+((l or t)-e)^2)end function 𝘷(o)local e=split"boot,scene,mainmenu,controls,intro,playmap"for n=1,#e do if(e[n]==o)return{update=ee[n*2-1],draw=ee[n*2]}
end end function z(n)return flr(rnd(#n))+1end function 𝘶()na={}for n in all(n𝘩)do if(not o({-1,196},n.chrsprdailogueidx))add(na,n)
end return na end function 𝘮(n,e,o,l)w(e,o,#n*4+8,12,4,10,9)local t=0if(l)t=10y(n,e+5,o+5,2)
y(n,e+4,o+4,t)end function 𝘦()return nl(nj,nz)end function nl(e,o)local n={}for e in all(e)do add(n,e)end for e in all(o)do add(n,e)end return n end function nk(n)if(n.time==nil)n.time=1
w(8,100,112,24,4,10,9)local l=n.speakerid local i=m(x(l=="*",n𝘤,l))local e,t,a=i.name,n.text,n.time?e,30,104,2
?e,29,103,9
local e=t if(l=="𝘢"and a==1)sfx(4)
if(a<#t)e=sub(t,1,a)n.time+=1
if#e<=22then y(e,29,110,0)else local n=-1for t=23,1,-1do if(o(split(",.? ",""),sub(e,t,t)))n=t break
end y(sub(e,1,n).."\n"..sub(e,n+1),29,110,0)end w(10,103,17,17,1,6,5)spr(i.chrsprdailogueidx,11,104,2,2)if(n.large)w(30,22,68,68,1,6,5)𝘺(0,i.chrsprdailogueidx,4,3,4,false,false,16)
local n,o=117,2if(#t==#e)n,o=117,10
if(btn(5))n,o=118,9
if(n==117)?"❎",112,118,0
?"❎",112,n,o
end function 𝘣(n)if(n==nil)return nil
local e,o,t=234,0,2*n-5if(n==2or n==3)e=250else o=2*n-1t=0
return e,o,t end function 𝘸(n,e)nd={}for e=(e or 1)+1,#n do add(nd,n[e])end return nd end function 𝘰(o)local n={}for e in all(𝘦())do if(e.mapid==o)add(n,e)
end return n end function w(o,t,n,e,r,a,d)local l,i,e,n=o+1,t+1,o+n,t+e rectfill(l,i,e-1,n-1,r)line(l,t,e-1,t,a)line(l,n,e-1,n,d)line(o,i,o,n-1,a)line(e,i,e,n-1,d)pset(o,n,0)pset(e,n,0)line(l,n+1,e-1,n+1,0)end local n=split("206;206,221,237#238;222,238#207;207,223,239#235;235,251,218#205;202,203,205#236;204,236","#")function n6(e)for n in all(n)do local n=split(n,";")if(e==n[1])return split(n[2])
end return nil end function n7()local e={}for n in all(n)do local n=split(n,";")[1]add(e,n)end return e end function y(n,...)print(n9("^"..n),...)end function n9(n)local e,l,o,t="",false,false for i=1,#n do local n=sub(n,i,i)if n=="^"then if(o)e=e..n
o=not o elseif n=="~"then if(t)e=e..n
t,l=not t,not l else if o==l and n>="a"and n<="z"then for e=1,26do if(n==sub("abcdefghijklmnopqrstuvwxyz",e,e))n=sub("𝘢𝘣𝘤𝘥𝘦𝘧𝘨𝘩𝘪𝘫𝘬𝘭𝘮𝘯𝘰𝘱𝘲𝘳𝘴𝘵𝘶𝘷𝘸𝘹𝘺𝘻[\\",e,e)break
end end e=e..n o,t=false,false end end return e end function j(e,o)for n=0,319,4do poke4(e+n,peek4(o+n))end end function no(o,t,l,n,e)poke(17792,peek(24320+n))poke2(17793,peek2(24320))poke4(17795,peek4(24360))poke2(17799,peek2(24369))poke(17801,peek(24371))poke(24320+n,n)poke2(24320,n==0and 4352or 272)j(17472,0)j(0,24576)camera()fillp(0)rectfill(0,0,127,4,(16-peek(24320))*0x.1)?o,0,0,n
j(17152,24576)j(24576,0)j(0,17152)camera(peek2(17795),peek2(17797))sspr(0,0,128,5,t,l,128*e,5*e)j(0,17472)poke(24320+n,peek(17792))poke2(24320,peek2(17793))fillp(peek2(17799)+peek(17801)*.5)end
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
__map__
ebebebebebebebebebebebebebcfcfcfcfcfcfebcececeebebebebebebebebebcdececbe9ebecfcfbebe9ecdcdcdcdebebebebebebebebebebcfcfcfebebebebebebcdcdcdcdcdcdcdcdcdebebebebebcdcd6ccdcdcdcdcdcdcdcdebebebebebebebebebebebebcfcfebebebebebebebebebebebebebebebebebebebebebebeb
ebcdebcdebdccdeccdcdcdebcdcfcfcfcfcfcfecebcececdcdecebebebebebebcdcdcdbebe9ecfbebe9ecfcdcdcdceceebebebcdcdcdcdcdcdcfcfcdcdcdcdebebaf8e8e8e8e8e8e8e8e8e8e8e8eafebeb6ccdcdcdcdcdcdcdcdcdcdcdcdcdebebebd7cdcdcdcdcfcfcdcdcdcdcdcdebebebebebcdcdcdcdebebebebebebebeb
ebcdeccdcdeccdcdcdcdececcfcfcfcfebcfcfcfcecececdcdcdcdebebebebebcdcdebcdbebe9e9eecbe9ecdebcececeebebcd6ccdcdcdcdcdcfcfcdbe9ecddcebafbf6bd9bfd9b1bfb2b2bfbfb2afebebcdaf8e8e8e8e8e8e8e8e8e8eafcdebebcdcdeccdebcdcfcfcdcdcdeccdcdebebebcdcdcdcdebcdebebcdcdcdebebeb
ebcdcdebcdcdcdebcdeccfcfcfcfcfebebebcfcfeecececdcdcdcdcdcdebebebcdebebcdebcdbecfcdcdcdebcecececdebcd6ccfcfcfcf6ccfcfcfcd9e9ecdebcdafbf6bbfbfbfb2bfbfbfbfbfbfafcdebcdaf5b5b5bbfbfbfbfbf6abfafcdebebebcdcdcdcdcdcfcfcdebcdcdcdcdebebebcdcdcdcdcdcdebcdcdcfcfcdebeb
ebcdcdcdecececececcfcfcfcfcfcdebebebceceeeeecfcfcfebececcddcebebcdcdcdcdebcdcfcfcdcdebebcececdebeb6ccfcfcfcfcfcfcfcfcd6d9e9ecdebcd2abf6abfbfbfbfbfbfbfbfd9bf2acdebcd2ab9bfbfbfbfbfbfbfbfbf2acdcdebcdcdebcdcd6ccfcfcdebebcdcdcdebebebcdcdcdcdcdcdcdcdcfcfcfcdebeb
ebebcdeccfcfcfcfcfcfcfcfeccdcdebcecececeeecfcfcfcfcfcfcfcfcdebebcdebebcdebcdcfcf9fcdcdebceceebcdebcdcdcdcdcfcfcfcfcfcd9ebe9ecdebcdafbf6bbfbfbfbfbfbfbfbfbfbfafcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdebcdeccdcdebcfcfcfcdebcdcdcdcdebebcdcdcfcfcdebcdcdcfcfcfcdebebeb
ebcdcdcfcfcfcfcfcfcfcfcfeccdebebcececeebcfcfcfcfcfcfcfcfcfcfebebcdcdcdcdcdcdcfcfcfcdcdcdcecececdebebececcdcfcfcfcfcfcdcdbe9ecdebcdafbf6bbfbfb2bfbfbfb2bfbfbfafcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdebcdcdcdebcdcfcfcdebcdcdcdeccdebebcdcdcfcfcdcd6ccfcfcfcdebcdcdeb
ebcdcdcfcddbcdcfcfcfececcdcdecebceceebebebcfcfcfcfcfcfcfcfcfebebebcdcdcdcdeccfcfcfcfcdcdcfcececeebcdcdcdcd6dcfcfcfcfcdcdececcdcdcdaf8e8e8e8e8e2b2b8e8e8e8e8eafcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdebcdcdcdebcdcfcfeccdebcdcdcdcdebcfcfcfcfcfcfcfcfcfcfcdcdcdcdcdeb
ebebcdcfcdcdcfcfcfeccdcdcdcdcdebebebebebeb6ccfcfcfcfcfcfcfcdebebcdcdebebcdcdeccfcfcfcdcfcfcfceceebcd9ebe9ecdcdcfcfcfcdcdcdcdcdaecdafbfbfd8bfbfbfbf5b5bbfbf5bafcdcdcdafbfbfbfbfbfbfbfbfbfb9afcdcdebcdcdcdcdebcfcfcfecebebcdcdcdebcfcfcfcfcfcfcfcfcfcfcde6e7cdcdeb
ebcddccfcfcfcfcfeccdebcdcdebcdebebebebeb6ccfcfcfcfcfcfebeccdebebd7ebcdcdcdcdeccfcfcfcfcfcfcdcdcdebcd9e9e9ebecdcdcfcfcfcdcdaeaeaecdaf5abfbfbf3bbfbfbfbfbfbfbfafcdcdcdaf3abfbfbfbfbfbfbfbfbfafcdcdebcdcdcdcdcdcdcfcfcdebcdcdcdcdebebcdcdcdeccfcfcfcfcfcdf6f7cdcdeb
ebcdcdcfcfcfcfeccdcdcdcdeccdebebebebeb6ccfcfcfcfcfebebebcdcdebebcdcdcdcdebcdcdeccfcfcfcfcdcdebebebcdbe9ebe9ecdcdcfcfeccdaeaeaeaecdafbfbf3bbfbfbfbfbfbfbfbfbfafcdcdcdafbfbfbfbfbfbfbfbfbfbfafcdcdebcdcdcdcdcdcdcfcfcdcdcdcdcddbebebcdcdeccd6ccfcfcfcfcfcfcfcfcdeb
ebcdcfcfcfcfeccdcdcdcdcdcdcdebebebeb6ccfcfcfcfebebebebebcdcdebebebcdcdcdebebcdcdeccfcfcfcfcdcdebebcd9e9ebecdcd6ecfcfeccdaeaeaeaecd2abfbfbfbfbfbfbfbfbfbfbfbf2acdcdcd2abfbfbfbfbfbfbfbfbfbf2acdebebcdeccdcdcdcdcfcfcdebcdcdcdcdebebcdcdcdcdcdcfcfcfcfcfcfcfcfcdeb
ebcfcfcfcfcdcdcdcdeccdebcdcdebebeb6ccfcfcfcdcdcdcdebdbcdcdcdebebebcdcddccdebcdcdcdcdcfcfcfcfcdebebcdcdcdcdcdcfcfcfcfeccdaeaeaeaecdafbfbfbfbfbfbfbfbfbfbfbfbfafcdaecdafbfbfbfbfbfbfbfbfbfbfafcdebebcdcdcdcdcdeccfcfcdebcdcdcd9eebebebebcdcdcdcfcfcfcfcfcfcfcdcdeb
cfcfcfcfcdcdebcdebcdcdcdcdeccdebebcfcfcfcdcdcdcdcdcdcdcdcdcdebebebcdcdcdcdcdcdcdcdcdcdcfcfcfcfcfebcdaeaeaecdcfcfcfcf7a7baeaeaeaecdaf4abfbfbf3abfbfbfbfbfbf4aafcdaecdaf8e8e8e8e2b2b8e8e8e8eafcdebebcdaeaeaeeccfcfcfcdebcdcd9eebebebebebcdcdcdcfcfeccdcdcdcdcdebeb
cfcfcfcdcdcdeccdcdcdcdebcdcdcdebcfcfcfcfcdcdcdecdccdcdcdcdcdebebebdbcdcdcdcdcdcdcdcdcdcdcdcfcfcfebcdaeaeaecdcdcfcfcf8a8baeaeaeaeccaf8e8e8e8e8e8e2b8e8e8e8e8eafccaeaecdeccdcdcfcfcfcfcdcdeccdcdebebaeaeaeaeaecfcfcdcdcdcd9eebebebebebebebcdcdcfcfcdcdcdcdebebebeb
cfcfebebebebebebebebebebebebebebcfcfcfebebebebebebebebebebebebebebebebebebebebebebebebebebcfcfcfdbcdaeaeaeaecdcfcfcdcdcdcdaeaeaecdcdcccdcdcfcfcfcfcfcfcdcdcccdcdaeaeeccdcdcdcfcfcfcfcfcdcdeccdcdebaeaeaeaeaecfcfebebebebebebebebebebebebebebcfcfebebebebebebebeb
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
0c 3d3e3f00
0f 00000000
07 00000040
06 40004040
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
__meta:title__
over the garden wall
made by pepperoni-jabroni
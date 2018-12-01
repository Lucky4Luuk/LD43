pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
local x=0
local y=64
local f=false --if player is flipped
local terrain={}
local terrainflowers={}
local terrainh={}
local seed=69
local camx=0
local camy=0

function updatemap()
	h=48
	local cx=flr(camx/8)
	for i=1+cx,128+cx do
		local pd=terrain[max(i-1,1)]
		local d=terrain[i]
		local nd=terrain[min(i+1,16)]
		local n=1
		if d==0 and pd==0 then
			n=1
		elseif d==-1 and (pd==0 or pd==-1) then
			n=2
		elseif d==1 and (pd==0 or pd==1) then
			n=5
		end
		if d==-1 then
			h-=8
		end
		mset(i-1-cx,h/8-1,terrainflowers[i])
		mset(i-1-cx,h/8,n)
		for y=h/8+1,9 do
			mset(i-1,y,4)
		end
		h+=d*8
		if d==-1 then
			h+=8
		end
		h=min(h/8,16)*8
	end
end

function gen_terrain(seed)
	srand(seed)
	local d=0
	local h=48
	local ph=48
 for i=1,1024 do
		if d==0 then --going straight
			local r=flr(rnd(3))
			if r==2 then
				d=flr(rnd(3)-1) --either -1,0 or -1
			end
		elseif d==-1 then --going up
			local r=flr(rnd(3))
			if r==2 then
				d=0
			end
		elseif d==1 then --going down
			local r=flr(rnd(3))
			if r==2 then
				d=0
			end
		end
		h+=d*8
		if h/8<1 then
			d=0
			h+=8
		end
		if h/8>6 then
			d=0
			h-=8
		end
		terrain[i]=d
		for j=0,7 do
			ph+=d
			terrainh[i*8+j]=ph
		end
		if d==0 then
			if flr(rnd(4))==0 then
				--mset(i-1,h/8-1,3)
				terrainflowers[i]=3
			else
				--mset(i-1,h/8-1,6)
				terrainflowers[i]=6
			end
		end
		--line(i*8,h-d,i*8+8,h,7)
 end
 
	updatemap()
end

function _init()
	gen_terrain(seed)
end

function _update()
	if btn(0) then
		x-=1
		f=true
		--y+=terrain[max(min(flr(x/8+1.5),16),1)]*-1
	end
	if btn(1) then
		x+=1
		f=false
		--y+=terrain[max(min(flr(x/8+1.5),16),1)]
	end
	local y1=terrainh[flr(x+15)]+16
	local y2=terrainh[flr(x+8)]+16
	y=min(y1,y2)
	camx=max(0,x-64)
	camy=min(0,y-52)
end

function _draw()
	cls()
	--updatemap()
 map(0+flr(camx/8),0+flr(camy/8),0-((camx/8)%1)*8,24-((camy/8)%1)*8,17,16)
	--map(0,0,0-((camx/8)%1)*8,24,17,16)
	--sspr(40,0,16,16,x,y,16,16,f,false)
	sspr(56,0,8,8,x-camx,y-camy,8,8,f,false)
	print("!===debug===!",0,0,1)
	print("mem: "..tostr(stat(0)),0,6,1)
	print("cpu: "..tostr(stat(1)),0,12,1)
end
__gfx__
0000000033b33333fffffff3ffffffff000000003fffffffffffffff555555550000000000000000000000000000000000000000000000000000000000000000
00000000332b32b3ffffff33ffffffff0000000033ffffffffffffff555555550000000000000000000000000000000000000000000000000000000000000000
00700700b242b52bfffff333ffffffff00000000333fffffffffffff557057050000000000000000000000000000000000000000000000000000000000000000
0007700044544445ffff3333ffffffff000000003333ffffffffffff555555550000000000000000000000000000000000000000000000000000000000000000
0007700054224224fff33330ffffffff0000000003333fffffffffff515555150000000000000000000000000000000000000000000000000000000000000000
0070070024452252ff333030f9ffff9f00000000030333ffffffffff511551150000000000000000000000000000000000000000000000000000000000000000
0000000002220202f3330000f3ff8f3f000000000003033fff3fff3f551111550000000000000000000000000000000000000000000000000000000000000000
000000000022000033030000f3f3ff3f00000000000000333f3f3f3f555555550000000000000000000000000000000000000000000000000000000000000000
33000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

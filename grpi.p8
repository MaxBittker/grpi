pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function find_where(t, f)
  for key, value in pairs(t) do
    if f(value) then return value end
  end
  return false
end

function has (tab, val)
    for index, value in pairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function vadd(a,b)
  return {x=a.x+b.x, y=a.y+b.y}
end
function vsub(a,b)
  return {x=a.x-b.x, y=a.y-b.y}
end
function vmult(a,c)
  return {x=a.x*c, y=a.y*c}
end
function mag(a)
  return sqrt((a.x)^2+(a.y)^2)
end

function distance(a, b)
  ab = {}
  ab.x = a.x-b.x
  ab.y = a.y-b.y
  return mag(ab)
end

function magsq(a)
  return (a.x)^2+(a.y)^2
end

function v_mag(a,b)
  return sqrt((a.x-b.x)^2+(a.y-b.y)^2)
end

function norm(a)
  local mag=mag(a)
  if mag > 0 then
    a.x=a.x/mag
    a.y=a.y/mag
  else
    a.x=a.x
    a.y=a.y
  end
  return a
end
function qsort(a,c,l,r)
    c,l,r=c or ascending,l or 1,r or #a
    if l<r then
        if c(a[r],a[l]) then
            a[l],a[r]=a[r],a[l]
        end
        local lp,rp,k,p,q=l+1,r-1,l+1,a[l],a[r]
        while k<=rp do
            if c(a[k],p) then
                a[k],a[lp]=a[lp],a[k]
                lp+=1
            elseif not c(a[k],q) then
                while c(q,a[rp]) and k<rp do
                    rp-=1
                end
                a[k],a[rp]=a[rp],a[k]
                rp-=1
                if c(a[k],p) then
                    a[k],a[lp]=a[lp],a[k]
                    lp+=1
                end
            end
            k+=1
        end
        lp-=1
        rp+=1
        a[l],a[lp]=a[lp],a[l]
        a[r],a[rp]=a[rp],a[r]
        qsort(a,c,l,lp-1       )
        qsort(a,c,  lp+1,rp-1  )
        qsort(a,c,       rp+1,r)
    end
end

holds = {}
player = {}
held_holds = {}
tick = 0
size  = 4
reach = 18
floor_y = 110

-- starting velocity
velx = 0
vely = 0
colors = {
  8,12,11,9
} 
function distance_sort( a,b ) 
      pup = vadd(player, {x=0,y=-5})
      return distance(a,pup) < distance(b,pup)
end

function label_holds(holds)
  t = {1,2,3,4}
  for k,v in pairs(held_holds)do
    del(t, v.c)
  end
  types = {}
  for i,v in pairs(t) do
    add(types,v)
  end
  i = 0
  for k,h in pairs(holds) do
    if has(held_holds,h) then
      
    else
      h.c = types[1 + (i%count(types))] 
      i+=1
    end
  end
end

function _init()
      player.x = 50
      player.y = 50 

      for x=8,120,15 do
            for y=8,100,15 do
                  hold = {x=x+rnd(10), y=y+rnd(10), c=0}
                  add(holds, hold)
            end
      end
end

function draw_hold(i,hold)
      color = colors[hold.c] 
      if( i > 4 ) then
            color = 6
      end
      circfill(hold.x,hold.y,1.8,color)

end

function _draw_reach(hold)
  line(player.x,player.y,hold.x,hold.y,colors[hold.c])
end

function _draw()
 cls(7)
 
--  print("press ❎ to bump",
      --  32,10, 6)
 
 circ(player.x,player.y,reach,14)
 
 spr(1,player.x-4-velx, 
       player.y-4-vely)

 for i,h in pairs(holds) do draw_hold(i,h) end
 rectfill(0,floor_y,127,127,12)

foreach(held_holds, _draw_reach)

 spr(6,116,4)
end

function pull_hold(hold) 

end

function _update60()
 -- move ball left/right

 if player.x+velx < 0+size or
    player.x+velx > 128-size
 then
  -- bounce on side!
  velx *= -0.5 
  -- sfx(1)
 else
  player.x += velx
 end
 
 -- move ball up/down

 if player.y+vely < 0+size or
    player.y+vely > floor_y-size
 then
  -- bounce on floor/ceiling
  vely = vely * -0.5
  -- sfx(0)
  
 else
  player.y += vely
 end
 vely += 0.3
 held_holds = {}
 hcount = 0
 for h = 1,4 do
  -- pull_hold(holds[h])
  if(btn(h-1)) and hcount<2 then
    hcount+=1
    hold = find_where(holds, function (ho) return ho.c ==h end)
    if hold then
      d = distance(player, hold)
      if d < reach then
        add(held_holds, hold)
        pulldir = norm(vsub(player,hold)) 
        pull = vmult(pulldir, d*0.1)
        velx -= pull.x
        vely -= pull.y
      end
    end
  end
end


 velx *= 0.9
 vely *= 0.9
 if tick==10 then
  qsort( holds, distance_sort )
 end
 label_holds(holds)
 tick = (tick+1) %11

end

__gfx__
00000000000f00f0000f00f000ffff000022270066656666000bb000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ffff0000ffff0001ff100022222206665666600bbbb00000000000000000000000000000000000000000000000000000000000000000000000000
007007000001f1f00001f1f000ffff0002ffff206656665508bbbcc0000000000000000000000000000000000000000000000000000000000000000000000000
00077000000ffff0000ffff0f222222f025ff52066666665888bcccc000000000000000000000000000000000000000000000000000000000000000000000000
0007700000002200000022000022220002ffff206666656688889ccc000000000000000000000000000000000000000000000000000000000000000000000000
0070070000f2220000f22200004004002222222265666665088999c0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000020000000200000400400022222206666665600999900000000000000000000000000000000000000000000000000000000000000000000000000
00000000000f0000000f000000f00f00020000206566656600099000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000300000f01112051180311e021280113a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001a76011750247300070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
000400000c47011470164600f460164501b44013430164201b420184201d4202241027410164000c4000c4000f40013400114000c4000f4000f4000c400004000040000400004000040000400004000040000400
000400000c5700c5501154018530165201f5101d50018500185001f500225001d5001f500225002b5002250029500245002450029500275002b5002b500005000050000500005000050000500005000050000500

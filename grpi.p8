pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- bouncy ball demo
-- by zep
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
tick = 0
size  = 10
floor_y = 100

-- starting velocity
velx = rnd(6)-3
vely = rnd(6)-3

function distance_sort( a,b ) 
      pup = vadd(player, {x=0,y=-5})
      return distance(a,pup) < distance(b,pup)
end


function _init()
      player.x = 50
      player.y = 50 

      for x=8,120,20 do
            for y=8,120,20 do
                  hold = {x=x+rnd(5), y=y+rnd(5), c=rnd(4)+3}
                  add(holds, hold)
            end
      end
end

function draw_hold(i,hold)
      color = i %4 + 10 
      if( i> 9 ) then
            color = 6
      end
      circfill(hold.x,hold.y,1.8,color)
end

function _draw()
 cls(7)
 
 print("press ❎ to bump",
       32,10, 6)
 
--  circfill(player.x,player.y,size,14)
 
 spr(1,player.x-4-velx, 
       player.y-4-vely)

 for i,h in pairs(holds) do draw_hold(i,h) end
 rectfill(0,floor_y,127,127,12)
end
-- function _update() 
--       table.sort( holds, distance_sort )

-- end
function _update60()

 -- move ball left/right

 if player.x+velx < 0+size or
    player.x+velx > 128-size
 then
  -- bounce on side!
  velx *= -1 
--   sfx(1)
 else
  player.x += velx
 end
 
 -- move ball up/down

 if player.y+vely < 0+size or
    player.y+vely > floor_y-size
 then
  -- bounce on floor/ceiling
  vely = vely * -0.9
--   sfx(0)
  
  
 else
  player.y += vely
 end
 
 -- gravity!
--  vely += 0.2
 
 -- press a button to ranomly
 -- choose a new velocity
 if (btnp(5)) then
--   velx = rnd(6)-3
--   vely = rnd(6)-8
     pull = norm(vsub(player,holds[1]))
     velx = pull.x
     vely = pull.y
--   sfx(2)
 end
 if tick==10 then
--   qsort( holds, distance_sort )
 end
 tick = (tick+1) %11

end

__gfx__
0000000000f00f00000f00f000ffff00002227000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ffff00000ffff0001ff100022222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700001f1f000001f1f000ffff0002ffff200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000ffff00000ffff0f222222f025ff5200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000022000000022000022220002ffff200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000f22200000f2220000400400222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000200000000200000400400022222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000f00000000f000000f00f00020000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000300000f01112051180311e021280113a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001a76011750247300070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
000400000c47011470164600f460164501b44013430164201b420184201d4202241027410164000c4000c4000f40013400114000c4000f4000f4000c400004000040000400004000040000400004000040000400
000400000c5700c5501154018530165201f5101d50018500185001f500225001d5001f500225002b5002250029500245002450029500275002b5002b500005000050000500005000050000500005000050000500

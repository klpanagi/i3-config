
--[[ RINGS with SECTORS widget
	v1.0 by wlourf (08.08.2010)
	this widget draws a ring with differents effects 
	http://u-scripts.blogspot.com/2010/08/rings-sectors-widgets.html
	
To call the script in a conky, use, before TEXT
	lua_load /path/to/the/script/rings.lua
	lua_draw_hook_pre main_rings
and add one line (blank or not) after TEXT


Parameters are :
3 parameters are mandatory
name		- the name of the conky variable to display,
			  for example for {$cpu cpu0}, just write name="cpu"
arg			- the argument of the above variable,
			  for example for {$cpu cpu0}, just write arg="cpu0"
		  	  arg can be a numerical value if name=""
max			- the maximum value the above variable can reach,
			  for example for {$cpu cpu0}, just write max=100
	
Optional parameters:
xc,yc		- coordinates of the center of the ring,
			  default = middle of the conky window
radius		- external radius of the ring, in pixels,
			  default = quarter of the width of the conky window
thickness	- thickness of the ring, in pixels, default = 10 pixels
start_angle	- starting angle of the ring, in degrees, value can be negative,
			  default = 0 degree
end_angle	- ending angle of the ring, in degrees,
			  value must be greater than start_angle, default = 360 degrees
sectors		- number of sectors in the ring, default = 10
gap_sectors - gap between two sectors, in pixels, default = 1 pixel
cap			- the way to close a sector, available values are
				"p" for parallel , default value 
				"r" for radial (follow the radius)
inverse_arc	- if set to true, arc will be anticlockwise, default=false
border_size	- size of the border, in pixels, default = 0 pixel i.e. no border
fill_sector	- if set to true, each sector will be completely filled,
			  default=false, this parameter is inoperate if sectors=1
background	- if set to false, background will not be drawn, default=true
foreground	- if set to false, foreground will not be drawn, default=true

Colours tables below are defined into braces :
{position in the gradient (0 to 1), colour in hexadecimal, alpha (0 to 1)}
example for a single colour table : 
{{0,0xFFAA00,1}} position parameter doesn't matter
example for a two-colours table : 
{{0,0xFFAA00,1},{1,0x00AA00,1}} or {{0.5,0xFFAA00,1},{1,0x00AA00,1}}
example for a three-colours table : 
{{0,0xFFAA00,1},{0.5,0xFF0000,1},{1,0x00AA00,1}}

bg_colour1	- colour table for background,
			  default = {{0,0x00ffff,0.1},{0.5,0x00FFFF,0.5},{1,0x00FFFF,0.1}}
fg_colour1	- colour table for foreground,
			  default = {{0,0x00FF00,0.1},{0.5,0x00FF00,1},{1,0x00FF00,0.1}}
bd_colour1	- colour table for border,
			  default = {{0,0xFFFF00,0.5},{0.5,0xFFFF00,1},{1,0xFFFF00,0.5}}			  

Seconds tables for radials gradients :
bg_colour2	- second colour table for background, default = no second colour
fg_colour2	- second colour table for foreground, default = no second colour
bd_colour2	- second colour table for border, default = no second colour

v1.0 (08 Aug. 2010) original release

]]

require 'cairo'
function set_settings()
mod_settings={

	{--Primer anillo. Temperatura CPU
	xc=65,
	yc=65,
	int_radius=43,
	radius=53,
	--here we don't draw a full circle
	first_angle=17,	--default=0
	last_angle=164,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${execi 4 sensors | grep -A 0 'temp2' | cut -c15-18}")),	
	--maximum value of the ring
	maxValue = 100,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},

	{--Primer anillo. Temperatura CPU
	xc=65,
	yc=65,
	int_radius=43,
	radius=53,
	--here we don't draw a full circle
	first_angle=197,	--default=0
	last_angle=343,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${execi 4 sensors | grep -A 0 'temp2' | cut -c15-18}")),	
	--maximum value of the ring
	maxValue = 100,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},
	
	{--Primer anillo-interno. Frecuencia CPU
	xc=65,
	yc=65,
	int_radius=24,
	radius=39,
	--here we don't draw a full circle
	first_angle=39,	--default=0
	last_angle=321,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${freq_g 1}")),
	
        --maximum value of the ring
	maxValue = 3,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},


-----------------------------------------------------------------------------------------------------
	{--Segundo anillo. Memoria RAM
	xc=215,
	yc=65,
	int_radius=43,
	radius=53,
	--here we don't draw a full circle
	first_angle=18,	--default=0
	last_angle=164,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${memperc}")),	
	--maximum value of the ring
	maxValue = 100,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,10},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},	

	{--Segundo anillo. Memoria RAM
	xc=215,
	yc=65,
	int_radius=43,
	radius=53,
	--here we don't draw a full circle
	first_angle=197,	--default=0
	last_angle=342,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${memperc}")),	
	--maximum value of the ring
	maxValue = 100,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,10},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},	
	
	{--Segundo anillo-interno. Memoria SWAP
	xc=215,
	yc=65,
	int_radius=24,
	radius=39,
	--here we don't draw a full circle
	first_angle=39,	--default=0
	last_angle=321,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${swapperc}")),
	
        --maximum value of the ring
	maxValue = 100,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},
	
-----------------------------------------------------------------------------------------------------------------------------------------	
	{--Tercer anillo. Temperatura NVIDIA
	xc=365,
	yc=65,
	int_radius=43,
	radius=53,
	--here we don't draw a full circle
	first_angle=17,	--default=0
	last_angle=164,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${nvidia temp}")),	
	--maximum value of the ring
	maxValue = 100,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},
	
        	{--Tercer anillo. Temperatura NVIDIA
	xc=365,
	yc=65,
	int_radius=43,
	radius=53,
	--here we don't draw a full circle
	first_angle=197,	--default=0
	last_angle=343,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${nvidia temp}")),	
	--maximum value of the ring
	maxValue = 100,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},

	{--Tercer anillo-interno. Frecuencia NVIDIA
	xc=365,
	yc=65,
	int_radius=24,
	radius=39,
	--here we don't draw a full circle
	first_angle=39,	--default=0
	last_angle=321,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${nvidia gpufreq}")),
	
        --maximum value of the ring
	maxValue = 600,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	{--Cuarto anillo. Velocidad de bajada
	xc=515,
	yc=65,
	int_radius=43,
	radius=53,
	--here we don't draw a full circle
	first_angle=17,	--default=0
	last_angle=164,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${downspeedf}")),	
	--maximum value of the ring
	maxValue = 250,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},

       {--Cuarto anillo. Velocidad de bajada
	xc=515,
	yc=65,
	int_radius=43,
	radius=53,
	--here we don't draw a full circle
	first_angle=196,	--default=0
	last_angle=343,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${downspeedf}")),	
	--maximum value of the ring
	maxValue = 250,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,5},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},
	
	{--Cuarto anillo-interno. Velocidad de subida
	xc=515,
	yc=65,
	int_radius=26,
	radius=39,
	--here we don't draw a full circle
	first_angle=39,	--default=0
	last_angle=320,	 	--default=360
	gradient_effect=true,
	tablebg = {{0x000000,1}},
	
	--theses parameters are for this mod only
	--nb of portions (>15 or effect won't be nice)
	nbPortions = 50,
	--value to display
	value = tonumber(conky_parse("${upspeedf}")),
	
        --maximum value of the ring
	maxValue = 100,
	--space between two portions, don't push too far, but it accepts negatives values
	--no space beetwwen portion here
	delta=1,
	--color at beginning red, green, blue ,alpha
	rgba0 = {125,0,0,0},
	--color at the end : red, green, blue ,alpha
	rgba1 = {0,255,0,25},
	--fillPortion : if true, draw only full portions
	fillPortion=false,},	
}

--END OF PARAMETERS HERE, at line 1101, there is a script to display text

end

function create_pie_settings(tt)
	--default values, just in case
	--theses one are needed to compute the portions used in the table pie_chart
	if tt.first_angle==nil then tt.first_angle=0 end
	if tt.last_angle==nil then tt.last_angle=0 end
	if tt.xc==nil then tt.xc=conky_window.width/2 end
	if tt.yc==nil then tt.yc=conky_window.height/2 end	
    if tt.int_radius ==nil then tt.int_radius =conky_window.width/6 end
    if tt.radius ==nil then tt.radius =conky_window.width/4 end
    if tt.gradient_effect==nil then tt.gradient_effect=true end
	if tt.tablebg==nil then tt.tablebg={{0xFFFFFF,0.5}} end
	
	--compute
	local deltaR = (tt.rgba1[1]-tt.rgba0[1])/tt.nbPortions
	local deltaG = (tt.rgba1[2]-tt.rgba0[2])/tt.nbPortions
	local deltaB = (tt.rgba1[3]-tt.rgba0[3])/tt.nbPortions
	local deltaA = (tt.rgba1[4]-tt.rgba0[4])/tt.nbPortions
	local portion = tt.maxValue/tt.nbPortions
	local anglePortion=(tt.last_angle-tt.first_angle)/tt.nbPortions	


	--create the pie_settings table
	for i = 1,tt.nbPortions do
		--compute the values for a block i
		local value2=0
		if tt.value== nil then tt.value=0 end
		if tt.value<i*portion and tt.value>(i-1)*portion then 
			if tt.fillPortion then
				value2=1
			else
				value2 = (tt.value-(i-1)*portion)/portion
			end
		end
		if tt.value>=i*portion then value2 = 1 end  

		--create the table
		local t={}
		table.insert(pie_settings,t)
		pie_settings[i].tableV={
            	--elements in the table
            	--{"label","conky variable","conky arg","max value", "unit"}
                {"","",value2,1,""},
                }
        pie_settings[i].int_radius = tt.int_radius
        pie_settings[i].radius = tt.radius
        pie_settings[i].gradient_effect=tt.gradient_effect
        pie_settings[i].first_angle	= tt.first_angle+(i-1)*anglePortion
        pie_settings[i].last_angle = tt.first_angle+i*anglePortion--1
        pie_settings[i].show_text = false
		local alpha=((pie_settings[i].last_angle+pie_settings[i].first_angle)/2)*math.pi/180

        pie_settings[i].xc = tt.xc+tt.delta*math.sin(alpha)
        pie_settings[i].yc = tt.yc-tt.delta*math.cos(alpha)
        local color  = string.format("0x" .. Dec2Hex(tt.rgba0[1]+deltaR*i) .. Dec2Hex(tt.rgba0[2]+deltaG*i) .. Dec2Hex(tt.rgba0[3]+deltaB*i) )
        pie_settings[i].tablefg={
                {color,tt.rgba0[4]+deltaA*i},
                }
        pie_settings[i].tablebg = tt.tablebg
		
	end
end

function Dec2Hex(nValue)
	--http://www.indigorose.com/forums/threads/10192-Convert-Hexadecimal-to-Decimal
	if type(nValue) == "string" then
		nValue = String.ToNumber(nValue);
	end
	nHexVal = string.format("%X", nValue);  -- %X returns uppercase hex, %x gives lowercase letters
	local prefix=""
	if #nHexVal==1 then  prefix="0" end
	sHexVal = prefix..nHexVal.."";
	return sHexVal;
end


--main function
function conky_main_pie()
    if conky_window==nil then return end

	pie_settings={}
	set_settings()		

    local w=conky_window.width
    local h=conky_window.height
    local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
    cr=cairo_create(cs)

    if tonumber(conky_parse('${updates}'))>5 then
		--mod here : create multiple pie_settngs tables
		for m in pairs(mod_settings) do
			
			create_pie_settings(mod_settings[m])
			for i in pairs(pie_settings) do
				--print ("i",i)
				draw_pie(pie_settings[i])
			end
			--reset pie_settings
			pie_settings={}
		end
    end

	for i in pairs(pie_settings) do
		--print ("i",i)
		draw_pie(pie_settings[i])
	end
	
	--draw separator
	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr,0.5,0.5,0.5,0.5)
	cairo_move_to(cr,0,170)
	cairo_line_to(cr,conky_window.width,170)
	cairo_stroke(cr)
	
	--end of mod for texts
    cairo_destroy(cr)
end



function string:split(delimiter)
--source for the split function : http://www.wellho.net/resources/ex.php4?item=u108/split
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end


function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function size_to_text(size,nb_dec)
    local txt_v
    if nb_dec<0 then nb_dec=0 end
    size = tonumber(size)
    if size>1024*1024*1024 then
        txt_v=string.format("%."..nb_dec.."f Go",size/1024/1024/1024)
    elseif size>1024*1024 then 
        txt_v=string.format("%."..nb_dec.."f Mo",size/1024/1024)
    elseif size>1024 then 
        txt_v=string.format("%."..nb_dec.."f Ko",size/1024)
    else
        txt_v=string.format("%."..nb_dec.."f o",size)
    end
    return txt_v
end



function read_df(show_media,sort_table)
    --read output of command df and return arrays of value for files systems
    --reurn array of table {file syst, "", occupied space , total space , convert to G, M, K ...}
    
    local f = io.popen("df")

    local results={}

    while true do
         local line = f:read("*l")
         if line == nil then break end
         while string.match(line,"  ") do
             line=string.gsub(line,"  "," ")
         end
        local arr_l=string.split(line," ")
        local match = string.match(arr_l[1],"/")
        
        if string.match(arr_l[1],"/") then
            if not show_media then arr_l[6]=string.gsub(arr_l[6],"/media/","",1) end
            table.insert(results,{arr_l[6],"",(arr_l[2]-arr_l[4])*1024,arr_l[2]*1024,true})
        end
    end

    f:close()
    
    if sort_table then
        --how to sort table into table?
        local flagS=true
        while flagS do
            for k=2, #results do 
                flagS=false
                if tonumber(results[1][3])>tonumber(results[2][3]) then
                    local tmpV = results[1]
                    results[1] = results[2]
                    results[2] = tmpV
                    flagS=true
                end
                if tonumber(results[k][3])<tonumber(results[k-1][3]) then
                    local tmpV = results[k-1]
                    results[k-1] = results[k]
                    results[k] = tmpV
                    flagS=true
                end
            end
        end
    end
    
    return results --array {file syst, occupied space , total space }
end


function draw_pie(t)
    if t.tableV==nil then 
        print ("No input values ...") 
        return
    else
        tableV=t.tableV
    end

    if t.xc==nil then t.xc=conky_window.width/2 end
    if t.yc==nil then t.yc=conky_window.height/2 end
    if t.int_radius ==nil then t.int_radius =conky_window.width/6 end
    if t.radius ==nil then t.radius =conky_window.width/4 end
    if t.first_angle==nil then t.first_angle =0 end
    if t.last_angle==nil then t.last_angle=360 end
    if t.proportional==nil then t.proportional=false end
    if t.tablebg==nil then t.tablebg={{0xFFFFFF,0.5},{0xFFFFFF,0.5}} end
    if t.tablefg==nil then t.tablefg={{0xFF0000,1},{0x00FF00,1}} end
    if t.gradient_effect==nil then t.gradient_effect=true end
    if t.show_text==nil then t.show_text=true end
    if t.line_lgth==nil then t.line_lgth=t.int_radius end
    if t.line_space==nil then t.line_space=10 end
    if t.line_width==nil then t.line_width=1 end
    if t.extend_line==nil then t.extend_line=true end
    if t.txt_font==nil then t.txt_font="Japan" end
    if t.font_size==nil then t.font_size=12 end
    --if t.font_color==nil then t.font_color=0xFFFFFF end
    if t.font_alpha==nil then t.font_alpha = 1 end
    if t.txt_offset==nil then t.txt_offset = 1 end
    if t.txt_format==nil then t.txt_format = "&l : &v" end
    if t.nb_decimals==nil then t.nb_decimals=1 end
    if t.type_arc==nil then t.type_arc="l" end
    if t.inverse_l_arc==nil then t.inverse_l_arc=false end
    
    local function draw_sector(tablecolor,colorindex,pc,lastAngle,angle,radius,int_radius,gradient_effect,type_arc,inverse_l_arc)
        --draw a portion of arc
        radiuspc=(radius-int_radius)*pc+int_radius
        angle0=lastAngle
        val=1
        if type_arc=="l" then 
            val=pc;radiuspc=radius
        end
        angle1=angle*val

        if type_arc=="l" and inverse_l_arc then 

            cairo_save(cr)
    
            cairo_rotate(cr,angle0+angle)
            
            if gradient_effect then        
                local pat = cairo_pattern_create_radial (0,0, int_radius, 0,0,radius)
                cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(tablecolor[colorindex][1],0))
                cairo_pattern_add_color_stop_rgba (pat, 0.5, rgb_to_r_g_b(tablecolor[colorindex][1],tablecolor[colorindex][2]))
                cairo_pattern_add_color_stop_rgba (pat, 1, rgb_to_r_g_b(tablecolor[colorindex][1],0))
                cairo_set_source (cr, pat)
                cairo_pattern_destroy(pat)
            else
                cairo_set_source_rgba(cr,rgb_to_r_g_b(tablecolor[colorindex][1],tablecolor[colorindex][2]))
            end
            cairo_move_to(cr,0,-int_radius)
            cairo_line_to(cr,0,-radiuspc)
            cairo_rotate(cr,-math.pi/2)
        
            cairo_arc_negative(cr,0,0,radiuspc,0,-angle1)
            cairo_rotate(cr,-math.pi/2-angle1)
            cairo_line_to(cr,0,int_radius)
            cairo_rotate(cr,math.pi/2)
            cairo_arc(cr,0,0,int_radius,0,angle1)
            cairo_close_path (cr);
            cairo_fill(cr)

            cairo_restore(cr)
        else
        
            cairo_save(cr)
    
            cairo_rotate(cr,angle0)

            if gradient_effect then        
                local pat = cairo_pattern_create_radial (0,0, int_radius, 0,0,radius)
                cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(tablecolor[colorindex][1],0))
                cairo_pattern_add_color_stop_rgba (pat, 0.5, rgb_to_r_g_b(tablecolor[colorindex][1],tablecolor[colorindex][2]))
                cairo_pattern_add_color_stop_rgba (pat, 1, rgb_to_r_g_b(tablecolor[colorindex][1],0))
                cairo_set_source (cr, pat)
                cairo_pattern_destroy(pat)
            else
                cairo_set_source_rgba(cr,rgb_to_r_g_b(tablecolor[colorindex][1],tablecolor[colorindex][2]))
            end
            cairo_move_to(cr,0,-int_radius)
            cairo_line_to(cr,0,-radiuspc)
            cairo_rotate(cr,-math.pi/2)
        
            cairo_arc(cr,0,0,radiuspc,0,angle1)
            cairo_rotate(cr,angle1-math.pi/2)
            cairo_line_to(cr,0,int_radius)
            cairo_rotate(cr,math.pi/2)
            cairo_arc_negative(cr,0,0,int_radius,0,-angle1)
            cairo_close_path (cr);
            cairo_fill(cr)

            cairo_restore(cr)
        end
        

    end

    function draw_lines(idx,nbArcs,angle,table_colors,idx_color,adjust,line_lgth,length_txt,txt_offset,radius,line_width,line_space,font_color,font_alpha)
        --draw lines
        
        local x0=radiuspc*math.sin(lastAngle+angle/2)
        local y0=-radiuspc*math.cos(lastAngle+angle/2)
        local x1=1.2*radius*math.sin(lastAngle+angle/2)
        local y1=-1.2*radius*math.cos(lastAngle+angle/2)

        local x2=line_lgth
        local y2=y1
        local x3,y3=nil,nil
        if x0<=0 then
            x2=-x2
        end

        if adjust then
            if x0>0 and x2-x1<length_txt then x2=x1+length_txt end
            if x0<=0 and x1-x2<length_txt then x2=x1-length_txt end            
        end 
        
        if idx>1 then
            local dY = math.abs(y2-lastPt2[2])
            if dY < line_space and lastPt2[1]*x1>0 then
                if x0>0 then
                    y2 = line_space+lastPt2[2]
                else
                    y2 = -line_space+lastPt2[2]
                end
                if (y2>y1 and x0>0) or (y2<y1 and x0<0 )  then
                    --x3 is for vertical segment if needed
                    x3,y3=x2,y2                    
                    x2=x1
                    if x3>0 then x3=x3+txt_offset end
                else
                    Z=intercept({x0,y0},{x1,y1},{0,y2},{1,y2})
                    x1,y1=Z[1],Z[2]
                end
            end
        else
            --remind x2,y2 of first value
            x2first,y2first = x2,y2
        end

        if font_color==nil then
            cairo_set_source_rgba(cr,rgb_to_r_g_b(table_colors[idx_color][1],table_colors[idx_color][2]))
        else
            local pat = cairo_pattern_create_linear (x2,y2, x0,y0)
            cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(font_color,font_alpha))
            cairo_pattern_add_color_stop_rgba (pat, 1, rgb_to_r_g_b(table_colors[idx_color][1],table_colors[idx_color][2]))
            cairo_set_source (cr, pat)
            cairo_pattern_destroy(pat)
        end

        
        cairo_move_to(cr,x0,y0)
        cairo_line_to(cr,x1,y1)
        cairo_line_to(cr,x2,y2)
        if x3~=nil then 
            cairo_line_to(cr,x3,y3)
            x2,y2=x3,y3    
        end
        cairo_set_line_width(cr,line_width)
        cairo_stroke(cr)
        --lastAngle=lastAngle+angle
        return {x2,y2}
    end
    
    function intercept(p11,p12,p21,p22)
        --calculate interscetion of two lines and return coordinates
        a1=(p12[2]-p11[2])/(p12[1]-p11[1])

        a2=(p22[2]-p21[2])/(p22[1]-p21[1])

        b1=p11[2]-a1*p11[1]

        b2=p21[2]-a2*p21[1]

        X=(b2-b1)/(a1-a2)

        Y=a1*X+b1
        return {X,Y}
    end

    --some checks
    if t.first_angle>=t.last_angle then
        local tmp_angle=t.last_angle
        --t.last_angle=t.first_angle
        --t.first_angle=tmp_angle
        print ("inversed angles")
    end

    if t.last_angle-t.first_angle>360 and t.first_angle>0 then
        t.last_angle=360+t.first_angle
        print ("reduce angles")
    end
    
    if t.last_angle+t.first_angle>360 and t.first_angle<=0 then
        t.last_angle=360+t.first_angle
        print ("reduce angles")
    end
    
    if t.int_radius<0 then t.int_radius =0 end
    if t.int_radius>t.radius then
        local tmp_radius=t.radius
        t.radius=t.int_radius
        t.int_radius=tmp_radius
        print ("inversed angles")
    end
    if t.int_radius==t.radius then
        t.int_radius=0
       -- print ("int radius set to 0")
    end    
    --end of checks
    
    cairo_save(cr)
    cairo_translate(cr,t.xc,t.yc)
    cairo_set_line_join (cr, CAIRO_LINE_JOIN_ROUND)
    cairo_set_line_cap (cr, CAIRO_LINE_CAP_ROUND)
    
    local nbArcs=#tableV
    local anglefull= (t.last_angle-t.first_angle)*math.pi/180
    local fullsize = 0
    for i= 1,nbArcs do
        fullsize=fullsize+tableV[i][4]
    end

    local cb,cf,angle=0,0,anglefull/nbArcs
    lastAngle=t.first_angle*math.pi/180
    lastPt2={nil,nil}

    for i =1, nbArcs do
        if t.proportional then
            angle=tableV[i][4]/fullsize*anglefull
        end
        --set colours
        cb,cf=cb+1,cf+1
        if cb>#t.tablebg then cb=1 end
        if cf>#t.tablefg then cf=1 end
        
        if tableV[i][2]~="" then
            str=string.format('${%s %s}',tableV[i][2],tableV[i][3])
        else
            str = tableV[i][3]
        end
        str=conky_parse(str)
        value=tonumber(str)
        if value==nil then value=0 end
    
        --draw sectors
        draw_sector(t.tablebg,cb,1,lastAngle,angle,t.radius,t.int_radius,t.gradient_effect,t.type_arc,t.inverse_l_arc)
        --print (t.tablefg,cf,tableV[i][2],tableV[i][3],lastAngle,angle,t.radius,t.int_radius)
        --print (cf,tableV[i],tableV[i][2],tableV[i][3])
        draw_sector(t.tablefg,cf,value/tableV[i][4],lastAngle,angle,t.radius,t.int_radius,t.gradient_effect,t.type_arc,t.inverse_l_arc)

        if t.show_text then
            --draw text
            local txt_l   = tableV[i][1]
            local txt_opc = round(100*value/tableV[i][4],t.nb_decimals).."%%"
            local txt_fpc = round(100*(tableV[i][4]-value/tableV[i][4]),t.nb_decimals).."%%"
            local txt_ov,txt_fv,txt_max
            if tableV[i][5]==true then
                txt_ov  = size_to_text(value,t.nb_decimals)
                txt_fv  = size_to_text(tableV[i][4]-value,t.nb_decimals)
                txt_max = size_to_text(tableV[i][4],t.nb_decimals)
            else
                if tableV[i][5]=="%" then tableV[i][5]="%%" end
                txt_ov=string.format("%."..t.nb_decimals.."f ",value)..tableV[i][5]
                txt_fv=string.format("%."..t.nb_decimals.."f",tableV[i][4]-value)..tableV[i][5]
                txt_max=string.format("%."..t.nb_decimals.."f",tableV[i][4])..tableV[i][5]
            end
            txt_pc = string.format("%."..t.nb_decimals.."f",100*tableV[i][4]/fullsize).."%%"
            local txt_out = t.txt_format
            txt_out = string.gsub(txt_out,"&l",txt_l)  --label
            txt_out = string.gsub(txt_out,"&o",txt_opc)--occ. %
            txt_out = string.gsub(txt_out,"&f",txt_fpc)--free %
            txt_out = string.gsub(txt_out,"&v",txt_ov) --occ. value
            txt_out = string.gsub(txt_out,"&n",txt_fv) --free value
            txt_out = string.gsub(txt_out,"&m",txt_max)--max
            txt_out = string.gsub(txt_out,"&p",txt_pc)--percent
            
            local te=cairo_text_extents_t:create()
            cairo_set_font_size(cr,t.font_size)
            cairo_select_font_face(cr, t.txt_font, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
            cairo_text_extents (cr,txt_out,te)

            --draw lines 
            lastPt2=draw_lines(i,nbArcs,angle,t.tablefg,cf,t.extend_line,t.line_lgth+t.radius, 
                    te.width + te.x_bearing,t.txt_offset,t.radius,t.line_width,t.line_space,t.font_color,t.font_alpha)    
        
            local xA=lastPt2[1]
            local yA=lastPt2[2]-t.line_width-t.txt_offset
            if xA>0 then xA = xA-(te.width + te.x_bearing) end
            cairo_move_to(cr,xA,yA)
            cairo_show_text(cr,txt_out)
        end
        
        lastAngle=lastAngle+angle
    end
    cairo_restore(cr)
end


--[[END OF PIE CHART WIDGET]]

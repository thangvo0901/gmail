--require ("icon")
require ("/data/en_name")
function AppOpen(a) 
	local times = os.time()
	
	appKill(a);usleep(1000000);
	appRun(a);
	
	while (os.time() - times <= 6) do
	
		local state = appState(a);
		if string.format(state) == "ACTIVATED"
		then
			toast("Open ["..a.."] Done",1)
			break
		else
			appRun(a);
			usleep(1000000)
		end
	end
	return false
end

function AppKill(a)
	local times = os.time()
	
	appKill(a);
	while (os.time() - times <= 5) do
		local state = appState(a);
		
		if string.format(state) ~= "NOT RUNNING"
			then
			appKill(a);
		else
			toast("Kill ["..a.."] Done",1)
			break
		end
	end
	return false
end

function tap(x, y)
	local id = math.random(0,2)
	local speed = math.random(12000,32000);
    touchDown(id, x, y);
    usleep(speed)
    touchUp(id, x, y);
	log(string.format("\n Click tại toạ độ: x:%f, y:%f \n Tốc độ: speed:%f \n ID Click: id:%f ", x, y, speed, id));
end

function tapRandom(x, y)
    if x > 10 and y > 10 then
        x = math.random(x - 10, x + 10)
        y = math.random(y - 10, y + 10)
    end
tap(x, y)
end

function find_Colors(t, icon,Check) --t time tìm kiếm |  icon
    local times = os.time()
    while (true) do
        local result  = findColors(icon, 2, nil)
		for i, v in pairs(result) do
			if(Check == 1)
				then
				log(string.format("Tìm Thấy tại toạ độ: x:%f, y:%f", v[1], v[2]));
				return true
			end
			tapRandom(v[1], v[2])
			usleep(math.random(1000000,1500000))
			return true
		end
        if os.time() - times >= t then
			log(string.format("Ko Tìm Thấy \n")..table.tostring(icon));
            return false
        end
    end
	
end

function swipe(action, speed, stop) --action: Số lần , speed: tốc độ[10-100], stop: dừng
    for i = 1, action do
        id = math.random(1, 3)
        local x = math.random(350, 450)
        local ya = math.random(950, 1050)
        local yb = math.random(300, 400)
        local timeus = math.random(14000, 16000)

        if (speed == nil) then
            speed = 40
        end

        touchDown(id, x, ya)
        usleep(timeus)

        repeat
            ya = ya - math.random(speed - 1, speed + 1)
            touchMove(id, x, ya)
            usleep(timeus)
        until (ya <= yb)

        touchUp(id, x, ya)
        usleep(timeus)
        if (stop == 1) then
            touchDown(id, x, ya)
            usleep(math.random(1000, 1100))
            touchUp(id, x, ya)
            usleep(math.random(2200000, 2500000))
        end
        usleep(math.random(2200000, 2500000))
    end
end

function writeFile(path,text,mode)
    local file = io.open(path,mode);--a:append mode, 
    if file then
        file:write(text);
        file:close();
    end
end

function CreateFolder(namefile) -- Kiểm tra chưa có Folder thì tạo
    require "lfs"
    local path = "/private/var/mobile/Library/AutoTouch/Scripts/"
    local err, ok, code = os.rename(path .. namefile, path .. namefile)
    if not ok then
        if code == 13 then
            return true
        end
    end
    if err then
        return
    else
        lfs.mkdir(path .. namefile)
        toast("Đã tạo thư mục " .. namefile)
    end
end

function Xoainfo(act,note) --act == "Reset","Save"
	local icon_Success = {{16382456,0,0}, {16382199,-6,6}, {16645629,13,12}, {16447993,13,25}, {15526889,44,-18}, {15592682,50,-11}}
	local icon_Done = {{9353687,0,0}, {6982304,21,0}, {8299711,21,23}, {8761034,0,23}}
	local times = os.time()
	
	if(act == "Reset")
		then
		io.popen("uiopen 'XoaInfo://Reset'")
	end
	if(act == "Save")
		then 
		io.popen("uiopen 'XoaInfo://Reset?RRS&ghichu="..note.."'")
	end

	while(true)do
		
		if(find_Colors(1, icon_Success,1) == true or find_Colors(1, icon_Done,1) == true)
			then
			toast("[Xoainfo]......["..act.."]......["..os.time() - times.." Giây]",6);
			usleep(6000000);
			break
		end
		if(os.time() - times >= 120)
			then
			log("Lỗi không có mạng !!!");
			alert("Lỗi không có mạng !!!");
			stop();
		end
	end
	
end

function CheckIp()
	f = assert(io.popen("curl ident.me"))
	ip = f:read("all")
	if (string.find(ip, ".") == nil and string.find(ip, ":") == nil) then
		repeat
			toast("Đang Check IP")
			f = assert(io.popen("curl ident.me"))
			ip = f:read("all")
			usleep(500000)
		until(string.find(ip, ".") ~= nil or string.find(ip, ":") ~= nil)
	end
	alert(ip)
	return true
end

function get_randomText(length,mode) --Mode1: chữ thường+hoa+số , Mode2: Chữ thường+hoa+số+Kýtự
    math.randomseed(os.time())
    local index, pw, rnd = 0, ""
		local chars = {
        "abcdefghijklmnopqrstuvwxyz",
        "0123456789",
    	}
	if(mode == 1)
		then
		local chars = {
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "abcdefghijklmnopqrstuvwxyz",
        "0123456789"
    	}
	end
	if(mode == 2)
		then
		local chars = {
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "abcdefghijklmnopqrstuvwxyz",
        "0123456789",
		"!\"#$%&'()*+,-./:;<=>?@[]^_{|}~"
    	}
	end
    repeat
        index = index + 1
        rnd = math.random(chars[index]:len())
        if math.random(2) == 1 then
            pw = pw .. chars[index]:sub(rnd, rnd)
        else
            pw = chars[index]:sub(rnd, rnd) .. pw
        end
        index = index % #chars
    until pw:len() >= length
    return pw
end

--Return
function btnReturn()
	local icon_Return = {{5198424,0,0}, {9738915,3,-6}, {6185576,0,-6}, {3290424,0,8}, {8751763,-5,8}, {9212315,-9,10}, {5264216,-11,-6}, {5132630,-11,5}, {10265259,-42,-7}, {7106935,-47,-2}, {2039842,-50,-6}, {3092788,-48,10}, {8093831,-46,-6}, {5725024,-42,-4}, {1710877,20,-6}, {10133675,27,-7}, {7040886,32,-4}, {6777458,30,10}, {5066837,30,-1}, {7435645,22,0}, {6514542,27,-4}, {3619132,23,-3}}
	find_Colors(5, icon_Return);
	usleep(math.random(100000,300000));
end

function Taping(a, text) --text ="number" bàn phím số "mail" mail tren safari
    function Tappping(kt) ---Hàm tap bàn phím
        function tapp(x, y)
            local id = math.random(0, 3)
            local x = math.random(x - 5, x + 5)
            local y = math.random(y - 5, y + 5)
            touchDown(id, x, y)
            usleep(math.random(10000, 32000))
            touchUp(id, x, y)
            usleep(math.random(50000, 100000))
        end
        if (text == "number") then
            if (kt == "1") then
                tapp(133, 952) ---1
            end
            if (kt == "2") then
                tapp(377, 954) ---2
            end
            if (kt == "3") then
                tapp(625, 957) ---3
            end
            if (kt == "4") then
                tapp(135, 1059) ---4
            end
            if (kt == "5") then
                tapp(377, 1065) ---5
            end
            if (kt == "6") then
                tapp(628, 1068) ---6
            end
            if (kt == "7") then
                tapp(127, 1170) ---7
            end
            if (kt == "8") then
                tapp(377, 1172) ---8
            end
            if (kt == "9") then
                tapp(625, 1172) ---9
            end
            if (kt == "0") then
                tapp(373, 1276) ---0
            end
        else
            if (kt == "q") then
                tapp(40, 960) ---q
            end
            if (kt == "w") then
                tapp(114, 960) ---w
            end
            if (kt == "e") then
                tapp(190, 958) ---e
            end
            if (kt == "r") then
                tapp(264, 960) ---r
            end
            if (kt == "t") then
                tapp(337, 960) ---t
            end
            if (kt == "y") then
                tapp(410, 960) ---y
            end
            if (kt == "u") then
                tapp(488, 960) ---u
            end
            if (kt == "i") then
                tapp(560, 960) ---i
            end
            if (kt == "o") then
                tapp(639, 960) ---o
            end
            if (kt == "p") then
                tapp(711, 960) ---p
            end
            if (kt == "a") then
                tapp(74, 1072) ---a
            end
            if (kt == "s") then
                tapp(146, 1072) ---s
            end
            if (kt == "d") then
                tapp(222, 1072) ---d
            end
            if (kt == "f") then
                tapp(294, 1072) ---f
            end
            if (kt == "g") then
                tapp(371, 1066) ---g
            end
            if (kt == "h") then
                tapp(450, 1067) ---h
            end
            if (kt == "j") then
                tapp(524, 1067) ---j
            end
            if (kt == "k") then
                tapp(600, 1068) ---k
            end
            if (kt == "l") then
                tapp(673, 1066) ---l
            end
            if (kt == "z") then
                tapp(151, 1176) ---z
            end
            if (kt == "x") then
                tapp(221, 1175) ---x
            end
            if (kt == "c") then
                tapp(301, 1177) ---c
            end
            if (kt == "v") then
                tapp(376, 1177) ---v
            end
            if (kt == "b") then
                tapp(449, 1177) ---b
            end
            if (kt == "n") then
                tapp(527, 1177) ---n
            end
            if (kt == "m") then
                tapp(599, 1177) ---m
            end
            if (kt == " ") then
                tapp(384, 1286) ---space
            end
            if (kt == "1") then
                tapp(52, 1283)
                -- change
                tapp(40, 960) ---1
                tapp(52, 1283)
            -- change
            end
            if (kt == "2") then
                tapp(52, 1283)
                -- change
                tapp(114, 960) ---2
                tapp(52, 1283)
            -- change
            end
            if (kt == "3") then
                tapp(52, 1283)
                -- change
                tapp(190, 958) ---3
                tapp(52, 1283)
            -- change
            end
            if (kt == "4") then
                tapp(52, 1283)
                -- change
                tapp(264, 960) ---4
                tapp(52, 1283)
            -- change
            end
            if (kt == "5") then
                tapp(52, 1283)
                -- change
                tapp(337, 960) ---5
                tapp(52, 1283)
            -- change
            end
            if (kt == "6") then
                tapp(52, 1283)
                -- change
                tapp(410, 960) ---6
                tapp(52, 1283)
            -- change
            end
            if (kt == "7") then
                tapp(52, 1283)
                -- change
                tapp(488, 960) ---7
                tapp(52, 1283)
            -- change
            end
            if (kt == "8") then
                tapp(52, 1283)
                -- change
                tapp(560, 960) ---8
                tapp(52, 1283)
            -- change
            end
            if (kt == "9") then
                tapp(52, 1283)
                -- change
                tapp(639, 960) ---9
                tapp(52, 1283)
            -- change
            end
            if (kt == "0") then
                tapp(52, 1283)
                -- change
                tapp(711, 960) ---0
                tapp(52, 1283)
            -- change
            end
            if (kt == "-") then
                tapp(52, 1283)
                -- change
                tapp(45, 1066) ---1
                tapp(52, 1283)
            -- change
            end
            if (kt == "/") then
                tapp(52, 1283)
                -- change
                tapp(115, 1072) ---/
                tapp(52, 1283)
            -- change
            end
            if (kt == ":") then
                tapp(52, 1283)
                -- change
                tapp(185, 1072) ---:
                tapp(52, 1283)
            -- change
            end
            if (kt == ";") then
                tapp(52, 1283)
                -- change
                tapp(259, 1072) ---;
                tapp(52, 1283)
            -- change
            end
            if (kt == "(") then
                tapp(52, 1283)
                -- change
                tapp(336, 1062) ---(
                tapp(52, 1283)
            -- change
            end
            if (kt == "&") then
                tapp(52, 1283)
                -- change
                tapp(563, 1068) ---&
                tapp(52, 1283)
            -- change
            end
            if (kt == "@") then
				if (text == "mail")
					then
					tapp(422, 1283);---@
				else
                tapp(52, 1283)
                tapp(639, 1068)
                tapp(52, 1283)
				end
            end
            if (kt == ".") then
				if (text == "mail")
					then
					tapp(515, 1287);---.
				else
                tapp(52, 1283)
                -- change
                tapp(161, 1181) ---
                tapp(52, 1283)
				end
            end
            if (kt == ",") then
                tapp(52, 1283)
                -- change
                tapp(272, 1170) ---
                tapp(52, 1283)
            -- change
            end
            if (kt == "?") then
                tapp(52, 1283)
                -- change
                tapp(371, 1175) ---
                tapp(52, 1283)
            -- change
            end

            if (kt == "!") then
                tapp(52, 1283)
                -- change
                tapp(483, 1174) ---
                tapp(52, 1283)
            -- change
            end
            if (kt == "Q") then
                tapp(49, 1177)
                -- change
                tapp(40, 960) ---q
            end
            if (kt == "W") then
                tapp(49, 1177)
                -- change
                tapp(114, 960) ---w
            end
            if (kt == "E") then
                tapp(49, 1177)
                -- change
                tapp(190, 958) ---e
            end
            if (kt == "R") then
                tapp(49, 1177)
                -- change
                tapp(264, 960) ---r
            end
            if (kt == "T") then
                tapp(49, 1177)
                -- change
                tapp(337, 960) ---t
            end
            if (kt == "Y") then
                tapp(49, 1177)
                -- change
                tapp(410, 960) ---y
            end
            if (kt == "U") then
                tapp(49, 1177)
                -- change
                tapp(488, 960) ---u
            end
            if (kt == "I") then
                tapp(49, 1177)
                -- change
                tapp(560, 960) ---i
            end
            if (kt == "O") then
                tapp(49, 1177)
                -- change
                tapp(639, 960) ---o
            end
            if (kt == "P") then
                tapp(49, 1177)
                -- change
                tapp(711, 960) ---p
            end
            if (kt == "A") then
                tapp(49, 1177)
                -- change
                tapp(74, 1072) ---a
            end
            if (kt == "S") then
                tapp(49, 1177)
                -- change
                tapp(146, 1072) ---s
            end
            if (kt == "D") then
                tapp(49, 1177)
                -- change
                tapp(222, 1072) ---d
            end
            if (kt == "F") then
                tapp(49, 1177)
                -- change
                tapp(294, 1072) ---f
            end
            if (kt == "G") then
                tapp(49, 1177)
                -- change
                tapp(371, 1066) ---g
            end
            if (kt == "H") then
                tapp(49, 1177)
                -- change
                tapp(450, 1067) ---h
            end
            if (kt == "J") then
                tapp(49, 1177)
                -- change
                tapp(524, 1067) ---j
            end
            if (kt == "K") then
                tapp(49, 1177)
                -- change
                tapp(600, 1068) ---k
            end
            if (kt == "L") then
                tapp(49, 1177)
                -- change
                tapp(673, 1066) ---l
            end
            if (kt == "Z") then
                tapp(49, 1177)
                -- change
                tapp(151, 1176) ---z
            end
            if (kt == "X") then
                tapp(49, 1177)
                -- change
                tapp(221, 1175) ---x
            end
            if (kt == "C") then
                tapp(49, 1177)
                -- change
                tapp(301, 1177) ---c
            end
            if (kt == "V") then
                tapp(49, 1177)
                -- change
                tapp(376, 1177) ---v
            end
            if (kt == "B") then
                tapp(49, 1177)
                -- change
                tapp(449, 1177) ---b
            end
            if (kt == "N") then
                tapp(49, 1177)
                -- change
                tapp(527, 1177) ---n
            end
            if (kt == "M") then
                tapp(49, 1177)
                -- change
                tapp(599, 1177) ---m
            end
        end
    end
    -------
    if (colorX == 0) then
        tap(49, 1177)
    end
    for i = 1, #a do
        kt1234 = string.sub(a, i, i)
        Tappping(kt1234)
        usleep(10000)
    end
end

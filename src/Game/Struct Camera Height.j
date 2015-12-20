// http://www.hiveworkshop.com/forums/jass-resources-412/system-getcamoffset-131434/
library GetCamOffset initializer cameramapInit
    globals
        private location cameramapLoc
        private real array camOffset[90][90]
        private real mapMinX
        private real mapMinY
        private real mapMaxX
        private real mapMaxY
    endglobals
   
    private function GetGridCamOffset takes integer ix, integer iy, integer offx, integer offy returns real
        local real r
        local integer ixl = ix-1
        local integer ixr = ix+1
        local integer iyd = iy-1
        local integer iyu = iy+1
        if ixl<0 then
            set ixl = 0
        endif
        if iyd<0 then
            set iyd = 0
        endif
        if ixr>256 then
            set ixr=256
        endif
        if iyu>256 then
            set iyu=256
        endif
        if offx>0 then
            if offy>0 then
                set r =   .089696*camOffset[ixl][iyu]+ .139657*camOffset[ix][iyu]+ .097349*camOffset[ixr][iyu]
                set r = r+.130989*camOffset[ixl][iy] + .099380*camOffset[ix][iy] + .139657*camOffset[ixr][iy]
                set r = r+.082587*camOffset[ixl][iyd]+ .130989*camOffset[ix][iyd]+ .089696*camOffset[ixr][iyd]
            elseif offy<0 then
                set r =   .082587*camOffset[ixl][iyu]+ .130989*camOffset[ix][iyu]+ .089696*camOffset[ixr][iyu]
                set r = r+.130989*camOffset[ixl][iy] + .099380*camOffset[ix][iy] + .139657*camOffset[ixr][iy]
                set r = r+.089696*camOffset[ixl][iyd]+ .139657*camOffset[ix][iyd]+ .097349*camOffset[ixr][iyd]
            else
                set r =   .084604*camOffset[ixl][iyu]+ .134226*camOffset[ix][iyu]+ .091913*camOffset[ixr][iyu]
                set r = r+.134017*camOffset[ixl][iy] + .101594*camOffset[ix][iy] + .142877*camOffset[ixr][iy]
                set r = r+.084604*camOffset[ixl][iyd]+ .134226*camOffset[ix][iyd]+ .091913*camOffset[ixr][iyd]
            endif
        elseif offx<0 then
            if offy>0 then
                set r =   .097349*camOffset[ixl][iyu]+ .139657*camOffset[ix][iyu]+ .089696*camOffset[ixr][iyu]
                set r = r+.139657*camOffset[ixl][iy] + .099380*camOffset[ix][iy] + .130989*camOffset[ixr][iy]
                set r = r+.089696*camOffset[ixl][iyd]+ .130989*camOffset[ix][iyd]+ .082587*camOffset[ixr][iyd]
            elseif offy<0 then
                set r =   .089696*camOffset[ixl][iyu]+ .130989*camOffset[ix][iyu]+ .082587*camOffset[ixr][iyu]
                set r = r+.139657*camOffset[ixl][iy] + .099380*camOffset[ix][iy] + .130989*camOffset[ixr][iy]
                set r = r+.097349*camOffset[ixl][iyd]+ .139657*camOffset[ix][iyd]+ .089696*camOffset[ixr][iyd]
            else
                set r =   .091913*camOffset[ixl][iyu]+ .134226*camOffset[ix][iyu]+ .084604*camOffset[ixr][iyu]
                set r = r+.142877*camOffset[ixl][iy] + .101594*camOffset[ix][iy] + .134017*camOffset[ixr][iy]
                set r = r+.091913*camOffset[ixl][iyd]+ .134226*camOffset[ix][iyd]+ .084604*camOffset[ixr][iyd]
            endif
        else
            if offy>0 then
                set r =   .091913*camOffset[ixl][iyu]+ .142877*camOffset[ix][iyu]+ .091913*camOffset[ixr][iyu]
                set r = r+.134226*camOffset[ixl][iy] + .101594*camOffset[ix][iy] + .134226*camOffset[ixr][iy]
                set r = r+.084604*camOffset[ixl][iyd]+ .134017*camOffset[ix][iyd]+ .084604*camOffset[ixr][iyd]
            elseif offy<0 then
                set r =   .084604*camOffset[ixl][iyu]+ .134017*camOffset[ix][iyu]+ .084604*camOffset[ixr][iyu]
                set r = r+.134226*camOffset[ixl][iy] + .101594*camOffset[ix][iy] + .134226*camOffset[ixr][iy]                
                set r = r+.091913*camOffset[ixl][iyd]+ .142877*camOffset[ix][iyd]+ .091913*camOffset[ixr][iyd]
            else
                set r =   .086125*camOffset[ixl][iyu]+ .136429*camOffset[ix][iyu]+ .086125*camOffset[ixr][iyu]
                set r = r+.136429*camOffset[ixl][iy] + .109784*camOffset[ix][iy] + .136429*camOffset[ixr][iy]
                set r = r+.086125*camOffset[ixl][iyd]+ .136429*camOffset[ix][iyd]+ .086125*camOffset[ixr][iyd]
            endif
        endif
        return r
    endfunction
   
    function GetCamOffset takes real x, real y returns real
        local integer iXLo = R2I((x-mapMinX)/512.+.5)
        local integer iYLo = R2I((y-mapMinY)/512.+.5)
        local integer iXHi = iXLo+1
        local integer iYHi = iYLo+1
        local integer iChkXLo
        local integer iChkXLoOff
        local integer iChkXHi
        local integer iChkXHiOff
        local integer iChkYLo
        local integer iChkYLoOff
        local integer iChkYHi
        local integer iChkYHiOff
        local real XLo
        local real YLo
        local real XHi
        local real YHi
        local real rX
        local real rY
        local real r
        local real LoDX = (x-mapMinX)-(iXLo*512.-256.)
        local real LoDY = (y-mapMinY)-(iYLo*512.-256.)
        if LoDX<=12 then
            set iChkXLo = iXLo
            set iChkXLoOff = 0
            set iChkXHi = iXLo
            set iChkXHiOff = 1
        elseif LoDX<500 then
            set iChkXLo = iXLo
            set iChkXLoOff = 1
            set iChkXHi = iXHi
            set iChkXHiOff =-1
        else
            set iChkXLo = iXHi
            set iChkXLoOff =-1
            set iChkXHi = iXHi
            set iChkXHiOff = 0
        endif
        if LoDY<=12 then
            set iChkYLo = iYLo
            set iChkYLoOff = 0
            set iChkYHi = iYLo
            set iChkYHiOff = 1
        elseif LoDY<500 then
            set iChkYLo = iYLo
            set iChkYLoOff = 1
            set iChkYHi = iYHi
            set iChkYHiOff =-1
        else
            set iChkYLo = iYHi
            set iChkYLoOff =-1
            set iChkYHi = iYHi
            set iChkYHiOff = 0
        endif
        set XLo = iChkXLo*512.+iChkXLoOff*12.-256.
        set XHi = iChkXHi*512.+iChkXHiOff*12.-256.
        set YLo = iChkYLo*512.+iChkYLoOff*12.-256.
        set YHi = iChkYHi*512.+iChkYHiOff*12.-256.
        set rX = ((x-mapMinX)-XLo)/(XHi-XLo)
        set rY = ((y-mapMinY)-YLo)/(YHi-YLo)
        set r =   GetGridCamOffset(iChkXHi,iChkYHi,iChkXHiOff,iChkYHiOff)*rX*rY
        set r = r+GetGridCamOffset(iChkXLo,iChkYHi,iChkXLoOff,iChkYHiOff)*(1-rX)*rY
        set r = r+GetGridCamOffset(iChkXHi,iChkYLo,iChkXHiOff,iChkYLoOff)*rX*(1-rY)
        set r = r+GetGridCamOffset(iChkXLo,iChkYLo,iChkXLoOff,iChkYLoOff)*(1-rX)*(1-rY)
        return r
    endfunction
   
    private function cameramapInit_GridSub takes real x, real y returns real
        local integer index
        local integer iX = -6
        local integer iY
        local real z
        local real r
        local real i = 64 //9*4+12*2+4
        call MoveLocation(cameramapLoc,x,y)
        set z = GetLocationZ(cameramapLoc)
        set r = 0.
        call MoveLocation(cameramapLoc,x-128.,y)
        set r = r+GetLocationZ(cameramapLoc)*4./i
        call MoveLocation(cameramapLoc,x,y)
        set r = r+GetLocationZ(cameramapLoc)*4./i
        call MoveLocation(cameramapLoc,x+128.,y)
        set r = r+GetLocationZ(cameramapLoc)*4./i
        call MoveLocation(cameramapLoc,x-128.,y+128.)
        set r = r+GetLocationZ(cameramapLoc)*4./i
        call MoveLocation(cameramapLoc,x,y+128.)
        set r = r+GetLocationZ(cameramapLoc)*4./i
        call MoveLocation(cameramapLoc,x+128.,y+128.)
        set r = r+GetLocationZ(cameramapLoc)*4./i
        call MoveLocation(cameramapLoc,x-128.,y-128.)
        set r = r+GetLocationZ(cameramapLoc)*4./i
        call MoveLocation(cameramapLoc,x,y-128.)
        set r = r+GetLocationZ(cameramapLoc)*4./i
        call MoveLocation(cameramapLoc,x+128.,y-128.)
        set r = r+GetLocationZ(cameramapLoc)*4./i
       
        call MoveLocation(cameramapLoc,x-256.,y-128.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
        call MoveLocation(cameramapLoc,x-256.,y)
        set r = r+GetLocationZ(cameramapLoc)*2./i
        call MoveLocation(cameramapLoc,x-256.,y+128.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
       
        call MoveLocation(cameramapLoc,x+256.,y-128.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
        call MoveLocation(cameramapLoc,x+256.,y)
        set r = r+GetLocationZ(cameramapLoc)*2./i
        call MoveLocation(cameramapLoc,x+256.,y+128.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
       
        call MoveLocation(cameramapLoc,x-128.,y-256.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
        call MoveLocation(cameramapLoc,x,y-256.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
        call MoveLocation(cameramapLoc,x+128.,y-256.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
       
        call MoveLocation(cameramapLoc,x-128.,y+256.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
        call MoveLocation(cameramapLoc,x,y+256.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
        call MoveLocation(cameramapLoc,x+128.,y+256.)
        set r = r+GetLocationZ(cameramapLoc)*2./i
       
        call MoveLocation(cameramapLoc,x+256.,y+256.)
        set r = r+GetLocationZ(cameramapLoc)*1./i
        call MoveLocation(cameramapLoc,x+256.,y-256.)
        set r = r+GetLocationZ(cameramapLoc)*1./i
        call MoveLocation(cameramapLoc,x-256.,y+256.)
        set r = r+GetLocationZ(cameramapLoc)*1./i
        call MoveLocation(cameramapLoc,x-256.,y-256.)
        set r = r+GetLocationZ(cameramapLoc)*1./i
        return r
    endfunction
   
    private function cameramapInit_DoRow takes nothing returns nothing
        local real x = mapMinX+256.
        local real y = mapMinY+256.
        local integer iX = bj_forLoopAIndex
        local integer iY = 0
        loop
            exitwhen y+iY*512.>mapMaxY
            set camOffset[(iX+1)][iY+1] = cameramapInit_GridSub(x+iX*512.,y+iY*512.)
            set iY = iY + 1
        endloop
    endfunction

    private function cameramapInit takes nothing returns nothing
        local real x
        local real y
        local integer iX = 0
        local integer iY
        local rect map = GetWorldBounds()
        set mapMinX = GetRectMinX(map)
        set mapMinY = GetRectMinY(map)
        set mapMaxX = GetRectMaxX(map)
        set mapMaxY = GetRectMaxY(map)
        call RemoveRect(map)
        set map = null
        set x = mapMinX+256.
        set y = mapMinY+256.
        set cameramapLoc = Location(0,0)
        loop
            exitwhen x+iX*512.>mapMaxX
            set bj_forLoopAIndex = iX
            call ExecuteFunc("cameramapInit_DoRow")
            set iX = iX + 1
        endloop
        call RemoveLocation(cameramapLoc)
        set cameramapLoc = null
    endfunction
endlibrary

library StructGameCameraHeight requires Asl, GetCamOffset
	/**
	 * \brief Adjusts the camera height add registered rects to a Z value.
	 */
	struct CameraHeight
		public static real period = 1.0
		private static timer m_timer
		private static ARectVector m_rects
		private static ARealVector m_heights
		
		public static method addRect takes rect whichRect, real height returns nothing
			call thistype.m_rects.pushBack(whichRect)
			call thistype.m_heights.pushBack(height)
		endmethod
		
		private static method timerFunctionUpdateCameraHeight takes nothing returns nothing
			local integer i = 0
			local integer j
			local real height = 0.0
			local boolean found = false
			debug call Print("run")
			debug call Print("Terrain cliff level: " + I2S(GetTerrainCliffLevel(GetCameraTargetPositionX(), GetCameraTargetPositionY())) + " with distance " + R2S(GetCameraField(CAMERA_FIELD_ZOFFSET)))
			
			set j = 0
			loop
				exitwhen (j == MapData.maxPlayers)
				if (GetLocalPlayer() == Player(j)) then
					set i = 0
					loop
						exitwhen (i == thistype.m_rects.size() or found)
						set height = thistype.m_heights[i]
						
						if (RectContainsCoords(thistype.m_rects[i], GetCameraTargetPositionX(), GetCameraTargetPositionY())) then
							call SetCameraField(CAMERA_FIELD_ZOFFSET, height, thistype.period)
							debug call Print("Applying height: " + R2S(height))
							set found = true
						endif

						set i = i + 1
					endloop
					
					// reset
					if (not found) then
						call SetCameraField(CAMERA_FIELD_ZOFFSET, 0.0, thistype.period)
					endif
				endif
				set j = j + 1
			endloop
		endmethod
		
		public static method start takes nothing returns nothing
			call TimerStart(thistype.m_timer, thistype.period, true, function thistype.timerFunctionUpdateCameraHeight)
		endmethod
		
		public static method pause takes nothing returns nothing
			call PauseTimer(thistype.m_timer)
		endmethod
		
		public static method resume takes nothing returns nothing
			call TimerStart(thistype.m_timer, thistype.period, true, function thistype.timerFunctionUpdateCameraHeight)
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.m_timer = CreateTimer()
			set thistype.m_rects = ARectVector.create()
			set thistype.m_heights = ARealVector.create()
		endmethod
		
	endstruct
	
endlibrary
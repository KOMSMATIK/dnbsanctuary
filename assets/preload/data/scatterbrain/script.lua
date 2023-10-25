function onUpdate()

        if mustHitSection == false then
           
			setProperty('defaultCamZoom', 0.55)
		
        else
           
			setProperty('defaultCamZoom', 1.0)
		
        end
    
        triggerEvent('Camera Follow Pos','','')
    
	end
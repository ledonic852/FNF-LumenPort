-- Just a little script to put GF where she's meant to be.
function onCreate()
    setProperty('gf.visible', false)
    setProperty('dad.x', getProperty('gf.x'))
    setProperty('dad.y', getProperty('gf.y'))
end
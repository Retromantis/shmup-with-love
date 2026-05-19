-- main.lua

local push = require("libs.push")

local GAME_WIDTH = 240
local GAME_HEIGHT = 400

local WINDOW_WIDTH = 720
local WINDOW_HEIGHT = 1200

local fullscreen = false

local windowWidth = 720
local windowHeight = 1200

local bg = nil

function love.load()
    -- windowWidth, windowHeight = love.window.getDesktopDimensions()

    love.window.setTitle("Vertical Shmup")

    love.window.setMode(
        windowWidth,
        windowHeight,
        {
            resizable = true,
            fullscreen = false,
            vsync = true
        }
    )

    bg = love.graphics.newImage("assets/images/bg.png")

    push:setupScreen(
        GAME_WIDTH,
        GAME_HEIGHT,
        windowWidth,
        windowHeight,
        {
            fullscreen = fullscreen,
            resizable = true,
            vsync = true
        }
    )
end

function love.keypressed(key)
    local alt =
        love.keyboard.isDown("lalt") or
        love.keyboard.isDown("ralt")

    if key == "return" and alt then
        fullscreen = not fullscreen

        push:switchFullscreen(
            windowWidth,
            windowHeight,
            fullscreen
        )
    end

    if key == "escape" then
        love.event.quit()
    end
end

function love.resize(w, h)
    if not fullscreen then
        windowWidth = w
        windowHeight = h
    end
    push:resize(w, h)
end

function love.draw()
    push:start()

    love.graphics.draw(bg, 0, 0)

    push:finish()
end
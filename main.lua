-- main.lua

local push = require("libs.push")
local anim8 = require("libs.anim8")
local player = require("player")
require("utils")

GAME_WIDTH = 240
GAME_HEIGHT = 400

local WINDOW_WIDTH = 720
local WINDOW_HEIGHT = 1200

local windowWidth, windowHeight = WINDOW_WIDTH, WINDOW_HEIGHT

local fullscreen = false

local  NEXT_ENEMY_DELAYTIME = 100
local next_enemy_timer = 0

local bg1 = {
    image = nil,
    x = 0,
    y = -GAME_HEIGHT,
    speed = 10
}

local bg2 = {
    image = nil,
    x = 0,
    y = -GAME_HEIGHT,
    speed = 20
}

player_bullets = {}

local player_bullet = {}

enemy_bullets = {}

local enemy_bullet = {}

enemy = {
    WIDTH = 40,
    HEIGHT = 40,
    rect = nil,
    image = nil,
    frames = nil,
    animation = nil,
    speed = 50
}

enemies = {}

function love.load()
    -- windowWidth, windowHeight = love.window.getDesktopDimensions()

    love.window.setTitle("Shmup with Love")

    love.graphics.setDefaultFilter(
        "nearest",
        "nearest"
    )

    push:setupScreen(
        GAME_WIDTH,
        GAME_HEIGHT,
        windowWidth,
        windowHeight,
        {
            fullscreen = fullscreen,
            resizable = true,
            vsync = true,
            pixelperfect = true
        }
    )

    bg1.image = love.graphics.newImage("assets/images/bg1.png")
    bg2.image = love.graphics.newImage("assets/images/bg2.png")

    player.rect = get_rect(0, 0, player.WIDTH, player.HEIGHT)

    player.hitbox = get_rect(8, 8, 24, 24)

    set_position(player, GAME_WIDTH / 2 - 20, GAME_HEIGHT - 60)
    
    player.image =
        love.graphics.newImage(
            "assets/images/player.png"
        )

    player.frames = anim8.newGrid(
        player.rect.width,
        player.rect.height,
        player.image:getWidth(),
        player.image:getHeight()
    )

    player.animation = anim8.newAnimation(player.frames("1-2", 1), 0.15)

    player_bullet.image =
        love.graphics.newImage(
            "assets/images/player_bullet.png"
        )

    player_bullet.frames = anim8.newGrid(
        4,
        10,
        player_bullet.image:getWidth(),
        player_bullet.image:getHeight()
    )

    enemy.image =
        love.graphics.newImage(
            "assets/images/enemy.png"
        )

    enemy.frames = anim8.newGrid(
        enemy.WIDTH,
        enemy.HEIGHT,
        enemy.image:getWidth(),
        enemy.image:getHeight()
    )

    enemy.animation = anim8.newAnimation(enemy.frames("1-2", 1), 0.15)

    enemy_bullet.image =
        love.graphics.newImage(
            "assets/images/enemy_bullet.png"
        )

    enemy_bullet.frames = anim8.newGrid(
        4,
        10,
        enemy_bullet.image:getWidth(),
        enemy_bullet.image:getHeight()
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

    if key == "x" then

        local bullet = {}

        bullet.x = player.rect.x + 18

        bullet.y = player.rect.y

        bullet.speed = 220

        bullet.animation =
            anim8.newAnimation(enemy_bullet.frames("1-2", 1), 0.08)

        table.insert(
            player_bullets,
            bullet
        )

    end
end

function love.update(dt)

    local moving = false

    if love.keyboard.isDown("left", "a") then
        player:to_left(dt)
        moving = true
    end

    if love.keyboard.isDown("right", "d") then
        player:to_right(dt)
        moving = true
    end

    if love.keyboard.isDown("up", "w") then
        player:to_up(dt)
        moving = true
    end

    if love.keyboard.isDown("down", "s") then
        player:to_down(dt)
        moving = true
    end

    -- limites virtuales

    player:keep_in_bounds()

    if moving then
        player.animation:update(dt)
    end

    for i = #player_bullets, 1, -1 do

        local bullet =
            player_bullets[i]

        bullet.y = bullet.y - bullet.speed * dt

        bullet.animation:update(dt)

        -- destruir fuera pantalla

        if bullet.y < -16 then
            table.remove(player_bullets,i)
        end

    end

    bg1.y = bg1.y + bg1.speed * dt
    if bg1.y >= 0 then
        bg1.y = -GAME_HEIGHT
    end

    bg2.y = bg2.y + bg2.speed * dt
    if bg2.y >= 0 then
        bg2.y = -GAME_HEIGHT
    end

    next_enemy_timer = next_enemy_timer + dt * 50
    if next_enemy_timer >= NEXT_ENEMY_DELAYTIME then
        spawn_enemy()
        next_enemy_timer = 0
    end

    for _, enemy_instance in ipairs(enemies) do
        enemy_instance.y = enemy_instance.y + enemy_instance.speed * dt
        enemy_instance.animation:update(dt)
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

    love.graphics.draw(bg1.image, bg1.x, bg1.y)
    love.graphics.draw(bg1.image, bg1.x, bg1.y + GAME_HEIGHT)

    love.graphics.draw(bg2.image, bg2.x, bg2.y)
    love.graphics.draw(bg2.image, bg2.x, bg2.y + GAME_HEIGHT)

    player.animation:draw(
        player.image,
        math.floor(player.rect.x),
        math.floor(player.rect.y)
    )

    for _, bullet in ipairs(player_bullets) do

        bullet.animation:draw(
            player_bullet.image,
            math.floor(bullet.x),
            math.floor(bullet.y)
        )

    end

    for _, enemy_instance in ipairs(enemies) do

        enemy_instance.animation:draw(
            enemy.image,
            math.floor(enemy_instance.x),
            math.floor(enemy_instance.y)
        )

        if enemy_instance.y > GAME_HEIGHT then
            table.remove(enemies, _)
        end

    end

    push:finish()
end

spawn_enemy = function()
    local enemy_instance = {}

    enemy_instance.x = math.random(0, GAME_WIDTH - enemy.WIDTH)

    enemy_instance.y = -enemy.HEIGHT

    enemy_instance.speed = enemy.speed

    enemy_instance.animation =
        anim8.newAnimation(enemy.frames("1-2", 1), 0.15)

    table.insert(
        enemies,
        enemy_instance
    )
end

local player = {
    speed = 200,
    lives = 3,
    WIDTH = 40,
    HEIGHT = 40
}

player.to_left = function(self, dt)
    set_position(self, self.rect.x - self.speed * dt, self.rect.y)
    -- self.rect.x = self.rect.x - self.speed * dt
end

player.to_right = function(self, dt)
    set_position(self, self.rect.x + self.speed * dt, self.rect.y)  
end

player.to_up = function(self, dt)
    set_position(self, self.rect.x, self.rect.y - self.speed * dt)
end

player.to_down = function(self, dt)
    set_position(self, self.rect.x, self.rect.y + self.speed * dt)
end

player.position = function(self, x, y)
    set_position(self, x, y)
end

player.keep_in_bounds = function(self)
     if self.rect.x < 0 then
        -- set_position(player, 0, player.rect.y)
        self:position(0, self.rect.y)
    end

    if self.rect.x > GAME_WIDTH - self.WIDTH then
        self:position(GAME_WIDTH - self.WIDTH, self.rect.y)
    end

    if self.rect.y < 0 then
        self:position(self.rect.x, 0)
    end

    if self.rect.y > GAME_HEIGHT - self.HEIGHT then
        self:position(self.rect.x, GAME_HEIGHT - self.HEIGHT)
    end
end

return player
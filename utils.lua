function set_rect(entity, x, y, width, height)
    entity.x = x
    entity.y = y
    entity.width = width
    entity.height = height
end

function get_rect(x, y,width, height)
    return {
        x = x,
        y = y,
        width = width,
        height = height
    }
end

function check_collision(rect1, rect2)
    return rect1.x < rect2.x + rect2.width and
           rect1.x + rect1.width > rect2.x and
           rect1.y < rect2.y + rect2.height and
           rect1.y + rect1.height > rect2.y
end

function set_position(entity, x, y)
    entity.rect.x = x
    entity.rect.y = y
    entity.hitbox.x = x + entity.hitbox.x
    entity.hitbox.y = y + entity.hitbox.y
end

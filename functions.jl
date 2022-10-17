function area(circle::Circle)
    area = 2*pi*circle.radius^2
    return area
end

function area(square::Square)
    area = square.side^2
    return area
end

function overlap(circle1::Circle, circle2::Circle)
    dist = sqrt((circle1.center.x-circle2.center.x)^2+(circle1.center.y-circle2.center.y)^2)
    if circle1.radius + circle2.radius <= dist
        return "circles do not overlap"
    else 
        return "circles overlap"
    end
end
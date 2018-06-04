gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local image = resource.load_image "disconnect.png"

function node.render()
    image.draw(image, 10, 10, 35, 35)
end

require 'shoes'

WIDTH = 680
HEIGHT = 340

class Love
  def initialize
    @btn_info = {top: 0, left: 0, width: 0, height: 0}

    @path = File.expand_path(File.join(__FILE__, ".."))
  end

  def img_path
    "#{@path}/assert/image/background.jpg"
  end

  def music_path
    "#{@path}/assert/music/bg.mp3"
  end

  def get_random_corpus
    ['房产证写你名字', '我妈会游泳', '我做家务', '保大的', '会写代码', '会修电脑', '生儿生女都一样'].sample
  end

  def init_position(btn)
    style = btn.style
    top = style[:absolute_top] + style[:margin_top]
    left = style[:absolute_left] + style[:margin_left]

    @btn_info = {top: top, left: left, width: style[:element_width], height: style[:element_height]}
  end

  # 由于无法检测button的hover事件，采用边缘检测，靠近按钮边缘即可
  def is_hover?(top, left)
    min_x = @btn_info[:left] - 5
    max_x = @btn_info[:left] + @btn_info[:width] + 5
    min_y = @btn_info[:top] - 5
    max_y = @btn_info[:top] + @btn_info[:height] + 5

    (min_x <= left) && (left <= max_x) && (min_y <= top) && (top <= max_y)
  end

  def get_rand_pos(left, top)
    min_top = top - @btn_info[:height] - 5
    min_top = min_top <= 0 ? nil : rand(0..min_top)

    min_left = left - @btn_info[:width] - 5
    min_left = min_left <= 0 ? nil : rand(0..min_left)

    max_top = HEIGHT - @btn_info[:height] - 5
    max_top = top >= max_top ? nil : rand(top..max_top)

    max_left = WIDTH - @btn_info[:width] - 5
    max_left = left >= max_left ? nil : rand(left..max_left)

    new_top = [min_top, max_top].compact.sample
    new_left = [min_left, max_left].compact.sample

    [new_left, new_top]
  end

  def move_btn(btn, left, top)
    # 按钮所在slot的起始坐标值
    base_top = 192
    base_left = 322

    new_left, new_top = get_rand_pos(left, top)
    btn.move(new_left - base_left, new_top - base_top)
  end
end

Shoes.app width: WIDTH, height: HEIGHT, resizable: false, title: '做我女朋友好吗?' do
  love = Love.new

  background white
  stack width: 0.4 do
    image love.img_path, height: 300

    @text = para nil, align: 'center'
  end

  stack width: 0.6 do
    para '小姐姐，你这么可爱', size: 25, align: 'center', margin_top: 70
    para '做我', strong('女朋友'), '好不好呀', size: 25, align: 'center', margin_top: 10

    flow do
      button '好呀😍', margin_top: 40, margin_left: 90 do
        alert('爱你，么么哒💕')
      end

      @n_btn = button '算了😢', margin_top: 40, margin_left: 50
    end

    @n_btn.click do
      @n_btn.text = '我愿意🎉'
      alert('😄，看清楚了吗？')
    end
  end

  motion do |left, top|
    love.init_position(@n_btn)

    if love.is_hover?(top, left)
      love.move_btn(@n_btn, left, top)

      @text.text = love.get_random_corpus
    end
  end

  bg_music = sound(love.music_path)
  bg_music.play
end

from pygame import *
from random import randint
# подгружаем отдельно функции для работы со шрифтом
font.init()
font1 = font.Font(None, 80)
win = font1.render('ТЕБЕ ПОВЕЗЛО ТЫ СБЕЖАЛА', True, (255, 0, 0))
lose = font1.render('АХАХХАХАХАХАХАХАХАХХАХА', True, (180, 0, 0))

font2 = font.Font(None, 36)

#фоновая музыка
mixer.init()
mixer.music.load('muzyka-iz-k-f-saylent-hill-bez-nazvaniya.mp3')
mixer.music.play()
fire_sound = mixer.Sound('fantasy_trap_02.mp3')

# нам нужны такие картинки:
img_back = "Без имени-1.png" #фон игры
mg_bullet = 'Без имени-4.png'
img_bullet = "Llo3NvY_Xuk (1).jpg" #пуля
img_hero = "Без имени-4.png" #герой
img_enemy = "vrag.jpeg"
end ='1614436646_35-p-glaza-na-temnom-fone-40.jpg'
 
score = 0 # сбито кораблей
goal = 10 # столько кораблей нужно сбить для победы
lost = 0 # пропущено кораблей
max_lost = 3 # проиграли, если пропустили столько
 
# класс-родитель для других спрайтов
class GameSprite(sprite.Sprite):
  # конструктор класса
    def __init__(self, player_image, player_x, player_y, size_x, size_y, player_speed):
        # Вызываем конструктор класса (Sprite):
        sprite.Sprite.__init__(self)

        # каждый спрайт должен хранить свойство image - изображение
        self.image = transform.scale(image.load(player_image), (size_x, size_y))
        self.speed = player_speed

        # каждый спрайт должен хранить свойство rect - прямоугольник, в который он вписан
        self.rect = self.image.get_rect()
        self.rect.x = player_x
        self.rect.y = player_y
 
  # метод, отрисовывающий героя на окне
    def reset(self):
        window.blit(self.image, (self.rect.x, self.rect.y))

# класс главного игрока
class Player(GameSprite):
    # метод для управления спрайтом стрелками клавиатуры
    def update(self):
        keys = key.get_pressed()
        if keys[K_a] and self.rect.x > 5:
            self.rect.x -= self.speed
        if keys[K_d] and self.rect.x < win_width - 80:
            self.rect.x += self.speed
        if keys[K_w] and self.rect.y > 5:
            self.rect.y -= self.speed
        if keys[K_s] and self.rect.y < win_height - 10:
            self.rect.y += self.speed

  # метод "выстрел" (используем место игрока, чтобы создать там пулю)
    def fire(self):
        bullet = Bullet(img_bullet, self.rect.centerx, self.rect.top, 80, 80, -0)
        bullets.add(bullet)

# класс спрайта-врага   
class Enemy(GameSprite):
    # движение врага
    def update(self):
        self.rect.y += self.speed
        global lost
        # исчезает, если дойдет до края экрана
        if self.rect.y > win_height:
            self.rect.x = randint(80, win_width - 80)
            self.rect.y = 0
            lost = lost + 1
 
# класс спрайта-пули   
class Bullet(GameSprite):
    # движение врага
    def update(self):
        self.rect.y += self.speed
        # исчезает, если дойдет до края экрана
        if self.rect.y < 0:
            self.kill()
 
# Создаем окошко
win_width = 1252
win_height = 700
display.set_caption('О̵̼̯̫̜̟̺͚͎̇͛̀͂̂͘н̶̢̡͙̼̖̤̥̪̎̓͂о̴̯͉͕͎̬̿̍ ̶͖̜͎̾͑͂̌͛͘ͅн̵̦̭̓̏͒̈́̎͆̌̌͠͡а̷̛̜̱̙̯̙̝̱͉̔̋̏͌͟͝б̵̛̥̘̝̪͇͓̈́̿̿л̸̡̲͍͉͇̯̔͑́́͂̀̊̕͝ю̶̫̜͋̉̾̋̅͂̾̄̚д̶̡̊̑̊̒̄̀̏͘͝͠а̶͉̜͎͔͈͇̉̀̌̊͛͗̔͐е̸̨̧̢̙͉͕͊́͌͑͒͛͑̚͝т̷͎̫̤̗̩̲̂̈̍͟ ̶̫̹͉̮̗̆̽͆͒̀̎̇͊̓ӟ̵̜̥̱̟̥̮̈́̿а̷̮͙̲̀̈́̅͌͟ ̶̳̪̫̬͙͉̤͠т̷̥̞̥̙͖̜̝͒̏ͅо̵̬̯̗́̾̉̔͂̒͒̉͝б̶̛̱̤͉͉́͂̿͊̈́́о̴͕̲̱̮͔̘͎̽́̽̒͒й̷̡̲̥̪͖̻̗̓̋͟"')
window = display.set_mode((win_width, win_height))
background = transform.scale(image.load(img_back), (win_width, win_height))
 
# создаем спрайты
ship = Player(img_hero, 5, win_height - 100, 80, 100, 100)
 
# создание группы спрайтов-врагов
monsters = sprite.Group()
for i in range(1, 2):
    monster = Enemy(img_enemy, randint(80, win_width - 80), -40, 80, 50, randint(1, 2))
    monsters.add(monster)
 
bullets = sprite.Group()
 
# переменная "игра закончилась": как только там True, в основном цикле перестают работать спрайты
finish = False
# Основной цикл игры:
run = True # флаг сбрасывается кнопкой закрытия окна
while run:
    for e in event.get():
        if e.type == QUIT:
            run = False
        elif e.type == KEYDOWN:
            if e.key == K_SPACE:
                fire_sound.play()
                ship.fire()
    
    if not finish:
        window.blit(background, (0, 0))
        ship.update()
        monsters.update()
        bullets.update()

        ship.reset()
        monsters.draw(window)
        bullets.draw(window)

        collides = sprite.groupcollide(monsters, bullets, True, True)
        for c in collides:
            score += 1
            monster = Enemy(img_enemy, randint(80, win_width - 80), -40, 80, 50, randint(1, 5))
            monsters.add(monster)

        if sprite.spritecollide(ship, monsters, False) or lost >= max_lost:
            finish = True
            window.blit(lose, (200, 200))

        if score >= goal:
            finish = True
            window.blit(win, (200, 200))

        text = font2.render("Счет: " + str(score), True, (255, 255, 255))
        window.blit(text, (10, 20))

        text_lose = font2.render("Пропущено: " + str(lost), True, (255, 255, 255))
        window.blit(text_lose, (10, 50))

        display.update()
    else:
        # Resetting the game
        finish = False
        score = 0
        lost = 0
        bullets.empty()
        monsters.empty()
        
        time.delay(900)
        for i in range(6, 20):
            monster = Enemy(img_enemy, randint(80, win_width - 80), -40, 80, 50, randint(3, 5))
            monsters.add(monster)

    time.delay(50)



    '''window.blit(end, (0, 0))'''






    

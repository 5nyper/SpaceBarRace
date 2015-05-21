##    SpaceBarRace

import csfml, csfml_audio, strutils, math, times
import unicode
var
  i = 0
  isBreak = false
  timerStart: float

let
  songFile = newSoundBuffer("imports/Et.wav")
  song = newSound(songFile)
  window = newRenderWindow(videoMode(400, 200), "SpaceBar Race")
  font = new_Font("imports/sansation.ttf")
  text = new_Text("        Press Space to Start", font)
  gO = new_text("                   Game Over!",font)

text.color = Black

while window.open():
  var count = new_text("""



                          $1""" % [$i],font)
  var e = new_text("""



      Your HighScore is $1 !""" % [$i],font)
  count.color = Black
  window.clear color(math.random(255),math.random(255),math.random(255))
  stdout.write(mouseGetPosition(window), "\r")
  var event: Event
  block outer:
    while window.pollEvent(event):
      if event.kind == EventType.Closed:
        window.close()
      elif event.kind == EventType.KeyPressed:
        if $event.key.code == "Space":
          if i < 1:
            timerStart = epochTime()
            song.play()
          if epochTime() - timerStart >= 10:
            isBreak = true
            break outer
          i+=1
        elif $event.key.code == "R":
          timerStart = epochTime()
          isBreak = false
          i=0


  if isBreak:
    window.draw e
    window.draw gO
  else:
    window.draw count
    window.draw text
  window.display()
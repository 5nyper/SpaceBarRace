##    SpaceBarRace

import csfml, csfml_audio, strutils, math, times, json
import unicode

let
  songFile = newSoundBuffer("imports/Et.wav")
  song = newSound(songFile)
  window1 = newRenderWindow(videoMode(400, 200), "SpaceBar Race")
  window2 = newRenderWindow(videoMode(300, 50), "Enter your username")
  font = new_Font("imports/sansation.ttf")
  text = new_Text("        Press Space to Start", font)
  gO = new_text("                   Game Over!",font)

var
  (i,ph) = (0,0)
  isBreak = false
  timerStart: float
  str = new_seq[Rune]()
  dam = new_Text("", font)
  name = ""

text.color = Black
dam.color = Black

while window2.open:
    var event: Event
    while window2.poll_event(event):
        case event.kind
        of EventType.KeyPressed:
            case event.key.code
            of KeyCode.Escape:
                window2.close()
            of KeyCode.Back:
                if str.len > 0:
                    discard str.pop()
            of KeyCode.Return:
                name = dam.str
                echo name
                window2.close()
            else: discard
        of EventType.TextEntered:
            if ord(event.text.unicode) >= ord(' '):
                str.add event.text.unicode
            dam.str = "" & $str
        of EventType.Closed:
            window2.close()
        else: discard

    window2.clear White
    window2.draw dam
    window2.display()

while window1.open():
  window2.close()
  var count = new_text("""



                          $1""" % [$i],font)
  var e = new_text("""



      Your HighScore is $1 !""" % [$i],font)
  count.color = Black
  window1.clear color(math.random(255),math.random(255),math.random(255))
  stdout.write(mouseGetPosition(window1), "\r")
  var event: Event
  block outer:
    while window1.pollEvent(event):
      if event.kind == EventType.Closed:
        window1.close()
      elif event.kind == EventType.KeyPressed:
        if $event.key.code == "Space":
          if i < 1:
            timerStart = epochTime()
            song.play()
          if epochTime() - timerStart >= 10:
            isBreak = true
            if ph < 1:
              var scores = %*{"username": name,"score": i}
              var file = open("output.json", fmAppend)
              write(file, "$1,\n" % [$scores])
              close(file)
            ph += 1
            break outer
          i+=1
        elif $event.key.code == "R":
          timerStart = epochTime()
          isBreak = false
          ph = 0
          i=0


  if isBreak:
    window1.draw e
    window1.draw gO
  else:
    window1.draw count
    window1.draw text
  window1.display()

let x = readFile("output.json")
var data = parseJSON(x)

echo data

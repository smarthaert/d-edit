     Welcome to the help file for IronClad. In this document you will learn
how to make IronClad as much yours as it is mine. I made this program always
keeping in mind that I was going to change things the next day. The result
of this is one of the easiest games to change I've ever seen!

If you do make changes to IronClad, which I encourage whole heartedly,
I would love to see what you did. Please E-mail any enhancements you make.

Also, remember that the source code for the game is located in the Source
directory of the path you specified during installation.(Default: c:\IronClad)
If you have any questions or comments on the source please E-mail me.

EMAIL ME> victor@intrex.net

  I. Making new enemies
 II. Making new levels
III. Changing the hero
 IV. Sending me enhancements

I. Making new enemies
A. Drawing your enemy
The first step is to draw the enemy using DRAW.EXE . This was also made by
me (Justin Pierce) when we needed a simple drawing program. It was not
truely intended to be released, so it is not perfect. It is alot like
Windows's paintbrush or paint depending on your version of Windows. First
go to the size button and specify a size. Most of the enemies in the game
are 49x41. I do not recommend you go much higher than this in size, or
else the game will slow down. Next draw your enemy FACING DOWNWARDS using
the utilities and colors.
Notes:
-Double left click draws a line
-Each mouse button can be assigned a button
-If filling messes up your drawing, quickly load PREFILL.DRW (this
is your drawing before fill)

B. Saving your enemy
Of course the enemy has to be saved now.
First, you must know what directory you specified install to install to.
I will ASSUME you used c:\IronClad for this example. You MUST put the picture
in the pictures directory located under c:\IronClad. So 
simply click on the save button and enter a file name such as
c:\ironclad\pictures\bship13.drw or c:\ironclad\pictures\bship14.drw etc.
(Note: bship simply stands for "bad ship"... cool huh)
You can now quit DRAW.EXE

C. Making IronClad load the new picture
You must now edit the file assign.pic which is located in the directory
you specified in the installation program. Under the section
![Picture Assignments] AND GSHIP:\GSHIP.DRW! insert the name of the new
enemy. This can be anything, but it makes it simpler if you make it the
filename of the DRW file (As can be seen elsewhere in the file). The new
entry should look like this:
If the new drawing is called bship15.drw type
bship15:\bship15.drw
IF the new drawing is called bship16.drw type
bship15:\bship16.drw
Of course, as I mentioned, the name can be anything.. bship16.drw could be
assigned to
myship:\bship16.drw
But no matter what name you use you must remember it for latter.
(Note: ALWAYS remember the "\" in the assignment section)

D. Giving the enemy life
Finally, edit enemy.inf (this should be in the same directory as assign.pic).
go to the botom of the file, copy the entry at the bottom (starting from
[New] , copy to and include Orrientation=??  ), and paste the copied entry
at the bottom. Now you have two exact copies of the same entry (This step
is to make sure you do not miss any input). Now change the entry:
picture name= to the name you specified in assign.pic. Finally change the
statistics for the ship. Below is what the entries mean.
[New] (calls out to create a new ship)

picture name=(name specified in assign.pic)

point value=(how many points the hero gets for killing)

strength=(how many shots it takes to kill enemy)

jump=(how many pixels enemy jumps every time it is updated [updating relies
on delay= entry])

delay=(tells the game how many 1000's of a second to wait before updating)

ram damage=(how many points of damage hero recieves for ramming the enemy)

weapon type=(specifies the number of the weapon the enemy uses [1..20])

chance of shot=(when random(chance_of_shot)=1 then the enemy shots [in
other words the lower the number the higher the probability of the enemy
shooting])

weapon power=(this specifies the power of the weapon that the enemy shoots
[In the game laser class 1 gives 1 damage. Judge your power from that])

orrientation=(how many pixels the weapon is displaced from the left hand side
of the enemy ship [this depends on the size of the ship and the size
of the weapon]. More on orrientation: If you set orrientation=1 then the
laser that you specified will appear to come out of the left side of the
enemy. I suggest you try to make the laser come from the middle of the enemy
as all the other laser do. To try to find exact orrientaion see equation
below--
where bshipx = the x dimension of the enemy drawing
where lasx = the x dimension of the weapon
orrientaion= (bshipx div 2) - (lasx div 2)

Note: to find out the laser dimension load picture of the weapon in DRAW.EXE
the name will be as follows:
weapon 1 = glaser1.drw
weapon 2 = glaser2.drw
weapon X = glaserX.drw
missles = glaserm.drw
)

E. Using your enemy!
Now, all you need to do is make a map using your enemy (this is explained
latter in this document)!

II. Making new levels
A. Making the first part of the level
To start a level simply run MAPPER.EXE located in the directory you
specified during installation (Default C:\IronClad\MAPPER.EXE). You
will see the hero flying at the bottom of the screen, but he does not
respond to the game commands. The only command on this screen is the
space bar. This starts the add enemy screen. Simply select the enemy
you want to attack, and position the enemy as you wish. This will
take you back to the flying screen, and you will see the new enemy you
added flying down. Wait any time period and hit the space bar again, repeat
this procedure until you are satisfied with one part of the level and hit "Q".
(Note: "Q" means that a PART of the level is complete, during the game
this will take the hero to the docking station to prepare for the next part)
Answer that you "do want to save this pattern".
This will take you to to a screen where you need to specify the name of
the map. This will then save map the hard drive. YOU WILL NEED to remember
the name you specified to make more parts of the level.

B. Making more parts to an existing level
Simply follow the same steps that appear in part A.. Except when enter
the name of the level to save enter the name you specified in part A..
The program will ask you if you wish to add on to the level, answer yes, and
the part is added to the existing level. Do this until you are satisfied with
the level.

C. Playing the level
Start IronClad and select Load Map/Game. Answer that you
wish to load a map. Enter the name you saved your map to, and you
should then be able to play the map you created.

III. Changing the hero
Please read section I.A to become comfortable with DRAW.EXE before
continuing.
Once you understand DRAW.EXE simply load c:\[IronClad Directory]\gship.drw ,
edit it, and save it as the same name.

IV. Sending me enhancements
A. Zipping the directory
To do this you will need pkzip.exe
Simply change to the directory you specified during the install program
and type:
pkzip -rp c:\newiron.zip *.*
This will create c:\newiron.zip which you can send to me via E-mail

B. Sending newiron.zip to me
Just use your E-mail client to attach the file to an E-mail message, and then
send the file to victor@intrex.net  . I appreciate it if you are doing this, I
would like to see this program actually finished :) .

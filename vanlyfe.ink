// day handlers
VAR day = 0
LIST time_of_day = morning, (noon), evening, night

// player vars
LIST food = (beans), (ramen), (tomato_soup), (noodle_soup), (hot_dog), (cereal)
LIST coffee = full
VAR hunger = 0
VAR shower = 0
VAR laundry = 0
VAR bladder = 0
VAR mood = 0
VAR money = 1000
VAR player = "Nora"

// van vars
VAR gas = 0
VAR power = 0
VAR trash = 0
VAR dirty = 0

//habits
VAR filthy = false
VAR clean = false
VAR foodie = false
VAR starving = false
VAR low_maintenance = false
VAR bougie = false

->foodtime_handler

=== time_handler ===
hi there nerd

== function name(item)
{item:
- beans: beans
- tomato_soup: tomato soup
- noodle_soup: noodle soup
- hot_dog: hot dog 
- cereal: cereal
- else: {item}
}

=== foodtime_handler ===
{time_of_day == morning: Nora: What's for breakfast?}
{time_of_day == noon: Nora: What's for lunch?}
{time_of_day == evening: Nora: What's for dinner?}
{time_of_day == night: Nora: ...dessert?}

// copy the list you're using to make options
~ temp toprint = food
- (top)
// take an element off the list to print
~ temp food_from_list = LIST_MIN(toprint)
~ toprint -= food_from_list
// thread in the choice for this element
<- option(food_from_list)

// if there's any left to print, loop to print the next one
{ toprint: -> top }

+ [Skip Meal]
-    {hunger > 0:
    Nora: I'm not hungry
    }
    ~ hunger ++
-    {hunger == 1:
    Nora: I'm not in the mood
    }
    ~ hunger ++
-    {hunger == 2:
    Nora: I'm hungry, but best to conserve food
    }
    ~ hunger ++    
-    {hunger == 3:
    Nora: I'm starving. I can skip this meal, but I'll have to eat soon.
    }
    ~ hunger ++    
-    else:
    Nora: No. Gotta eat something.
    -> foodtime_handler
    
-> DONE

= option(food_from_list)
+ [{name(food_from_list)}] -> choose(food_from_list)

+ ->
    Narrator: You scrounge through the cupboards but there is nothing to eat.
    
    Narrator: You feel dizzy for a moment, then everything goes black.
    ~time_of_day ++
    -   {time_of_day == morning: 
        Narrator: You wake up and the sun is shining through the windshield into your eyes
        }
    -   {time_of_day == noon: 
        Narrator: You wake up to the dusty heat of the van.
        }        
    -   {time_of_day == evening: 
        Narrator: You wake up to a deer staring at your through the windshield. It blinks twice, then dart off into the trees.
        }
    -   {time_of_day == night: 
        Narrator: You wake up to a chill. its dark all around you.  
        }
    Narrator: You need to find something to eat before you pass out again.
        
        
=== choose(food_from_list) ===
{food_from_list == beans: 
Narrator: You snap open the can of beans and scoop them into your mouth cold. 
Nora: Damn I love them beans
~ food -= beans
}
{food_from_list == tomato_soup: 
Narrator: The hob clicks on in an instant
Narrator: You scrape your short fingernails under the pull tab and snap open the can of tomato soup. 
Nora: If only I has some grilled cheese to go with....
~food -= tomato_soup
}

{food_from_list == ramen: 
Narrator: You pull the brick of noodles out of the wrapper and plop it into the bubbling water. 
Narrator: Your 
}

    -> END
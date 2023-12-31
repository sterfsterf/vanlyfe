// ================ debug menu ================


->time_handler
//->foodtime_handler
//-> start

// ================ vars ================



// day/time handler vars
VAR day = 0
LIST time_of_day = morning, (afternoon), evening, night
LIST day_of_week = end_of_week, Monday, Tuesday, Wednesday, Thursday, Friday, (Saturday), Sunday 
VAR ate_already = false
VAR tidyed_already = false
VAR tidyed_bed_already = false
VAR tidyed_surfaces_already = false
VAR tidyed_floor_already = false
VAR tidyed_litterbox_already = false
VAR ventured_already = false
VAR showered_already = false

// inventory vars
LIST food = beans, ramen, (tomato_soup), noodle_soup, hot_dog, cereal
VAR coffee = 2

// player vars
VAR nora_hunger = 0
VAR nora_dirty = 0
VAR nora_laundry = 0
VAR nora_bladder = 0
VAR nora_mood = 0
VAR nora_money = 1000

//place vars
LIST place_private = (secluded), quiet, crowded 
LIST place_safe = (safe), ok, scary


//kitty vars
VAR has_kitty = false
VAR kitty_name = "Hugo"

// van vars
VAR van_gas = 0
VAR van_power = 0
VAR van_water = 0
VAR van_greywater = 0 //when this hits 0, reset to 20 
VAR van_trash = 0
VAR van_dirty = 0

//habits vars
VAR filthy = false
VAR clean = false
VAR foodie = false
VAR starving = false
VAR low_maintenance = false
VAR bougie = false

// ================ functions ================



//user friendly names database
== function name(item)

{item:
- beans: Beans
- tomato_soup: Tomato soup
- noodle_soup: Noodle soup
- hot_dog: Hot dog 
- cereal: Cereal
- else: {item}
}


// ================ handlers ================



//this increments the time of day each time you hit this. It also handles counting the days and looping through the days of week.
=== time_handler ===

{day_of_week == Sunday && time_of_day == night:
~ day_of_week = end_of_week
}

{time_of_day == night: 
    Narrator: You slip into a deep and dreamless slumber
    ~ time_of_day = morning
    ~ day ++
    ~ day_of_week ++
    ~ tidyed_already = false
    ~ ate_already = false
    ~ nora_hunger ++
- else: 
    ~ time_of_day ++
    ~ ate_already = false
}

<b>Day {day} <br><>
<b>It's {day_of_week} {time_of_day} 

-> activity_handler

=== activity_handler ===

{van_dirty >= 3 && van_dirty <=10:
The van is looking a little messy.
}
{van_dirty >10:
The van is filthy.
}

{nora_hunger < 0:
You're still so stuffed from that last meal. 
}
{nora_hunger == 0:
You're not very hungry.
}
{nora_hunger > 0 && nora_hunger <=2:
You could eat.
}
{nora_hunger > 3 && nora_hunger <=4:
You could eat.
}
{nora_hunger >= 5:
You're starving.
}

{nora_dirty >= 2 && nora_dirty <=5:
You feel a little stinky.
}

{nora_dirty >6:
You smell like old meat and rancid milk. 
}


+ {ate_already == false} [Let's eat]
    -> foodtime_handler
+ {tidyed_already == false} [Let's tidy up the van]
    -> tidy_handler
+ {showered_already == false} [Let's wash up]
    -> shower_handler
    
    
=== shower_handler ===
Nora: Time to get clean, but lets check on the water first

{van_water} gallons left in the freshwater tank.

+ {van_water >= 1}[Take a sponge bath]
    Narrator: You wash only your stinkiest bits with a dribble from the sink. Gotta conserve water.
    ~ nora_dirty = nora_dirty/2
    ->activity_handler

+ {van_water >= 4}[Take a quick shower]
    Narrator: In 2 minutes youre feeling clean again
    ~ nora_dirty = 0
    ->activity_handler
    
+ {van_water >= 8}[Take a long shower]
    Narrator: You can always get more water. It falls from the sky. 
    Narrator: You give your scalp a good scrub, easing away the tension.
    ~ nora_mood ++
    ~ nora_dirty = 0
    ->activity_handler

+ ->
    {van_water <= 0:
    Nora: I guess that means no shower today 
    }
->activity_handler
    
=== tidy_handler ===
Nora: A clean van makes a clean mind!

+ {tidyed_bed_already == false}[Make the Bed]
~ van_dirty --
~ tidyed_bed_already = true
-> tidy_handler

+ {tidyed_surfaces_already == false}[Wipe Down Surfaces]
~ van_dirty --
~ tidyed_surfaces_already = true
-> tidy_handler

+ {tidyed_floor_already == false}[Sweep the Floor]
~ van_dirty --
~ tidyed_floor_already = true
-> tidy_handler

+ {has_kitty == true && tidyed_litterbox_already == false} [Clean Litterbox]
~ van_dirty --
~ tidyed_litterbox_already = true
-> tidy_handler

+ [All Done]
~ tidyed_already = true
->activity_handler

=== foodtime_handler ===
{nora_hunger < 0:
Narrator: ... but out here there's no one to judge you
}

{time_of_day == morning: Nora: What's for breakfast?}
{time_of_day == afternoon: Nora: What's for lunch?}
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

+ {coffee > 0} [Coffee]
    ~ coffee --
    ~ nora_hunger --
    ~ ate_already = true
//TODO - back to the loop
-> activity_handler

+ [Skip Meal]
-    {nora_hunger <= 0:
    Nora: I'm not hungry.
    ~ nora_hunger ++
    ~ ate_already = true
    -> activity_handler
    }
-    {nora_hunger == 1:
    Nora: I'm not in the mood.
    ~ nora_hunger ++
    ~ ate_already = true
    -> activity_handler
    }
-    {nora_hunger == 2:
    Nora: I'm hungry, but I can eat later.
    ~ nora_hunger ++  
    ~ ate_already = true
    -> activity_handler
    }
-    {nora_hunger ==3:
    Nora: I'm <i>so</i> hungry, but not now.
    ~ nora_hunger ++ 
    ~ ate_already = true
    -> activity_handler
    }
-    {nora_hunger ==4:
    Nora: I'm starving. I can skip this meal, but I'll have to eat soon.
    ~ nora_hunger ++    
    ~ ate_already = true
    -> activity_handler
    }
- {nora_hunger >=5 && (LIST_COUNT(food) > 0 or coffee > 0):
    Nora: Nope. Gotta eat something.
    -> foodtime_handler
    }
- {nora_hunger >=5 && (LIST_COUNT(food) <= 0 or coffee <= 0):
    Narrator: You think about skipping, but you are <i>so</i> <i>so</i> hungry 
    -> no_food
    }

= option(food_from_list)
+ [{name(food_from_list)}] -> choose(food_from_list)

=== no_food ===
+ ->
    Narrator: You scrounge through the cupboards but there is nothing to eat.
    
    Narrator: You feel dizzy for a moment, then everything goes black.
    ~time_of_day ++
    -   {time_of_day == morning: 
        Narrator: You wake up and the sun is shining through the windshield into your eyes
        }
    -   {time_of_day == afternoon: 
        Narrator: You wake up to the dusty heat of the van.
        }        
    -   {time_of_day == evening: 
        Narrator: You wake up to a deer staring at your through the windshield. It blinks twice, then dart off into the trees.
        }
    -   {time_of_day == night: 
        Narrator: You wake up to a chill. It's dark all around you.  
        }
    Narrator: You need to find something to eat before you pass out again.
    
//TODO    
        ->time_handler
        
=== choose(food_from_list) ===
{food_from_list == beans: 
Narrator: You snap open the can of beans and scoop them into your mouth cold. 
Nora: Damn I love them beans.
~ food -= beans
~ nora_hunger --
}
{food_from_list == tomato_soup: 
Narrator: The hob clicks on in an instant.
Narrator: You scrape your short fingernails under the pull tab and snap open the can of tomato soup. 
Nora: If only I has some grilled cheese to go with....
~food -= tomato_soup
~ nora_hunger --
}

{food_from_list == ramen: 
Narrator: You pull the brick of noodles out of the wrapper and plop it into the bubbling water. 
Nora: YUM!
~food -= ramen
~ nora_hunger --
}
    ~ ate_already = true
    ->activity_handler

// ================ start story here ================

=== start ===
Mom: Do you really have to go, Nora?

Nora: C'mon Mom, we already built the whole van. Can't back out now.


    -> END

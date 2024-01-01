// ================ debug menu ================

<shake>❀❀❀Debug Menu❀❀❀</shake> 
//->time_handler
//->foodtime_handler
-> start

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
VAR van_gas = 0 // gallons
VAR van_max_gas = 25 // gallons
VAR van_power = 0 // amp hours
VAR van_max_power = 100 // amp hours
VAR van_water = 0 // gallons
VAR van_max_water = 30 // gallons
VAR van_greywater = 0 // gallons
VAR van_max_greywater = 20 // gallons
VAR van_propane = 0 //lbs
VAR van_max_propane = 18 //lbs
VAR van_trash = 0 // gallons
VAR van_max_trash = 10 // this can overcap, but when it does the van gains dirtiness
VAR van_dirty = 0 // 0 is clean, over 10 is filthy
VAR van_last_oil_change = 65001
VAR van_next_oil_change = 68001
VAR van_miles = 65007
VAR van_solar = 100 //watts


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
+ [Let's hit the road]
    -> roadtrip_handler
+ [Let's explore]
    -> explore_handler
    
=== roadtrip_handler ===
//put roadtrip stuff there
->DONE

=== explore_handler ===
// put explore stuff here 
->DONE
    
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
Mom: Do you really have to go, Nora? #Mom

Nora: C'mon Mom, I already built out the whole van. Can't back out now. #Nora

Mom: Excuse me don't you mean WE already built out the whole van? #Mom

Nora: Sure. #Nora
Nora: Yes #Nora
Nora: Thank You Mom. #Nora
Nora: But either way its built. #Nora

Narrator: Your mom smiles and wraps you in a big hug. #Narrator

Mom: You know you can call me any time, yea? #Mom

Nora: Yea I know. 

Mom: I made you a little card for the van so you can remember everything you need to know. #Mom
+ [Take Card]
Narrator: She hands you an index card, every space intricately packed with your mom's small, neat handwriting. Each line in smallcaps is pairs with all lowercase lines, and every spare space, littered with tiny hand-drawn flowers.
-> van_reference_card

=== van_reference_card ===

<b>❀ 1978 JORD WAYFARER VAN ❀</b>

4 Cylinder 2.0 Liter Engine <br> ❀❀❀ vroom vroom! ❀❀❀
{van_max_gas} Gallon Gas Tank <br> ❀❀❀ get gas when you can when you're out in the middle of nowhere ❀❀❀
{van_max_water} Gallon Freshwater Tank <br> ❀❀❀ you'll use ~2 gallons / day for drinking & washing ❀❀❀
{van_max_greywater} Gallon Greywater Tank <br> ❀❀❀ any water that goes down the drain end up here ❀❀❀
{van_max_trash} Gallon Trash Can <br> ❀❀❀ take out the trash girl! ❀❀❀
{van_solar} Watt Solar Panel <br> ❀❀❀ can generate ~8 amps / hour when its sunny and maybe half that when its cloudy ❀❀❀
{van_max_power} Amp Hour 12V Battery for Onboard Electric <br> ❀❀❀ see back for details! ❀❀❀

Last Oil Change at {van_last_oil_change} Miles <br> Next Oil Change at {van_next_oil_change} Miles <br> ❀❀❀ don't forget to get your oil changed! keep that engine running great! ❀❀❀

+ [Flip Card]
    Narrator: You flip the laminated index card over in your hands.
    -> van_reference_card_back
+ [Put Card Away]
    Narrator: You tuck the card away 
    -> mom_gives_toolbox

=== van_reference_card_back ===
<b>❀ Equipment thats Draws Power ❀</b>
2 cubic ft Mini fridge - 5 amps / hr <br> ❀❀❀ runs about 1/3 of the time so ~40 amp hrs / day ❀❀❀
LED overhead strip lights - 1 amp / hr <br> ❀❀❀ keep on only in the evening so ~4 amp hrs / day ❀❀❀
2 110v outlets - it depends what you plug in :) <br> ❀❀❀ you should be able to keep your phone / laptop / camera charged for   ~8 amp hrs / day ❀❀❀
Water Pump - 8 amps / hr <br> ❀❀❀ you probably only use this ~1 hr/day tho ❀❀❀

❀❀❀ Total Average Power Used per Day ❀❀❀ <br> 60 amps / day <br> (i know math isn't your strong suit ;P)

<b>❀ Other Equipment ❀</b>
Back door showerhead - uses ~4 gallons for a quick shower. <br> ❀❀❀ water goes quick! be careful! remember this doesn't drain into your greywater tank, please be considerate of where you use it! ❀❀❀

+ [Flip Card]
    Narrator: You flip the laminated index card over in your hands.
    -> van_reference_card
+ [Put Card Away]
    Narrator: You tuck the card away 
    -> mom_gives_toolbox

=== mom_gives_toolbox ===
* [Wow that's a lot of info!]
    Mom: Well you don't have to process it all now. That's why I put it on a card!
* [Yea, yea, yea I know!]
    Mom: Ok! Ok! Ok! I just don't want you to forget!
* [Thanks mom!]
    Mom: Awwwwww! You're welcome Nora!
- 
Mom: Oh! I almost forgot!

Narrator: Your mom rushes into the garage and returns a moment later with a little yellow toolbox with a red bow hastily stuck to the latch. 

Mom: Just in case you need to fix something while you're on the road! 

* [Thanks!]
Nora: Awwwww thanks mom!!! 
* [I'd better get going]
Nora: Mooooooooom I gotta gooooooooo
Mom: Ok! Ok! 
- 
Mom: I just want you to be safe! There are a lot of wierdos out there!




    -> END

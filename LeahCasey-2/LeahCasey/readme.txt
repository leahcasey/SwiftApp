/Users/lc27/Desktop/readme.txt

This app’s core features revolve around managing and displaying a custom list of football players. At launch, player data is loaded from an included XML file and automatically saved into Core Data. The entity it initially saved into is CDPerson.
This app has another entitiy called FavouritePerson, which is iniotially empty. A playter can be added to favourite Person in the PersonViewController by clicking the favourite button.
When the favourite button is clicked, the app shows an alert to the user informing them that said player has been successfully added to their favourites list.
These two entities have the same looking screens/viewcontrollers, but they are different view controllers dedicated to the normal entitiy and the favourite entitiy to ensure consistency and clarity.
The AddPersonViewController can be used to add a new player to CDPerson, or edit the information about an existing player. The UpdateFavouriteViewController also allows editing of players from the entity FavouritePerson.
My personal technical contribution to this project, was adding a segmented control to the first page, the PeopleTableViewController. I did this so that the players in the Liverpool team could be seperated based on their position e.g., forward, goalkeeper, etc.
When a segment is selected, the app dynamically filters the Core Data results to only show players whose position field matches the selected category. Choosing "All" resets the filter to display every player.
